---
title: Where did those 800 pods come from?
author: Tibo Beijen
date: 2026-07-18T15:00:00+01:00
url: /2026/07/18/where-did-those-800-pods-come-from
categories:
  - articles
tags:
  - ArgoCD
  - AWS
  - EKS
  - Fargate
  - Troubleshooting
description: A typical unlikely combination of factors, involving Argo CD ApplicationSets and mysterious AWS EKS Fargate nodes, resulting in some head-scratching, troubleshooting and interesting take-aways.
thumbnail: img/unsupported-pods-800.png

---

Recently I merged a pull request that was like any other pull request. But things unfolded quite differently.

Things didn't break, but could have. Things shouldn't have happened, but did.

The typical unlikely combination of factors, involving Argo CD ApplicationSets and mysterious AWS EKS Fargate nodes, resulting in some head-scratching, troubleshooting and interesting take-aways.

In this article:

{{< toc >}}

{{< figure src="/img/unsupported-pods-800.png" title="Lots of invalid pods" >}}

## The Pull Request

The PR contents were basically a chore. Kubernetes (AWS EKS) and Argo CD are our tools of choice, and we use a custom Helm chart to have consistent application deployments. The PR involved bumping the chart version and optimizing some resource and probe configuration details.

While at it, there was also some moving of values between files. Originally we had only a `values-non-prod.yaml` and `values-prod.yaml`, both sharing a lot of identical values. It is how things go: Somebody starts flat and simple. Then config grows over time and it becomes increasingly hard to keep things consistent. But also it becomes increasingly hard to tell _intentional_ differences from _accidental_ differences[^footnote_zen_explicit]. 

A small maintenance change, getting us from:

```
# Note: Examples are simplified for readability

# file: values-non-prod.yaml
env: non-prod
containerPort: 8000
toleration: applications

# file: values-prod.yaml
env: prod
containerPort: 8000
toleration: applications
```

To:

```
# file: values-shared.yaml
containerPort: 8000
toleration: applications

# file: values-non-prod.yaml
env: non-prod

# file: values-prod.yaml
env: prod
```

