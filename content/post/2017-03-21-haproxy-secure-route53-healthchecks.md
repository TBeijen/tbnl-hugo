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
  - ELB
  - Elastic IP
  - HAProxy
  - VPN
description: 

---
## Case outline
When designing a highly available service on EC2, AWS Elastic Loadbalancers are quite often a key component. A common setup is to have an internet facing ELB forward requests to EC2 instances that are in a private subnet, not directly accessible from the internet. Recently though, we encountered a scenario where we couldn't use ELBs as they can't have a fixed ip (Elastic IP in AWS terms).

### The elastic IP requirement
Originally the service, a dashboard of sorts, was restricted to the office network and a limited number of supplier office networks, so whitelisted to a set of ips. In these times of remote working not a maintainable strategy so we needed to grant access to traffic originating from the office VPN, allowing access also to remote workers. 

In our office's VPN configuration, internet traffic is by default not routed over the VPN connection. So the office automation department needed to know what the ip's were, in order to configure VPN clients to route traffic to the service over the VPN as well. This way we could setup firewall rules to grant access to the VPN exit nodes, but it also meant we needed to look for alternatives to our ELBs.

### The HA in Haproxy
As we already had (good) experience with Haproxy, the most apparent approach was to replace the ELB by Haproxy running on an EC2 instance in one of our VPC's public subnets. However, ELBs are by design 'highly available', yet a single EC2 instance is not. So we needed at least 2 of them, in different availability zones. 

TODO: Schematic of loadbalancers in public subnets of multiple AZs

### Route 53 healthchecks
To prevent half of the traffic going to the /dev/null of the internet, this required having Route 53 health checks in place that will stop traffic going to a loadbalancer in case of failure or reboots due to maintenance. Straightforward if it weren't for the firewall rules that will only allow traffic originating from our VPN...

## Possible solutions
After some research, possible solutions boiled down to:

* Whitelist known Route 53 health check ip's.
* Find a way to only publicly expose a monitor endpoint that reflects the service health.


