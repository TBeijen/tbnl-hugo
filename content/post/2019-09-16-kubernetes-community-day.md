---
title: 'Kubernetes Community Day Amsterdam 2019'
author: Tibo Beijen
date: 2019-09-16T10:00:00+01:00
url: /2019/09/16/kubernetes-community-day-amsterdam-2019/
categories:
  - articles
tags:
  - Conference
  - Kubernetes
  - Community
  - Amsterdam
  - KCD19
description: "Short recap of the Kubernetes Community Day that took place 2019."
---

Friday sept. 13th the small conference 'Kubernetes Community Day 2019' took place in Pakhuis de Zwijger in Amsterdam.
Small-scale events like this are a nice counter-balance to the massive scale of CNCF/KubeCon: No flying for miles. Just one track so no need to choose and no missing out on interesting talks. 

From what I understood this was one of the goals: Being a smaller, more accessible (both geographically and financially), more environmentally conscious addition to the big conferences. This goal was emphasized by paying attention to the global footprint by offering single-track catering as well: All vegetarian.

Some take-aways:

### Ahold

* Uses a combination of Terraform and Ansible for infra provisioning. Ansible more or less providing the magic & glueing.
* Uses Rancher to create clusters in different clouds, providing an identical interface for, say, Azure and GKE. (Interesting, as Terraform provides infra-as-code, but not this level of abstraction)

### Operators

* Managing the operators: [Operator Lifecycle Manager](https://github.com/operator-framework/operator-lifecycle-manager)
* Mind permissions. What can an operator do? Who can use it?

### ABN

* 3-stage pipeline: Application, Docker image & Cloud delivery
* Uses Foritfy for secure coding scan
* Policy enforcement:

  * OPA (Kubernetes)
  * Sentinel (Terraform)


