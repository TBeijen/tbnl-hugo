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
  - Networking
description: "How secondary CIDR blocks and private NAT gateways provide an alternative to custom networking, when needing to feed EKS routable ips in an enterprise multi-VPC set up."
thumbnail: img/terraform-good-plan-good-apply-header.png

---
## EKS and its hunger for IP addresses

Kubernetes allows running highly diverse workloads with similar effort. From a user perspective there's little difference between running 2 pods on a node, each consuming 2 vCPU, and running tens of pods each consuming 0.05 vCPU. Looking at the network however, there is a big difference: Each pod needs to have a unique IP addres. In most Kubernetes implementations there is a CNI plugin that allocates each pod an IP address in an IP space that's _internal_ to the cluster. 

EKS, the managed Kubernetes offering by AWS, [by default](https://docs.aws.amazon.com/eks/latest/userguide/pod-networking.html) uses the [Amazon VPC CNI plugin for Kubernetes](https://github.com/aws/amazon-vpc-cni-k8s). Different to most networking implementations, this assigns each pod a dedicated IP address in the VPC, the network the nodes reside in.

What the VPC CNI plugin does [^footnote_vpc_cni_workings], boils down to this:
* It keeps a number of network interfaces (ENIs) and IP addresses 'warm' on each node, to be able to quickly assign IP addresses to new pods.
* By default it keeps an entire spare ENI warm.
* This means that any node effectively claims 2 ENIs * ip-per-ENI, since there will always be at least one daemonset, claiming an IP address of the first ENI.

Now if we look at the [list of available IP address per ENI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI) and calculate an example:
* EC2 type `m5.xlarge`, 15 IP addresses per ENI. 30 IP addresses at minimum per node.
* Say, we have 50 nodes running. That's 1500 private addresses taken. (For perspective: That's ~$7000/month on-demand).
* Say, we have `/21` VPC, providing 3 `/23` private subnets. That's `3 x 512 = 1536` available IP addresses.
* Managed services also need IP addresses...

We can see where this is going. So, creating `/16` VPCs it is then? Probably not.

## Multiple VPCs

In a lot of organizations there is not just one VPC. The networking landscape might be a combination of:

* Multiple AWS accounts and VPCs in one or more regions
* Datacenters
* Office networks
* Peered services, like DBaaS from providers other than AWS

There are [many ways](https://docs.aws.amazon.com/whitepapers/latest/aws-vpc-connectivity-options/welcome.html) to connect VPCs and other networks. The larger the CIDR block is that needs to be routable from outside the VPC, the more likely it becomes that there is overlap.

As a result, in larger organizations, individual AWS accounts are typically provided a VPC with a relatively small CIDR block, that fits in the larger networking plan. To still have 'lots of ips', AWS VPCs [can be configured with](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html#VPC_Sizing) with secondary CIDR blocks.

This solves the IP space problem, however does not by itself solve the routing problem. The secondary CIDR block would still need to be unqiue in the total networking landscape to be routable from outside the VPC. This could not be a problem if workloads in the secondary CIDR _only_ need to connect to resources within the VPC. But this very often is not the case.

Quite recently AWS introduced [Private NAT gateways](https://aws.amazon.com/blogs/networking-and-content-delivery/how-to-solve-private-ip-exhaustion-with-private-nat-solution/) which, together with custom networking, are options to facilitate routable EKS pods in secondary CIDR ranges.

## VPC setups

Let's go over some VPC setups to illustrate the problem and see how we can run EKS.

### Basic

A basic VPC consists of a single CIDR block, some private and public subnets, a NAT gateway and an Internet Gateway. Depending on the primary CIDR block size this might be sufficient, but in the scope of larger organizations let's assume a relatively small CIDR block.

{{< figure height="250" src="/img/eks_private_ips_basic.drawio.png" title="Basic VPC" >}}

* Pro: Simple
* Con: Private IP exhaustion 

### Secondary cidr

Next step. Adding secondary CIDR block. Placing nodes and pods in the secondary subnets. This _could_ work if workloads never need to connect to resources in private networks outside the VPC, which is unlikely. Theoretically pods would be able to send packets to other VPCs but there is no route back.

{{< figure height="250" src="/img/eks_private_ips_secondary.drawio.png" title="Secondary CIDR block" >}}

* Pro: Simple
* Con: No route between pods and private resources outside the VPC

### Secondary cidr + custom networking

To remedy the routing problem, custom networking can be enabled in the VPC CNI plugin. This allows placing the nodes and pods in different subnets. Nodes go into the primary private subnets, pods go into the secondary private subnet. This solves the routing problem since by default, for traffic to external networks, the CNI plugin translates the pods IP address to the primary IP address of the node (SNAT). In this setup those nodes are in routable subnets.

{{< figure height="250" src="/img/eks_private_ips_secondary_custom_nw.drawio.png" title="Secondary CIDR block + Custom networking" >}}

Setting up secondary CIDR blocks and custom networking is described in the [AWS knowledge center](https://aws.amazon.com/premiumsupport/knowledge-center/eks-multiple-cidr-ranges/) and also in the [Amazon EKS Workshop](https://www.eksworkshop.com/beginner/160_advanced-networking/secondary_cidr/)

Be aware that Source Network Address Translation [is disabled when using security groups for pods](https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html)[^footnote_sg_pods]: 

> Source NAT is disabled for outbound traffic from pods with assigned security groups so that outbound security group rules are applied. To access the internet, pods with assigned security groups must be launched on nodes that are deployed in a private subnet configured with a NAT gateway or instance. Pods with assigned security groups deployed to public subnets are not able to access the internet.

* Pro: No additional NAT gateway needed
* Con: Complex VPC CNI network configuration
* Con: Not compatible with security groups for pods

### Secondary cidr + private NAT gateway

{{< figure height="250" src="/img/eks_private_ips_secondary_private_natgw.drawio.png" title="Secondary CIDR block + Custom networking" >}}

https://aws.amazon.com/blogs/networking-and-content-delivery/how-to-solve-private-ip-exhaustion-with-private-nat-solution/

* Pro: Straightforward default VPC CNI network configuration
* Pro: Can be used with security group for pods
* Con: NAT gateway incurs cost

## Controlling cost

```
[ec2-user@ip-100-64-43-196 ~]$ ping www.google.com
PING www.google.com (74.125.193.147) 56(84) bytes of data.
64 bytes from ig-in-f147.1e100.net (74.125.193.147): icmp_seq=1 ttl=49 time=2.31 ms
^C

[ec2-user@ip-100-64-43-196 ~]$ tracepath -p 443 74.125.193.147
 1?: [LOCALHOST]                                         pmtu 9001
 1:  ip-10-150-42-36.eu-west-1.compute.internal            0.168ms
 1:  ip-10-150-42-36.eu-west-1.compute.internal            1.016ms
 2:  ip-10-150-40-116.eu-west-1.compute.internal           0.739ms
 3:  ip-10-150-40-1.eu-west-1.compute.internal             1.510ms pmtu 1500
 3:  no reply
^C
```

## Trade-offs

* Amount of network traffic going over Transit Gateway and by that the private NAT gateway
* Ability to use security groups for pods
* Complexity of set-up

[^footnote_vpc_cni_workings]: This is described in great detail in this blog post: <https://betterprogramming.pub/amazon-eks-is-eating-my-ips-e18ea057e045>

[^footnote_sg_pods]: Disclaimer: We haven't yet enabled security groups for pods so this is theoretical. However, following the described logic of 'No NAT = no route to the internet', we can assume similar restrictions to apply to external private networks.
