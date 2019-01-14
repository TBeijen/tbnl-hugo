---
title: 'Maximize learnings from a Kubernetes cluster failure'
author: Tibo Beijen
date: 2019-01-14T10:00:00+01:00
url: /2019/01/14/learning-from-kubernetes-cluster-failure/
categories:
  - articles
tags:
  - DevOps
  - Kubernetes
  - Agile
  - Failure management
  - Company Culture
description: "Analyzing past Kubernetes cluster issues, but more importantly: Maximize learnings."

---

Recently our team faced some problems on one of our Kubernetes clusters. Not as severe as to bring everything to a grinding halt, but definitely affecting end user experience of some interally used tools and dashboards.

Coincidentally, around the same time I visited DevOpsCon 2018 in Munich, where the opening keynote ["Staying Alive: Patterns for Failure Management from the Bottom of the Ocean"](https://devopsconference.de/business-company-culture/staying-alive-patterns-for-failure-management-from-the-bottom-of-the-ocean/) related very well to this incident.

The talk (by [Ronnie Chen](https://twitter.com/rondoftw), an engineering manager at Twitter) focussed on various ways to make DevOps teams more effective in preventing and handling failures. One of the topics addressed was how catastrophes are usually caused by a cascade of failures, resulting in this quote:

 > A post-mortem that blames an incident only on the root cause, might only cover ~15% of the issues that led up to the incident.

Postmortem templates: https://github.com/dastergon/postmortem-templates


Description of what went wrong


The root cause

Cascade of failures


Wrapup
- not even fixed on root cause
- company culture. Importance of blameless post mortems.


