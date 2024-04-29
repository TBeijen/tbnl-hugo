---
title: Terraform and Ansible were already Terrible in 2016
author: Tibo Beijen
date: 2024-04-30T05:00:00+01:00
url: /2024/04/30/terrible-and-ansible-were-already-terrible-in-2016
categories:
  - articles
tags:
  - Terrible
  - Terraform
  - Ansible
  - DevOps
description: IBM now has Terraform plus Ansible which is Terrible. A great combination, that is why somewhere an in-house 'Terrible' was created many years ago.
thumbnail: img/12factor_13years_header.jpg

---

## Introduction

After IBM [acquired Red Hat](https://www.redhat.com/en/about/press-releases/ibm-closes-landmark-acquisition-red-hat-34-billion-defines-open-hybrid-cloud-future) in 2019, it recently has [acquired HashiCorp](https://www.hashicorp.com/blog/hashicorp-joins-ibm). So now Big Blue not only has [Ansible](https://www.ansible.com/) in its portfolio, but also [Terraform](https://www.terraform.io/).

Tech articles and social media galore, and many people have found out that if you mix 'Terraform' and 'Ansible', you end up with 'Terrible'. Depending on your tech stack, it _is_ a great combination: Terraform to provision cloud infrastructure, including servers. Ansible to configure those servers.

That was exactly the combination of capabilities needed by Sanoma Media Netherlands, in 2016. An in-house tool was created and, as a play of words, it was named... Terrible.

Terrible plan?

> This is the first article of a series 'Stuff From The Past (SFTP)', for which I have got a number topics lined up. Things I have created or should not have created. Things I have worked with or wish I would not have. How did those systems age? What can be learned?

Author's note 1: This topic was at some random place in my blog topic list. But since a lot of people are suddenly making terrible jokes, there is no better moment than now.

Author's note 2: I did not _build_ Terrible, but was one of its power users and worked quite closely with the team maintaining it for many years. Shout out to the forward thinkers that understood the need for this tool and made it happen.

Author's note 3: Everything described leading up to the creation of Terrible is based on my perspective, and my recollection and knowledge of matters. All of those might be inaccurate or incomplete.

## Context

In 2016, Sanoma Media Netherlands had a portfolio consisting of many print magazines, and a number of digital assets that were among the largest in the Netherlands. This included [Autoweek](https://www.autoweek.nl/), [Kieskeurig](https://www.kieskeurig.nl/) and the product I worked for: [NU.nl](https://www.nu.nl/), the largest news site in the Netherlands.

From an architectural point of view, (micro-)services were the norm. Services included a tagging service, an identity platform for customers, and platforms for images and videos. When the GDPR legislation was implemented, an organization-wide event bus was created to implement the '[Right of access](https://gdpr-info.eu/issues/right-of-access/)' and the '[Right to be Forgotten](https://gdpr-info.eu/issues/right-to-be-forgotten/)'.

Product teams were autonomous and would use said services to do a lot of heavy lifiting. Looking back, I would say there was a keen understanding of what services were needed to propel the organization forward: The amount of re-invented square wheels was fairly limited.

This culture of providing services was present in the DevOps way of working as well. All application were hosted on virtual machines in datacenters. The 'systems' team provided tools like [Puppet](https://www.puppet.com/), [Foreman](https://theforeman.org/) and [CheckMK](https://checkmk.com/). Product teams were in control of configuring their infrastructure, using puppet modules provided by the systems team. A model of 'You Build It, You Run It', backed by the systems team.

In 2016, the current datacenter contracts were about to end, so the organization would either have to renew, or move to other infrastructure. For that reason, a 'big IT solutions provider', let's call them SalesCorp, had been working on a new private cloud for quite some time. In that same period, some proof of concepts were done using AWS. Also, tools like Terraform and Ansible had been explored. Ultimately, SalesCorp did not deliver to expectations and timeframe, and the plug was pulled.

As a result, the organization faced the challenge to move everything out of the datacenters into AWS in a short timeframe of just months. Enter Terrible 1...

## Terrible 1

Terrible 1 consisted of a set of services and a command-line client to interact with those services. Since the move to AWS needed to happen in a relatively short timespan, the goal was rehosting, not re-architecting. Coming from datacenter VMs, the AWS building blocks needed were very limited: EC2 instances. classic load balancers (ELB) and security groups.

For that reason, a very simple YAML schema was created that Terrible 1 would translate into actual Terraform HCL code. An example[^footnote_hipchat_public]:

```
product: nunl
cluster: news
environment: production
version: "v1"
hipchat: "NU.nl => AWS"

instances:
    - role: lbapi
      count: 3
      disk_size: 20
      type: c4.large
      public: true
      firewall:
        - ingress:
          port: 80
          proto: tcp
          cidr:
            - 0.0.0.0/0
        - ingress:
          port: 443
          proto: tcp
          cidr:
            - 0.0.0.0/0
```

Terrible 1 took care of:

* Authentication
* Remote state
* AWS account permissions
* Consistent tagging
* Executing Terraform `init`, `plan` and `apply` stages, and streaming output to users via cli client.
* Executing Ansible on the resulting infrastructure, and streaming output to users via cli clients.

The organization was organized in clusters, in our case: news. Clusters could run many products and each product would have several environments: production, staging, test.

A cluster admin could add products and environments, providing the repository containing the sources. Once set up, the typical workflow would look like:

```
terrible plan news/nunl/test <git-rev>

# Result: CLI streaming output showing plan being executed, followed by the resulting plan ID

# If deemed neccessary, or if configured to be required, ping a colleague to review the plan via hipchat
# Colleague would execute, review changes and confirm:

terrible acknowledge news/nunl/test <plan-ID>

# Change author would apply:

terrible apply news/nunl/test <plan-ID>

# Result: CLI streaming output showing apply being executed
```

For a number of common server components, Ansible modules were created, for example Nginx, Python, Uwsgi and Varnish. Also, a 'common' module was provided, ensuring the systems team would be able to access servers, and CheckMK was installed.

The resulting configuration was more or less identical to the configuration previously set up by puppet, so the rehosting in general was a smooth process. A Direct Connect link existed between the AWS VPC and datacenter, so we could easily move applications one at a time.

Worth mentioning is that, although the Ansible modules were initially set up by the 'systems' team, they saw a lot of contributions by various teams in order to enable various use cases. 

## Terrible 2

## Looking back

### Good: Plan stage front and center

One of the strong points of Terraform is the confidence gained from the plan stage: The changes that will be executed 

### Good: Iterate, removing bottlenecks

### Good: Enable teams

### Good: Create fast, sunset fast

### Meh, LDAP auth

### Meh, Generic permissive

[^footnote_hipchat_public]: Back then HipChat was a thing, and you could still run high-traffic news sites using DNS load balanced public VMs without immediately regretting it.
