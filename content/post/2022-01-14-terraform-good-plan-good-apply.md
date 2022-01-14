---
title: 'Terraform: Good plan = good apply'
author: Tibo Beijen
date: 2021-12-03T10:00:00+01:00
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

First of all, Terraform for quite some time supports `for_each`, which [is a more robust way to create multiple resources](https://www.terraform.io/language/meta-arguments/count#when-to-use-for_each-instead-of-count). That said, there can be various reasons why resources have been created by iterating over a list. The most obvious one being code that originates from before `for_each` was common and converting would require module users to do complex migrations. The [new `moved` block](https://learn.hashicorp.com/tutorials/terraform/move-config) will certainly help in these scenarios, although it requires users to upgrade to Terraform v1.1 first.

In this particular case we added a secondary cidr to a VPC 'A' that was peered to another VPC 'B'. The VPC peering connection was managed by CloudPosse's [terraform-aws-vpc-peering](https://github.com/cloudposse/terraform-aws-vpc-peering) module.

In the vocabulary of the module, VPC A is the accepter, VPC B is the requester. The peering module before the change managed 5 route tables in VPC B: 1x VPC default, 1x public subnets, and 3x private subnet for each availability zone. In each of those route tables a route is managed by the module that routes traffic to VPC A cidr over the VPC peering connection that is managed by the module.

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

Looking closer, and helped by [looking at the module source](https://github.com/cloudposse/terraform-aws-vpc-peering/blob/master/main.tf#L52), one can distinguish an alternating pattern in the destionation cidr block: Primary, secondary, primary, secondary, repeat.

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

Much better and can be applied with zero impact.

## Using --target to prevent computed values side effects

Another case where a simple change would result in an unexpected amount of `terraform plan` output was the following.






Take-aways:
* Reverse engineering modules can be worth it
* 




It might simply be old code. Also it can be complex to convert a list of resouces obtained via `data` to a map
