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

Working with, and liking Kubernetes, reading all of the above, it's tempting to reflect on the question "What did I get into?".

Discussing the value and cost of Kubernetes in my opinion is not merely about "servers vs. serverless" or "simple vs. complex". But it's about at what point (assuming that point exists) do the benefits of Kubernetes outweigh the challenges.

So, let's focus on some of Kubernetes strong points and look into avoiding some of its complexities.

## Versatility

Kubernetes is everywhere: It can facilitate a variety of workloads in a variety of environments:

-- Diagram

As can be seen in the above diagram, one can run Kubernetes in environments ranging from Hyperscale clouds, small clouds, on-premise datacenters right up to edge computing.

Focusing on the type of workloads, Kubernetes can do a lot. But there are types of workload Kubernetes might not be particular suited for. On the monolith side one could think of (legacy) mainframes. Or VM-based applications that are hard to containerise. 

On the hyperscale clouds, there is a plethora of managed services, including databases, memory stores, messaging components and services focused on AI/ML and Big Data. For those you _can_ run cloud-native cloud-agnostic alternatives within Kubernetes. But it requires more up-front effort and the potential gain will differ per situation. 

Then on the far end of micro, big clouds offer Function-as-a-Service, typically well-integrated with components like an API Gateway and building blocks for event-driven architectures. One could decide to run those in Kubernetes, for example using [Knative](https://knative.dev/). But it requires setting and supporting those components first, whereas cloud in that regard is easier to get into and usually offers scale-to-zero as a distinguishing feature.

Focusing on specific services offered by the big clouds, there are definitely services big clouds excel at. On the other hand, if putting in the effort, there is a lot Kubernetes _can_ do, while providing its users a standardised way-of-working (roughly: Put YAML in cluster), and platform teams a unified way to support engineering teams (roughly: Help come up with proper YAML and help put YAML in cluster). 

More on that standardisation later.





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
	- A platform to easily and frequently deploy containerised applications?
	- Means of standardisation, allowing platform team to build and provide golden paths and guardrails for engineering teams?
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

[^footnote_social_media_debate]: Debate on social media meaning: 90% shouting, 10% listening, and needing to seach for nuance while avoiding to get carried away.





