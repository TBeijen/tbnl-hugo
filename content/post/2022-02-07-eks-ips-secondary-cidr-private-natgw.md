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
description: "How secondary CIDRs and private NAT gateways provide an alternative to custom networking, when needing to feed EKS routable ips in an enterprise multi-VPC set up."
thumbnail: img/terraform-good-plan-good-apply-header.png

---
## EKS and its hunger for IP addresses

Kubernetes allows running highly diverse workloads with similar effort. From a user perspective there's little difference between running 2 pods on a node, each consuming 2 vCPU, and running tens of pods each consuming 0.05 vCPU. Looking at the network however, there is a big difference: Each pod needs to have a unique ip. In most Kubernetes implementations there is a CNI plugin that allocates each pod an ip in an ip space that's _internal_ to the cluster. 

EKS, the managed Kubernetes offering by AWS, [by default](https://docs.aws.amazon.com/eks/latest/userguide/pod-networking.html) uses the [Amazon VPC CNI plugin for Kubernetes](https://github.com/aws/amazon-vpc-cni-k8s). Different to most networking implementations, this assigns each pod a dedicated ip address in the VPC, the network the nodes reside in.



## Multiple VPCs

VPC Peerings or Transit Gateway

## VPC setups

### Basic

Pro: Simple
Con: Private IP exhaustion

### Secondary cidr

Pro: Relatively simple
Con: Without custom networking only useful for isolated VPCs

### Secondary cidr + custom networking

Custom networking. SNAT.

> Source NAT is disabled for outbound traffic from pods with assigned security groups so that outbound security group rules are applied. To access the internet, pods with assigned security groups must be launched on nodes that are deployed in a private subnet configured with a NAT gateway or instance. Pods with assigned security groups deployed to public subnets are not able to access the internet.

https://aws.amazon.com/premiumsupport/knowledge-center/eks-multiple-cidr-ranges/


https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html

https://aws.amazon.com/blogs/containers/introducing-security-groups-for-pods/

Pro: No additional NAT gateway needed
Con: Complex VPC CNI network configuration
Con: Not compatible with security groups for pods

### Secondary cidr + private NAT gateway

Pro: Straightforward default VPC CNI network configuration
Pro: Can be used with security group for pods
Con: NAT gateway incurs cost

## Controlling cost



## Trade-offs

* Amount of network traffic going over Transit Gateway
* Ability to use security groups for pods
* Complexity of set-up

