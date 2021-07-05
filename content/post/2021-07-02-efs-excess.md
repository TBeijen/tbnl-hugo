---
title: 'EFS Excess'
author: Tibo Beijen
date: 2021-07-02T08:00:00+01:00
url: /2021/07/02/efs-excess
categories:
  - articles
tags:
  - AWS
  - EFS
  - NFS
  - Troubleshooting
  - Kubernetes
  - EKS
description: "Disovering terabytes of excessive data, on our bill first, and cleaning it up."

---
Recently we discovered that what used to be a minor line in our monthly billing graph, had become several strokes wider, amounting to a couple of hundred dollars on the monthly bill. This line represented EFS, wich we use, but by no means in large amounts. 

So we thought... 

As it appeared we were using around 3 terabyte of data.

## Investigating

We use EFS as our go-to persistent storage solution for applications in EKS, it's main benefit being that it spans all availability zones so scheduling of pods remains simple. Nearly all applications are stateless and use Elasticache or RDS for persistent storage, so the number of applications that use persistent storage are limited, and for the applications that _do_ use it, requirements are not high. Examples of applications that use EFS include Jenkins, Grafana and Prometheus.

We provision an EFS volume and configure [efs-provisioner](https://github.com/kubernetes-retired/external-storage/tree/master/aws/efs) accordingly for each EKS cluster (We'll probably switch to [EFS CSI Driver](https://github.com/kubernetes-sigs/aws-efs-csi-driver) or [EFS CSI dynamic provisioning](https://aws.amazon.com/blogs/containers/introducing-efs-csi-dynamic-provisioning/) at some point). The beauty is that providing an application with EFS storage is as simple as specifying a storage class. A side-effect is that AWS tags give no additional information as to what application in the cluster is using excessive storage.

So, we can peek into the individual EFS PVCs currently used by pods. But it's quite a hassle and maybe data was added by an application that no longer exists. So the most thorough way is to mount the entire EFS volume and explore that.

That can be accomplished by adding a temporary deployment similar to this:

```
# kubectl apply -f this_file.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: awscli-efs-mount
  labels:
    manual_install: "1"
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: awscli-efs-mount
      app.kubernetes.io/instance: default
  template:
    metadata:
      labels:
        app.kubernetes.io/name: awscli-efs-mount
        app.kubernetes.io/instance: default
    spec:
      containers:
        - name: default
          image: "amazon/aws-cli:2.0.59"
          command: ['cat']
          tty: true
          volumeMounts:
            - name: efs-volume
              mountPath: /mnt/efs        
      volumes:
        - name: efs-volume
          nfs: 
            server: <EFS-ID>.efs.eu-west-1.amazonaws.com
            path: /
```
And start a terminal session within the pod, e.g.

```
kubectl exec -it awscli-efs-mount-xxxxxxx-yyyyy -- bash
```

If needing more fine-grained control over nfs mount options, since the [nfs volume type offers no options](https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#nfsvolumesource-v1-core), you could mount the EFS volume from within the pod, however this requires the pod to run in privileged mode. (We initially went in this direction, but in our case the above simple way worked yust fine.) 

```
# add security context to the 'default' container from previous example
      containers:
        - name: default
          # ...
          securityContext:
            privileged: true  
```

Then within the container run:

```
yum -y install nfs-utils
mkdir /mnt/efs
mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport <EFS-ID>.efs.eu-west-1.amazonaws.com:/ /mnt/efs &&
```

Note:
* In the above example I use the `amazon/aws-cli` image. Use any image you are familiar with that provides a shell.
* Use a container running the user root. Normally not the best of practices but here you need to be able to navigate a filesystem with varying ownership.

