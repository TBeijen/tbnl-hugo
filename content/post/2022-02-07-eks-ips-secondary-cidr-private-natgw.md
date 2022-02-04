---
title: 'EKS and the quest for ips: Secondary CIDRs and private NAT gateways'
author: Tibo Beijen
date: 2022-02-07T10:00:00+01:00
url: /2022/02/07/eks-ips-secondary-cidr-private-natgw
categories:
  - articles
tags:
  - DevOps
  - AWS
  - EKS
  - VPC
description: "Secondary CIDRs and private NAT gateways coming to the rescue to feed EKS routable ips in an enterprise multi-VPC set up."
thumbnail: img/terraform-good-plan-good-apply-header.png

---
## EKS and its hunger for IP addresses

Kubernetes allows running highly diverse workloads with similar effort. From a user perspective there's little difference between running 2 pods on a node, each consuming 2 vCPU, and running tens of pods each consuming 0.05 vCPU. Looking at the network however, there is a big difference: Each pod needs to have a unique ip. In most Kubernetes implementations there is a CNI plugin that allocates each pod an ip in an ip space that's _internal_ to the cluster. 

EKS, the managed Kubernetes offering by AWS, [by default](https://docs.aws.amazon.com/eks/latest/userguide/pod-networking.html) uses the [Amazon VPC CNI plugin for Kubernetes](https://github.com/aws/amazon-vpc-cni-k8s). Different to most networking implementations, this assigns each pod an ip address in the VPC, the network the nodes reside in.
