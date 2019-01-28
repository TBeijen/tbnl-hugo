---
title: 'Maximize learnings from a Kubernetes cluster failure'
author: Tibo Beijen
date: 2019-01-14T10:00:00+01:00
url: /2019/01/14/learning-from-kubernetes-cluster-failure/
categories:
  - articles
tags:
  - DevOps
  - Kubernetes
  - Agile
  - Failure management
  - Company Culture
description: "Analyzing past Kubernetes cluster issues, but more importantly: Maximize learnings."

---

Recently our team faced some problems on one of our Kubernetes clusters. Not as severe as to bring down the cluster completely, but definitely affecting end user experience of some interally used tools and dashboards.

Coincidentally, around the same time I visited DevOpsCon 2018 in Munich, where the opening keynote ["Staying Alive: Patterns for Failure Management from the Bottom of the Ocean"](https://devopsconference.de/business-company-culture/staying-alive-patterns-for-failure-management-from-the-bottom-of-the-ocean/) related very well to this incident.

The talk (by [Ronnie Chen](https://twitter.com/rondoftw), an engineering manager at Twitter) focussed on various ways to make DevOps teams more effective in preventing and handling failures. One of the topics addressed was how catastrophes are usually caused by a cascade of failures, resulting in this quote:

 > A post-mortem that blames an incident only on the root cause, might only cover ~15% of the issues that led up to the incident.


As can be seen in [this list of postmortem templates](https://github.com/dastergon/postmortem-templates), quite a lot of them contain 'root cause(s)' (plural). Nevertheless the chain of events can be easily overlooked, especially as in a lot of situations, removing or fixing the root cause makes the problem go away.

So, let's see what cascade of failures led to our incident and maximize our learnings.

## The incident

Our team received reports of a number of services showing erratic behavior: Occasional error pages, slow responses and time-outs.

Attempting to investigate via Grafana, we experienced similar behavior affecting Grafana and Prometheus. Examining the cluster from the console resulted in:

```
$: kubectl get nodes
NAME                                          STATUS     ROLES     AGE       VERSION
ip-10-150-34-78.eu-west-1.compute.internal    Ready      master    43d       v1.10.6
ip-10-150-35-189.eu-west-1.compute.internal   Ready      node      2h        v1.10.6
ip-10-150-36-156.eu-west-1.compute.internal   Ready      node      2h        v1.10.6
ip-10-150-37-179.eu-west-1.compute.internal   NotReady   node      2h        v1.10.6
ip-10-150-37-37.eu-west-1.compute.internal    Ready      master    43d       v1.10.6
ip-10-150-38-190.eu-west-1.compute.internal   Ready      node      4h        v1.10.6
ip-10-150-39-21.eu-west-1.compute.internal    NotReady   node      2h        v1.10.6
ip-10-150-39-64.eu-west-1.compute.internal    Ready      master    43d       v1.10.6
```

Nodes ``NotReady``, not good. Describing various nodes (not just the not ready ones) showed:

```
$: kubectl describe node ip-10-150-36-156.eu-west-1.compute.internal

<truncated>

Events:
  Type     Reason                   Age                From                                                     Message
  ----     ------                   ----               ----                                                     -------
  Normal   Starting                 36m                kubelet, ip-10-150-36-156.eu-west-1.compute.internal     Starting kubelet.
  Normal   NodeHasSufficientDisk    36m (x2 over 36m)  kubelet, ip-10-150-36-156.eu-west-1.compute.internal     Node ip-10-150-36-156.eu-west-1.compute.internal status is now: NodeHasSufficientDisk
  Normal   NodeHasSufficientMemory  36m (x2 over 36m)  kubelet, ip-10-150-36-156.eu-west-1.compute.internal     Node ip-10-150-36-156.eu-west-1.compute.internal status is now: NodeHasSufficientMemory
  Normal   NodeHasNoDiskPressure    36m (x2 over 36m)  kubelet, ip-10-150-36-156.eu-west-1.compute.internal     Node ip-10-150-36-156.eu-west-1.compute.internal status is now: NodeHasNoDiskPressure
  Normal   NodeHasSufficientPID     36m                kubelet, ip-10-150-36-156.eu-west-1.compute.internal     Node ip-10-150-36-156.eu-west-1.compute.internal status is now: NodeHasSufficientPID
  Normal   NodeNotReady             36m                kubelet, ip-10-150-36-156.eu-west-1.compute.internal     Node ip-10-150-36-156.eu-west-1.compute.internal status is now: NodeNotReady
  Warning  SystemOOM                36m (x4 over 36m)  kubelet, ip-10-150-36-156.eu-west-1.compute.internal     System OOM encountered
  Normal   NodeAllocatableEnforced  36m                kubelet, ip-10-150-36-156.eu-west-1.compute.internal     Updated Node Allocatable limit across pods
  Normal   Starting                 36m                kube-proxy, ip-10-150-36-156.eu-west-1.compute.internal  Starting kube-proxy.
  Normal   NodeReady                36m                kubelet, ip-10-150-36-156.eu-west-1.compute.internal     Node ip-10-150-36-156.eu-west-1.compute.internal status is now: NodeReady
```

Apparently processes, possibly including ``kubelet``, were killed at random by the node's operating system.

The nodes in our cluster are part of an auto-scaling group. So, considering we had intermittent outages and at that time had problems reaching Grafana, we decided to terminate the NotReady nodes one by one to see if new nodes would remain stable. This was not the case, new nodes appeared correctly but either some existing nodes or new nodes got into status NotReady.

It _did_ result however, in Prometheus and Grafana to be scheduled at a node that remained stable, so at least we had more data to analyze and the root cause became apparent quickly...

## Root cause




## Cascade of failures


Wrapup
- not even fixed on root cause
- company culture. Importance of blameless post mortems.


