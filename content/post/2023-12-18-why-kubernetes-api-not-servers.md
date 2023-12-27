---
title: "Why Kubernetes? Focus on the API, not the servers"
author: Tibo Beijen
date: 2023-12-18T08:00:00+01:00
url: /2023/12/18/why-kubernetes-api-not-servers
categories:
  - articles
tags:
  - Kubernetes
  - Serverless
  - GitOps
description: Discussing the value and cost of Kubernetes in the light of various tech topics of 2023
thumbnail: 

---

## End of the year: Reflection time

As we are moving from 2023 to 2024, it is a good moment to reflect. Undoubtedly, one of the biggest topics of the past year was the rise of AI. Or the rise of the expectations of the promise of AI, so you will. But somewhat closer to my day-to-day job, there were some events that stood out:

* The [Amazon Prime move from serverless microservices to 'monolith'](https://www.primevideotech.com/video-streaming/scaling-up-the-prime-video-audio-video-monitoring-service-and-reducing-costs-by-90) blogpost. Which was followed by a lot of clickbait lukewarm takes and "my tech stack is better than yours" type of discussions. Start at [this post by Jeremy Daly](https://offbynone.io/issues/233/) to pick some articles worth reading and avoiding about this topic.
* Social media being social media: Debates[^footnote_social_media_debate] about pretty much every tech topic, including how "Kubernetes has single-handed set our industry back a decade", as [put in perspective](https://twitter.com/kelseyhightower/status/1671582240026025986?lang=en) by Kelsey Hightower. Or 37signals' [move out of the cloud, dodging Kubernetes in the process](https://world.hey.com/dhh/we-have-left-the-cloud-251760fb).
* Datadog's outage. Caused by a variety of contributing factors that can be summarized by the keywords: Kubernetes, Cilium, eBPF, Systemd, OS updates. It's [all explained nicely](https://newsletter.pragmaticengineer.com/p/inside-the-datadog-outage) by Gergely Orosz (The Pragmatic Engineer).

Working with, and liking Kubernetes, reading all of the above, it's tempting to reflect on the question "What did I get into?". Or in a broader sense: "What are we as an industry getting ourselves into?".

Discussing the value and cost of Kubernetes in my opinion is not merely about "servers vs. serverless" or "simple vs. complex". But it's about at what point (assuming that point exists) do the benefits of Kubernetes outweigh the challenges.

So, let's focus on where Kubernetes stands, its strong points and look into avoiding some of its complexities.

In this article:

{{< toc >}}

## Versatility

Kubernetes is everywhere: It can facilitate a variety of workloads in a variety of environments:

{{< figure src="/img/why_k8s.versatility.svg" title="Kubernetes is everywhere" >}}

As can be seen in the above diagram, one can run Kubernetes in environments ranging from big clouds, small clouds, on-premise datacenters right up to edge computing.

Focusing on the type of workloads, Kubernetes can do a lot. But there are types of workload Kubernetes might not be particularly suited for. On the monolith side one could think of (legacy) mainframes. Or VM-based applications that are hard to containerize. 

The big cloud platforms offer a plethora of managed services, including databases, memory stores, messaging components and services focused on AI/ML and Big Data. For those, you _can_ run cloud-native cloud-agnostic alternatives within Kubernetes. But it requires more up-front effort, and the potential gain will differ per situation. 

Then on the far end of micro, big clouds offer 'serverless': Function-as-a-Service, typically well-integrated with components like an API Gateway and building blocks for event-driven architectures. One could decide to run those in Kubernetes, for example, using [Knative](https://knative.dev/). But it requires setting up and supporting those components first, whereas cloud in that regard is easier to get into. Additionally, serverless offers fast scaling and scale-to-zero as a distinguishing feature.

Big clouds offer many excellent services: Easy to get into and little to no operational burden. On the other hand, if putting in the effort, there is a lot Kubernetes _can_ do, while providing its users a standardized way-of-working (roughly: Put YAML in cluster), and platform teams a unified way to support engineering teams (roughly: Help come up with proper YAML and help put YAML in cluster). 

More on that standardization later.

## Why and how

As an organization, it is important to have a good understanding of why a (technical) strategy is chosen and what the expectations are.

As the title of this blog post suggests, it's good to have a clear answer to the question "Why are we using Kubernetes?". But perhaps even better would be if "Kubernetes" is the logical answer to various challenges faced by an organization. For example:

* How can we effectively run numerous containerized workloads?
* How can we allow a team of cloud specialists to empower many engineering teams by providing golden paths and guardrails?
* How can we run applications at the edge, preferably in a way that aligns with the software delivery process we already have?
* How can we allow engineering teams to deploy applications in our on-premise datacenter?
* How can we standardize our way-of-working, while providing flexibility where it matters for us?
* How can we ensure the know-how and tooling we invest in, are as widely applicable as possible (e.g. not limited to a single cloud vendor)?

Yes, the last point has this 'multi-cloud' and 'vendor lock-in' ring to it. To be clear: Switching clouds because the compute is a bit cheaper elasewhere hardly ever pays off. Using the common denominator of multiple clouds hardly every pays off. Vendor lock-ins are everywhere, not just at the cloud selection. But, looking at the timespan of years, an organization might see an advantage in focusing on technology that is applicable across vendor boundaries.

## Building a skyscraper

Embarking on the journey to adopt Kubernetes, there is a lot that needs to be set up before Kubernetes starts to deliver value. We are building a platform, so let's illustrate by a physical-world building analogy:

-- Diagram

At the bottom we find the foundation. It's there because it needs to be there, but nobody builds a foundation just to have a foundation. In Kubernetes terms, the foundation includes components like networking (CNI), storage (CSI), container runtime (CRI), virtual machines or bare metal servers and operating system.

Next up is the basement. Similar to foundation, this is not the end-goal (unless you're building a parking garage). It houses things that need to be there that you typically take for granted. Equipment, maintenance rooms, piping and whatnot. In Kubernetes this would include observability and security tooling, certificate management, perhaps a policy engine.

Finally, we get above the surface. This is what we are building for: Buildings that have a purpose! In Kubernetes terms, these are obviously the applications that are deployed. But also components that enhance the ability of our platform. Examples include ArgoCD (efficient deployments using GitOps), Argo Workflows (Workflow engine), KEDA (smarter scaling) or databases.

Now for each component one could argue if it's foundation, basement or building. Perhaps ArgoCD and KEDA are more basement than building. Maybe CSI is basement as well, instead of foundation, since you can somewhat easily add remove storage classes. 

What matters is that going from beneath to above the surface, we can observe that components:

* Become increasingly visible
* Change from being just cost to something that has business value
* In general become easier to adapt over time

## Focus: Not everywhere at once

An organization needs to be careful not to get caught up spending the majority of its time on foundation and basement, while lacking resources to actually put up something nice above the surface.

At the same time, you can only build on a solid foundation. And the basement should not collapse either.

We need focus. If running in one of the big clouds, all the foundation components exist in a prefab way. Consider those first.

Similarly, at the basement level, one can spend a lot of time building an observability platform. But there are various SaaS solutions or solutions provided by the cloud provider. Likewise for security. If prefab components don't satisfy a requirement, carefully review those requirements. Are we sure the proposed simple solution is not 'good enough'?

When running on edge, focusing on the operating system and networking is essential: One needs the ability to safely update the remote device without breaking networking and locking one self out. On the other hand, when running in the cloud, favor the solutions provided by the cloud vendor and leave it at that.

When running on premise, one probably needs a performant storage solution and backup solution for stateful workloads. But when running the cloud, one does not _need_ to DIY databases in Kubernetes. Consider a managed database, providing all the sizing options and point-in-time recovery you need. Use S3-compatible object storage for storing files. Use a SaaS for observability. Doing so allows storage requirements to be minimal, allowing things to stay simple.

## Complexity budget

Any customization or component added to a cluster adds complexity. It requires day 1 set up and day 2 maintenance and by that, it requires resources. This means there is a budget for the amount of complexity we can sustain.

While boundaries of definitions might vary depending on who you ask, we could consider every customization or addition to our platform [capital expenditure](https://en.wikipedia.org/wiki/Capital_expenditure): It's an upfront expense we expect to get a return on investment (ROI) out of.

As long as what we spend on CapEx results in reducing, or at worst, stabilizing our _overall_ [operating expense](https://en.wikipedia.org/wiki/Operating_expense), our operations are sustainable. If not, and OpEx gets the upper hand, we run into problems.

## API Flywheel effect

When having dodged some of the complexity rabbit-holes beneath the surface, the unified API and way-of-working Kubernetes provides can start to pay off. Let's illustrate:

We have a Kubernetes set up. Teams are deploying applications. However we notice sometimes workloads are not resilient to rescheduling. Also, consistent tagging is a bit of a problem. We add a policy engine. This helps us enforce good practices.

_Improvement:_ We notice we start to have a _lot_ of deployment pipelines. And they are all slightly different. And we find it increasingly hard to correlate what is supposed to run in our cluster, with those pipelines, that are primarily managed by various engineering teams. We add GitOps. We now have a single pane of glass, with a pull-request-based workflow to deploy updates. PR-based workflows we already had, so that is a good fit. And of course, we can automate certain updates to avoid unnecessary pull requests. Also worth noting is that by splitting CI and CD pipelines, our pipelines [can become a _lot_ simpler](https://www.fullstaq.com/knowledge-hub/blogs/why-you-should-split-ci-from-cd).

_New status:_ Team puts YAML in git. GitOps puts YAML in cluster. Cluster machinery makes things happen.

_Improvement:_  Some teams notice they need something more 'clever' than CPU based scaling of workloads. Platform team sets up KEDA. Since there's already a policy engine, it is easy to set up some guardrails for KEDA scaler configurations. 

_New status, just like it was previously:_ Team puts YAML in git. GitOps puts YAML in cluster. Cluster machinery makes things happen.

_Improvement:_ Platform team notices that a lot of the changes that need to be done for engineering teams boil down to the same: Provide a namespace, an artifact repository, a database, redis, a pipeline, IAM identities for new services or a queue. After a POC, the platform team decides to setup [Crossplane](https://www.crossplane.io/), adapt the policy engine to allow a curated set of Crossplane resources and provide guardrails. Now teams can set up the resources themselves. The platform team meanwhile, can continue to focus on providing and maintaining that capability, without getting swamped by 'lots of similar tasks'.

_New status, just like it was previously:_ Team puts YAML in git. GitOps puts YAML in cluster. Cluster machinery makes things happen.

_Improvement:_ Platform team notices it takes increasing effort to keep track of component updates. After a POC they set up [Renovate](https://github.com/renovatebot/renovate). Now, the platform team no longer has to check the release pages of each component that is running in the platform.

_New status, very similar to previous:_ Renovate puts YAML in git. GitOps puts YAML in cluster. Cluster machinery makes things happen.

The changes described above are not something implemented overnight. Furthermore they involve changing the way of working in an organization, which usually, compared to the technical part, is the hardest part. They _do_ show how carefully taking on additional complexity in one place, can reduce the overall effort within an organization.

## API mindset

When adopting Kubernetes, depending on organization, experience and culture, there might be different perspectives:

* Server-up: "We run servers, and we put Kubernetes on top of them"
* API-down: "We run Kubernetes, and we just happen to need servers for that"

The former tends to lean towards avoiding change and focus on uptime. 

The latter embraces frequent controlled change as a means to keep fulfilling various requirements. 

It's a subtle difference but, as you might have guessed, the API-down mindset is a better fit when using Kubernetes. It will result in a platform that is easier to maintain in the long run. Some examples:

_Instead of:_ Set up shell access to servers for administrative purposes.

_Do:_ Focus on how to avoid ever needing to log in into (production) servers. What observability data do we need to send out? How can we reproduce error scenarios in a lab setup?

_Instead of:_ Investigate how to patch nodes in-place, with all the orchestration, checks and reboots that come with it.

_Do:_ Consider immutable infrastructure. Simply replace nodes with patched ones frequently. A process that is easily reproducible (testing on non-prod) _and_ reversible. Bonus benefit: [Chaos engineering](https://en.wikipedia.org/wiki/Chaos_engineering).

_Instead of:_ Using [Ansible](https://www.ansible.com/) to 'do things on servers'

_Do:_ Focus on immutable infrastructure, and [cloud-init](https://cloud-init.io/) to perform the few installation steps that are absolutely necessary.

_Instead of:_ Extending VM images with observability agents, EDR agents and whatnot

_Do:_ Favor deamonsets[^ami_bad_daemonset_good], having [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) as needed, to run those processes. Remember the flywheel effect: We already have means to easily put workloads in clusters, and all the observability in place to monitor the components. Also, Renovate will help us to keep the components updated.

The gist of the above is that we need to avoid ending up what we did a decade ago (managing a fleet of VMs), _plus_ managing a lot of Kubernetes moving parts. We need to leverage Kubernetes to make the VM managing part much easier, or disappear entirely. That will leave room to focus on the platform and developer experience.

## Conclusion (aka TL;DR)

At a certain scale, and as the number of teams increases, organizations will face the following challenge:

> How to provide guardrails without ending up with gates?

Topics like compliance, security, cost-effectiveness, performance and disaster-recovery all need to be addressed. Delegating that to each individual team is not effective: For teams it's a distraction, and it requires having sufficient knowledge of those topics in each team. As a result, organizations need a way to consolidate this knowledge and apply it to all teams. This in a nutshell is why the buzzword 'DevOps' is nowadays superseded by 'Platform engineering'.

Running at scale, Kubernetes, also in 2024, is a suitable stack to build this platform engineering on top off. But the stakes are high: There can be great rewards, but it requires upfront effort before it starts to give back. And that imposes a risk.

Running at the edge, Kubernetes might turn out to be good choice that integrates naturally into the way you operate your centralized applications.

But, Kubernetes might simply not fit your organization:

* Startup needing to run 'some' applications in the cloud? Don't build Kubernetes first unless you have a clear goal for that.
* Autonomous teams without centralized platform team? You need _something_ to avoid every team from re-inventing slightly different DevOps wheels. Could be Kubernetes.
* Actually not running that many containers but using serverless? Fantastic, set up your organization to continuously improve _that_ stack. Don't consider Kubernetes because 'people are using Kubernetes'.

Spend your complexity budget wisely. When chosing Kubernetes, focus on the API and you might even forget about the servers. 

Just avoid getting caught up below the surface while forgetting to enjoy the sunlight.

[^footnote_social_media_debate]: Debate on social media meaning: 90% shouting, 10% listening, and needing to search for the insights beyond the noise, while avoiding getting carried away.
[^ami_bad_daemonset_good]: Guilty, been there. Extending AWS AMIs is totally cumbersome compared to managing a daemonset.




