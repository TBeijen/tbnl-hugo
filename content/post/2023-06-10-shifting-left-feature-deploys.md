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

## Preview deploys. An anti-pattern?

## Define scope

* The why? What is the purpose. Smoke tests? Visual? Highly controlable e2e tests?
* Speed of provisioning
* Isolation & data flow

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



