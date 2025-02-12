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
thumbnail: img/kubestronaut-study-header.jpg

---

## Introduction

At KubeCon 2024 in Paris, CNCF introduced the [Kubestronaut](https://www.cncf.io/training/kubestronaut/) program. Quoting:

> The Kubestronaut program recognises community leaders who have consistently invested in their ongoing education and grown their skill level with Kubernetes.

> Individuals who have successfully passed every CNCF’s Kubernetes certifications – CKA, CKAD, CKS, KCNA, KCSA – will receive the title of “Kubestronaut”

From October 2024 through Januari 2025 I completed the five exams. Overal, I think about 2/3 of my preparation time has been spent on CKS alone.

In this article I'll share what worked for me while studying and taking the exams. I hope it encourages and helps anyone in passing them all!

{{< figure src="/img/kubestronaut-study-certificates.jpg" title="Kubestronaut certificates, inspired by my son's night lamp" >}}

## Order of exams

First thing to think about is in what order to take the exams. Some build up to others. So, if starting from having little experience in the CNCF ecosystem, building up difficulty, a logical order would be:

> KCNA → KCSA → CKAD → CKA → CKS

One could consider doing KCSA later, between CKA and CKS. The topic being security, it nicely helps shifting the focus there. And the hands-on exams are more 'fun' and tangible, so this could help keep momentum. This is of course highly subjective.

Now for a bit of context: I use Kubernetes since 2018, mostly AWS EKS, and work in tech for about 20 years. Yet, it's easy to spend years using Kubernetes and hardly ever have to deal with things like `etcdctl`, `kubeadm`, encrypting etcd, `ImagePolicyWebhook`, etc. So, I was mostly focused on CKA and CKS to fill in knowledge gaps. And then the inner completionist got the upper hand. I started with CKA, followed by CKS and then wound up the series a couple of weeks after that in a short time span. 

That worked very well _for me_, starting with the 'new' material which I found engaging and motivating. But, as always: YMMV.

Whatever your experience level is, know that CKS is (by far) the hardest and not to be underestimated: It has the widest range of topics in scope, and is the hardest to complete within the 2 hours you have during the exam. Also, October 15, 2024, some [new topics have been added](https://training.linuxfoundation.org/cks-program-changes/), so be aware that not all study material reflects that yet.

Similarly, February 18, 2025, there will be a [change to the CKA exam](https://training.linuxfoundation.org/certified-kubernetes-administrator-cka-program-changes/).

## Practice and take notes

Whether it is reading written material, watching video content, or doing interactive hands-on practices, what worked for me is: Take notes. Just start a repo with a markdown file. Write down topics, keywords, or sample commands. For me this has two purposes: It forces me to stay focused. And some of the topics I later move to a 'to-do' section, indicating I need to study that more.

Also, during the hands-on training, I sometimes noted keywords that lead to the correct page in the Kubernetes documentation. For example, 'kubeadm reconfigure' leads to [the page describing how to use various configmaps](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-reconfigure/) to configure cluster components, including kubelet. Initially my searches only yielded pages about configuring kubelet itself, not specifically the kubeadm way.

In general, I found the ['tasks' pages in the documentation](https://kubernetes.io/docs/tasks/) the most valuable during the hands-on exams.

## Killercoda

Having a homelab is a great source of learning in general, but in my experience not necessary for preparing the Kubestronaut exams. Regardless of having one or not, I can highly recommend using [Killercoda](https://killercoda.com/) for two reasons:

First, by its very nature it resets. So you can easily repeat certain exercises, or start over when messing up. Especially topics like upgrading a cluster, or encrypting etcd secrets, become very accessible and repeatable this way.

Second, taking the [Plus membership](https://killercoda.com/account/membership) brings an additional advantage: It allows you to solve the CKA, CKS and CKAD scenarios in the Exam Remote Desktop. Mind you, this not a _nice_ experience: There is lag, clunky copy-paste, reduced screen estate. But that's how the exam is, and I found that helped massively in getting comfortable with the exam environment.

Based on study material and notes taken, define some practices for yourself and simply use the Killercoda playgrounds where you can turn everything inside-out at will.

## Keep it simple, make it routine

In your day-to-day job you might have a highly tailored set of aliases and shell extensions, and a multi-screen setup that resembles a space control center. 

You can't bring those to the exam.

So, similar to using the real clunky remote desktop in Killercoda, practice using a setup that is representative for what you will be using during the exam. One of the most challenging aspects of the exams, especially CKS, is the lack of time. In my experience you won't lose critical time from typing something out that is routine. Instead, it's the unexpected fumbling, that will take time, _and_ put you off the track.

Be aware that you will be SSH-ing into various virtual machines during the exam, so anything you customize in one place, will be gone in the next. So:

* No k9s. `kubectl` all the way. Luckily that one _is_ aliased to `k`.
* No alias `$now` for `--force --grace-period 0`
* No alias `$do` for `--dry-run=client -o yaml`

You _can_ use them if you insist, but if they're suddenly not there, you find yourself waiting for a pod to terminate, or need to replace the pod you accidentally created. In my opinion not worth it. Once again: YMMV.

What worked for me: Two terminal tabs. One primary for working on the task, one secondary, for example to `k explain` my way around a certain topic. Also I started every exam with opening mousepad, for notes about questions to come back to. I found that easier than the notepad built into the PSI Secure Browser[^footnote_mousepad].

## CKAD, CKA and CKS 

Besides using KillerCoda I would suggest using one of the two [Killer.sh](https://killer.sh/) practice exams quite early in your study plan, for several reasons:

* Gauge one's readiness. So, see how far you get within the 2 hours. But also, get a feeling of what's expected.
* Use it as a practice environment for the duration of 36 hours. So: Best plan _when_ you want to activate the practice exam, to get the most out of it. No point in starting it at the start of a busy work week.
* A web page with detailed step-by-step solutions and explanations will be available in that 36 hour. Be sure to save that page on disk to refer to later. It is great study material.

For studying the topics of CKS, [Kim Wüstkamp's CKS course is available for free on Youtube](https://www.youtube.com/watch?v=d9xfB5qaOfg). While it does not include all the recently added topics, it still contains most of what you need to know. If just wanting to _pass_ the exam, 11 hours of video content might not be the most time-effective option. (And, mind you, that is excluding the time to do the hands-on labs that are included). Focusing on scenarios and researching anything unknown, might be faster. But if you actually want to _learn_, it's a great trove of knowledge.

In general, time is scarce. So know what can be done fast using imperative `kubectl` commands, and when you need to save and edit YAML first. For example, in your day job, using Helm or Kustomize, you might never use `kubectl expose`. But in the exam it is the fastest way to create a service.

I have created a gist containing [topic summaries and command examples I created while studying CKS](https://gist.github.com/TBeijen/028556fea2a62623f455590d82dabb46).

## KCNA and KCSA

These two are relatively easy. A good starting point would be some practice exams to see what topics are included. Based on that one could determine if purchasing additional courses is needed or one already has enough knowledge.

Some free resources:

* [Kubernetes Security KCSA Mock Exam](https://kubernetes-security-kcsa-mock.vercel.app/), A great resource of almost 300 practice questions by Thiago S Shimada Ramos. ([Github source](https://github.com/thiago4go/kubernetes-security-kcsa-mock)).
* [KCNA questions on examtopics.com](https://www.examtopics.com/exams/linux-foundation/kcna/). Haven't used this myself. Looks suitable to get an impression on the types of question to expect.

Of course there are also paid options on various e-learning platforms. I purchased some KCNA(https://www.udemy.com/course/kcna-kubernetes-and-cloud-native-associate-practice-exams/) and [KCSA](https://www.udemy.com/course/kcsa-kubernetes-cloud-native-security-associate-exam-prep/) practice exams on Udemy when they were on a bargain (EUR 10-ish each). They are fine and provide some explanation on each question, but I could have done with the free options. Especially KCSA, since the aforementioned mock exam provides ample practice material.

## During the exam

Somehow scrolling in Firefox in the remote desktop makes you feel like you're drunk. You scroll a bit, and the part you're interested in scrolls right past, out of the screen. What I found helpful is disabling 'smooth scrolling'.

Depending on screen size and distance to the screen, it might be worth reducing font size (`ctrl -`) in both the terminal and Firefox, to allow more content to be in view. 

Furthermore, in the exam there are no reset or retry options. So, if asked to modify a deployment, given an original file, it might be worth copying that file to `<filename>.ori` _first_.

Also, when generating YAML to be modified later, find a consistent naming scheme that works for you. For example `q13-netpol-deny-all.yaml`. I can't fully remember, but if more than one exam question use the same VM, it will help when needing to re-address a particular question.

During the exam, some tasks might have you wait. For example upgrading a node using `kubeadm`. This can stress you out if you are already running out of time. You _could_ use that time to do some research on previous questions. But keep in mind that it also causes a distraction and increases the risk of making a mistake. Tip: Follow the steps _exactly_. Example: During the exam `kubeadm` only upgraded _after_ I executed `apt-mark unhold kubeadm`. I got into a habit of skipping that because it was never needed in the Killercoda environment.

And, as mentioned before, use mousepad to take notes.

{{< figure src="/img/kubestronaut-firefox-terminal.png" title="Two terminal tabs ✔. Mousepad ✔. Smooth scroll disabled ✔. Ready to go!" >}}

## CLI essentials

You don't need to be a command line wizard, but an understanding of Linux and command line fundamentals is needed. Some tips:

```bash
# Build muscle memory:
k --dry-run=client -o yaml
k --grace-period=0 --force

# Use k explain
k explain ciliumnetworkpolicy.spec.egressDeny

# Use man
man Dockerfile
man docker-run
man docker-build

# Quickly find falco params about nanoseconds
falco --list |grep nano

# Test connectivity, limiting time-out wait time
curl -m 1 http://my-svc.my-ns.svc.cluster.local
```

Vim basics:

* Enter 'insert mode'/exit back to 'command mode': `i`/`esc`
* Save file (when in command mode): `:w`. Save & exit: `:wq`. Exit without saving: `:q!`
* Select block: `shift-v`, then cut `d`, copy `y`. 
* Paste copied/cut block elsewhere, move to insert point and: `shift-p`.
* Decrease/increase selected block: `<`/`>`. Repeat with `.`
* Move to start/end line: `^`/`$`
* Backward/forward one word: `b`/`w`

## Concluding

In general, I am somewhat skeptical of the type of exams that has you memorize small details of various cloud services. Those can be looked up easily, and are subject to change. Compared to those, the hands-on exams were a nice experience.

Interestingly, in a professional setting, one might hardly ever use `kubectl` to configure clusters: Git and automation are the norm. Even so, knowing the fundamentals of Kubernetes helps. And, in my opinion, the exam format succeeds in testing that fundamental knowledge: Without preparation you'll run out of time. Prepared, one can still quickly look up details, just like the real world.

Final note: If liking multiple choice exams, one can now pursue 'Golden Kubestronaut' status. Introduced at KubeCon India, this requires 7 more exams, for a total of twelve. If I were to pursue that, I suppose by the time that is completed, I have to start renewing the original five...

Hopefully this gave inspiration to pursue new learnings and maybe even Kubestronaut status! Don't hesitate to find me on [LinkedIn](https://www.linkedin.com/in/tibobeijen/) or [BlueSky](https://bsky.app/profile/tibobeijen.nl). Thanks for reading!

[^footnote_mousepad]: Apparently Killercoda recommends mousepad for notes as well, which I just recently noticed. Anyway, it's a good tip.