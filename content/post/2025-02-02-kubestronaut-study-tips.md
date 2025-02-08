---
title: "Study tips for becoming a Kubestronaut"
author: Tibo Beijen
date: 2025-02-10T05:00:00+01:00
url: /2025/02/10/study-tops-for-becoming-a-kubestronaut
categories:
  - articles
tags:
  - CNCF
  - Certification
  - CKAD
  - CKA
  - CKS
description: Tips for studying and preparing for the five CNCF exams that grant the Kubestronaut title
thumbnail: 

---

## Introduction

## Order of exams

First thing to think about is in what order to take the exams. Some build up to others. So, if starting from having little experience in the CNCF ecosystem, building up difficulty, a logical order would be:

> KCNA → KCSA → CKAD → CKA → CKS

One could consider doing KCSA later, between CKA and CKS. The topic being security, it nicely helps shifting the focus there. And the hands-on exams are more 'fun' and tangible, so this could help keep momentum. This is of course highly subjective.

Now for a bit of context: I use Kubernetes since 2018, mostly AWS EKS, and work in tech for about 20 years. Yet, it's easy to spend years using Kubernetes and hardly ever have to deal with things like `etcdctl`, `kubeadm`, encrypting etcd, `ImagePolicyWebhook`, etc. So, I was mostly focused on CKA and CKS to fill in knowledge gaps, and then the inner completionist got the upper hand. I started with CKA, followed by CKS and then wound up the series a couple of weeks after that in a short timespan. That worked very well or me, starting with the 'new' stuff which is engaging and motivating. But, as always: YMMV.

Whatever your experience level is, know that CKS is (by far) the hardest and not to be underestimated: It has the widest range of topics in scope, and is the hardest to complete within the 2 hours you have during the exam. Also, October 15, 2024, some [new topics have been added](https://training.linuxfoundation.org/cks-program-changes/), so be aware that not all study material reflects that.

Similarly, February 18, 2025, there will be a [change to the CKA exam](https://training.linuxfoundation.org/certified-kubernetes-administrator-cka-program-changes/).

## Practice and take notes

Whether it is reading written material, watching video content, or doing interactive hands-on practices, what worked for me is: Take notes. Just start a repo with a markdown file. Write down topics, keywords, or sample commands. For me this has two purposes: It forces me te keep focus. And some of the topics I later move to a 'to-do' section, indicating I need to study that more.

Also, during the hands-on training, I sometimes noted keywords that lead to the correct page in the Kubernetes documentation. For example, 'kubeadm reconfigure' leads to [the page describing how to use various configmaps](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-reconfigure/) to configure various components throughout a cluster.

In general, I found the ['tasks' pages in the documentation](https://kubernetes.io/docs/tasks/) the most usable during the hands-on exams.

## KillerCoda

Having a homelab can help, but in my experience is absolutely not necessary. Regardless of having one or not, I can highly recommend using [KillerCoda](https://killercoda.com/) for two reasons:

First, by its very nature it resets. So you can easily repeat certain exercises, or start over when messing up. Especially topics like upgrading a cluster, or encrypting etcd secrets, become very accessible and repeatable this way.

Second, taking the [Plus membership](https://killercoda.com/account/membership) brings an additional advantage: It allows you to solve the CKA, CKS, CKAD scenarios in the Exam Remote Desktop. Mind you, this not a _nice_ experience: There is lag, clunky copy-paste, reduced screen estate. But that's how the exam is, and I found that helped massively in getting comfortable with the exam environment.

Based on study material and notes taken, define some practices for yourself and simply use the playgrounds where you can turn everything inside-out at will.

## Keep it simple, make it routine

In your day-to-day job you might have a highly tailored set of aliases and shell extensions, and a multi-screen setup that resembles a space control center. 

You can't bring those to the exam.

So, similar to using the real clunky remote desktop in KillerCoda, practice in a setup that is representative for what you will be using during the exam. One of the most challenging aspects of the exams, especially CKS, is the lack of time. In my experience you won't lose critical time from typing something out that is routine. Instead, it's the unexpected fumbling, that will take time, _and_ put you of track.

Be aware that you will be SSH-ing into various virtual machines during the exam, so anything you customize in one place, will be gone in the next. So:

* No k9s. `kubectl` all the way. Luckily that one _is_ aliased to `k`.
* No alias `$now` for `--force --grace-period 0`
* No alias `$do` for `--dry-run=client -o yaml`

You _can_ use them if you insist, but if they're suddenly not there, you find yourself waiting for a pod to terminate, or need to replace the pod you accidentally created. In my opinion not worth it. Once again: YMMV.

## CKAD, CKA and CKS 

Killercoda

Use one practice exam. Remains accessible for about 30 hours. Be sure to save the page

## KCNA and KCSA

Relatively easy. Use practice exams to gauge one's readiness.

Free resources;

* https://www.itexams.com/exam/KCNA - Not used myself. Looks free and representative although UI a bit clunky.
* https://www.examtopics.com/exams/linux-foundation/kcna/view/
* https://github.com/thiago4go/kubernetes-security-kcsa-mock

## During the exam

Disable smooth scrolling

Consider reducing font size

Open a note in mousepad and keep open

## CLI essentials

Muscle memory

`--dry-run=client -o yaml`
`--grace-period=0 --force`

Use `k explain`

```sh
k explain ciliumnetworkpolicy.spec.egressDeny
```

Use `man`

```sh
man Dockerfile
man docker-run
man docker-build
```

Search & navigate 

Vim basics

select, cut, copy, paste. Remove line, increase/decrease indent

```sh
# curl with max timeout 1 sec
curl -m 1 http://my-svc.my-ns.svc.cluster.local

# When asked for formatting displaying 'time in nanoseconds'
falco --list |grep nano

# -n: Create 16-char length base64 pw without newline being appended to value
echo -n "this-is-very-sec" |base64
```

## Concluding

