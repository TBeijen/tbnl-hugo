---
title: Kubernetes Community Days 2023 Amsterdam
author: Tibo Beijen
date: 2023-03-02T15:00:00+01:00
url: /2023/03/02/kubernetes-community-days-2023-ams
categories:
  - articles
tags:
  - Kubernetes
  - CNCF
  - Community
  - Conference
description: Recap of the Kubernetes Community Days 2023 Amsterdam event
thumbnail: img/kcd2023.jpg

---
## Introduction

The last time Kubernetes Community Day took place in the Netherlands was [September 2019](/2019/09/16/kubernetes-community-day-amsterdam-2019/). Then the pandemic turned the world upside down, and suddenly we find ourselves in February 2023 for the next event. 

In those three years, [the event](https://community.cncf.io/events/details/cncf-kcd-netherlands-presents-kubernetes-community-days-amsterdam-2023/) became bigger, doubling in all aspects: The number of days (2), number of tracks (2), and audience now totaling 450 attendees. So either people fancy in-person events more than ever, or Kubernetes adoption simply continued growing.

Let's summarize some of the learnings and findings.

In this recap:

{{< toc >}}

{{< figure src="/img/kcd2023.jpg" title="Source: Twitter @cloudnativeams" >}}

## Main takeaways

*Note:* This is highly subjective, it mostly focuses on what would be most actionable and beneficial for the teams I represent.

### ArgoCD / GitOps

By no means a new concept in the CNCF space, ArgoCD, the most commonly used GitOps solution, is there to stay and has seen a lot of attention in past years. It fits the way Kubernetes operates nicely:

* Kubernetes: Give me YAML, and I will align the resources.
* ArgoCD: Give me git repos, and I will align the YAML.

It makes clear the separation between the CI (test, build, publish artifacts) and the CD parts (promote artifacts through various stages). Conceptually that makes a lot of sense, however, when diving in, questions might arise along the lines of "Ok, but _how_ exactly?". 

The presentation "GitOps Patterns for managing cloud native applications" covered this nicely. Demo code is available at Github: https://github.com/rcarrata/kcd23ams-gitops-patterns

Topics addressed included, SyncWaves, Hooks, App-of-app pattern, ApplicationSets (generators creating multiple applications) and promotion between environments.

### eBPF

The [Extended Berkeley Packet Filter](https://en.wikipedia.org/wiki/EBPF) is another technology that is making waves for some time. As Wikipedia describes it:

> A technology that can run sandboxed programs in a privileged context, such as the operating system kernel.

As Raymond de Jong from Isovalent described it in his presentation "Service MESH without the MESS":

> eBPF makes the kernel programmable in a secure way: _What Javascript is to the browser, eBPF is to the kernel_.

Cilium is a network plugin based on eBPF that provides:

* Advanced networking 
* Security
* Observability

More specifically, this means:

* Service mesh without sidecars
* Faster service mesh because of less TCP stack traversal
* Multi-cluster capabilities
* A control plane that can integrate with Istio
* Advanced observability for applications using [Hubble](https://github.com/cilium/hubble/) without requiring adapting the applications themselves.
* Replacement for Ingress controller (from `v1.13`: Shared load balancer for multiple ingress resources)

Cilium is already integrated into Google's Kubernetes offering and AWS [EKS Anywhere](https://isovalent.com/blog/post/2021-09-aws-eks-anywhere-chooses-cilium/). Sadly not (yet?) in standard EKS[^footnote_eks_cilium]. It is possible though, to [chain Cilium CNI to the default CNI with 0-downtime](https://medium.com/codex/migrate-to-cilium-from-amazon-vpc-cni-with-zero-downtime-493827c6b45e).

## Presentation notes

### "Scaling the 4th industrial revolution" (Opening Keynote) by Sarah Polan (Hashicorp)

An interesting talk about business operations, efficiency and agility in the context of [the 4th industrial revolution](https://www.weforum.org/agenda/2016/01/the-fourth-industrial-revolution-what-it-means-and-how-to-respond/), addressing concepts such as:

* [Occam's razor](https://en.wikipedia.org/wiki/Occam%27s_razor)
* [Conway's Law](https://en.wikipedia.org/wiki/Conway%27s_law)
* [Willow Run](https://en.wikipedia.org/wiki/Willow_Run)
* [OODA loop](https://en.wikipedia.org/wiki/OODA_loop)

The five factors of scalability:

* Simplicity
* Communication
* Standardization
* Automation
* Agility

Mentioned also:

> Lots of talking and many stakeholders lead to complex architectures...

### "gRPS Proxyless Service" by Gijs Molenaar (Spotify)

Spotify pioneering in the streaming business, requiring tools that didn't exist yet:

* Hermes: A protocol built on ZeroMQ and protobuf
* Nameless: Service discovery using DNS SRV records
* Helios: Spotify's internal K8S (Finished around time K8S launched, quickly replaced by K8S)

Things have changed over time, now using different tools.

Why not Istio? Proxy sidecar not favored. Need better multi-cluster and global capabilities. Some services outside K8S.

Currently using [Google Traffic Director](https://cloud.google.com/traffic-director), based on gRPC, not requiring sidecars.

### "Detecting cloud and container threats" by Marcel Claassen (Sysdig)

A talk about [Falco](https://falco.org/), a runtime security project.

Why runtime security? 

* There can be drift from scanned version
* Some threats are only present in runtime
* 0-Day exploits

Falco can use eBPF or run as kernel module.

[Falco Sidekick](https://falco.org/blog/extend-falco-outputs-with-falcosidekick/) can aggregate and forward.

Most seen security event: Shell in container (e.g. via log4j)

### "Operating high traffic websites on Kubernetes" by Salman Iqbal (Appvia)

Described the concepts of services, cloud load balancer and ingress. Then continued on how to scale an ingress controller using [KEDA](https://keda.sh/): Kubernetes Event-Driven Autoscaling.

Samples based on [this Nginx tutorial](https://www.nginx.com/blog/microservices-march-reduce-kubernetes-latency-with-autoscaling/).

### "Gateway API: The new way to travel north/south" by Ara Pulido (Datadog)

The `Ingress` resource mixes the responsibilities of the infrastructure provider, cluster operator and application developer. This can become problematic.

[Gateway API](https://gateway-api.sigs.k8s.io/) does not _replace_ Ingress but can provide solutions where Ingress is too limited.

### "Managed Kubernetes Service: Day Zero Survival Pack" by Kristina Devochko (Admincontrol)

Managed Kubernetes is not a PaaS.

Important:

* Day-0: Design & architecture
* Long-term tech strategy: Single cloud/multi-cloud, hybrid/cloud-only, serverless/Kubernetes.

To GitOps or not to GitOps, that's the question: Mature over time.

Cost-conscious:

* Node VM sizes
* Nightly shutdown
* Reserved instances
* Spot instances
* Policy management
* Cost-focused tools ([Kubecost](https://www.kubecost.com/), [Cast](https://cast.ai/), [Loft](https://loft.sh/))

Security considerations:

* Restrict to IP ranges or private network
* Unprivileged
* Minimal base images
* RBAC
* Namespaces are not tenants
* Network isolation

### "How CERN empowers its users with Kubernetes and OpenShift" by Jack Henschel (CERN)

Two flavors: 

* Kubernetes based on OpenStack Magnum (Power users, more flexible)
* Openshift based on [OKD](https://www.okd.io/) (More turnkey, using community edition of RedHat Openshift)

OKD4 cluster upgrades are automated and seamless.

OpenShift relies heavily on operators. ArgoCD fits this model well.

[Open Policy Agent](https://www.openpolicyagent.org/) is used to ensure unique hostnames across clusters.

Clusters at CERN are _pets_ since they contain a lot of data.

Operators for various purposes, including application management, DNS, and GitLab pages.

Lessons learned:

* The importance of internal documentation
* Operators are powerful, but a sharp tool
* Not _everything_ has to be automated
* Power users & casual users: Benefit both
* Share common competence and experience

### "Leading in Open Source - A Strategic Approach" by Dawn Foster (VMWare)

Three stakeholders:

* The project/community
* The individual contributor
* The company

Employees contribute as an individual on the company's behalf.

Community comes before an individual's or company's needs. _Strategy should take that into account!_

Open Source contribution works best with a long-term strategic approach.

Takeaways:

* Building trust takes time
* Align with business goals to highlight the importance and impact
* Focus on strategic projects with the biggest impact
* Guidelines and processes should make it _easy_ to contribute. Encourage!
* Measure success
* Upstream your patches
* Build relationships
* Leadership: Encourage people to move into leadership positions within their communities
* Discuss changes first within the community and break into smaller contributions

### "Cloud to on-prem and back again" by Gijs van der Voort (Picnic)

Description of the journey of Picnic to move to on-premise using [VMWare Tanzu](https://tanzu.vmware.com/tanzu) and back to AWS.

Running everything in two data center rooms proved to be complex. K8S does not abstract away the underlying hardware and the physical reality of having to deal with power outages. 

Moved back to AWS EKS, also allowing improvements such as Graviton.

Three types of applications:

* Stateless: Containers. HA. Applications
* Stateful HA: VM-based. Postgres, RabbitMQ, Consul
* Stateful non-HA: Control and transport systems. The physical part of the fulfillment center.

Size: 444 CPU, 465Gb Ram, 10TB storage.

Digital and mechanical engineering come together in the conveyors in the fulfillment center. Even with EKS in AWS Ireland, using Direct Link, latency of `< 100 msec` is accomplished, which encompasses:

* Scan
* Send event
* Calculate desired junction state
* Send desired state
* Change junction direction

### "The Great Lambda Migration to Kubernetes Jobs" by Liav Yona (Firefly)

[Firefly](https://www.gofirefly.io/) is SaaS platform that allows teams to manage their entire cloud footprint.

Started off with operations running in Lambda. Moved, partly because of the limited duration to ECS. Still proved costly, not open, hard to customize.

Now using Kubernetes, using CRD to define every customer account. Scalability and observability are key benefits.

Works for Firefly, by no means a serverless vs. Kubernetes talk.

## Summary

Although at a grander scale than 2019, KCD 2023 once again was an event that provided a lot of room for the 'hallway track'. Also, this particular one was a nice warm-up for KubeCon in April, which undoubtedly will be bigger, broader, and more in-depth.

Shout out to the organizers for making this event awesome! I'm looking forward to 2024.

[^footnote_eks_cilium]: Personal take: AWS might be dragging its feet a bit either because they want to have good integrations with AppMesh and X-Ray from the get-go or because Cilium has the potential to cannibalize these services._