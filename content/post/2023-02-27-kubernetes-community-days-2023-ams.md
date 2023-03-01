---
title: Kubernetes Community Days 2023 Amsterdam
author: Tibo Beijen
date: 2023-02-27T10:00:00+01:00
url: /2023/02/27/kubernetes-community-days-2023-ams
categories:
  - articles
tags:
  - Kubernetes
  - CNCF
  - Community
  - Conference
description: Recap of the Kubernetes Community Days 2023 Amsterdam event
thumbnail: img/foobar.jpg

---
## Introduction

Last time Kubernetes Community Day took place in the Netherlands was [september 2019](/2019/09/16/kubernetes-community-day-amsterdam-2019/). Then the pandemic turned the world upside down and suddenly we find ourselves in february 2023 for the next event. 

In those 3 years the event became bigger, doubling in all aspects: The number of days (2), number of tracks (2) and audience now totalling 450 attendees. So either people fancy in-person events more than ever, or Kubernetes adoption simply continued to grow.

Let's summarize some of the learnings and findings.

## Main take-aways

Note: This is highly subjective, it mostly focuses on what would be most actionable and beneficial for the teams I represent.

### ArgoCD / GitOps

By no means a new concept in the CNCF space, ArgoCD, the most commonly used GitOps solution, is there to stay and sees a lot of attention in past years. It fits the way Kubernetes operates nicely:

* Kubernetes: Give me YAML, I will align the resources.
* ArgoCD: Give me git repos, I will align the YAML.

It makes clear the separation between the CI (test, build, publish artifacts) and the CD parts (promote artifacts through various stages). Conceptually that makes a lot of sense. However, when diving in questions might arise along the lines of "Ok, but _how_ exactly?". 

The presentation "GitOps Patterns for managing cloud native applications" covered this nicely. Demo code is available at Github: https://github.com/rcarrata/kcd23ams-gitops-patterns

Topics addressed included, SyncWaves, Hooks, App-of-app pattern, ApplicationSets (generators creating multiple applications) and promotion between environments.

### eBPF

The [Extended Berkeley Packet Filter](https://en.wikipedia.org/wiki/EBPF) is another technology that is making waves for some time. As Wikipedia describes it:

> A technology that can run sandboxed programs in a privileged context such as the operating system kernel.

As Raymond the Jong from Isovalent described it in his presentation:

> eBPF makes the kernel programmable in a secure way: _What Javascript is to the browser, eBPF is to the kernel.

Cilium is a network plugin based on eBPF that provides:

* Advanced networking 
* Security
* Observability

More specifically this means:

* Service mesh without sidecars
* Faster service mesh because of less TCP stack traversal
* Multi-cluster capabilities
* A control plane that can integrate with Istio
* Advanced observability for applications using [Hubble](https://github.com/cilium/hubble/) without requiring adapting the applications themselves.
* Replacement for Ingress controller (from `v1.13`: Shared loadbalancer for multiple ingress resources)

Cilium is already integrated in Google's Kubernetes offering and [EKS Anywhere](https://isovalent.com/blog/post/2021-09-aws-eks-anywhere-chooses-cilium/). Sadly not (yet?) on standard EKS[^footnote_eks_cilium]. It is possible though to [chain Cilium CNI to the default CNI with 0-downtime](https://medium.com/codex/migrate-to-cilium-from-amazon-vpc-cni-with-zero-downtime-493827c6b45e).



[^footnote_eks_cilium]: Personal take: AWS might be dragging its feet a bit either because they want to have good integrations with AppMesh or X-Ray from the get-go, or because Cilium has the potential to cannibalize on these services.