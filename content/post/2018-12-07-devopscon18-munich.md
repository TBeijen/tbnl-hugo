---
title: 'DevOpsCon 2018 Munich'
author: Tibo Beijen
date: 2018-12-08T10:00:00+02:00
url: /2018/12/08/devopscon18-munich/
categories:
  - articles
tags:
  - Devops
  - Conference
  - Munich
  - Kubernetes
  - CI/CD
description: Recap of DevOpsCon 2018 conference in Munich.

---
Tuesday 4th and wednesday 5th the [DevOps Conference 2018](https://devopsconference.de/) took place in Munich. With a program filled with talks addressing 'DevOps' topics such as CI/CD, Kubernetes, Security, Company culture and change, Microservices, I was lucky enough to attend. Below you'll find a slightly redacted version of the notes I took during the talks and off-track chats I had with several people.

## Day 1

### [Staying Alive: Patterns for Failure Management from the Bottom of the Ocean](https://devopsconference.de/business-company-culture/staying-alive-patterns-for-failure-management-from-the-bottom-of-the-ocean/)

Opening keynote drawing parallels between deep-sea diving and Devops, comparing aspects such as training, adapting, learning and chain of events that lead to incidents.

* Succes is when failure becomes routine and boring.
* Security systems that aren't used do not exist.
* Security systems that aren't tested do not exist either.
* Evaluating risk: Gauge the magnitude of regret.
* Incident training: Inexperienced people to the front! As a result:

  * Equalize the gap in experience
  * Revise and improve systems
  * Raise the floor

* Improving:

  * Refining judgement
  * Post mortems
  * Pre mortems
  * Fire drills
  * Revisit past decisions

### [Running Kubernetes in Production at Scale: Centralizing Operations and Governance](https://devopsconference.de/docker-kubernetes/running-kubernetes-in-production-at-scale-centralizing-operations-and-governance/)

[Oleg Chunikhin](https://twitter.com/olgch) of [Kublr](https://kublr.com/) gave a technical run-through of [how Kublr works](https://kublr.com/how-it-works/). What I found especially interesting was that they had Prometheus running outside of the clusters, using a prometheus collector inside the individual cluster. In a brief chat we had later, Oleg explained they use [federation](https://prometheus.io/docs/prometheus/latest/federation/) for that. 

Based on prior research I was under the impression that simply forwarding was not one of the adviced/typical use cases, but I'll definitely explore this further. There for sure is an advantage in having metrics available *outside* of a cluster, as a recent mishap we experienced teached us.  (I'll blog about that later. Kubernetes failures are entertaining reads and based on other talks we are in great company.)

For backups [Heptio community tools](https://heptio.com/community/) were mentioned.

### [Continuous Delivery requires Release Orchestration](https://devopsconference.de/continuous-delivery/continuous-delivery-requires-release-orchestration/)

Highly enjoyable talk on the challenges of delivering software fast. Following quote of course wins over the audience:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Good presentation already: Release our big bugs more often. Get beer more often. <a href="https://twitter.com/hashtag/devopscon?src=hash&amp;ref_src=twsrc%5Etfw">#devopscon</a> <a href="https://twitter.com/hashtag/xebia?src=hash&amp;ref_src=twsrc%5Etfw">#xebia</a></p>&mdash; Tibo Beijen (@TBeijen) <a href="https://twitter.com/TBeijen/status/1069903784120381440?ref_src=twsrc%5Etfw">December 4, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Some other mentions:

* Feedback loops should be fast! 12-15 minutes tops, otherwise too slow.
* Value stream mapping
* Microservices can encourage silos
* Definition of quality: Software that does exactly what the customer wants it to do at the speed at which the customer wants it to happen.

And this slide, showing how much we've learned...

<!--  -->
<!--  -->
<!--  -->
**TODO: SLIDE**




### [OpenSource Pentesting & Security Analysis Tools: The DevOps-way…](https://devopsconference.de/security/opensource-pentesting-and-security-analysis-tools/)

A talk that focussed mainly on [OWASP ZAP](https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project), a tool to perform passive and active security scans on an application. It can be run headless and can be integrated in CI/CD pipelines. Passive scanning is relatively fast and could be performed on every commit.

This type of scanning goes well with e2e tests (e.g. Selenium) that generate actual traffic.

### [Service Mesh – Kilometer 30 in a Microservices Marathon](https://devopsconference.de/microservices/service-mesh-kilometer-30-in-a-microservice-marathon/)

Drawing a parallel between the 30th kilometer of a marathon (the man with the hammer) and the moment the number of services in a cluster spins out of control: All at a sudden things get very tough.

It focused mainly on [Istio](https://istio.io/) but also [Linkerd](https://linkerd.io/) was mentioned.

Advantages of a service mesh include: 

* Handling resilience at the platform level (a big potential win over doing it in various applications in various frameworks in various ways)
* Features like canary release, circuit breakers
* Tracing
* Ability to test application resilience via fault injection

Jokingly the comparison between doing things 'the wrong way' and sticking a knife in your leg was made. Very apt in my opinion, you'll keep moving forward but it will be slow and hurts a lot. I'll keep that in mind if I need a non-technical answer to the question of 'why would one be doing this devops thing?'.

The tracability got me wondering how that holds up with GraphQL which tends to wrap errors in the response:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">gRPC has a similar problem and <a href="https://twitter.com/linkerd?ref_src=twsrc%5Etfw">@linkerd</a> shows both the http status code *and* the gRPC status code.</p>&mdash; Thomas (@grampelberg) <a href="https://twitter.com/grampelberg/status/1070005094089809921?ref_src=twsrc%5Etfw">December 4, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


### [Continuous Integration/Continuous Delivery for Microservices: Rule them all](https://devopsconference.de/continuous-delivery/continuous-integration-continuous-delivery-for-microservices-rule-them-all/)

A talk about the CI/CD setup of [LivePerson](https://www.liveperson.com/), a messaging platform for brands. Some numbers: 200 Microservices, 7000 deploys/year, 15000 builds/week, 5 DevOps engineers. They converged their setup to Maven and NPM, offering teams a end-to-end pipeline as service. One of the (commercial) services used in their pipeline is Checkmarx for security scanning.

On my question on how to manage the integration testing aspect of 200 pipelines that cause a lot of parallel movement: It is a pain point, focus as much as possible on contract testing.

### [Expert’s panel discussion](https://devopsconference.de/organizational-change/experts-panel-discussion/)

A panel discussion on how to effictively achieve 'digital transformation' and establish 'devops culture'. Some highlights:

* Don't copy the answers, copy the questions.
* Consider transformation as a constant process.
* Recipe for disaster: The [Peter principle](https://en.wikipedia.org/wiki/Peter_principle) in effect. Middle management getting a level down and doing micromanagement.
* Netflix example: Teams have freedom of choice. There's the paved highway. And there's going custom as long as requirements are met.

## Day 2



<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">This feels like home: „engineering has anecdotes from daily stand up as a measure of success” 😂🤦‍♂️🤷‍♂️. Entertaining talk by <a href="https://twitter.com/jbaruch?ref_src=twsrc%5Etfw">@jbaruch</a> and <a href="https://twitter.com/ligolnik?ref_src=twsrc%5Etfw">@ligolnik</a> at <a href="https://twitter.com/hashtag/devopscon?src=hash&amp;ref_src=twsrc%5Etfw">#devopscon</a> <a href="https://t.co/VCIU0n02Ku">pic.twitter.com/VCIU0n02Ku</a></p>&mdash; Torsten Bøgh Köster (@tboeghk) <a href="https://twitter.com/tboeghk/status/1070229667267911680?ref_src=twsrc%5Etfw">December 5, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


