---
title: 'Akamai, Terraform and the testing pyramid'
author: Tibo Beijen
date: 2021-12-01T10:00:00+01:00
url: /2021/12/01/akamai-terraform-testing
categories:
  - articles
tags:
  - Akamai
  - Terraform
  - Testing
description: "Using Terraform to provision Akamai properties in a shift left testing practice."
thumbnail: img/akamai-terraform-shift-left-launchable.png
draft: true

---

Recently we migrated our CDNs from Cloudfront to Akamai. We use Terraform for infra-as-code and luckily it supports Akamai as well. Nevertheless there were some challenges, like what to do with Akamai's 'staging network' in a test-early, test-often approach? (Spoiler alert: Don't use the staging network) and the concept of activating a property version. All in all it was a smooth transition and the challenges were mostly about learning the ins and outs of Akamai.

## Shift Left testing

"Shift left" is a popular in the contemporary agile and DevOps IT-landscape, and for good reasons. This article [by BMC](https://www.bmc.com/blogs/what-is-shift-left-shift-left-testing-explained/) summarizes it nicely:

> Shift Left is a practice intended to find and prevent defects early in the software delivery process. The idea is to improve quality by moving tasks to the left as early in the lifecycle as possible. Shift Left testing means testing earlier in the software development process.

Shift left testing illustrated:

{{< figure src="/img/akamai-terraform-shift-left-launchable.png" title="Shift Left testing (image by Launchable, Inc.)" >}}

Quoting yet another source, [devops.com](https://devops.com/devops-shift-left-avoid-failure/):

> Shifting left requires two key DevOps practices: continuous testing and continuous deployment.

And:

> Another way to reduce the failure rate is to make all environments in the pipeline look as much like production as possible.

So, how does a CDN (any CDN, be it Cloudfront, Akamai, Fastly, you name it) fit into this shift left approach? Very well actually, as long as:

* The CDN isn't limited to production only but has is present in every environment as early as possible in the delivery lifecycle. [^footnote_local_cdn]
* Setting up and updating the CDN should be no different than any other code or infra change. As [Martin Fowler says](https://martinfowler.com/bliki/FrequencyReducesDifficulty.html): "If it hurts, do it more often".

## Akamai concepts

### The staging network

### Activation







 [^footnote_local_cdn]: For a CDN, representative _local_ development seems a bit far-fetched, but once you deploy, having a representative environment should be the goal.



Akamai concepts

Using Terraform

Quirks

Final thoughts


Confidence in provisioning `1...n` near-identical CDN properties instead of using Akamai's staging network to test very close to final production release.