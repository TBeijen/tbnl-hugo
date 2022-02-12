---
title: 'EKS node types'
author: Tibo Beijen
date: 2022-02-09T10:00:00+01:00
url: /2022/02/16/eks-node-types
categories:
  - articles
tags:
  - DevOps
  - AWS
  - EKS
  - Kubernetes
description: ""
thumbnail: ""

---
draft


Launch template overlay


Update process:

Terraform flow

* Load latest AMI and pass to lt or pin specific AMI
* Terraform plan/apply
* Updates ng launch template, and by that ng lt version in place
* EKS performs managed cycle of nodes

Userdata can be fully specified

EKS Action

* Don't specify AMI
* EKS offers upload ption in console. Select or use API to trigger (assumed that exists)
* Launch template not modified since it doesn't contain ami. EKS lt updated with EKS managed API.
* EKS performs managed cycle of nodes

Userdata modifying via 'hack'. See managed nodes tf readme. Plus https://github.com/awslabs/amazon-eks-ami/issues/844)

Start part of bootstrap.sh

```sh
#!/usr/bin/env bash

set -o pipefail
set -o nounset
set -o errexit

err_report() {
    echo "Exited with error on line $1"
}
```

Example to modify

```sh
    pre_bootstrap_user_data = <<-EOT
    #!/bin/bash
    set -ex
    cat <<-EOF > /etc/profile.d/bootstrap.sh
    export CONTAINER_RUNTIME="containerd"
    export USE_MAX_PODS=false
    export KUBELET_EXTRA_ARGS="--max-pods=110"
    EOF
    # Source extra environment variables in bootstrap script
    sed -i '/^set -o errexit/a\\nsource /etc/profile.d/bootstrap.sh' /etc/eks/bootstrap.sh
    EOT 
```

Script works by assuming a line `set -o errexit` exists and that is the correct place to insert script. Very likely the case for foreseeable future but it's not a 'contract'. So giving EKS the go-ahead to update nodes requires to check if the user-data is still compatible with the bootstrap.sh script of the AMI that will be used.


Self managed nodes

* Specify AMI
* AMI change updates launch template, sets latest version to asg
* New nodes will have new AMI
* Need tool to safely cycle nodes, e.g. hello-fresh




Label/taint support



