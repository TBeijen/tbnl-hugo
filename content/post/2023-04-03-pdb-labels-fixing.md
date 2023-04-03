---
title: "PodDisruptionBudget confused: Labels matter."
author: Tibo Beijen
date: 2023-04-03T09:00:00+01:00
url: /2023/04/03/pdb-labels-fixing
categories:
  - articles
tags:
  - Kubernetes
  - PodDisruptionBudget
  - Ingress
  - Troubleshooting
description: PodDisruptionBudget and incomplete labels is not a great combination. How to prevent this situation and how to fix it.
thumbnail: img/pdb_says_no.gif

---
## Introduction

Recently we were performing an EKS upgrade. We use managed node groups, and updates have become routine without any surprises.

And then, hardly a surprise: Surprise! [^footnote_real_writer]

> PodEvictionFailure: Reached max retries while trying to evict pods from nodes in node group ng_a_on_demand

It is worth noting that nothing breaks because of this. The node group update procedure is basically a blue/green deployment type of [process](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-update-behavior.html): 

* EKS adds new nodes
* It drains old nodes and moves pods to the new ones
* Finally, it terminates the old nodes 

In this particular case, however, it waits for old nodes to drain, hits a snag, moves pods back to the old nodes, and exits with a 'Computer says no'.

It is also worth noting that a similar upgrade a few days earlier on a non-prod cluster executed flawlessly. So, once again: Surprise.

Let's see what happened.

{{< figure src="/img/pdb_says_no.gif" title="Computer says no" >}}
## The situation

As hinted at by the error message, the problem originates from _within_ the cluster. Upon checking the event log, the underlying problem became apparent.

```
# kubectl get events --sort-by='.metadata.creationTimestamp' -A
my-app              8m52s       Warning   CalculateExpectedPodCountFailed   poddisruptionbudget/my-app

# (newline for readability)
Failed to calculate the number of expected pods: jobs.batch does not implement the scale subresource
```

Upon inspecting the application, some things became clear:

* At first, there was only a single deployment, creating pods having labels:

```
app.kubernetes.io/instance: my-app
app.kubernetes.io/name: my-app
```

* The 'instance' label would allow distinguishing different releases within the namespace. Good.
* Later, a PodDisruptionBudget was added, limiting the number of unavailable pods. Also good (should have been there from the start, actually).
* After _that_, a Helm pre-update hook was added, copying assets to shared storage. This job pod has the same labels and is the `job.batch` referred to in the error mentioned above.

And now we find ourselves in a situation where we can't replace nodes.

### How to prevent

#### Consistent guidelines

Consistent examples and clear, simple to follow guidelines go a long way. Also, one needs clear guidelines anyway when wanting to implement more advanced measures, as described below.

The following pattern, partly based on Helm chart defaults, in our experience works well:

```
metadata:
  name: <unique-release-name>-<component>
  labels:
    # Below 3 labels used as selector labels in various places as well
    app.kubernetes.io/name: <chart-name>
    app.kubernetes.io/instance: <unique-release-name>
    app.kubernetes.io/component: <component>
```

So, in our case, that would be:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-instance-x-web
  # truncated
spec:
  template:
    metadata:
      name: my-app-instance-x-web
      labels:
        app.kubernetes.io/name: my-app
        app.kubernetes.io/instance: my-app-instance-x
        app.kubernetes.io/component: web
  # truncated, selectorLabels in accordance with template labels
---
apiVersion: batch/v1
kind: Job
metadata:
  name: my-app-instance-x-copy-assets
  # truncated
spec:
  template:
    metadata:
      name: my-app-instance-x-copy-assets
      labels:
        app.kubernetes.io/name: my-app
        app.kubernetes.io/instance: my-app-instance-x
        app.kubernetes.io/component: copy-assets
  # truncated, selectorLabels in accordance with template labels
```


#### OPA/Gatekeeper or Kyverno

Policy engines such as [OPA/Gatekeeper](https://github.com/open-policy-agent/gatekeeper) and [Kyverno](https://kyverno.io/) exist that can validate manifests and block bad things from being deployed. Validating the existence of a component label in the manifests could have helped. It might be more complicated though, to validate that component labels of different components are actually _different_.

Operating a policy engine, and maintaining the rule set, is not something you implement in the blink of an eye. In our case, there are short communication lines between platform- and application engineering, so 'fix and educate' goes a long way. But at some point, it will be worth investigating.

#### CDK

When using [cdk8s](https://cdk8s.io/), one could nest charts. One of the child 'component' charts then would contain a set of ApiObjects (say: Deployment, Service, PDB, HPA) and take `component` as an argument. This way, defining a component would be required, and by design, it would be consistently applied to the underlying resources.

But, abstractions tend to hide capabilities and bring cognitive overhead. Furthermore, code constructs require testing. So, adopting CDK comes with trade-offs and, like implementing OPA or Kyverno, is not done overnight.

### How to fix

#### Remove the PodDisruptionBudget

When focusing on replacing nodes, one could consider temporarily removing the PDB. But:

* The PDB exists for a reason. We have no control over the amount of nodes that will be drained in parallel. Without the PDB, the scheduler could evict _all_ pods simultaneously.
* It's not fixing, but 'working around'. It still leaves the incorrect label setup.

Not an option.

#### Fix the labels

We need to fix the labels. Doing so, we run into an error:

```
The Deployment "my-app-instance-x-web" is invalid: spec.selector: Invalid value:
v1.LabelSelector{MatchLabels:map[string]string{"deployment":"my-app-instance-x-web"},
MatchExpressions:[]v1.LabelSelectorRequirement(nil)}: field is immutable
```

So, not as straightforward as one would hope.

#### Replace the deployment

When searching for ways to handle the immutable labels, the proposed solution is usually: Delete the object(s), then re-add with proper labels.

In some cases, this would work, but it's not 0-downtime.

What can be 0-downtime:

* Deploy a second release of the application, having different names than the original release, proper labels, omitting the `Ingress`
* Ensure the new release is sufficiently scaled up
* Adjust the existing ingress to point to the new service
* Validate traffic going to the new release
* Remove the old release

We use Helm, and for Ingress we use Zalando's [Skipper](https://opensource.zalando.com/skipper/). When deploying duplicate `Ingress` objects, skipper will randomly select one. 

In this situation, we can use that to our advantage. We can deploy the new, correctly named and labeled Ingress _alongside_ the existing one for a brief period.

Specific to our setup, the procedure then becomes:

* Deploy a second release of the application, using Helm, having a release name different than the original, proper labels and leaving out the `Ingress`
* When scaled up, redeploy, activating the new `Ingress`
* Observe traffic now going 50%/50% old/new
* Delete old Ingress (we want to be sure ingress disappears before the service and pods)
* Uninstall the old Helm release

Obviously, this procedure should be tested on a non-production setup first.

### Conclusion

Object names and labels need to be unique and complete. It's advisable to have naming and labeling that:

* Allows to uniquely identify each component within the release, even if there is only one initially.
* Allows multiple releases to co-exist within a namespace, even if there is only one initially.

Failing to do so can lead to problems that can be complex to fix. Luckily, the Kubernetes API gives great control over the update procedure, so with careful planning and testing, downtime can be avoided.


[^footnote_real_writer]: These days one has to throw in an uncommon sentence here and there to prove an article is not written by ChatGPT.