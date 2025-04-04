---
title: "FastFlowConf recap"
author: Tibo Beijen
date: 2025-04-04T05:00:00+01:00
url: /2025/04/04/fastflowconf-recap
categories:
  - articles
tags:
  - FastFlowConf
  - Team Topologies
  - Agile
  - Platform Engineering
  - Architecture
description: Some take-aways of FastFlowConf that took place 2025 march 23rd in Den Bosch.
thumbnail: img/fastflowconf_header.jpg

---

## Introduction

Past week, I attended [FastFlowConf](https://www.fastflowconf.com/), "a Team Topologies Conference".

As the [Team Topologies](https://teamtopologies.com/) site describes itself:

> Team Topologies is the result of years of research into how successful leaders design team-of-teams organizations delivering business outcomes through technology

Team Topologies, to me, feels like a logical evolution of [Agile](https://en.wikipedia.org/wiki/Agile_software_development). Most practices described in the Agile principles, take a team as a starting point. When multiple teams are involved, organizing those to work together can become challenging. So, frameworks like [Scaled Agile](https://en.wikipedia.org/wiki/Scaled_agile_framework) emerged, which provide structure to collaboration, but don't automatically preserve agility.

Team Topologies takes the (fast) flow of Value Streams as a guiding principle. What I find very interesting is how the role and place of architecture has changed in this agile, flow-focused way of working. Traditionally, in the [Waterfall model](https://en.wikipedia.org/wiki/Waterfall_model), architecture, or the designing of software, was a discrete phase. Something done _up front_, before implementing. Trying to do that in Agile brings all kinds of friction: Architecture becomes a bottleneck (blocker of flow). It discourages changing of requirements. It reduces sense of ownership by the team. Just to name a few.

However, moving from waterfall to more agile methodologies, architecture is perhaps more important than ever. Not so much in a design-gatekeeping way, but in a guiding way. How do we see our processes? How do we see our systems? What level of autonomy do we deem fitting? Domain Driven Design concepts like Event Storming, Ubiquitous Language and Bounded Context, help clarify our landscape. And that insight can help model team composition and interactions, often referred to as the [Reverse Conway Manouvre](https://www.agileanalytics.cloud/blog/team-topologies-the-reverse-conway-manoeuvre). 

This is at [the core of Team Topologies](https://teamtopologies.com/key-concepts), which identifies 4 team types and 3 interaction modes.

Ok, enough of my interpretation of Team Topologies. Let's gloss over some brief 'notes & quotes' of some of the talks. Be aware that [videos of the talks](https://www.youtube.com/@fastflowconf/videos) are online.

{{< figure src="/img/fastflowconf_banner.jpg" title="Fastflowconf" >}}

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
* Community of Practice / share stories / evangelize
* Improve developer experience

One can use the [CNCF Platform Engineering Maturity Model](https://tag-app-delivery.cncf.io/whitepapers/platform-eng-maturity-model/) as a map for one's platform engineering journey

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

Enabling teams to the rescue! But who rescues the enabling teams? (Firefighters, blocking flow, doing operational work not done by other teams)

Budget (the traditional kind) is useful in context: A world that is moving slower than today. A world that is predictable.

> Forget about absolute numbers. We just need relative performance to beat the competition!

> More fiction is written in Excel than in novels (PowerPoint might come close)

Rolling window budgeting is more suitable for agile organizations (Amazon does this).

Mentions Swedish bank, not using budgets since 70s, never having needed taxpayer's money to be bailed out, pays share value to employees. Creates collaboration.

## How Flow Works and other curiosities

_By James Lewis_

Fun and inspring talk with perhaps my favorite quote of the day:

> Why shared test environments should be nuked from orbit

The building blocks of flow are coordination, cadence (schedule) and queues. Shared testing environments combine all three, making them unfit for fast flow.

Several platform models were illustrated via [M/M/c queues](https://en.wikipedia.org/wiki/M/M/c_queue), showing wy IaaS clouds like AWS enable flow: Throughput is not determined by number of platform operators.

{{< figure src="/img/fastflowconf_platforms.jpg" title="Why AWS (IaaS) is a thing and the others are expensive and slow because c = number of people. Source: Video of presentation." >}}

## DevX - Beyond Platform Engineering

_By Ophelia Zhang Dalsgaard & Henrik Høegh_

Developer experience does not equal platform engineering (it's more)

The circle of developer experience: Flow state, feedback loop, cognitive load

Working memory is made up of:
* Extraneous load (_Distractions_): Backup details, CI/CD implementation, release mechanics
* Intrinsic load (_Complexity_): Code quality, unclear goals/tasks, skill vs. task
* Germane load (_Learning_): Problem domain, user behavior, customer value

Shown was an example of user needs mapping where the developer needs, such as self-service, test, push, resulted in just 3 tools to master: Git, Backstage and "Bura", an in-house CLI.

## Team Topologies in Practice: A Journey of Re-Teaming Using Architecture for Flow

_By Susanne Kaiser & Nina Siessegger_

Event storming can help identify candidates for bounded contexts

{{< figure src="/img/fastflowconf_decision_models.jpg" title="Consent decision-making: A balanced approach. Source: Video of presentation." >}}

## Unlocking Flow: Combining Team Topologies and Platform Engineering at ASML IT

_By Tom Slenders & Andrea Klettke_

ASML uses Scaled agile/Release trains (ART)

Pilot groups (ARTs) consisting of different views/perspectives:

* Senior management
* ART leadership
* Team members

This helped:

* Formulate communication that is clear for each every participant
* Establish trust by all views being represented

Leverage the industry standards and meet with peers:

* Learn from each other
* Proves on right path. Industry is moving in this directions

Very important: “Keep on repeating”

## Transforming claims resolution at Parasol: Accelerating outcomes with Platform Engineering

_By Stefan van Oirschot_

Balance is essential: Output consists of debts, risks, defects and features. Once the former three grow, feature output declines.

Squeezing the tube: Variance at start, determine what differentiates you, then focus (remove distractions) to achieve high flow.

What we want to deliver to the customer: The intersection between safety (UX, standards, security, etc.) and speed (freedom, cutting edge, innovative, etc.). We don't want safety without speed or speed without safety.

The full stack fallacy: I-shaped, T-shaped, Pi-shaped, comb-shaped. Comp-shaped unicorns don't exist. They need platform engineering for manageable cognitive load.

Platform engineering: Don't start too low in the stack.

## Autonomy, is that what we really want?

_By Evelyn Van Kelle and Kenny Baas-Schwegler_

[Slides](https://speakerdeck.com/baasie/autonomy-is-that-what-we-really-want-at-fast-flow-conf-nl)

> **Autonomy**, as described by **Daniel H. Pink**, is the urge to direct **one's own life**. Without the ability to control **what, when and how we work**, and who we work with, we'll never be completely motivated to complete a task.

Using [Polarity maps](https://universityinnovation.org/wiki/Resource:Polarity_Mapping) to unpack different aspects of autonomy.

{{< figure src="/img/fastflowconf_polarity_map.jpg" title="Polarity map of autonomy. Source: Slides of presentation." >}}

Autonomy exists within a context and boundaries.

> The paradox of autonomy: It empowers individuals and teams, yet risks fracturing us into 'us vs. them'. Will we allow this polarity to define us, especially as we pursue for fast flow?

Let's actively reshape the narrative:

> Celebrate difference, cherish equality, intentionally build 'us AND them' and actively seek our shared needs!

* Autonomy within teams. Autonomy is not dictatorship.
* Autonomy between teams. Risk of ivory towers.
* Autonomy in organizations. A continuous negotiation.


## Conclusion

Looking back to all the presentations, there seem to be some overarching themes: 

* Foster a product mindset
* Involve all layers of an organization
* Communicate, communicate, communicate! And then communicate some more.

This was a great conference. Besides interesting talks, the relatively small scale, and the fine location, allowed for some nice hallway conversations. Or actually: Sunny outside terrace conversations.

My take-away; "How does this affect flow?" is a valuable perspective for individuals, teams and organizations.
