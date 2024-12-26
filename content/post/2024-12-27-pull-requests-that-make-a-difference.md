---
title: "Infra pull requests that make a DIFFerence"
author: Tibo Beijen
date: 2024-12-27T07:00:00+01:00
url: /2024/12/27/infra-pull-requests-that-make-a-difference
categories:
  - articles
tags:
  - Infrastructure as code
  - DevOps
  - Platform engineering
  - Team topologies
  - Collaboration
description: How to effectively collaborate on infra-as-code and roll out changes with confidence
thumbnail: ""

---


## Introduction

These days, applying Infrastructure as Code (IaC) changes is typically automated by using pipelines or GitOps. 
The Infrastructure Lifecycle shares some characteristics with the Software Development Lifecycle: It starts with defining a goal, which is then followed by authoring of code, checks and tests, and a code review step.

However, there are also some aspects that make the deployment of infrastructure as code quite different from regular software. 
These challenges bring risks, which tend to slow teams down. Those risks also limit the practical use of infrastructure as code to the 'expert' teams, limiting collaboration within an organization.

By improving our review process we can make infrastructure changes as easy as the continuous delivery of software. 

Let's look into what we can improve, and how this fits into platform engineering and [Team Topologies](https://teamtopologies.com/key-concepts).

## Challenges

Now what are these challenges, that set IaC delivery apart from 'just software'?

### Challenge: Code change does not equal infra change

When you change the name of a variable within a function, you have a better named variable. However, when you change the name of an S3 bucket in a Terraform project, your bucket will be _replaced_.

So, there can be a big disconnect between the (small) code change and the actual effect when rolling out the change.

This is aggravated by various mechanisms that are used for good reason: [Terraform modules](https://registry.terraform.io/browse/modules), [CDK constructs](https://constructs.dev/search?q=&cdk=aws-cdk&cdkver=2&offset=0), [Helm charts](https://artifacthub.io/) encapsulate a lot of resources.
So, the small maintenance task of bumping the version of a Terraform module, will likely introduce changes. Now the author of such a module has a responsibility, but _you_ are responsible. 

Another mechanism is the overlaying of values. For example, Kustomize allows one to use [overlays](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/#bases-and-overlays). A great concept, but it can make it hard to predict the effect of a code change on a given environment. To illustrate: Changing a value in a base, might not have any effect on production because it is already defined in the production overlay. This is impossible to predict by looking at the code change alone.

### Challenge: Big bang rollouts




To summarize:

* Small code changes can have big, unexpected, side-effects
* Module upgrades bring hard to predict infra changes
* Effect of value overlays is hard to predict



### Challenge: Unexpected changes
    - Unexpected replace or removal
    - Unnoticed changes that have impact

### Challenge: Rollout
    - No progressive rollout
    - Destructive

### Challenge: access


### Collaboration

Typical collaboration workflow (diagrams)
- Software
  - Authoring
  - Linting/automated tests
  - Pull request
  - Artifact
  - Deploy non-prod
  - Test
  - Deploy prod
- IaC:
  - Authoring
  - Linting
  - PR
  - Apply

Highlight areas of: Safeguards, risk and human focus

### Integrate Pull Request and planned changes

Describe. 
Various systems have a preview step (tf plan, cdk synth, bicep, helm diff, kubectl diff, cloudformation change set)
Illustrate when integrating in PR:
* Move risk from apply time to PR
* Focus only once

### Why

#### PR process already setup for collaboration

Additional benefit: PR process is aimed at collaboration. The systems that show change sets might not.

#### Prevents needing access

To pipeline environment. Or in case of GitOps where there is no pipeline, to cluster.
To affected resources, auth & network.
Simple

#### Unblocks teams

No ticket queue, or aligning sprints. Stream aligned teams have autonomy to submit changes.

Needs review. Depending on subject, this responsibility can be delegated entirely to the submitting team.

#### Makes abstractions accessible

Illustration complexity skip. Focus on input and output.

Similar to functions in programming, or APIs.

#### Easier onboarding

Or infrequent work. 

#### Auditability and context

What happened previous time we rolled out a similar change?
4-eyes principle

### What about IDPs?

And does the P mean platform? Or portal?

Internal development platforms
Self-servicability
Requests, forms

Illustration breadth/depth/area/baseline/threshold

Applicable for all infra

Processes you need to maintain, takes effort. Either limit capabilities (can be conscious choice)

Pair with modules, charts, libraries that include all good practices. Mix knowledge from Open Source with company guidelines, compiance. Golden path.

Improve DX and conformality, without needing to build a lot on top of IaC.

https://tag-app-delivery.cncf.io/whitepapers/platforms/

### What about team topologies


### Challenges

- What to show? E.g. PR affecting many, similar, edge devices
- Noise (metadata changes, like 'last_updated', 'previous_version')
- Apply-time errors

### Conclusion

Reference to Terrible. Platforms like Hashicorp cloud. Cloudformation Github integration.

Remove the scary part from IaC. Allow collaboration, similar to 'normal' software.

Reference to team topologies.

Future post pipeline simple building blocks.




