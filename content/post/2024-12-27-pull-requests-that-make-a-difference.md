---
title: "Infra pull requests that make a DIFFerence"
author: Tibo Beijen
date: 2024-12-27T07:00:00+01:00
url: /2024/12/27/infra-pull-requests-that-make-a-difference
categories:
  - articles
tags:
  - Infra as code
  - DevOps
  - Platform engineering
  - Team topologies
  - Collaboration
description: How to effectively collaborate on infra-as-code and roll out changes with confidence
thumbnail: ""

---


### Introduction
- IaC rollout process
- Risks:

Goal: Mitigate risk & increase efficiency

How can we accomplish this, improve platform and enable teams?

### Challenge: Unexpected changes
    - Unexpected replace or removal
    - Unnoticed changes that have impact

### Challenge: Rollout
    - No progressive rollout
    - Destructive

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


### Challenges

- What to show? E.g. PR affecting many, similar, edge devices
- Noise (metadata changes, like 'last_updated', 'previous_version')
- Apply-time errors

### Conclusion

Reference to Terrible. Platforms like Hashicorp cloud. Cloudformation Github integration.

Remove the scary part from IaC. Allow collaboration, similar to 'normal' software.

Reference to team topologies.

Future post pipeline simple building blocks.




