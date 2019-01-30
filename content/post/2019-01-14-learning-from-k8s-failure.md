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
Since a number of months we ([NU.nl](https://www.nu.nl) development team) operate a small number of Kubernetes clusters. We see the potential of Kubernetes and how it can increase our productivity and how it can improve our CI/CD practices. Currently we run part of our logging and building toolset on Kubernetes, plus some small (internal) customer facing workloads, with the plan to move more applications there once we've build up knowledge and confidence.

Recently our team faced some problems on one of the clusters. Not as severe as to bring down the cluster completely, but definitely affecting end user experience of some interally used tools and dashboards.

Coincidentally, around the same time I visited DevOpsCon 2018 in Munich, where the opening keynote ["Staying Alive: Patterns for Failure Management from the Bottom of the Ocean"](https://devopsconference.de/business-company-culture/staying-alive-patterns-for-failure-management-from-the-bottom-of-the-ocean/) related very well to this incident.

The talk (by [Ronnie Chen](https://twitter.com/rondoftw), engineering manager at Twitter) focussed on various ways to make DevOps teams more effective in preventing and handling failures. One of the topics addressed was how catastrophes are usually caused by a cascade of failures, resulting in this quote:

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

Nodes ``NotReady``, not good. Describing various nodes (not just the unhealthy ones) showed:

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

It looked like the node's operating system was killing processes before the ``kubelet`` was able to reclaim memory, as [described in the Kubernetes docs](https://kubernetes.io/docs/tasks/administer-cluster/out-of-resource/#node-oom-behavior).

The nodes in our cluster are part of an auto-scaling group. So, considering we had intermittent outages and at that time had problems reaching Grafana, we decided to terminate the ``NotReady`` nodes one by one to see if new nodes would remain stable. This was not the case, new nodes appeared correctly but either some existing nodes or new nodes quickly got into status ``NotReady``.

It _did_ result however, in Prometheus and Grafana to be scheduled at a node that remained stable, so at least we had more data to analyze and the root cause became apparent quickly...

## Root cause

[One of the dashboards](https://grafana.com/dashboards/315) in our Grafana setup shows cluster-wide totals as well as a graphs for pod memory and cpu usage. This quickly showed the source of our problems.

{{< figure src="/img/learning_from_k8s_failure_grafana_pod_memory.png" title="Pods memory usage, during and after incident" >}}

Those lines going up into nowhere are all pods running [ElastAlert](https://github.com/Yelp/elastalert). For logs we have an Elasticsearch cluster running, and recently we had been experimenting with ElastAlert to trigger alerts based on logs. One of the alerts that was introduced shortly before the incident was an alert that would fire if our ``Cloudfront-*`` indexes would not receive new documents for a certain period. As the throughput of that Cloudfront distribution is a couple of millions of request/hour, this apparently caused an enormous ramp up in memory usage. In hindisght, [digging deeper into documentation](https://elastalert.readthedocs.io/en/latest/ruletypes.html#max-query-size), we'd better have used ``use_count_query`` and/or ``max_query_size``.

## Cascade of failures

So, root cause identified, investigated and fixed. Incident closed, right? Keeping in mind the quote from before, there's is still 85% of learnings to be found, so let's dive in:


### No alerts fired

### Grafana dashboard affected by cluster problems

### Not fully benefitting from our ELK stack

### No CPU & memory limits on ElastAlert pod

### No default or enforced cpu & memory limits

### No team-wide awareness of the ElastAlert change that was deployed

### No smoke tests

### Knowledge of operating Kubernetes limited to part of team



Better dashboarding & alerting on events

No cpu & memory limits

Smoke tests.




Wrapup
- not even fixed on root cause
- company culture. Importance of blameless post mortems.


