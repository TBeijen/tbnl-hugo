---
title: 'Shifting Akamai to the left using Terraform'
author: Tibo Beijen
date: 2021-12-03T10:00:00+01:00
url: /2021/12/03/shift-left-akamai-terraform
categories:
  - articles
tags:
  - DevOps
  - Akamai
  - Terraform
  - IaC
  - Shift-left testing
  - Testing
description: "Using Terraform to provision Akamai properties in a shift left testing practice."
thumbnail: img/akamai-terraform-shift-left-header.png

---

Recently [we](https://www.nu.nl) migrated our CDNs from Cloudfront to Akamai. We use Terraform for infrastructure as code (IaC) and luckily it supports Akamai as well. Since we had Cloudfront distributions for pretty much every environment, it served as a good moment to reflect on what we've taken for granted in the past years, especially since Akamai has the concept of a 'staging network' which doesn't naturally seem to fit in a test-early, test-often approach (Spoiler alert: We don't use the staging network).

{{< figure src="/img/akamai-terraform-shift-left-header.png" title="CDNs to the left. Source: Flickr - Benny Mazur (2007), via pedbikesafe.org" >}}

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

* The CDN isn't limited to production only but is present in every environment as early as possible in the development lifecycle. [^footnote_local_cdn]
* Setting up and updating the CDN should be no different than any other code or infra change. As [Martin Fowler says](https://martinfowler.com/bliki/FrequencyReducesDifficulty.html): "If it hurts, do it more often".

## Akamai concepts

Compared to Cloudfront, Akamai has some advanced concepts that need to be fitted into an IaC workflow in some way.

### Activation

An Akamai 'property' (what in Cloudfront is called a 'distribution') has versions of which one is active at any moment, typically the most recent one. When modifying a configuration of which the latest version is active, this results in a new property version which can be activated when ready. 

### The staging network

Akamai provides two networks: Production and staging. Property versions can be activated on the staging and production networks independently. The staging network is feature-complete but doesn't provide the performance of the production network. If the production network would use `mysite.com.edgekey.net` then the staging network would be accessible using `mysite.com.edgekey-staging.net`. This [can be used by modifying](https://learn.akamai.com/en-us/webhelp/ion/web-performance-getting-started-for-http-properties/GUID-094B3C1E-0205-4104-A091-36FD4E28362D.html) the `/etc/hosts` file, to allow testing before activating the version on the production network.

### Adapting to IaC

One can observe that both of the above concepts seem to originate from a more traditional acceptance testing practice happening late in the development lifecycle. In an IaC practice they loose some of their relevance and can even cause ambiguity that can be considered undesirable:

* Configuration versions are already present by having configuration in source control. The active version is determined by the branching model that is used (commonly 'latest master'), combined with any automation that exists.
* The Akamai staging network can be used to test a property version, but it's not really a staging environment since it uses the _production_ origins. [^footnote_staging_network] To illustrate: One could only test the integration of an application and a CDN change _after_ deploying the application to production. This limits the scope of what can be tested using the staging network. So for test, let alone multiple test (feature) environments, more than one property is needed.

What we found works well:

* Create a property for all environments: test (one or multiple), staging and production.
* Always activate the latest version.
* Test on test, which is fully representative, using any automation one has, for example [cypress](https://www.cypress.io/) e2e tests.

This way the delivery of Akamai config changes is identical to that of application changes.

Note that it still allows shit-hits-the-fan rollbacks: The first hour after activating a production property version, there's a quick fallback option. This can be activated (stop the bleeding), after which the active version defined in IaC can be aligned with the actual active version and a fix can be worked on (proper surgery). 

## Terraform

Overall the Terraform module does a fine job in translating declarative Terraform config into Akamai API actions. There are however some things to consider:

### Version to be activated
An activation is a [separate Terraform resource](https://registry.terraform.io/providers/akamai/akamai/latest/docs/resources/property_activation). What happens under the hood is that if the version changes it will use Akamai's Property API (PAPI) to [create a new activation](https://developer.akamai.com/api/core_features/property_manager/v1.html#postpropertyactivations).

The [Terraform property resource](https://registry.terraform.io/providers/akamai/akamai/latest/docs/resources/property) has 3 attributes related to versions: `latest_version`, `production_version` and `staging_version`. These are determined _after_ the property has been updated, but _before_ any activation has finished. 

We take 'always activating latest' as a starting point. However, scenarios can exist where you want to pin a version. One possible way to accomplish this is a setting a `local` like this:

```
locals {
  production_version_to_activate = (var.production_activate_latest == true ? 
    akamai_property.property.latest_version : 
    (var.production_pinned_version > 0 ? var.production_pinned_version : akamai_property.property.production_version))
}
```

Having variable defaults:

```
# Note: Similar variables would exist for staging network
variable "production_pinned_version" {
  description = "Pin PRODUCTION network activation to this version. Set to 0 to always use previous property version on production (don't activate any property changes)."
  type        = number
  default     = 0
}

variable "production_activate_latest" {
  description = "Apply latest version to production. This supersedes any pinned version so disable if wanting to stay at a specific version."
  default     = true
}
```

This way  `tfvars` can be set for various scenarios following below examples:

```
# Directly activate latest property version (default)
production_activate_latest   = true

# Stick to previously active version (update the property, activate later, or via GUI)
production_activate_latest   = false

# Activate specific version (e.g. reverting to known to work version)
production_pinned_version    = 7
production_activate_latest   = false
```

### Slow activations

Activating the staging network takes about 2 to 3 mins. Activating production typically takes between 9 and 11 minutes. To shorten the feedback loop, one can configure DNS for the test environment to use Akamai's staging network, and avoid activating the production network altogether. Example:

```
test.mysite.com CNAME test.mysite.com.edgekey-staging.net
```

Given low traffic, the cache-hit ratio on test usually can't be compared to production anyway, so not having production performance would normally not be an issue.

### Implicit edge hostnames

The [edge hostname](https://registry.terraform.io/providers/akamai/akamai/latest/docs/resources/edge_hostname) resource requires to set a certificate enrollment ID when using enhanced TLS (edge hostnames ending in `edgekey.net`). However, if you're a 'Secure by default' customer, you _can_ (not: must) [use default certificates](https://learn.akamai.com/en-us/learn_akamai/getting_started_with_akamai_developers/core_features/create_edgehostnames.html#cpsprerequisitefortls). In that case the edge hostname will be [created implicitly by the property manager API](https://developer.akamai.com/api/core_features/property_manager/v1.html#postedgehostnames).

As a result the edge hostname that is created is not managed via Terraform. Most of the [edge hostname attributes](https://registry.terraform.io/providers/akamai/akamai/latest/docs/resources/edge_hostname#argument-reference) hardly ever needs to be changed, but for [ip_behavior](https://registry.terraform.io/providers/akamai/akamai/latest/docs/resources/edge_hostname#ip_behavior) this can be a problem ([Github issue](https://github.com/akamai/terraform-provider-akamai/issues/268)).

## Final thoughts

The main take-away is: Treat a CDN like any other cloud resource, making sure to have representative environments as early as possible in the development lifecycle, whether it is via Terraform, the [Akamai CLI](https://developer.akamai.com/cli) or another tool of choice. 

Shift-left in the context of Akamai results in achieving confidence in provisioning `1...n` near-identical CDN properties, reducing the need for the Akamai's staging network and ultimately speeding up the delivery process.

Worth noting is that end-to-end tests in a caching setup can be challenging to keep fast due to cache ttl. This can be mitigated via cachebusters, reduced `max-age` values in response headers or other constructs. 

A representative test environment with carefully considered exceptions still beats shifting right.

Thanks for reading! If you have feedback or comments, be sure to [find me on Twitter](https://twitter.com/TBeijen).


[^footnote_local_cdn]: For a CDN, representative _local_ development seems a bit far-fetched, but once you deploy, having a representative environment should be the goal.

[^footnote_staging_network]: One could attempt to mitigate this by selecting a staging origin based on the request host, but this is a bad idea for a variety of reasons, the most obvious one being that it adds complexity that can easily backfire (production traffic ending up on staging origin), while still being limited to just production and staging. No test. No shifting left.


