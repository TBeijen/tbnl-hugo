---
title: "Shifting left using feature deploys"
author: Tibo Beijen
date: 2023-06-10T09:00:00+01:00
url: /2023/06/10/shifting-left-feature-deploys
categories:
  - articles
tags:
  - Kubernetes
  - CDN
  - Akamai
  - Helm
  - CI/CD
description: Deploying previews before merging into main. Should you? And if so, how would you?
thumbnail: ""

---
## Introduction

Once teams grow, you might have multiple people working on a single application. Ideally one wants to integrate often (the 'continuous' in CI), yet at the same time one usually wants the have the main branch in a deployable state. 

So, how to validate that a pull request results in a deployable application? Tests. very much preferably automated tests. 

But, once there is a more visual or UX aspect to the application, fully automated testing can be surprisingly hard. Similarly, collaborating with other departments might complicate testing. 

If there is just a single test environment, the testing lane easily becomes a traffic jam: Lots of alternating deploys of branches, a lot of alignment between team members and the ever-present question "Is my feature that I presume I am currently testing, really still on test?". Slow, error-prone, and full of overhead.

Another reason a single test environment might not suffice is when needing to have a representative environment for automated end-to-end tests before merging into the main branch.

Feature deploys, also sometimes referred to as 'preview deploys' can help to shorten the feedback loop and avoid this traffic jam: Every feature branch will be deployed in a separate environment. 

Examples of situations where [we](NU.nl) have found feature deploys to be useful are:

* How does this feature _look_? (to someone not able to easily spin up a local development environment)
* Is this swipe gesture _smooth_?
* Does the navigation still work when banner slot X is filled? (Needing a representative environment for e2e tests where advertising can be integrated)
* Does platform x receive the expected events?
* Does this API work-in-progress align with the feature developed in the mobile app? 

{{< figure src="/img/feature_deploys_header.jpg" title="Parallel tracks. Source: Bing Image Creator" >}}

## Preview deploys. An anti-pattern?

