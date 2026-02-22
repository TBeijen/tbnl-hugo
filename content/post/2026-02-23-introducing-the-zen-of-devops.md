---
title: "Introducing the Zen of DevOps"
author: Tibo Beijen
date: 2026-02-23T05:00:00+01:00
url: /2026/02/23/introducing-the-zen-of-devops
categories:
  - articles
tags:
  - DevOps
  - SRE
  - Platform Engineering
  - Python
  - Zenofdevops
description: Introducing the Zen of DevOps, an adaptation of the Zen of Python, providing guidance to the fields of DevOps, SRE and Platform Engineering
thumbnail: img/zenofdevops-sunset.jpg

---

## Introduction

Over the past ten years or so, my role has gradually shifted from software to platforms. More towards the 'ops' side of things, but coming from a background that values APIs, automation, artifacts and guardrails in the form of automated tests.

And I found out that a lot of best practices from software engineering can be adapted and applied to modern ops practices as well.

DevOps in a nutshell really: Bridging the gap between Dev and Ops. 

One of the most impacting pieces of guidance I have encountered, is the [Zen of Python](https://peps.python.org/pep-0020/). Which largely applies to modern DevOps as well.

So, I have created a variant: The [Zen of DevOps](https://www.zenofdevops.org/).

{{< figure src="/img/zenofdevops-sunset.jpg" title="Becoming Zen..." >}}

## The Zen of Python

It must have been around 2013 or so, when working at [NU.nl](https://www.nu.nl/), when we phased out PHP in favor of Python. And that was an interesting mental exercise!

Now I like my share of abstractions. When working on my graduation project, my favorite part was using OOP concepts in Macromedia Director, even though the demo app was just a small part of the project's scope. And working with PHP I went through my '[Gang of Four](https://en.wikipedia.org/wiki/Design_Patterns)' phase and built a fair share of overengineered bloat. [Zend Framework](https://framework.zend.com/manual/2.4/en/index.html) was my tool of choice, satisfying every design pattern crave I had.

Then came Python. And with that came [Django](https://www.djangoproject.com/), an _opinionated_ framework. Really the opposite side of Zend Framework (which is just a grab-bag of tools with a consistent interface). And it was not just Django that has opinions, Python itself as well. A vision of the core values of the language: The [Zen of Python](https://peps.python.org/pep-0020/).

After a transition period, shoving some PHP-isms into Python, I came to appreciate the nature of Python. At its core it's simple. But, when you need it, it gives you all the OOP you want, as well as powerful concepts such as [decorators](https://realpython.com/primer-on-python-decorators/), [context managers](https://realpython.com/python-with-statement/) and powerful [exceptions](https://realpython.com/python-exceptions/).

Simple when possible. Complex when needed.

## Adapting to DevOps

The Zen of DevOps combines personal experience with conversations and observations of the past many years: Setups I have experienced to be easy to maintain. Setups that, despite all the modern tools, were complex and brittle. Countless conference talks I attended and articles I read. Many hallway tracks, discussing practices with peers.

### Removals

Some elements of the Zen of Python, I have left out of the Zen of DevOps:

> Flat is better than nested / Sparse is better than dense / Readability counts

In DevOps we have to do with the languages and formats that are common: Mostly [Go](https://go.dev/), which has its own opinionated `fmt`. Furthermore, schema design of YAML and JSON should be guided more by API design guidelines, than readability. Although readability of course is a good thing.

> Special cases aren't special enough to break the rules / Although practicality beats purity

Although valid points in their own right, I felt that, because the scope of DevOps is so much wider than a single programming language, that this guideline is a bit too restrictive. The reality of DevOps in large organizations is often a messy variety of practices having different levels of maturity. This guideline just gets in the way.

> Now is better than never / Although never is often better than *right* now

I replaced that with "Favor changes that make you faster over those that slow you down". Putting a bit more emphasis on modern Agile and scrum practices, that sometimes favor external stakeholder requests over internal team effectiveness[^footnote_okr]. 

> Although that way may not be obvious at first unless you're Dutch.

It's a joke. I like jokes, and even though I'm Dutch as well: This one makes no sense and rather distracts than adds anything.

> Namespaces are one honking great idea -- let's do more of those!

The ubiquitous 'naming things'. A bit out of tone. DevOps is a lot about 'moving parts' and 'orchestration'. Not just software, where namespaces indeed are useful.

### Additions

Some guidelines have been added, compared to the python counterpart. See the Zen of DevOps for more elaborate explanation of the added guidelines.

> Be able to break non-production systems / Be able to break non-production systems only

These two guidelines emphasize on differentiating non-production and production. Which is more an 'ops' thing than a 'dev' thing and was not really conveyed in the Zen of Python.

> Design for more than one / Design for more than once

These guidelines focus on the automation and codifying practices of modern infra. And really, it's not that new: Using [sysprep](https://www.ibm.com/docs/en/tpmfod/7.1.1.16?topic=sysprep-windows-xp-windows-2003-operating-systems) in the Windows XP era, to stamp out many desktops, is not entirely different from preparing USB sticks for edge Kubernetes deployments. And that is not unlike immutable infrastructure, never modifying a server in-place, just stamping out new ones.

> Favor changes that make you faster over those that slow you down

As stated above, this guideline emphasizes the need to stay ahead of the maintenance curve. The scope and complexity of what teams can, and need to, manage is evergrowing. But that means changes that simplify, reduce friction and improve efficiency are more important than ever.

## Universal and timeless

Time will tell if the Zen of DevOps will be as timeless as the Zen of Python. I hope so!

The range of practices that can be observed in the field of devops is increasingly wide: Front runners have already adopted agentic workflows. At the same time there are organizations where requesting a server, a cluster, a DNS change, or firewall change, can take many days[^footnote_days].

AI is changing many fields of works in impactful ways[^footnote_ai]. At the same time, engineering principles are quite foundational. If you design a plane, you build it to last, you design for maintenance and upgrades, add redundancy[^footnote_boeing], add safety margins. Whether the design is created on paper using rulers, on a computer, or mostly by AI: Those principles still exist, and should be supervised. 

Software is no different: Security, observability, maintainability, auditability, computational efficiency are all foundational engineering practices, also known as 'non functional requirements'.

We will see if the Zen of DevOps will hold strong in these times of AI. If it doesn't, we have probably ended up with a lot of incomprehensible junk. But I have good hopes.

Take for example:

> There should be one - and preferably only one - obvious way to do it

This will translate directly into better agent performance. Likewise, when experimenting with agent integrations, it's really important you can do that on non-prod. And if first experiments mess things up, it's really helpful you can rebuild your setup.

Unlike the Zen of Python, which focused on a single language, the Zen of DevOps aims to be more universal. 

Our industry is full of 'strong preferences' or previous choices we have become invested in beyond the point of no return. The Zen of DevOps aims to guide at a higher level, so is not about:

* Serverless vs. Kubernetes
* Public cloud vs. on-premise
* AWS vs. Azure vs. GCP
* Terraform vs. CDK vs. Pulumi vs. Crossplane
* GitOps vs. Pipelines
* Agile vs. Kanban vs. Waterfall
* Strong vs. Weak typing
* Imperative vs. Declarative
* Windows vs. Linux
* Pets vs. Cattle
* DevOps vs. SRE vs. Platform Engineering
* Rust vs. ... \<every other language>
* YAML vs. JSON vs. TOML vs. KYAML vs JSON5

## Means, not goals

> Don’t let guidelines distract you from your goals!

Some of the guidelines can be interpreted in several ways. And not every guideline might be feasible or applicable in every environment. And that's ok!

Consider 'explicit'. To some it might mean: Make everything very visible. No abstractions. Everything is 'out there'. To others, including me, it means: Make conscious choices in what to expose, and what to hide, making the parts that can be considered 'the interface', explicit.

The main take away is: Be deliberate about such practices, and keep evaluating how they affect a project and collaboration within and between teams.

One does not complete or fail the Zen of DevOps.

## What's next

It has been interesting to try to collect years of experience and observations into a small set of principles. I hope it gives teams and individuals some new perspectives. Even if not agreeing, unpacking why that might be can yield insights, and has value.

In the coming time I might dive deeper into certain topics. If so, they will be tagged [zenofdevops](tags/zenofdevops/).

Got any thoughts or feedback? By all means, reach out on [LinkedIn](https://www.linkedin.com/in/tibobeijen/).

Zen to all...

[^footnote_okr]: I have yet to see an OKR stating 'good team mental health' as a key result.
[^footnote_days]: I am aware there are people, upon reading, wishing it were mere days.
[^footnote_boeing]: The price of not doing so [can be unacceptably high](https://risktec.tuv.com/knowledge-bank/the-price-of-single-point-failure/).
[^footnote_ai]: Curious what happens when we find out that we have replaced all simple deterministic processes by awesome 'magic', and now are strategically dependent on the new oil: Datacenter capacity, energy, GPUs, memory. Sold by just a few big companies.