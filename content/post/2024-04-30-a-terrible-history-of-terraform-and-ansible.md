---
title: A Terrible history of Terraform and Ansible
author: Tibo Beijen
date: 2024-04-30T05:00:00+01:00
url: /2024/04/30/a-terrible-history-of-terraform-and-ansible
categories:
  - articles
tags:
  - Terrible
  - Terraform
  - Ansible
  - DevOps
description: IBM now has Terraform plus Ansible which is Terrible. A great combination, that is why somewhere an in-house 'Terrible' was created already in 2016.
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

This culture of providing services was present in the DevOps way of working as well. All application were hosted on virtual machines. The 'systems' team provided tools like [Puppet](https://www.puppet.com/), [Foreman](https://theforeman.org/) and [CheckMK](https://checkmk.com/). Product teams were in control of configuring their infrastructure, using puppet modules provided by the systems team. A model of 'You Build It, You Run It', backed by the systems team.

In 2016, the current datacenter contracts were about to end, so the organization would either have to renew, or move to other infrastructure. For that reason, a 'big IT solutions provider', let's call them SalesCorp, had been working on a new private cloud for quite some time. In that same period some proof of concepts had been performed based on AWS. Also, tools like Terraform and Ansible had been explored. Ultimately, SalesCorp did not deliver to expectations and timeframe, and the plug was pulled.

As a result, the organization faced the challenge to move everything out of the datacenter into AWS in a short timeframe of just months. Enter Terrible 1...

## Terrible 1

## Terrible 2

