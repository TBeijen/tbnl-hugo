---
title: Where did those 800 pods come from?
author: Tibo Beijen
date: 2026-07-16T05:00:00+01:00
url: /2026/07/16/where-did-those-800-pods-come-from
categories:
  - articles
tags:
  - ArgoCD
  - AWS
  - EKS
  - Fargate
  - Troubleshooting
description: "A conceptual mistake and some coincidental other quirks means: Troubleshooting to be done, insights to gain and take-aways to obtain."
thumbnail: img/...

---

Recently I merged a pull request that was like any other pull request. But things unfolded quite differently.

Things didn't break, but could have. Things shouldn't have happened, but did.

The usual 'unlikely combination of factors', resulting in some troubleshooting, and interesting take-aways.

## The Pull Request

The PR contents were basically a chore. Kubernetes (AWS EKS) and ArgoCD are our tools of choice, and we use a custom Helm chart to have consistent application deployments. The PR involved bumping the chart version and optimizing some resource and probe configuration details.

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
# (shown for illustrative prurposes)
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

## This merge should not create that many pods

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

This application shouldn't run on Fargate. Also, pods now had the name of the application, appended with the name of the custom chart ('entertainment-apps'). Whatever was happening, this was _not_ just a typo in resources values, and this was _not_ our intended change.

A git revert and Argo sync later, at least from the Argo side things looked better. Lot of stale resources to prune but otherwise things looked ok.

From CLI I could still observe `UnsupportedPodSpec` pods being stamped out. So I checked if original replicaset still was ok (it was) and deleted the `prod-fawkes-api-entertainment-app-84d7d8dfd8` replicaset.

Things settled down. The resources to prune in Argo CD, included resources such as a `prod-fawkes-api-entertainment-app` service, that existed alongside the original `prod-fawkes-api` service, and similar duplicates.

This unexpected naming change was already a tell. The fact that this only happened in one of the environments as well...

## What happened?

So, I collected some forensic material into files: The list of unsupported pods. Events. Some descriptions of the unsupported pods. And Argo CD logs. 

Shout out to [stern](https://github.com/stern/stern) by the way. Beats Loki. Beats MCP. Everything dumped to a file in a second: 

```
stern -n argocd argocd --since=20m --include="err" > argocd-errors.log
```

By now two things stood out:

* Resource naming change, the appending of the chart name. I had a sense of _what_ went wrong (shared values file ignored), but not _why_.
* Fargate scheduling. I know the mechanics of scheduling, taints and tolerations. Still: Enigma.

With all the info present in files in a directory, I started chatting a bit with my [Anthropic friend](https://claude.ai/). As always: Super helpful, great at sifting through eye-bleed-inducing amounts of logs. Also great at firmly pointing out causes such as possible node pressure, or KEDA, that were completely unrelated, sending you (or itself) on an endless goose chases, if not guided properly.

All in all, a net possitive, making it clear what happened. Let's break it down:

## Root cause: Argo CD Application and ApplicationSet controllers are independent

> Eventual consistency does not imply order

A reasoning mistake. Or more correctly: Forgetting to reason about _how_ a PR will be applied.

What happened:

* PR was merged
* Argo CD picks up the new commit
* Application controller and ApplicationSet controller start to process the change
* In this particular case, Application controller was _first_. 
* The `Application` object _did not yet have the new `values-shared.yaml`_
* Reconcilers be reconciling, resulting in a lot of unexpected resources.

In hindsight it is very obvious. And the concepts are well-known.

Yet, how things interact can be easily overlooked. And thinking this over, our field of work is full of things like this. Some examples:

* Terraform plans are presented as atomic. But applying is not. What happens if an AWS API throws a 400 half-way?
* Promoting artifacts feels atomic, but there's usually a rolling update mechanism.
* A PR in a monorepo can show changes of all affected components, presentad as a single update. But you have to trust orchestration to take care of upgrading the components in the right order.
* Layers of caching making changes slow to propagate.

In our case the mistake was introducing the new `values-shared.yaml` file, _and_ moving values out of the original files, in the same commit. The safe approach:

* Introduce the new, empty, `values-shared.yaml`
* Ensure `Application` is updated and now uses the shared values
* Proceed with moving values to shared, using Argo CD Diff Preview to validate changes

Cumbersome. But safe.

We are considering CI checks to enforce this. Something like 'if `*.argocd.yaml` is changed, all value files concatenated should not change'. But it should be rock solid. Added complexity resulting in 10% false positives and 10% false negatives, helps no one.

[^footnote_zen_explicit]: This is what I mean with 'explicit' in The Zen of DevOps: Showing intent.