Nothing special, just the typical improvements once things grow. Worth knowing is we show diffs in our PRs using [Argo CD Diff Preview](https://github.com/dag-andersen/argocd-diff-preview), so we can move values around, and confirm it's a no-op in the PR.

Furthermore, we have ApplicationSets using the [Git Generator](https://argo-cd.readthedocs.io/en/latest/operator-manual/applicationset/Generators-Git/). If we want to install an application into a certain cluster, we do so by adding a specifically named file. An example:

```
# file: app-non-prod.argocd.yaml
project: audio
namespace: fawkes
# Default, no need to specify unless wanting to override.
# (shown for illustrative purposes)
valueFiles:
  - values-non-prod.yaml
```

So, the PR file changes were:

```
fawkes-api/app-non-prod.argocd.yaml   |  3 +++
fawkes-api/app-prod.argocd.yaml       |  3 +++
fawkes-api/helm/Chart.yaml            |  2 +-
fawkes-api/helm/values-non-prod.yaml  | 10 ----------
fawkes-api/helm/values-prod.yaml      | 10 ----------
fawkes-api/helm/values-shared.yaml    | 12 ++++++++++++
```

## This merge should not create that many pods!?

Usually with changes that might affect startup, I have a `k get pods -w` running somewhere on the side, to see things unfold. And that started to fill with lines like this:

```
prod-fawkes-api-entertainment-app-84d7d8dfd8-2cpn2   0/1   UnsupportedPodSpec   0   50s
prod-fawkes-api-entertainment-app-84d7d8dfd8-2m5ph   0/1   UnsupportedPodSpec   0   46s
prod-fawkes-api-entertainment-app-84d7d8dfd8-2m7td   0/1   UnsupportedPodSpec   0   20s
prod-fawkes-api-entertainment-app-84d7d8dfd8-2p2sb   0/1   UnsupportedPodSpec   0   9s
```

More than 800 of them, in the timespan of roughly a minute.

Everyone with some experience in this field probably knows the drill: Slightly heightened adrenaline. Do we need to contain blast radius? Can we fix forward? Can we roll back?

Events showed things like:

```
83s  Warning  UnsupportedPodSpec  pod/prod-fawkes-api-entertainment-app-84d7d8dfd8-c7jlg  Pod not supported: SchedulerName is not fargate-scheduler
```

This application shouldn't run on Fargate. Also, pods now had the name of the application, appended with the name of the custom chart ('entertainment-apps'). Whatever was happening, this was _not_ just a typo in resources values, and this was _not_ our intended change. Roll back it is.

A `git revert` and Argo sync later, I could observe Argo CD picking up the reverted configuration. From CLI I could still observe `UnsupportedPodSpec` pods being stamped out. So I checked if original replicaset still was ok (it was) and deleted the `prod-fawkes-api-entertainment-app-84d7d8dfd8` replicaset.

Things settled down. There were resources to prune in Argo CD, including resources such as a `prod-fawkes-api-entertainment-app` service, that existed alongside the original `prod-fawkes-api` service, and similar duplicates.

This unexpected resource naming change was already a tell. As was the fact that this did not consistently affect all environments (non-prod was fine)...

## What happened?

With the mess cleaned up, I started collecting material to investigate, into files: The list of unsupported pods. The events. Some descriptions of the unsupported pods. And Argo CD logs. 

Quick shout out to [stern](https://github.com/stern/stern) by the way. Beats Loki. Beats MCP. Everything dumped to a file in a second: 

```
stern -n argocd argocd --since=20m --include="err" > argocd-errors.log
```

By now two things stood out:

* Resource naming change, the appending of the chart name. I had a sense of _what_ went wrong (shared values file ignored), but not _why_.
* Fargate scheduling. I know the mechanics of scheduling, taints and tolerations. Still: Enigma.

With all the info present in files in a directory, I started chatting a bit with my [Anthropic friend](https://claude.ai/). As always: Super helpful, great at sifting through eye-bleed-inducing amounts of logs. Also great at firmly pointing out causes such as possible node pressure, or KEDA, that were completely unrelated, sending you (or itself) on an endless goose chase, if not guided properly.

All in all, a net positive, making it clear what happened. Let's break it down:

## Root cause: Argo CD Application and ApplicationSet controllers are independent

> Eventual consistency does not imply order

A reasoning mistake. Or more correctly: Completely forgetting to reason about _how_ a PR will be applied.

What happened:

* PR was merged
* Argo CD picks up the new commit
* Application controller and ApplicationSet controller start to process the change
* In this particular case, Application controller was _first_. 
* The `Application` object _did not yet have the new `values-shared.yaml`_.
* From that point on, all bets are off. The only certainty is that something will go wrong.
* One of the things going wrong was the resource name helper no longer having an input, so falling back to the `application name + chart name` fallback.
* Reconcilers be reconciling, resulting in a lot of unexpected resources.

In hindsight it is very obvious. And the concepts are well-known.

Yet, how things interact can be easily overlooked. And thinking this over, our field of work is full of things like this. Some examples:

* Terraform plans are presented as atomic. But applying is not. What happens if an AWS API throws a 400 half-way?
* Promoting artifacts feels atomic, but there's usually a rolling update mechanism.
* A PR in a monorepo can show changes of all affected components, presented as a single update. But you have to trust orchestration to take care of upgrading the components in the right order.
* Layers of caching making changes slow to propagate.

In our case the mistake was introducing the new `values-shared.yaml` file, _and_ moving values out of the original files, in the same commit. The safe approach:

* Introduce the new, empty, `values-shared.yaml`
* Ensure `Application` is updated and now uses the shared values
* Proceed with moving values to shared, using Argo CD Diff Preview to validate changes

Cumbersome. But safe.

### How can we improve?

For starters we've updated documentation to make this abundantly clear. Likewise a warning has been added to the LLM skill that helps with authoring application Helm configurations.

We are considering CI checks to enforce this. Something like 'if `*.argocd.yaml` is changed, all value files concatenated should not change'. But it should be rock solid: Added complexity resulting in 10% false positives and 10% false negatives, helps no one.

## Contributing factor: Helm chart lacking safeguards

Because we had a lot of our values missing, our rendered manifests ended up with an empty tolerations key value:

```
tolerations:
  - key: ""  # This should have contained: "applications"
    operator: "Exists"
    effect: "NoSchedule"
```

We use labels and taints to segment our nodes. This way we can isolate application workloads from system workloads such as KEDA and gateways.

With the key empty, the toleration effectively became: "tolerate everything". Not good.

### How can we improve?

Our Helm chart was simple and straightforward, and did not take an empty toleration value into account. Simple has its merits, but when authoring charts it's also important to think defensive: "What will happen if this value is absent?" or "How do we want this to fail?".

In this case several improvements can be considered:

* Require the value in `schema.json`. Good if always wanting a value. If absent you'll have a rendering error.
* Wrap the `tolerations` block in a conditional. Good if not specifying any toleration is acceptable. In our particular setup not a great fit. It would have resulted in pods that could not be scheduled. Which is still better than pods scheduled on the wrong node.
* Use a default value if `toleration` value is absent. Works if there is a safe default value. In our case 'applications' would indeed be a sane default.
* Pair any of the above with a policy. Improving charts is nice, and can help the chart user. However, from a cluster operator perspective this is API input that [needs to be validated](https://www.ncsc.gov.uk/collection/securing-http-based-apis/4-input-validation).

## Contributing factor: Empty Fargate node

An empty Fargate node you say? But how?

That's a great question.

AWS Fargate on EKS puts eligible pods on a node running on an AWS managed MicroVM[^footnote_firecracker]. That node's lifecycle is bound to the pod's lifecycle. Pod goes away, so does the node. At least it should.

Some details of the node:

```
Name:               fargate-ip-10-232-153-220.eu-west-1.compute.internal
# ...
CreationTimestamp:  Mon, 13 Jul 2026 13:20:20 +0200
Taints:             eks.amazonaws.com/compute-type=fargate:NoSchedule
Unschedulable:      false
Lease:
  HolderIdentity:  fargate-ip-10-232-153-220.eu-west-1.compute.internal
  AcquireTime:     <unset>
  RenewTime:       Fri, 17 Jul 2026 16:41:58 +0200
# ...
Allocatable:
  cpu:                2
  ephemeral-storage:  17573496Ki
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             3811520Ki
  pods:               1
# ...
Non-terminated Pods:          (0 in total)
  Namespace                   Name    CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----    ------------  ----------  ---------------  -------------  ---
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests  Limits
  --------           --------  ------
  cpu                0 (0%)    0 (0%)
  memory             0 (0%)    0 (0%)
  ephemeral-storage  0 (0%)    0 (0%)
  hugepages-1Gi      0 (0%)    0 (0%)
  hugepages-2Mi      0 (0%)    0 (0%)
Events:              <none>
```

So, somehow the Fargate control plane got confused. Even if we were to accidentally do something 'silly', for example cordon and drain the Fargate node (if that's even possible), I would expect the node to be garbage collected soon after.

We now had:

* A mysterious empty Fargate node with capacity to schedule a pod
* A pod that mistakenly tolerates all taints

The (regular) scheduler assigned the pod to the Fargate node. Then the Fargate kubelet rejected it, as could be seen from the pod events:

```
Events:
  Type     Reason              Age    From               Message
  ----     ------              ----   ----               -------
  Normal   Scheduled           6m26s  default-scheduler  Successfully assigned applications/prod-fawkes-api-entertainment-app-84d7d8dfd8-znb7r to fargate-ip-10-232-153-220.eu-west-1.compute.internal
  Warning  UnsupportedPodSpec  6m26s  kubelet            Pod not supported: SchedulerName is not fargate-scheduler
```

Three days after the incident, the node is still there. We raised an AWS support ticket and leave it for a little while to investigate. 

### How can we improve?

We can't fix the AWS Fargate control plane. And so far I have never heard of people being able to accidentally mess up their Fargate nodes. So for now I assume it's not something silly we did.

### How could AWS improve?

First of all: Operating services at AWS scale is hard. So there is a vast amount of context I am blissfully unaware of. That being said, it is very fun to hypothesize.

To run pods on Fargate, one defines [Fargate profiles](https://docs.aws.amazon.com/eks/latest/userguide/fargate-profile.html) but under the hood all boils down to common Kubernetes building blocks.

An admission controller

```
# kubectl get mutatingwebhookconfigurations 0500-amazon-eks-fargate-mutation.amazonaws.com -o yaml
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
metadata:
  name: 0500-amazon-eks-fargate-mutation.amazonaws.com
webhooks:
- admissionReviewVersions:
  - v1beta1
  clientConfig:
    caBundle: <bundle-contents>
    url: https://127.0.0.1:23445/mutate
  failurePolicy: Ignore
  matchPolicy: Equivalent
  name: 0500-amazon-eks-fargate-mutation.amazonaws.com
  namespaceSelector: {}
  objectSelector: {}
  reinvocationPolicy: Never
  rules:
  - apiGroups:
    - '*'
    apiVersions:
    - '*'
    operations:
    - CREATE
    resources:
    - pods
    scope: '*'
  sideEffects: None
  timeoutSeconds: 5
```

That takes pods such as the ones coming from this deployment:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kyverno-admission-controller
  namespace: kyverno
spec:
  template:
    spec:
      schedulerName: default-scheduler
```

And, if matching all the configured Fargate profile details, changes the pod spec into:

```
apiVersion: v1
kind: Pod
metadata:
  name: kyverno-admission-controller-99947f484-fzbqr
  namespace: kyverno
spec:
  schedulerName: fargate-scheduler
```

Fargate scheduler takes it from there.

That's the intended flow. Now if something unexpected happens, say I create a pod with `nodeName` set to a Fargate node, the pod bypasses the scheduler and is effectively assigned to that node.

The Fargate node kubelet will pick it up, and run a series of admission checks[^footnote_kubelet]. In the vanilla kubelet code there is a [PodAdmitHandler](https://pkg.go.dev/k8s.io/kubernetes/pkg/kubelet/lifecycle#PodAdmitHandler) interface. As far as I am aware of there is no extension mechanism. Given its totally different runtime environment, the AWS Fargate kubelet implementation is probably completely custom anyway. Either way, it rejects the pod and throws an `UnsupportedPodSpec` warning.

Problem in our case was that the ReplicaSetController did not pick this up and started churning out more pods that all went through the same motions: Default scheduler, assigned to Fargate node, rejected by kubelet.

That kubelet check needs to exist. The kubelet needs to be able to reject a pod it can't run and have a mechanism to report it.

But looking at the system as a whole, one could argue that these pods should not have existed in the first place. We don't _need_ the kubelet, with information that only exists in that context, to make that decision. We can already tell from the outset, the pod spec with `nodeName` set by scheduler and no `schedulerName`, that this pod should not run.

Following that reasoning, I wonder if an AWS validating admission controller, similar to the `eks-fargate-mutation` admission controller that already exists, could be an improvement:
* It would turn the failure mode from: "Here are 800 pods that would never have been able to run anyway", into: "ReplicaSetController gets an error when trying to create a pod and backs off". Arguably cleaner.
* The type of failure would be similar to e.g. Kyverno rejecting a pod based on policy violations. So: Known territory. Teams will probably have mechanisms in place to surface and deal with these types of events.

## Lucky: Prune set to false

Since the resource names all changed, Argo CD wanted to delete the old resources, and create the new counterparts.

Because of `prune: false` the old resources were preserved. This prevented this mishap from becoming an incident.

Lately I was leaning towards setting `prune: true`. Rationale:
* Charts updates can legitimately remove resources. We actually have that in one of our updates of the commonly used chart.
* Lingering resources can still have an undesired effect, e.g. a `RoleBinding` that should no longer exist, favoring pruning straight away.
* Guarding resources from accidental deletion of an `Application` is guarded by not setting the [resources finalizer](https://argo-cd.readthedocs.io/en/latest/user-guide/app_deletion/#about-the-deletion-finalizer).

At a certain scale, needing to manually prune resources can become hard to manage. We don't operate at that scale, our clusters are registered in a single Argo CD instance. 

Safe side and a bit more hassle it is.

## Lucky: Having a seat during my commute back home

The should you or should you not deploy on Fridays discussion has many variants.

Nothing wrong with being on the safe side, but I have more than once seen supposedly safely timed releases turn into problems outside of office hours[^footnote_release].

This PR merge I did at the end of the day, right before needing to travel back home. Needing to fix things while also having an eye on the clock is not a great combination.

The revert was cleanly done and all was healthy when I headed to the train. But it turned out some of the wrongly named resources were still around in Argo CD, waiting to be pruned and firing some alerts.

I could fix that quickly when in train, but it would have taken longer if not having had a seat. In this case, waiting a bit and having people silence the alert for a while would have been fine, but that could have been different. 

A good reminder to always think through the unlikely scenario of things not going as planned.

## Take-away

Identifying and fixing the mishap took minutes. It was an outlier situation, nothing broke, so it's tempting to quickly resume focus on more pressing matters.

Unpacking what exactly happened takes hours. But in my opinion it's fun and worth it. It allows identifying improvements in one's way of work. It also is a good way to (re-)sharpen one's knowledge: A good incentive to dive into areas one doesn't touch in a typical day.

To me, this also highlights the value of open source: Documentation, source code, all of it is yours to explore. And not yours alone, a vast community works within this ecosystem and tries to improve it. Day by day, in the open. To illustrate: kubelet source code I could explore. Fargate control plane and Fargate kubelet I could not, there my capabilities stop at the AWS support portal.

Never stop learning.

Got any thoughts or feedback? Find me on [LinkedIn](https://www.linkedin.com/in/tibobeijen/) or [BlueSky](https://bsky.app/profile/tibobeijen.nl)

[^footnote_zen_explicit]: This is what I mean with 'explicit' in [The Zen of DevOps](https://www.zenofdevops.org/#explicit): Showing intent.
[^footnote_firecracker]: Apparently [not Firecracker](https://justingarrison.com/blog/2024-02-08-fargate-is-not-firecracker/). The things you discover when digging around when writing a blogpost. AWS marketing did an admirable job.
[^footnote_kubelet]: [This section](https://www.youtube.com/watch?v=fsuwU94kuns&t=603s) of the talk "Kubernetes SIG Node Intro and Deep Dive" goes into the admission logic that lives inside the kubelet.
[^footnote_release]: Regulation and compliance can mandate release windows. But release windows should not be an excuse to not improve release procedures.