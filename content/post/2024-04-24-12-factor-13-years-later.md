---
title: "12 Factor: 13 years later"
author: Tibo Beijen
date: 2024-04-24T06:00:00+01:00
url: /2024/04/24/12-factor-13-years-later
categories:
  - articles
tags:
  - Cloud Native
  - Kubernetes
  - Operations
  - Development
description: The 12 factor methodology is about 13 years old. How did it age in the cloud-native era? Do we need a 13th factor?
thumbnail: img/12factor_13years_header.jpg

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

And yes, he was right. There are a lot of good practices to get from the 12 factor methodology. But do _all_ parts still hold up? Or might following it to the letter be actually counter-productive in some cases?

In the past, I have onboarded quite a number of applications into Kubernetes, that were already built with 12 factor in mind. That process usually was fairly smooth, so you start to take things for granted. Until you bump into applications that are tough to operate, that is.

Upon closer inspection, such applications are usually found to violate some of the 12 factor principles.

The 12 factor methodology has been [initiated almost 13 years ago](https://github.com/heroku/12factor/commit/2b06e7deabb64bb759f9fc6f4d9b6fcc546921bb) at Heroku, a company that was 'cloud native', focused on developer experience and ease of operation. So, it's no surprise it still _is_ relevant.

So, let's glance over the 12 factors, and put them in the context of modern cloud native applications.

{{< figure src="/img/12factor_13years_header.jpg" title="12 Factor. Still leading the way in the cloud-native era?" >}}

## The 12 factors

### 1. Codebase

> One [codebase](https://12factor.net/codebase) tracked in revision control, many deploys

Looking at the image, these days we would add artifact between codebase and deploys. Artifact being a container, or perhaps zip file (serverless). 

```
code         -> artifact       -> deploy
- versioned     - container       - prod
                - zip             - staging
                                  - local
```

It's worth noting that for local development, depending on the setup, some form of live-reload usually comes in place of creating an actual artifact.

### 2. Dependencies

> Explicitly declare and isolate [dependencies](https://12factor.net/dependencies)

This is something that has become more natural in containerized applications. 

One part of the description is a bit dated though: "Twelve-factor apps also do not rely on the implicit existence of any system tools. Examples include shelling out to ImageMagick or curl."

In containerized applications the boundary _is_ the container, and its contents are well-defined. So an application shelling out to `curl` is not a problem, since `curl` now comes with the artifact, instead of it being assumed to exist.

Similarly, in serverless setups like AWS Lambda, the execution environment is so well-defined that any dependency it provides, can be safely used.

### 3. Config

> Store [config](https://12factor.net/config) in the environment

This point is perhaps overly specific on the exact solution. The main takeaways are:

* Configuration not in application code
* Artifact + configuration = deployment

Confusingly, and especially with the rise of GitOps, the configuration _is_ in a codebase, but detached from the application code.

As long as the above concept is followed, using environment variables or config files, is mostly an implementation detail.

Using Kubernetes, depending on security requirements, there might be considerations to use files instead of environment variables, optionally combined with envelope encryption. On this topic I can recommend:

* KubeCon EU 2023: [A Confidential Story of Well-Kept Secrets - Lukonde Mwila, AWS](https://kccnceu2023.sched.com/event/1HyVr/a-confidential-story-of-well-kept-secrets-lukonde-mwila-aws) [(video)](https://youtu.be/-I1JjJxy-rU?t=302).

### 4. Backing services

> Treat [backing services](https://12factor.net/backing-services) as attached resources

This has become common practice. In Kubernetes, it's usually easy to configure either a local single-pod (non-prod) Redis or Postgres, or a remote cloud-managed variant like RDS or Elasticache.

There can be reasons to use local file system or memory, for example performance, or simplicity. This is fine, as long as the data is completely ephemeral, and the implementation doesn't negatively affect any of the other factors.

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

Some takeaways:

* One container, one process, one service.
* No sticky-sessions. Store sessions externally, e.g. in Redis. See also factor 4.
* Simplify the process by considering [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) or [Helm chart hooks](https://helm.sh/docs/topics/charts_hooks/). See also factor 12.

Somewhat overlapping with factor 4, this factor implies using external services where possible. For example: Use external Redis instead of embedded Infinispan.

### 7. Port binding

> [Export services](https://12factor.net/port-binding) via port binding

This holds up for TCP-based applications. But it is no longer applicable for event-driven systems such as AWS Lambda or WASM on Kubernetes using [SpinKube](https://www.spinkube.dev/).

### 8. Concurrency

> [Scale out](https://12factor.net/concurrency) via the process model

Make your application horizontal scalable. This is somewhat related to factor 4, which result in share-nothing application processes.

Furthermore, the application should leave process management to the operating system or orchestrator.

### 9. Disposability

> Maximize robustness with [fast startup and graceful shutdown](https://12factor.net/disposability)

In a way this can be seen as complementing the previous factor: Just as it should be easy to horizontally scale out, it should be easy to remove or replace processes.

Specific to Kubernetes, this boils down to:

* Obey [termination signals](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-termination). The application should gracefully shut down. Either handle the `SIGTERM` signal in the application, or setup a [PreStop](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks
) hook ([more info](https://cloud.google.com/blog/products/containers-kubernetes/kubernetes-best-practices-terminating-with-grace)).
* Setup probes. Probes should only return `OK` when the application is actually ready to receive traffic.
* Setup `maxSurge` ([rolling updates](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment)) and `PodDisruptionBudget`([scheduling](https://kubernetes.io/docs/tasks/run-application/configure-pdb/)).
* Nodes are cattle, so it always should be possible to reschedule pods: The share-nothing concept.

### 10. Dev/prod parity

> Keep development, staging, and production [as similar as possible](https://12factor.net/dev-prod-parity)

This is a broad topic and as relevant as ever. At a high level it boils down to 'Shift left': Validate changes as reliably and quickly as possible.

Solutions are many, and could include [Docker Compose](https://docs.docker.com/compose/), [VS Code dev containers](https://code.visualstudio.com/docs/devcontainers/containers), [Telepresence](https://www.telepresence.io/), [Localstack](https://www.localstack.cloud/) or setting up temporary AWS accounts as a development environment for serverless applications.

### 11. Logs

> Treat logs as [event streams](https://12factor.net/logs)

Don't store logs in files. Don't 'ship' logs in the application.

The operating system or orchestrator should capture the output stream and route it to the logging storage of choice.

Where the 12 factor methodology shows its age a bit is that there is no mention of metrics and traces, together with logs, often referred to as "the three pillars of observability".

Extrapolating the approach to logging, consider systems that 'wrap' an application instead of requiring a detailed implementation. [OpenTelemetry zero-code instrumentation](https://opentelemetry.io/docs/concepts/instrumentation/zero-code/) could be a good starting point. APM agents of observability SaaS platforms such as New Relic or Datadog can be applied similarly.

### 12. Admin processes

> Run admin/management tasks as one-off processes

This fragment in the full description might summarize it better: "Admin code should ship with the application code".

This is about tasks like changing database schema, or uploading asset bundles to a centralized storage location. 

The goal is to rule out any synchronization issues. Keywords are:

* Identical environment
* Same codebase

## Summarizing the 12 factors

As long as we try to grasp the idea behind the factors instead of following every detail, I would say most of the factors hold up quite well.

Some recommendations have become more or less common practice over the years. Some other recommendations have a bit of overlap. For example: Externalizing state (factor 4) makes concurrency (factor 8) and disposability (factor 9) easier to accomplish.

## Factor 13: Forward and backward compatibility

There is a point not addressed in the 12 factor methodology that in my experience has always made an application easier to operate: Backward and forward compatibility.

These days we expect application deployments to be frequent and without any downtime. That implies either rolling updates or blue/green deployments. Even blue/green deployments, in large distributed platforms, are hardly ever truly atomic. And deployment patterns like canary deployments, imply being able to roll back.

So, getting this right opens up the path the frequent friction-less deploys.

This is about databases, cached data and API contracts. We need to consider:

* How does our application handle data while version `N` and `N+1` are running simultaneously?
* What happens if we need to roll back from `N+1` to `N`?

Some pointers:

* When changing the database schema, first _add_ columns. Only remove the columns in a subsequent release once the data has been migrated.
* First add a field to an API or event schema, only then update consumers to actually expect the new field.
* Consider compatibility of cached objects. Prefixing cache-keys with something unique to the application version can help here.

What will happen with data in the transition period. Store in old _and_ new format? Do we need to store version information with the data and support multiple versions?

This can be complicated for applications provided for others to operate, unlike applications operated by the developing team itself, and released via CI/CD. External users often don't follow all minor releases, making it more likely to not have backward compatibility.

## Conclusion

Some of the above recommendations might take additional effort. However, in my experience that is worth it and will be paid back (with interest) by ease of operations, piece of mind and a reduced need for coordination of releases. 

[^footnote_xs4all_stint]: [XS4All](https://en.wikipedia.org/wiki/XS4ALL) had a great culture, showing its roots: Passionate, knowledgeable and vocal.
