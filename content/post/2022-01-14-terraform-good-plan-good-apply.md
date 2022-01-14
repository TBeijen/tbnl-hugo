---
title: 'Terraform: Good plan = good apply'
author: Tibo Beijen
date: 2022-01-14T13:00:00+01:00
url: /2022/01/14/terraform-smooth-apply-careful-plan
categories:
  - articles
tags:
  - DevOps
  - Terraform
  - IaC
  - AWS
  - EKS
  - VPC
  - Tricks
description: "Examples on how to reduce impact of applying Terraform by careful planning, using target and modifying of state."
thumbnail: img/terraform-good-plan-good-apply-header.png

---
Recently I worked on some infrastructure changes that resulted in `terraform plan` showing more, and more impactful, changes than expected. Diving deeper, it appeared that a lot of the planned changes could be avoided by some preparations, resulting in a `terraform apply` with no impact at all.

{{< figure src="/img/terraform-good-plan-good-apply-header.png" title="I love it when a terraform plan comes together. Source: PeteFarrow, via redbubble.com" >}}

## Ordered lists and state manipulation

First of all, Terraform for quite some time supports `for_each`, which [is a more robust way to create multiple resources](https://www.terraform.io/language/meta-arguments/count#when-to-use-for_each-instead-of-count). That said, there can be various reasons why resources have been created by iterating over a list. The most obvious one being code that originates from before `for_each` was common, where converting to `count` to `for_each` would require module users to do complex migrations. (The [new 'moved' block](https://learn.hashicorp.com/tutorials/terraform/move-config) will certainly help in these scenarios, although it requires users to upgrade to Terraform v1.1 first.)

In this particular case we added a secondary cidr to a VPC 'A' that was peered to another VPC 'B'. The VPC peering connection was managed by CloudPosse's [terraform-aws-vpc-peering](https://github.com/cloudposse/terraform-aws-vpc-peering) module.

In the vocabulary of the module, VPC A is the accepter, VPC B is the requester. Before the cidr addition the peering module managed 5 route tables in VPC B: 1x VPC default, 1x public subnets, and 3x private subnet for each availability zone. In each of those route tables a route is managed by the module that routes traffic to VPC A cidr over the VPC peering connection that is managed by the module.

Now with the introduction of a second cidr in VPC A, the module adds an additional route to each of the 5 route tables, resulting in a desired state like this:

{{< figure src="/img/terraform-good-plan-good-apply-routes.png" title="Route table example showing routes to VPC peering" >}}

It [does so](https://github.com/cloudposse/terraform-aws-vpc-peering/blob/master/main.tf#L52) by looping over a combination of the accepter VPC `cidr_block_associations` attributes and requester VPC route tables. This results in a `terraform plan` like this:

```
# module.vpc_peering.aws_route.requestor[1] must be replaced
-/+ resource "aws_route" "requestor" {
      ~ destination_cidr_block     = "10.123.32.0/21" -> "100.64.0.0/16" # forces replacement
      # truncated for readability
      ~ route_table_id             = "rtb-some-id" -> "rtb-other-id" # forces replacement
      ~ state                      = "active" -> (known after apply)
        vpc_peering_connection_id  = "pcx-peering-to-vpc-a"
    }

  # module.vpc_peering.aws_route.requestor[2] must be replaced
-/+ resource "aws_route" "requestor" {
        destination_cidr_block     = "10.123.32.0/21"
      # truncated for readability
    }

  # module.vpc_peering.aws_route.requestor[3] must be replaced
-/+ resource "aws_route" "requestor" {
      ~ destination_cidr_block     = "10.123.32.0/21" -> "100.64.0.0/16" # forces replacement
      # truncated for readability
    }

  # module.vpc_peering.aws_route.requestor[4] must be replaced
-/+ resource "aws_route" "requestor" {
        destination_cidr_block     = "10.123.32.0/21"
      # truncated for readability
    }

  # module.vpc_peering.aws_route.requestor[5] will be created
  + resource "aws_route" "requestor" {
      + destination_cidr_block     = "100.64.0.0/16"
      # truncated for readability
    }

  # module.vpc_peering.aws_route.requestor[6] will be created
  + resource "aws_route" "requestor" {
      + destination_cidr_block     = "10.123.32.0/21"
      # truncated for readability
    }

  # module.vpc_peering.aws_route.requestor[7] will be created
  + resource "aws_route" "requestor" {
      + destination_cidr_block     = "100.64.0.0/16"
      # truncated for readability
    }

  # module.vpc_peering.aws_route.requestor[8] will be created
  + resource "aws_route" "requestor" {
      + destination_cidr_block     = "10.123.32.0/21"
      # truncated for readability
    }

  # module.vpc_peering.aws_route.requestor[9] will be created
  + resource "aws_route" "requestor" {
      + destination_cidr_block     = "100.64.0.0/16"
      # truncated for readability
    }
```

I tried applying a change like this to a non-critical development environment and it applies quite fast. However, for production, 'quite fast' is not good enough. Futhermore, if for some odd reason it partially fails, you and your visitors are having a very bad day.

Looking closer, and helped by [looking at the module source](https://github.com/cloudposse/terraform-aws-vpc-peering/blob/master/main.tf#L52), one can distinguish an alternating pattern in the destination cidr block: Primary, secondary, primary, secondary, repeat.

This is validated by comparing some of the planned _additions_ to what's currently at different locations in state, for example:

```
# Same destination cidr and route table as planned addition [6]
terraform state show module.vpc_peering.aws_route.requestor[3]
```

Long story short, moving the existing resources in terraform state to where the module expects them to be in this new situation, results in a much more straightforward plan.

```
terraform state module.vpc_peering.aws_route.requestor[4] module.vpc_peering.aws_route.requestor[8]
terraform state module.vpc_peering.aws_route.requestor[3] module.vpc_peering.aws_route.requestor[6]
terraform state module.vpc_peering.aws_route.requestor[1] module.vpc_peering.aws_route.requestor[2]
terraform state module.vpc_peering.aws_route.requestor[2] module.vpc_peering.aws_route.requestor[4]
```

The resulting plan:

```
  # module.vpc_peering.aws_route.requestor[1] will be created
  + resource "aws_route" "requestor" {
      + destination_cidr_block     = "100.64.0.0/16"
      # truncated for readability
    }

  # module.vpc_peering.aws_route.requestor[3] will be created
  + resource "aws_route" "requestor" {
      + destination_cidr_block     = "100.64.0.0/16"
      # truncated for readability
    }

  # module.vpc_peering.aws_route.requestor[5] will be created
  + resource "aws_route" "requestor" {
      + destination_cidr_block     = "100.64.0.0/16"
      # truncated for readability
    }

  # module.vpc_peering.aws_route.requestor[7] will be created
  + resource "aws_route" "requestor" {
      + destination_cidr_block     = "100.64.0.0/16"
      # truncated for readability
    }

  # module.vpc_peering.aws_route.requestor[9] will be created
  + resource "aws_route" "requestor" {
      + destination_cidr_block     = "100.64.0.0/16"
      # truncated for readability
    }
```

Much better and can be applied with zero impact. Another case where a simple change would result in an unexpected amount of `terraform plan` output was the following:

## Using --target to prevent computed values side effects


We manage some EKS clusters, having managed node groups, using the [terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks) module.

Changing a property of a cluster, the `public_access_cidrs` resulted in quote some planned changes:

* The cidr addition, as expected.
* Apparently the mere fact that the EKS cluster itself is changed, causes a computed value change that introduces a new launch template version.
* The new launch template version causes a managed node group update, causing EKS to replace all nodes. Not a problem per se, since workloads should be able to handle this, but it takes a considerable amount of time.


```
# All resources truncated for readability

  # module.eks_cluster_a.module.eks_cluster.aws_eks_cluster.this[0] will be updated in-place
  ~ resource "aws_eks_cluster" "this" {
      ~ vpc_config {
          ~ public_access_cidrs       = [
              # Yes, we fully trust Cloudflare DNS to not hack into our cluster
              + "1.1.1.1/32",
            ]
        }
    }

  # module.eks_cluster_a.module.eks_cluster.module.node_groups.aws_eks_node_group.workers["ng_a"] will be updated in-place
  ~ resource "aws_eks_node_group" "workers" {
      ~ launch_template {
            id      = "lt-someid"
            name    = "cluster_a-ng_a20211222060030102500000001"
          ~ version = "5" -> (known after apply)
        }
    }

  # module.eks_cluster_a.module.eks_cluster.module.node_groups.aws_launch_template.workers["ng_a"] will be updated in-place
  ~ resource "aws_launch_template" "workers" {
      ~ default_version         = 5 -> (known after apply)
      ~ latest_version          = 5 -> (known after apply)
      ~ user_data               = "base64-gibberish" -> (known after apply)
    }

```

This seemed a bit over-the-top for a cidr addition. And indeed it can be avoided. 

Targeting only the cluster obviously shows only a change to the cluster (and the removal of several outputs):

```
terraform plan --target=module.eks_cluster_a.module.eks_cluster.aws_eks_cluster.this[0]
```

Applying this, and then running `terraform plan` on the entire project results in:

```
# Truncated for readability: Some read data sources that change

Plan: 0 to add, 0 to change, 0 to destroy.
```

Once again, much better!

## Concluding

When confronted with impactful planned changes, there might be more options than hope for the best, schedule at night or sit it out.

It's safe to do a `terraform plan` so when suspecting a chain of dependencies, experimenting with `--target` can help.

Modifying state is more tricky. What works for me is:

* Prepare _all_ of the state mv changes in a txt file first before applying them.
* Make sure to have the current state backed up (e.g. Copy `terraform state show` output to a file).
* Know how to revert the moves if needed.
* Test the pattern on a non-prod environment first.

Hopefully the above helps anyone to use Terraform with confidence without breaking (important) things. If you have feedback or comments, be sure to [reach out on Twitter](https://twitter.com/TBeijen)!
