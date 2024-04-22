---
title: "12 Factor: Going strong for over 12 years"
author: Tibo Beijen
date: 2024-04-22T08:00:00+01:00
url: /2024/04/22/12-factor-going-strong-for-over-12-years
categories:
  - articles
tags:
  - Cloud Native
  - Kubernetes
  - Operations
  - Development
description: The 12 factor methodology is more than 12 years old. How did it age in the cloud-native era?
thumbnail: img/foobar.png

---

## Introduction

In a presentation about CI/CD I gave recently, I briefly mentioned the [12 factor methodology](https://12factor.net/). Somewhere along the lines of "You might find some good practices there", and summarizing it as:

```
artifact
configuration +
---------------
deployment
```

After the talk, a colleague of way back, came to me and said: "You were way too mild in _suggesting_ it. It's mandatory, people _should_ follow those practices."[^footnote_xs4all_stint]

And yes, he's right. There is a lot of good practices to get from the 12 factor methodology. But do _all_ parts still hold up? Or might following it to the letter be actually counter-productive in some cases?

In the past, I have onboarded quite a number of applications into Kubernetes, that were already built with 12 factor in mind. That process usually was fairly smooth, so you start to take things for granted. Until you bump into applications that are tough to operate, that is.

Upon closer inspection, such applications are usually found to violate some of the 12 factor principles.

The 12 factor methodology has been [initiated almost 14 years ago](https://github.com/heroku/12factor/commit/2b06e7deabb64bb759f9fc6f4d9b6fcc546921bb) at Heroku, a company that was 'cloud native', focused on developer experience and ease of operation. So, it's no surprise it still _is_ relevant.

So, let's glance over the 12 factors, and put them in the context of modern cloud native applications.

## The 12 factors

### 1. Codebase

> One [codebase](https://12factor.net/codebase) tracked in revision control, many deploys

Looking at the image, these days we would add artifact between codebase and deploys. Artifact being a container, or perhaps zip file (serverless). 

```
code         -> artifact       -> deploy
- versioned     - container       - prod
                - zip             - staging
                - bundle          - local
```

It's worth noting that, depending on the local development setup, some form of live-reload usually comes in place of creating an actual artifact.

### 2. Dependencies

> Explicitly declare and isolate [dependencies](https://12factor.net/dependencies)

This is something that has become more natural in containerized applications. 

One part of the description is a bit dated though: "Twelve-factor apps also do not rely on the implicit existence of any system tools. Examples include shelling out to ImageMagick or curl."

In containerized applications the boundary _is_ the container, and its contents are well-defined. So an application shelling out to `curl` is not a problem, since `curl` now comes with the artifact, instead of it being assumed to exist.

### 3. Config

> Store [config](https://12factor.net/config) in the environment

This point is perhaps overly specific on the exact solution. The main take-aways are:

* Configuration not in application code
* Artifact + configuration = deployment

Confusingly, and especially with the rise of GitOps, the configuration _is_ in a codebase, but detached from the application code.

As long as the above concept is followed, using environment variables or config files, is mostly an implementation detail.

However, depending on security requirements, there might be considerations to use files instead of environment variables, optionally combined with envelope encryption. On this topic I can recommend:

* KubeCon EU 2023: [A Confidential Story of Well-Kept Secrets - Lukonde Mwila, AWS](https://kccnceu2023.sched.com/event/1HyVr/a-confidential-story-of-well-kept-secrets-lukonde-mwila-aws) [(video)](https://youtu.be/-I1JjJxy-rU?t=302).

### 4. Backing services

> Treat [backing services](https://12factor.net/backing-services) as attached resources

This has become common practice. In Kubernetes it's usually easy to configure either a local single-pod (non-prod) Redis or Postgres, or a remote cloud-managed variant like RDS or Elasticache.

There can be reasons to use local filesystem or memory, for example performance, or simplicity. This is fine, as long as the data is completely ephemeral and the implementation doesn't negatively affect any of the other 11 factors.

### 5. Build, release, run

> Strictly [separate](https://12factor.net/build-release-run) build and run stages

From Kubernetes to AWS Lambda: It will be hard these days to violate this principle. Enhancing the aforementioned summary:

```
Build   -> artifact
Release -> configuration +
--------------------------
Run     -> deployment
```

### 6. Processes

> Execute the app as one or more [stateless processes](https://12factor.net/processes)

In the full text, there is a line that better summarizes the point:

> Twelve-factor processes are stateless and share-nothing

Some take-aways:

* One container, one process, one service.
* No sticky-sessions. Store sessions externally, e.g. in redis. See also factor 4.
* Simplify the process by considering [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) or [Helm chart hooks](https://helm.sh/docs/topics/charts_hooks/).

Somewhat overlapping with factor 4, this factor implies using external services where possible. For example: Use external Redis instead of embedded Infinispan.

### 7. Port binding

> [Export services](https://12factor.net/port-binding) via port binding

This holds up for TCP-based applications. But it is no longer applicable for event-driven systems such as AWS Lambda or WASM on Kubeternetes using [SpinKube](https://www.spinkube.dev/).

### 8. Concurrency

> [Scale out](https://12factor.net/concurrency) via the process model



## Conclusion

Not addressed: N & N-1 compatibility
Not addressed: Metrics & traces


[^footnote_xs4all_stint]: Passionate, knowledgeable and vocal, defined the culture at XS4All.
