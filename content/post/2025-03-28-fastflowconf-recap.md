---
title: "FastFlowConf recap"
author: Tibo Beijen
date: 2025-03-29T05:00:00+01:00
url: /2025/03/29/fastflowconf-recap
categories:
  - articles
tags:
  - FastFlowConf
  - Team Topologies
  - Agile
  - Platform Engineering
  - Architecture
description: Some take-aways of FastFlowConf that took place 2025 march 23rd in Den Bosch.
thumbnail: 

---

## Introduction

Past week, I attended [FastFlowConf](https://www.fastflowconf.com/), "a Team Topologies Conference".

As the [Team Topologies](https://teamtopologies.com/) site describes itself:

> Team Topologies is the result of years of research into how successful leaders design team-of-teams organizations delivering business outcomes through technology

Team Topologies, to me, feels like a logical evolution of [Agile](https://en.wikipedia.org/wiki/Agile_software_development). Most practices described in the Agile principles, take a team as a starting point. When multiple teams are involved, organizing those to work together can become challenging. So, frameworks like [Scaled Agile](https://en.wikipedia.org/wiki/Scaled_agile_framework) emerged, which are quite prescriptive. Depending on who you ask, a framework like Scaled Agile, has become quite detached from the original Agile principles.

Team Topologies takes the (fast) flow of Value Streams as a guiding principle. What I find very interesting is how the role and place of architecture has changed in this agile, flow-focused way of working. Traditionally, in the [Waterfall model](https://en.wikipedia.org/wiki/Waterfall_model), architecture, or the designing of software, was a discrete phase. Something done _up front_, before implementing. Trying to do that in Agile brings all kinds of friction: Architecture becomes a bottleneck (blocker of flow), it discourages changing requirements, it reduces sense of ownership by the team. To name a few.

However, moving from waterfall to more agile methodologies, architecture is perhaps more important than ever. Not so much in a design-gatekeeping way, but in a guiding way. How do we see our processes? How do we see our systems? What level of autonomy do we deem fitting? Domain Driven Design concepts like Event Storming, Ubiquitous Language and Bounded Context, help clarify our landscape. And that insight can help model team composition and interactions, often referred to as the [Reverse Conway Manouvre](https://www.agileanalytics.cloud/blog/team-topologies-the-reverse-conway-manoeuvre). 

This is at [the core of Team Topologies](https://teamtopologies.com/key-concepts), which identifies 4 team types and 3 interaction modes.

Ok, enough of my interpretation of Team Topologies. Let's gloss over some brief 'notes & quotes' of some of the talks. Be aware that videos [of the talks](https://www.fastflowconf.com/agenda) are online.

## Platform as a Product: are we nearly there yet?

_By Paula Kennedy_

A talk about applying product mindset on the internal platform.

Mentioned as reasons for not succeeding: 

* Lack of understanding (ops is very different from design, or user surveys)
* Lack of investment
* Feat / reluctance to change
* It's hard

The "why?" showed several examples of companies increasing flow and productivity by embracing platforms, including Canadian Bank, Realtor and Uswitch.

What to do?

* Bring in product manager
* User research / observe platform usage
* Community of Practice / share stories / evangelise
* Improve developer experience

One can use the [CNCF Platform Engineering Maturity Model](https://tag-app-delivery.cncf.io/whitepapers/platform-eng-maturity-model/) as a map for ones platform engineering journey

Quote:

> The platform should not be mandatory. People should _want_ to use it!

## The Road to Faster Flow Is Paved with Missteps: A Retrospective

_By Jacob Duijzer_

A talk providing some valuable insights and patterns, but also highlighting the importance of leadership being on-board. In the example case a change of leadership sadly caused progress to fall apart.

> “The business” what is it? It's our business!

> An enabling team: “Inspiration as a service”

What worked well: Quarterly themes, such as security, measuring things, etc.

* Pattern: Start with the why, empower the how
* Anti-pattern: Doing an agile transformation
* Pattern: Focus on outcomes
* Anti-pattern: Psychological unsafe
* Pattern: Leaders go first 
* Anti-pattern: Using old ways of thinking with new ways of working
* Pattern: Communicate x3
* Pattern: Achieve big through small
* Pattern: Invite over inflict
* Pattern: Stop starting. Start finishing
* Anti-pattern: Grass roots hits a grass ceiling (How do we get on board with leadership? That will be a next talk)

## Team Topologies is not enough; you need a management model to match!

_By João Rosa_

> Everyone wants a platform... To dump work on it!

Enabling teams to the rescue! But who rescues the enabling teams? (Fire fighters, blocking flow, doing operational work not done by other teams)

Budget (the traditional kind) is useful in context: A world that is moving slower than today. A world that is predictable.

> Forget about absolute numbers. We just need relative performance to beat the competition!

> More fiction is written in excel than in novels (PowerPoint might come close)

Rolling window budgeting is more suitable for agile organizations (Amazon does this).

Mentions Swedish bank, not using budgets since 70s, never having needed tax payer's money to be bailed out, pays share value to employees. Creates collaboration.

## How Flow Works and other curiosities

_By James Lewis_

Fun and inspring talk with perhaps my favorite quote of the day:

> Why shared test environments should be nuked from orbit

The building blocks of flow are coordination, cadence (schedule) and queues. Shared testing environments combine all three, making them unfit for fast flow.

Several platform models were illustrated via [M/M/c queues](https://en.wikipedia.org/wiki/M/M/c_queue), showing wy IaaS clouds like AWS enable flow: Throughput is not determined by number of platform operators.

{{< figure src="/img/fastflowconf_platforms.jpg" title="Why AWS (IaaS) is a thing and the others are expensive and slow because c = number of people" >}}


## Conclusion

Overarching themes

* Involve all layers
* Communicate, communicate, communicate. Keep on repeating,
* Product mindset

Similar to agile, team topologies self organizing, autonomy. At a glance this might be tangent to architecture. Opposite is true: Bounded contexts help shape team structure.


