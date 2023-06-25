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

Once teams grow, you might have multiple people working on a single application. Ideally one wants to integrate often (the 'continuous' in CI) yet at the same time one usually wants the have the main branch in a deployable state. 

So, how to validate that a pull request results in a deployable application? Tests. very much preferably automated tests. 

But, once there is a more visual or UX aspect to the application, fully automated testing can be surprisingly hard. Similarly, collaborating with other departments might complicate testing. 

If there is just a single test environment, the testing lane easily becomes a traffic jam: Lots of alternating deploys of branches, a lot of alignment between team members and the ever-present question "Is my feature that I presume I am currently testing, really still on test?". Feature deploys, also sometimes referred to as 'preview deploys' can help to shorten the feedback loop and avoid this 'traffic jam'. Every feature branch will be deployed in a separate environment. 

Examples of situations where [we](NU.nl) have found feature deploys useful are:

> How does this feature _look_? (to someone not able to easily spin up a local development environment)
> Is this swipe gesture _smooth_?
> Does the navigation still work when banner slot X is filled?
> Does platform x receive the expected events?
> Does this API work-in-progress align with the feature developed in the mobile app? 

## Preview deploys. An anti-pattern?

So, [modern practice](https://trunkbaseddevelopment.com/) encourages us towards keeping features small, merging often and fast, and automating everything. Yet we are considering feature deploys where branches are preserved until some non-automated procedure is finished? Should we really?

Probably the most important thing is to never consider feature deploys the end goal. If feasible, putting effort into automation, removing the _need_ for feature deploys, would be preferable.

Speaking _for_ feature deploys: It aligns with the _shift left_ paradigm. We try to validate our work _as soon as possible_. If that involves stakeholders that can't be automated, validating before merging and proceeding further down the delivery pipeline, sounds reasonable.

Some alternatives might be worth considering:

### Feature flags

Feature flags decouple deployments from the actual release. This opens up the possibility for a more rigorous form of trunk-based development. Work in progress will be continuously deployed. Only when it is finished

### Moving development into the cloud


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



