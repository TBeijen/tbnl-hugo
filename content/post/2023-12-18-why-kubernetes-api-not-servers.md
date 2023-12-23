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
* Social media being social media: Debates[^footnote_social_media_debate] about pretty much every tech topic, including how "Kubernetes has single-handed set our industry back a decade", as [put in perspective](https://twitter.com/kelseyhightower/status/1671582240026025986?lang=en) by Kelsey Hightower. Or Basecamp's [move out of the cloud, dodging Kubernetes in the process](https://world.hey.com/dhh/we-have-left-the-cloud-251760fb).
* Datadog's outage. Caused by a variety of contributing factors that can be summarized by the keywords: Kubernetes, Cilium, eBPF, Systemd, OS updates. It's [all explained nicely](https://newsletter.pragmaticengineer.com/p/inside-the-datadog-outage) by Gergely Orosz (The Pragmatic Engineer).

Working with, and liking Kubernetes, reading all of the above, it's tempting to reflect on the question "What did I get into?". Or in a broader sense: "What are we as an industry getting ourselves into?".

Discussing the value and cost of Kubernetes in my opinion is not merely about "servers vs. serverless" or "simple vs. complex". But it's about at what point (assuming that point exists) do the benefits of Kubernetes outweigh the challenges.

So, let's focus on where Kubernetes stands, its strong points and look into avoiding some of its complexities.

## Versatility

Kubernetes is everywhere: It can facilitate a variety of workloads in a variety of environments:

-- Diagram

As can be seen in the above diagram, one can run Kubernetes in environments ranging from hyperscale clouds, small clouds, on-premise datacenters right up to edge computing.

Focusing on the type of workloads, Kubernetes can do a lot. But there are types of workload Kubernetes might not be particularly suited for. On the monolith side one could think of (legacy) mainframes. Or VM-based applications that are hard to containerize. 

On the hyperscale clouds, there is a plethora of managed services, including databases, memory stores, messaging components and services focused on AI/ML and Big Data. For those, you _can_ run cloud-native cloud-agnostic alternatives within Kubernetes. But it requires more up-front effort, and the potential gain will differ per situation. 

Then on the far end of micro, big clouds offer Function-as-a-Service, typically well-integrated with components like an API Gateway and building blocks for event-driven architectures. One could decide to run those in Kubernetes, for example, using [Knative](https://knative.dev/). But it requires setting and supporting those components first, whereas cloud in that regard is easier to get into and usually offers scale-to-zero as a distinguishing feature.

Focusing on specific services offered by the big clouds, there are many services big clouds excel at: Easy to get into and little to no operational burden. On the other hand, if putting in the effort, there is a lot Kubernetes _can_ do, while providing its users a standardized way-of-working (roughly: Put YAML in cluster), and platform teams a unified way to support engineering teams (roughly: Help come up with proper YAML and help put YAML in cluster). 

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

@TODO: Clarify vendor lock-in

## Organizational aspects

@TODO: Here or at conclusion


## Building it out

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

When running on edge, focusing on the operating system is essential: One needs the ability to safely update the remote device without breaking networking and locking one selves out. On the other hand, when running in the cloud, just pick the OS that is provided by the cloud vendor and be done with it.

When running on premise, one probably needs a performant storage solution and backup solution for stateful workloads. But when running the cloud, one does not _need_ to DIY databases in Kubernetes. Consider a managed database, providing all the point-in-time recovery you need. Use S3-compatible object storage for storing files. Use a SaaS for observability. Doing so allows storage requirements to be minimal, allowing things to stay simple.

## API Flywheel effect

When having dodged some of the complexity rabbit-holes beneath the service, the unified API and way-of-working Kubernetes provides can start to pay off. Let's illustrate:

We have a Kubernetes set up. Teams are deploying applications. However we notice sometimes workloads are not resilient to rescheduling. Also, consistent tagging is a bit of a problem. We add a policy engine. This helps us enforce good practices.

_Improvement:_ We notice we start to have a _lot_ of deployment pipelines. And they are all slightly different. And we find it increasingly hard to correlate what is supposed to run in our cluster, with those pipelines, that are primarily managed by various engineering teams. We add GitOps. We now have a single pane of glass, with a pull-request-based workflow to deploy updates. PR-based workflows we already had, so that is a good fit. And of course, we can automate certain updates to avoid unnecessary pull requests. Also worth noting is that by splitting CI and CD pipelines, our pipelines [can become a _lot_ simpler](https://www.fullstaq.com/knowledge-hub/blogs/why-you-should-split-ci-from-cd).

_New status:_ Team puts YAML in git. GitOps puts YAML in cluster. Cluster machinery makes things happen.

_Improvement:_  Some teams notice they need something more 'clever' than CPU based scaling of workloads. Platform team sets up KEDA. Since there's already a policy engine, it is easy to set up some guardrails for KEDA scaler configurations. 

_New status, just like it was previously:_ Team puts YAML in git. GitOps puts YAML in cluster. Cluster machinery makes things happen.

_Improvement:_ Platform team notices that a lot of the changes that need to be done for engineering teams boil down to the same: Provide a namespace, an artifact repository, a database, redis, a pipeline, IAM identities for new services or a queue. After a POC, the platform team decides to setup [Crossplane](https://www.crossplane.io/), adapt the policy engine to allow a curated set of Crossplane resources and provide guardrails. Now teams can set up the resources themselves. The platform team meanwhile, can continue to focus on providing and maintaining that capability, without getting swamped by 'lots of similar tasks'.

_New status, just like it was previously:_ Team puts YAML in git. GitOps puts YAML in cluster. Cluster machinery makes things happen.

_Improvement:_ Platform team notices it takes increasing effort to keep track of component updates. After a POC they set up [Renovate](https://github.com/renovatebot/renovate). Now the platform team no longer has to check the release pages of each component that is running in the platform.

_New status, very similar to previous:_ Renovate puts YAML in git. GitOps puts YAML in cluster. Cluster machinery makes things happen.

## API mindset

When adopting Kubernetes, depending on organization, expierience and culture, there might be different perspectives:

* Server-up: "We run servers, and we put Kubernetes on top of them"
* API-down: "We run Kubernetes and we just happen to need servers for that"

The former tends to lean towards avoiding change and focus on uptime. The latter embraces controlled change as a means to keep fulfilling various requirements. It's a subtle difference but, as you might have guessed, the API-fown mindset is a better fit when using Kubernetes. Some examples:

_Instead of:_ Set up shell access to servers for administrative purposes.

_Do:_ Focus on how to avoid ever needing to log in into (production) servers. What observability data do we need to ship? How can we reproduce error scenarios in a lab setup?

_Instead of:_ Investigate how to patch nodes in-place, with all the orchestration, checks and reboots that come with it.
reproducible
_Do:_ Consider immutable infrastructure. Simply replace nodes with patched ones. A process that is easily reproducable (testing) _and_ reversible.

_Instead of:_ Using [Ansible](https://www.ansible.com/) to 'do things on servers'

_Do:_ Focues on immutable infrastructure, and [cloud-init](https://cloud-init.io/) to perform the few installation steps that are absolutely necessary.

_Instead of:_ Extending VM images with observability agents, EDR agents and whatnot

_Do:_ Favor deamonsets[^ami_bad_daemonset_good], having [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) as needed, to run those processes. Remember the flywheel effect: We already have means to easily put workloads in clusters (GitOps) and all the observability in place to monitor the components. Also, Renovate will help us keeping the components updated.

Ultimately, as shown in the city building diagram, we want to keep the foundation and basement as simple and hidden as we possibly can. Remember: The value is above the surface. If servers at the edge are needed, by all means focus on that until it 'just works'. 

The take-away is to avoid having to manage servers _and_ a lot of moving parst on top, without using the capabilities of Kubernetes to make any of those parts easier.

## Conclusion (aka TL;DR)

All of the above illustrates the following:

At a certain scale

> Build guardrails. Don't end up with gates. 

Complexity budget


Wrapping it up:
* Is Kubernetes still great? Yes
* Do you need to put in effort to make it great? Yes
* Is Kubernetes the _only_ way to provide stream-aligned teams a platform? No, but it can help to scale a standardized way-of-work to many teams.
* Do you need Kubernetes to run 'some containers'? No



Just avoid getting caught up below the surface while forgetting to enjoy the sunlight.


## Outline

Introduction
- End of year, so: Reflection time
	- Socials: Serverless server-full debates
	- https://twitter.com/kelseyhightower/status/1671582240026025986?lang=en
	- The Amazon Prime thing
		- https://offbynone.io/issues/233/
	- State of Kubernetes in production
		- https://thenewstack.io/the-2023-state-of-kubernetes-in-production/
	- Datadog outage related to Kubernetes
		- https://newsletter.pragmaticengineer.com/i/121824122/what-really-caused-the-outage
- Reflecting on one's life choices, what did we get into. 
- Not about serverless vs Kubernetes. You can build awesome things using serverless.
- Instead focus on the strong points of Kubernetes (the API) and how to avoid getting entangled in the complex parts (servers)

Scope
- Diagram
	- Horizontal: From hypsercale cloud (AWS, Azure, etc.) to small cloud (Ditigital Ocean, OVH, etc.) to on-premise,  to edge
	- Vertical: From  bottom monolithic to micro to functions to serverless
- Kubernetes is (almost) everywhere
- Strategic: Investing in Kubernetes eco-system covers a lot of ground. Downside: Exclude some vendor specifics, most notably serverless functions.

Where to focus: Not everywhere at once

- What can Kubernetes bring for your organisation?
	- A platform to easily and frequently deploy containerized applications?
	- Means of standardization, allowing platform team to build and provide golden paths and guardrails for engineering teams?
	- The ability to run applications at the edge
    - The ability to hire a small team of cloud specialists to avoid needing a cloud specialist in every engineering team
	- A way to run a multitude of workloads within on-premise datacenters?
	- Flexibility to adapt platform to changing needs, leveraging the many components that exist?
	- A programmable platform, where the operator pattern can be used to manage databases or other complex stateful systems.
	- A strategic choice to reduce cloud vendor lock-in.
- Common
	- First two: containerised applications, standardisation
- Diagram
	- Outside: K8S API, deployments, gitops, CRDs, Operators
	- Basement: Observability, Security, Policy engine
	- Under the hood APIs, CNI, CSI, CRI
- City block analogy:
    - Foundation: Might be fully provided by cloud vendor. Focus only on what really matters
    - Basement: Does not need to be DIY. Many SaaS solutions exist
	  - Lock-in. Prepare doing things right. Pick what can also be run open-source
	  - Can help in identifying what org really needs
    - Extending the API: Focus on what's important. Step by step.

- Because you use Kubernetes, does not mean everything has to be inside kubernetes.

But... servers

- Means to an end
- Just a building block
- It depends: 
	- Cloud: Consider it a disposable box. Just the thing that provides CPU, memory.
	- Edge: Different focus. No unlimited hardware, edge storage. Update/patch cycle. Having hardware at the edge _is_ the goal.
- Fix once,  automate, push complexity down. Result is providing the api.
- Don't make it about servers, unless it's about servers (edge)

Power of the API: Standardisation

- The fly-wheel effect
- Adding things
	- We have: development flow using PRs
	- We add: GitOps
    - We now have: 
	- We notice: Bad practices deployed (no PDB, no limits)
	- We add: Policy engine
	- We notice: Hard to find application owner (security/finops)
	- We leverage: Policy engine to enforce tagging
	- We notice we need: Smarter scaling
	- We add: Keda
	- We notice: Common cloud infra (DB, container registry, Redis)
	- We add: CRDs, maybe Crossplane
- All follow same pattern
	- Platform team adds component (some effort)
	- Results in new YAML that can be deployed to cluster (using all the existing processes)
	- Things get done

API-down mindset instead of server-up
- Examples
	- Instead of: Figure out how to easily patch nodes
	- Rather do: Figure out how to easily replace nodes (resulting in robust setup, chaos engineering)
	- Instead of: Considering ansible to configure nodes
	- Rather do: Focus on cloud-init to have nodes self-bootstrap
	- Instead of: Monitoring servers, optionally providing aggregate views (e.g. nagios)
	- Rather do: Monitor golden signals, optionally drilling down into individual assets (e.g. via prometheus labels)
	- Instead of: Provisioning access to nodes
	- Rather do: Focus on what logging and monitoring node needs to send out, to avoid ever needing access to a node
	- Instead of: Extending VM by baking custom image or install-at-boot
	- Rather do: Use daemonsets wherever possible, leveraging any pod-observability one already has
	- etc. etc.

Concluding
- More upfront investments, also high potential
	- The upfront investment constitutes risk
- Focus on what it means for your org
- Use cloud provider and SaaS for the hard parts, Kubernetes itself as well as DBs and such
- Choosing Kubernetes is not a serverless vs complex servers discussion
	- More about using vendor opinionated ready-to-go solutions vs. Composing own platform tailored to ones needs
	- Both can be used to build great things. 
	- Of all the complexities Kubernetes can bring, servers don't need to be the biggest issue

[^footnote_social_media_debate]: Debate on social media meaning: 90% shouting, 10% listening, and needing to search for the insights beyond the noise, while avoiding getting carried away.
[^ami_bad_daemonset_good]: Guilty, been there. Extending AWS AMIs is totally cumbersome compared to managing a daemonset.




