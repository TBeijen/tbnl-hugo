---
title: 'DevOpsCon 2018 Munich'
author: Tibo Beijen
date: 2018-12-10T08:00:00+01:00
url: /2018/12/10/devopscon18-munich/
categories:
  - articles
tags:
  - DevOps
  - Conference
  - Munich
  - Kubernetes
  - CI/CD
description: Recap of the DevOpsCon 2018 conference in Munich.

---
Tuesday 4th and wednesday 5th the [DevOps Conference 2018](https://devopsconference.de/) took place in Munich. Offering a program filled with talks addressing 'DevOps' topics such as CI/CD, Kubernetes, Security, Company culture and change, Microservices, I was lucky enough to attend. Below you'll find a slightly redacted version of the notes I took during the talks and off-track chats I had with several people.

## Day 1

### [Staying Alive: Patterns for Failure Management from the Bottom of the Ocean](https://devopsconference.de/business-company-culture/staying-alive-patterns-for-failure-management-from-the-bottom-of-the-ocean/)

_#Business & Company Culture_

Opening keynote drawing parallels between deep-sea diving and DevOps, comparing aspects such as training, adapting, learning and chain of events that lead to incidents.

* Success is when failure becomes routine and boring.
* Security systems that aren't used do not exist.
* Security systems that aren't tested do not exist either.
* Evaluating risk: Gauge the magnitude of regret.
* Post mortems only focusing on root cause ignore a lot of what went wrong.
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

_#Docker & Kubernetes_

[Oleg Chunikhin](https://twitter.com/olgch) of [Kublr](https://kublr.com/) gave a technical run-through of [how Kublr works](https://kublr.com/how-it-works/). 

What I found especially interesting was that Kublr runs Prometheus outside of the clusters, using a prometheus collector inside each individual cluster. In a brief chat we had later, Oleg explained they use [federation](https://prometheus.io/docs/prometheus/latest/federation/) for that. Based on prior research I was under the impression that forwarding all metrics was not one of the adviced/typical use cases, but I'll definitely explore this further. 

There for sure is an advantage in having metrics available *outside* of a cluster, as a recent mishap we experienced taught us.  (I'll blog about that later. Kubernetes failures are entertaining reads and based on other talks we are in great company.)

For backups [Heptio community tools](https://heptio.com/community/) were mentioned.

### [Continuous Delivery requires Release Orchestration](https://devopsconference.de/continuous-delivery/continuous-delivery-requires-release-orchestration/)

_#Continuous Delivery_

Highly enjoyable talk on the challenges of delivering software fast. Following quote of course wins over the audience:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Good presentation already: Release our big bugs more often. Get beer more often. <a href="https://twitter.com/hashtag/devopscon?src=hash&amp;ref_src=twsrc%5Etfw">#devopscon</a> <a href="https://twitter.com/hashtag/xebia?src=hash&amp;ref_src=twsrc%5Etfw">#xebia</a></p>&mdash; Tibo Beijen (@TBeijen) <a href="https://twitter.com/TBeijen/status/1069903784120381440?ref_src=twsrc%5Etfw">December 4, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Some other mentions:

* Feedback loops should be fast! 12-15 minutes tops, otherwise too slow.
* Value stream mapping.
* Microservices can encourage silos.
* Definition of quality: Software that does exactly what the customer wants it to do at the speed at which the customer wants it to happen.

And this slide, showing how much we've learned in the past 25 years:

{{< figure src="/img/devopscon18__orchestration_slide.jpg" title="" >}}

### [OpenSource Pentesting & Security Analysis Tools: The DevOps-way…](https://devopsconference.de/security/opensource-pentesting-and-security-analysis-tools/)

_#Security, #Live Demo, #slideless_

A talk that focussed mainly on [OWASP ZAP](https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project), a tool to perform passive and active security scans on an application. It can be run headless and can be integrated in CI/CD pipelines. Passive scanning is relatively fast and could be performed on every commit.

This type of scanning goes well with e2e tests (e.g. Selenium) that generate actual traffic.

### [Service Mesh – Kilometer 30 in a Microservices Marathon](https://devopsconference.de/microservices/service-mesh-kilometer-30-in-a-microservice-marathon/)

_#Microservices_

Drawing a parallel between the 30th kilometer of a marathon (the man with the hammer) and the moment the number of services in a cluster spins out of control: All at a sudden things get very tough.

It focused mainly on [Istio](https://istio.io/) but also [Linkerd](https://linkerd.io/) was mentioned.

Advantages of a service mesh include: 

* Handling resilience at the platform level (a big potential win over doing it in various applications in various frameworks in various ways)
* Features like canary release, circuit breakers
* Tracing
* Ability to test application resilience via fault injection

Jokingly the comparison between doing things 'the wrong way' and sticking a knife in your leg was made. Very apt in my opinion, you'll keep moving forward but it will be slow and hurts a lot. I'll keep that in mind if I need a non-technical answer to the question of 'why would one be doing this DevOps thing?'.

The tracability got me wondering how that holds up with GraphQL which tends to wrap errors in the response instead of returning an error http status:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">gRPC has a similar problem and <a href="https://twitter.com/linkerd?ref_src=twsrc%5Etfw">@linkerd</a> shows both the http status code *and* the gRPC status code.</p>&mdash; Thomas (@grampelberg) <a href="https://twitter.com/grampelberg/status/1070005094089809921?ref_src=twsrc%5Etfw">December 4, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

### [Continuous Integration/Continuous Delivery for Microservices: Rule them all](https://devopsconference.de/continuous-delivery/continuous-integration-continuous-delivery-for-microservices-rule-them-all/)

_#Continuous Delivery, #Microservices_

A talk about the CI/CD setup of [LivePerson](https://www.liveperson.com/), a messaging platform for brands. Some numbers: 200 Microservices, 7000 deploys/year, 15000 builds/week, 5 DevOps engineers. They converged their setup to Maven and NPM, offering teams a end-to-end pipeline as service. One of the (commercial) services used in their pipeline is Checkmarx for security scanning.

On my question on how to manage the integration testing aspect of 200 pipelines that cause a lot of parallel movement: It is a pain point, focus as much as possible on contract testing.

### [Expert’s panel discussion](https://devopsconference.de/organizational-change/experts-panel-discussion/)

_#Business & Company Culture, #Organizational Change_

A panel discussion on how to effectively achieve 'digital transformation' and establish 'DevOps culture'. Some highlights:

* Don't copy the answers, copy the questions.
* Consider transformation as a constant process.
* Recipe for disaster: The [Peter principle](https://en.wikipedia.org/wiki/Peter_principle) in effect. Middle management getting a level down and doing micromanagement.
* Netflix example: Teams have freedom of choice. There's the paved highway. And there's going custom as long as requirements are met.

## Day 2

### [#DataDrivenDevops](https://devopsconference.de/logging-monitoring-analytics/datadrivendevops/)

_#Logging, Monitoring & Analytics_

DevOps usually contains a lot of dashboards, however engineering teams are typically bad at measuring our effectiveness, as the slide below subtly shows:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">This feels like home: „engineering has anecdotes from daily stand up as a measure of success” 😂🤦‍♂️🤷‍♂️. Entertaining talk by <a href="https://twitter.com/jbaruch?ref_src=twsrc%5Etfw">@jbaruch</a> and <a href="https://twitter.com/ligolnik?ref_src=twsrc%5Etfw">@ligolnik</a> at <a href="https://twitter.com/hashtag/devopscon?src=hash&amp;ref_src=twsrc%5Etfw">#devopscon</a> <a href="https://t.co/VCIU0n02Ku">pic.twitter.com/VCIU0n02Ku</a></p>&mdash; Torsten Bøgh Köster (@tboeghk) <a href="https://twitter.com/tboeghk/status/1070229667267911680?ref_src=twsrc%5Etfw">December 5, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Some quotes and take-aways:

* "80% of software is 80% done 80% of the time".
* "You know a bit about a lot and a lot about a bit".
* Often used metrics profit and velocity are not actionable.
* Canary deploys are a form of data driven continuous delivery.
* Velocity requires trust. Trust is build using data.

### [7 Principles for Production Ready Kubernetes](https://devopsconference.de/docker-kubernetes/7-principles-for-production-ready-kubernetes/)

_#Docker & Kubernetes_

Audi Business Innovation GmbH provides teams with a Kubernetes environment. Of course this didn't happen overnight and the road to it had it's share of bumps. In this talk a set of principles were outlined that will help any team that runs Kubernetes.

* Audi's stack includes: Kops, Sonarqube, Artifactory, Sonatype Nexus.
* Early-stage outages were related to in-place cluster upgrades, Romana network plugin error, ingress/egress down.
* Audi mixes Kubernetes applications with AWS managed services such as RDS.
* "Technology scales. Knowledge and people should scale as well".
* Define service risk and recovery objectives.
* [Helmsman](https://github.com/Praqma/helmsman) is effective at managing many deployments.
* Tools for backup:

  * Cluster state backup: [Heptio Ark](https://heptio.com/community/ark/).
  * EFS volumes: [BorgBackup](https://borgbackup.readthedocs.io/en/stable/), allowing incremental backups.

* Consider image pull policy, preventing pull from unknown source, [BlackDuck](https://www.blackducksoftware.com/products/hub) can be used for scanning.
* Focus on LTES, the 4 golden signals (Source: Google SRE book. Latency, Throughput, Error-rate, Saturation)

### [I deploy on Fridays (and maybe you should too)](https://devopsconference.de/continuous-delivery/i-deploy-on-fridays-and-maybe-you-should-too/)

_#Continuous Delivery_

This talk focused on various techniques to make teams work effectively and, as a result, be able to deploy 'all the time'.

Some take-aways:

* Survivor bias ("We're still here, apparently this works")
* Big steps, fail big. Small steps, fail small.
* Continuous everything.
* Product mindset instead of project mindset.
* Continuous delivery: code should always be in a releasable state.
* Best branching strategy: Don't branch! Branches delay integration so consider trunk based development.
* Code reviews delay flow, cause focus shifts for author and reviewer, and don't show the code that _hasn't been added_. Furthermore if the pull request is too big, people start 'scanning'. Alternatives:

  * Pair programming
  * Mob programming

* Decouple deployments from releases via feature toggles. However, beware for feature toggle debt!
* The value of pipelines as code. 
* Pipelines should be fast (15, 20 minutes max.)
* Potential testing layers: Unit, integration, acceptance, e2e.

### [Running Kubernetes in Production: A Million Ways to Crash Your Cluster](https://devopsconference.de/docker-kubernetes/running-kubernetes-in-production-a-million-ways-to-crash-your-cluster/)

_#Docker & Kubernetes_

[Slides](https://www.slideshare.net/try_except_/running-kubernetes-in-production-a-million-ways-to-crash-your-cluster-devopscon-munich-2018)

Zalando runs Kubernetes at scale (~100 clusters). In this talk some insights were given to what can go wrong and to how Zalando operates their clusters.


* Use [ResourceQuota](https://kubernetes.io/docs/concepts/policy/resource-quotas/) for team namespaces
* Dev, alpha, beta, stable branches for infra changes.
* E2e testing a change: Build cluster using old config, update config, test. Don't create using new config, test the update!
* Source of problems: Lack of unit /smoke tests
* DNS can become a problem. Switch to node-local dnsmasq and coredns.
* Zalando [has disabled cpu throttling](https://github.com/zalando-incubator/kubernetes-on-aws/issues/1026). Better utilization of cluster resources.
* Create reports of 'slack', the difference between resource requests and resources actually used.

### [When Performance matters – Effective Performance Testing from the Ground up](https://devopsconference.de/continuous-delivery/when-performance-matters-effective-performance-testing-from-the-ground-up/)

_#Continuous Delivery_

[Slides](https://speakerdeck.com/hassy/performance-testing-from-the-ground-up)

Hassy Veldstra of [Artillery.io](https://artillery.io/) how to effectively execute various types of performance tests, and integrate them into a CI/CD pipeline.

Some specific types of performance tests:

* Soak tests. Testing for a longer duration (1 - 2 hours) spotting memory leaks and the likes.
* Spike tests. Rapid ramp-up (Similar to when [a news platform](https://www.nu.nl) sends a breaking news push message).

Removing barriers:

* Tools that everyone has access to
* Tools that everyone can use

Reading tip: Production-ready Microservices - Susan J. Fowler (O'Reilly)

Organizing tests:

* Artillery blog article: https://artillery.io/blog/end-to-end-performance-testing-microservices
* Github template repo: https://github.com/artilleryio/acme-corp-api-tests

### Miscellaneous

Some pointers and insights obtained from chat with various attendants:

* Minimize integration tests where possible, focus on contract testing instead.
* Mutation testing as better measurement of test-suite quality than coverage.
* Automate the process to make process flaws visible. Move from there.