[Modern practice](https://trunkbaseddevelopment.com/) encourages us towards keeping features small, merging often and fast, and automating everything. Yet we are considering feature deploys that ideally are just for automated end-to-end tests, but might result in branches being preserved until some non-automated procedure is finished? Should we really?

Probably the most important thing is to never consider feature deploys as a goal but merely as a means to an end. If feasible, putting effort into automation, removing the _need_ for feature deploys, would be preferable.

Speaking _in favor_ of feature deploys: It aligns with the _shift left_ paradigm. We try to validate our work _as soon as possible_. If that involves stakeholders that can't be automated, validating before merging and proceeding further down the delivery pipeline, sounds reasonable.

Some alternatives might be worth considering:

### Feature flags

Feature flags decouple deployments from the actual release. This opens up the possibility for a more rigorous form of trunk-based development. Work in progress will be continuously deployed. Only when it is finished it will be released to the public via a feature flag.

Feature flag platforms can typically release features to segments, like company users, or beta testers. This way certain aspects can be tested on production _before_ releasing them to the general public.

### Moving development into the cloud

When development work in progress happens in the cloud, or is closely integrated with the cloud, the 'deploy' step can become integral part of the workflow to the point that it disappears completely. Tools like [Raftt](https://www.raftt.io/) and [Telepresence](https://www.telepresence.io/) aim at improving the development experience, including preview urls.

Likewise, serverless development, unless using something like [LocalStack](https://localstack.cloud/), often happens _in_ the cloud, making the availability of the work in progress ubiquitous.

## Define scope

So, once we've established feature deploys solve a problem, we arrive at the next question: What should be included in a feature deploy?

Applications are hardly ever isolated. They consume services, use databases, emit or consume events. Those services in turn also have depencencies, the list goes on.

Determining what to include in a feature deploy will involve trade-offs and pragmatism. Some questions that might pop up:

* Can we easily provision and populate a dedicated database? Provisioning time of a RDS Aurora cluster is ~20 minutes. Do we consider that easy? Is it cheap enough? Once provisioned, can we easily load a fixture dataset?
* If so, can we fully leverage database? Ideally, databases are used by a single (micro-)service. However, the landscape is not always ideal and other applications might be needed to write to the database, increasing our scope.
* Do we need to have per-feature deployments of supporting services?
* If not possible, for example when integrating with a SaaS, should we setup additional tenants (if possible)? 
* If not, and sharing a supporting service with other feature deploys, will our testing efforts interfere?
* Are there parts of our infrastructure we can not easily create duplicates for?
* Are there services we integrate with that can not handle multiple domain names? Example: A consent platform using redirects. Can it be configured to accept a wildcard domain as valid return url? Alternatively, does it have an API to (un)register return urls? If not (so much for self-servicability) can we disable this integration?

Rule of thumb: Keep the scope as small as possible. It will probably be easier from a devops perspective and easier to reason about.

To illustrate, small scope:

{{< figure src="/img/feature_deploys_scope_small.png" title="Small scope" >}}

And large scope. Note how choosing to deploy a relational database as a container can greatly speed up, and reduce ops complexity of the feature deployment:

{{< figure src="/img/feature_deploys_scope_large.png" title="Large scope variations" >}}

## Example implementation

Let's take a more in-depth look at the feature deploy setup for the BFF (Backend for Frontends) that is used by our mobile apps.

To address the 'should we?' question: An API returning JSON is typically easy to test in fully automated way. However, we still get value out of feature deploys:

* Teams are cross-functional. While one developer works on the API part, mobile app developers can work on corresponding changes based on the feature deploy.
* We can use the feature deploy to run e2e tests.
* We control many aspects of service integrations via the BFF, such as advertising and event tracking. Sending the _intended_ data can be unit tested, but ensuring it is the _correct_ data often requires some back-and-forth-ing with other departments. Feature deploys help us in shortening that feedback loop and ensuring correctness _before_ we ship.

Our feature deploy setup looks like this:

TODO: Illustration feature deploy

Let's fo over some parts

## Akamai

As [written previously](https://www.tibobeijen.nl/2021/12/03/shift-left-akamai-terraform/), it is valuable to have a representative testing environment as early as possible in the development lifecycle. And being representative means including the CDN.

Setting up an Akamai property takes about 15 minutes. That's not fast. Furthermore, specific to Akamai, there are some [hurdles](https://github.com/akamai/terraform-provider-akamai/issues/268) related to setting up properties that support wildcard certificates. Adding to that, DNS records need to be setup for the edge host _and_ for validating the TLS certificate. That is all possible to automate, but not particularly easy and doing so _does_ introduce a lot of moving parts.

We found that setting up a single property for all feature deploys works best. It's a one-time setup, not affecting the speed of any of the feature deploys. Caching is unique per feature since the cache key includes the host name. All traffic goes to Kubernetes ingress and only there is the split made to the separate feature deploys.

This setup involves some use of wildcards:

* A wildcard DNS entry to the CDN, e.g. `*.bff.feature.mysite.com CNAME bff.feature.mysite.com.edgekey.net.`
* A wildcard certificate on the CDN, in this example `*.bff.feature.mysite.com`

CDNs typically accept TLS certificates from origin that match either the requested `Host` or the origin FQDN. We terminate TLS on an AWS ALB and use the ALB FQDN.

## Helm unique release names

By convention our feature branches reference the Jira issue we are working on. So branches will be named something like `feature/JIRA-123_something_descriptive`. CI/CD will parse this issue from the branch name, and apply it to our Helm install in the following ways:

* Helm release name. Prefixing the release name with the issue code ensures all Kubernetes object names are unique within the namespace. For example a release name of `jira-1234-bff` resuling in deployments named `jira-1234-bff-api` and `jira-1234-bff-redis`.
* Ingress hostname: `jira-1234.bff.feature.mysite.com`
* Application config, things like the redis service-name if redis is included in the feature deploy, Hostnames the application accepts, etc.

## Resource usage and cost

Non-production capacity tuning can be somewhat challenging: A lot of time throughput is absent, yet having very low CPU limits will badly affect any request. What in our experience works well is to have very low CPU requests, say `0.05 cpu` and no, or sufficiently high, limit. This works because:

* CPU is compressible, so when having a brief period of CPU saturation, performance degrades but nothing will _break_
* Not all deployments will have throughput at the same time (the concept taken to the extreme by serverless)

Memory is not compressible,. Some tips: 

* Be aware of application configuration that affects memory usage. For example, having an needlessly high amount of [gunicorn worker processes](https://docs.gunicorn.org/en/stable/design.html#how-many-workers) on a non-prod environment will waste memory.
* Pick node instance types that have high memory vs. CPU. E.g. the AWS `m5/m6` instance families, where a `m5.large` couples 4 vCPU to 16GiB of memory.

A quick cost break-down: 

* Let's assume we use [m5.xlarge](https://instances.vantage.sh/aws/ec2/m5.xlarge?region=eu-west-1&cost_duration=monthly&os=linux&reserved_term=Standard.noUpfront) spot instance costing **~$70 / month**.
* Let's assume, using the above guidelines, we can have about 7 feature deploys on a node
* Let's also assume that, given low throughput, other cost such as network traffic or logging is neglegible
* Per feature deploy, assuming they would be active 24/7, the monthly cost per feature deploy would be **$10 / month**
* A feature is not active for an entire month. A week would already be long. So, cost per feature deploy is **$2.50**.

That's not 0, but not breaking the bank either. Now if we relate that to $100/hr cost of engineering (contractor) you would break even at **saving 1.5 minute of engineering time** per feature. Remembering the 'traffic jam' dynamics described in the introduction, that should be easy.

This doesn't take into account the initial setup effort. On the other hand, these calculations also ignore that feature deploys don't need to run 24/7, and that a week per feature is a high estimate. So we can consider those to be in balance.

## Cleanup



### Possible improvements


----



Ideally, one would strive for:

* Short-lived branches
* Frequent integration of code changes
* Complete coverage by automated tests


## Define scope

* The why? What is the purpose. Smoke tests? Visual? Highly controlable e2e tests?
* Speed of provisioning
* Isolation & data flow

### Considerations

Integrated services. Consent, callbacks, etc.

## Our particular implementation

### Akamai

* Wildcard domain
* Wildcard TLS

### Ingress

* Ingress specific FQDN
* Matching cert
* Ingress definition per deployment

### Redis 

* Per installation

### Teardown

* Nightly cleanup, cleanup after x hours

## Possible improvements

* GitOps ArgoCD ApplicationSet with Pull  Request Generator: https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Generators-Pull-Request/

## Conclusion

* Can be useful
* Lo-fi glue code can go a long way
* So do wildcard certificates and DNS entries
* Identify the goal, and choose scope wisely



