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
  - Terraform
description: How to effectively collaborate on infra-as-code and roll out changes with confidence
thumbnail: ""

---


## Introduction

These days, applying Infrastructure as Code (IaC) changes is typically automated by using pipelines or GitOps. 
This Infrastructure Lifecycle shares some characteristics with the Software Development Lifecycle: It starts with defining a goal, which is then followed by authoring of code, checks and tests, and a code review step.

However, there are also some aspects that make the _deployment_ of infrastructure as code quite different from regular software. 
These challenges bring risks, which tend to slow teams down. Those risks also limit the practical use of infrastructure as code to the 'expert' teams, limiting collaboration within an organization.

By improving our review process we can make infrastructure changes as easy as the continuous delivery of software. 

Let's look into what we can improve, and how this fits into platform engineering and [Team Topologies](https://teamtopologies.com/key-concepts).

## Challenges

Now what are these challenges, that set IaC delivery apart from 'just software'?

### Challenge: Code change does not equal infra change

When you change the name of a variable within a function, you have a better named variable. However, when you change the name of an S3 bucket in a Terraform project, your bucket will be _replaced_.

So, there can be a big disconnect between the (small) code change and the actual effect when rolling out the change.

This is aggravated by various mechanisms that are used for good reason: [Terraform modules](https://registry.terraform.io/browse/modules), [CDK constructs](https://constructs.dev/search?q=&cdk=aws-cdk&cdkver=2&offset=0), [Helm charts](https://artifacthub.io/) form reusable packages, encapsulating a lot of resources.
So, the small maintenance task of bumping the version of a Terraform module, will likely introduce several changes. Now the author of such a module has a responsibility to avoid to unneededly break things, but ultimately _you_ are responsible when using the package.

It is worth noting that unexpected changes can also occur when no code has changed. One source, which should be avoided, is click-ops, or automated systems competing for ownership. But an example of a more subtle source I have seen in the past, is Elasticache [automatic minor version upgrades](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster#auto_minor_version_upgrade-1) (the default). If other parameters haven't been set accordingly, you are suddenly faced with a _replacement_ of your Elasticache setup. Not what you want.

Another mechanism that complicates predictability, is the overlaying of values. For example, Kustomize allows one to use [overlays](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/#bases-and-overlays). A great concept, but it can make it hard to predict the effect of a code change on a given environment. To illustrate: Changing a value in a base, might not have any effect on production because it is already defined in the production overlay. This is impossible to predict by looking at the code change alone.

To summarize:

* Small code changes can have big, unexpected, side effects, such as removal of resources
* Module upgrades bring hard to predict infra changes
* Effect of value overlays is hard to predict

### Challenge: Big bang rollouts

In traditional software, we have various methods to safeguard us from production errors. We can run various tests in the CI pipeline, then let the CD pipeline move _the same_ artifact through various environments, up to production[^footnote_cicd]. The production deploy itself then, can use methods such as canary deploys and gradual rollouts.

Infrastructure changes are different: There is no single artifact that can be moved from environment to environment. Instead, each environment has its own artifact, in the form of the planned changes. There is also no concept of gradual rollout. Furthermore, rollouts are sometimes irreversible or destructive. For example, downgrading a database version is typically not possible.

Of course, changes can be rolled out to non-prod environments first. And this works to some extent. But a change only affecting prod, for example an instance type change, is hard to test. Furthermore, if one doesn't know exactly _what_ has been changed when upgrading a module, then how can one properly test the effect?

### Challenge: Access

Another challenge is access. Assuming we acknowledged the previous challenges, we probably want to preview our changes before submitting a pull request. This often requires a level of access we should not have. This access might be at the network level, authorization level, or both. For example, being able to `kubectl diff` might [not be as simple](https://github.com/kubernetes/kubectl/issues/981) as one expects, requiring broad permissions. And, while read-only access in a lot of cases seems ok, for secrets it is not.

## Improving the workflow

First, let's look at a basic workflow for infrastructure as code, and how a pipeline could automate parts of this:

{{< figure src="/img/iac_workflows.basic.svg" title="Example of a basic infrastructure as code workflow" >}}

* *Final check:* This would typically be a step in a pipeline, right before applying that shows the changes that will be applied. Then in the automation platform, the proposed changes can be confirmed. If something looks not right, this would be the moment were the process is aborted, and a new pull request needs to be created.
* *Focus*: These are the moments where a second person needs to shift focus to this workflow. The reviewer needs to grasp the intentions of the author, both at the moment of reviewing and when applying the changes. The author might need to chime in when changes are about to be applied, to verify any questions. This task switching [is expensive](https://www.psychologytoday.com/us/blog/brain-wise/201209/the-true-cost-of-multi-tasking) and increases the chance of errors.
* *Repeat loops:* Repeats can obviously originate from the pull request, but also from the final check. Every repeat loop requires a new pull request. And that will bring more task switching.
* *Risk:* Just before applying, might be the first time the proposed changes are visible. This requires alignment between the author and the person applying, requiring focus from both. As mentioned before, task switching increases the chance of errors. So, a 'quick final check' might not get the attention it needs and people might overlook important details.

Now let's see how we can improve this workflow by some relatively small modifications:

{{< figure src="/img/iac_workflows.improved.svg" title="Example of an improved infrastructure as code workflow" >}}

* *Remove risk:* By making the proposed changes available at review time, and ensuring that exactly those changes will be applied, there will be no unexpected changes.
* *Reduced task switching:* All collaboration is now reduced to a single occurrence: The pull request. The code changes, but also the resulting planned infrastructure changes, are presented in the pull request. This requires the reviewer to change tasks only once, and provides full context.
* *First time right:* The author, without needing any access or permissions on the target environment, can see the effect of the code changes. This allows the author to fix any issues _before_ submitting the pull request. This greatly reduces the chance of additional code changes, and by that a new pull request, being needed.
* *Additional checks*: By making the planned changes part of the review, we can run additional checks on the planned changes. For example: Prevent (accidental) deletion of certain resource types, or run policy checks.

The example below shows `terraform plan` output in a pull request. Here, apparently, we are about to remove an event listener from a Keycloak realm, which was temporarily added using click-ops to test something[^footnote_clickops]. Without plan output this would either go unnoticed (lack of control) or require further examination at apply-time (increased cognitive load).

{{< figure src="/img/iac_workflows.tf_example.png" title="Example of Terraform plan output in a GitHub PR" >}}

## How does this fit into platform engineering?

On the topic of 'platform engineering', one is bound to run into the term 'Internal Development Plaform' (IDP). Quoting [one of the definitions](https://internaldeveloperplatform.org/what-is-an-internal-developer-platform/) that can be found:

> An Internal Developer Platform (IDP) is built and provided as a product by the platform team to application developers and the rest of the engineering organization. An IDP glues together the tech and tools of an enterprise into golden paths that lower cognitive load and enable developer self-service. 

Gluing together, lower cognitive load, enable self service... Improving the workflow as described above ticks those boxes. At least to a certain extent.

Depending on who you ask, IDP can also mean 'Internal Development _Portal_'. The [following defininition](https://internaldeveloperplatform.org/developer-portals/) is quite concise in explaining the relationshi[^footnote_idp]:

> **Internal developer portals** serve as the interface through which developers can discover and access **internal developer platform** capabilities.




----

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

Reference to Terrible. Platforms like Hashicorp cloud. Atlantis. Cloudformation Github integration.

Remove the scary part from IaC. Allow collaboration, similar to 'normal' software.

Reference to team topologies.

Future post pipeline simple building blocks.



[^footnote_cicd]: This assumes separated CI and CD pipelines. A good practice, but in reality these are often intertwined in a single pipeline. Nevertheless, there are steps that _build_ (CI) and steps that _deploy_ (CD).

[^footnote_clickops]: Shame. Shame. Also: Pragmatic. But one needs to be aware the click-ops change can be reverted at any moment _and_ can thwart others workflow by showing unexpected changes.

[^footnote_idp]: [This blogpost](https://humanitec.com/blog/wtf-internal-developer-platform-vs-internal-developer-portal-vs-paas#what-is-an-internal-developer-portal
) by Humanitec, themselves an IDP vendor, gives some context on the platform/portal confusion of IDPs.