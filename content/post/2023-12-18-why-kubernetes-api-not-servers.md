---
title: "Shifting left using feature deployments"
author: Tibo Beijen
date: 2023-12-18T08:00:00+01:00
url: /2023/12/18/why-kubernetes-api-not-servers
categories:
  - articles
tags:
  - Kubernetes
  - Serverless
  - GitOps
description: 
thumbnail: 

---

# Why Kubernetes? Focus on the API, not the servers

Introduction
- End of year, so: Reflection time
	- Socials: Serverless server-full debates
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
	- A way to run a multitude of workloads within on-premise datacenters?
	- Flexibility to adapt platform to changing needs, leveraging the many components that exist?
	- A programmable platform, where the operator pattern can be used to manage databases or other complex stateful systems.
	- A strategic choice to reduce cloud vendor lock-in.
- Common
	- First two: containerised applications, standardisation
- Diagram
	- Outside: K8S API, deployments, gitops, CRDs, Operators
	- Basement: Observability, security
	- Under the hood APIs, CNI, CSI, CRI
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

Power of the API

- The fly-wheel effect
- Adding things
	- We have: development flow using PRs
	- We add: GitOps
	- We notice: Bad practices deployed
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







