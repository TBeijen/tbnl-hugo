---
title: 'Shifting Akamai to the left using Terraform'
author: Tibo Beijen
date: 2021-12-01T10:00:00+01:00
url: /2021/12/01/shift-left-akamai-terraform
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

Recently we migrated our CDNs from Cloudfront to Akamai. We use Terraform for infrastructure as code (IaC) and luckily it supports Akamai as well. Nevertheless there were some challenges, like what to do with Akamai's 'staging network' in a test-early, test-often approach? (Spoiler alert: Don't use the staging network) and the concept of activating a property version. All in all it was a smooth transition and the challenges were mostly about learning the ins and outs of Akamai.

## Shift Left testing

"Shift left" is popular in the contemporary agile and DevOps IT-landscape, and for good reasons. This article [by BMC](https://www.bmc.com/blogs/what-is-shift-left-shift-left-testing-explained/) summarizes it nicely:

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

Compared to Cloudfront, Akamai has some advanced concepts that need to be fitted into an IaC workflow in some way.

### Activation

An Akamai 'property' (what in Cloudfront is called a 'distribution') has versions of which one is active at any moment, typically the most recent one. When modifying a configuration of which the latest version is active, this results in a new property version which can be activated. 

### The staging network

Akamai provides 2 networks: Production and staging. Any property version can be activated on the staging and production network independently. The staging network is feature-complete but doesn't provide the performance of the production network. If the production network would use `mysite.com.edgekey.net` then the staging network would be accessible using `mysite.com.edgekey-staging.net`. This [could be used by modifying](https://learn.akamai.com/en-us/webhelp/ion/web-performance-getting-started-for-http-properties/GUID-094B3C1E-0205-4104-A091-36FD4E28362D.html) the `/etc/hosts` file.

### Adapting to IaC

One can observe that both of the above concepts seem to originate from a more traditional late acceptance testing practice. In an IaC practice they loose some of their relevance and can even cause ambiguity that can be considered undesirable:

* Configuration versions are already present by having configuration in source control. The active version is determined by the branching model that is used, commonly 'latest master'.
* The Akamai staging network can be used to test a property version, but it's not really a staging environment since it uses the same production origins. [^footnote_staging_network] To illustrate: One could only test the integration of an application and a CDN change _after_ deploying the application to production. So for test, let alone multiple test (feature) environments, more than one property is needed.

What we found works well:

* Create a property for all environments: test (one or multiple), staging and production.
* Always activate the latest version.
* Test on test, which is fully representative, using any automation one has, for example [cypress](https://www.cypress.io/) e2e tests.

This way the delivery of Akamai config changes is identical to that of application changes.

Note that it still allows shit-hits-the-fan rollbacks: The first hour after activating a production property version, there's a quick fallback option. This can be activated, after which the active version in IaC can be aligned with the actual state. 

## Terraform

## Quirks

## Final thoughts


Confidence in provisioning `1...n` near-identical CDN properties instead of using Akamai's staging network to test very close to final production release.


[^footnote_local_cdn]: For a CDN, representative _local_ development seems a bit far-fetched, but once you deploy, having a representative environment should be the goal.

[^footnote_staging_network]: One could attempt to mitigate this by selecting a staging origin based on the request host, but this is a bad idea for a variety of reasons, the most obvious one being that it adds complexity that can easily backfire (production traffic ending up on staging origin), while still being limited to just production and staging. No test. No shifting left.


