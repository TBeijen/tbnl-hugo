---
title: 'Secure Route 53 healthchecks using HAProxy'
author: Tibo Beijen
date: 2017-03-22T10:00:00+01:00
url: /2017/03/22/haproxy-secure-route53-healthchecks/
categories:
  - articles
tags:
  - AWS
  - Route53
  - HAProxy
description: 

---
## Introduction
When designing a highly available service on EC2, AWS Elastic Loadbalancers are quite often a key component. A common setup is to have an internet facing ELB forward requests to EC2 instances that are not directly accessible from the internet. Recently though, we encountered a scenario where we couldn't use ELBs as they can't have a fixed ip (Elastic IP in AWS terms).

## The elastic IP requirement
Originally the service, a dashboard of sorts, was restricted to the office network and a limited number of supplier office networks, so whitelisted to a set of ips. 
