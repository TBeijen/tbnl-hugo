---
title: 'The mysterious case of the missing ECR image'
author: Tibo Beijen
date: 2022-12-23T12:00:00+01:00
url: /2022/12/23/2022-12-23-the-mysterious-case-of-the-missing-ecr-image
categories:
  - articles
tags:
  - AWS
  - ECR
  - Docker
  - Podman
description: "Investigating why very occasionally we got bitten by our ECR lifecycle policy"
thumbnail: img/missing-ecr-image.png

---
## The mysterious case of the missing ECR image

Recently we experienced a specific ECR production image being absent that really should not have been purged by our lifecycle hooks. It happened in two scenarios:

* EKS node replacement, new node can't pull image.
* Rollback (we make mistakes). The rollback involved multiple images, all but this particular one were still present on ECR. As they should.

So far we've been lucky. The node replacement affected only one of multiple pods, leaving enough of them running. The rollback caused the particular deployment to stay at the most recent version, which was not a problem since it was compatible with what was successfully rolled back (and what was the actual target of the roll-back).

At some point luck will run out, so let's investigate before that.

### ECR lifecycle policies

Our ECR repository lifecycle policy looks like this:

```
{
  "rules": [
    {
      "action": {
        "type": "expire"
      },
      "selection": {
        "countType": "imageCountMoreThan",
        "countNumber": 5,
        "tagStatus": "tagged",
        "tagPrefixList": [
          "tag"
        ]
      },
      "description": "Keep last 5 production images",
      "rulePriority": 1
    },
    {
      "rulePriority": 5,
      "description": "Expire images older than 14 days",
      "selection": {
        "tagStatus": "any",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 14
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
```

We tag images based on git commit (example: `git-ad89876a`) and additionally tag production images with a 'tag' tag (example: `tag-1-256-0,`). So the above in human understandable language boils down to: "Purge everything older than 14 days, but no matter what, keep at least the 5 most recent production images".

This has worked quite nicely for the past 4 years or so, only downside being inactive non-prod deployments sometimes needing a re-build because those images get purged. Except for the mysterious case described above.

### Cloudtrail

Checking cloudtrail we could indeed observe our rollback target `tag-1-253-0` being removed at an earlier date than a tag that's older (`tag-1-251-0`)

Relevant part of the CloudTrail data:

```
            {
                "lifecycleEventImage": {
                    "digest": "sha256:ec1477a7420a97a789dd4b778a0a1141a6c6ba9314fce70599c134964121960c",
                    "tagStatus": "Tagged",
                    "tagList": [
                        "git-325dc21f",
                        "git-684254dd",
                        "git-06ec56d0",
                        "git-719feb86",
                        "git-418dbbae",
                        "git-841e4719",
                        "git-48a3a88a",
                        "git-a714d9b2",
                        "git-14c65fe5",
                        "tag-1-252-0",
                        "tag-1-253-0"
                    ],
                    "pushedAt": 1671098240000
                },
                "rulePriority": 1
            }
```

We were aware that an image can have multiple tags, that's how docker image tagging works. Still, the amount of tags was a bit higher than we expected. It did gave us insight in what went wrong though.

### Hypothesis

What looks to be the cause:

* New image checksum is identical to a previous one already built
* Push to ECR using new tag does not push any new layer, merely adds an additional tag to an already existing layer
* As a result of that `pushedAt` is not updated (makes total sense)
* So what we (as humans) consider to be a recent image based on the tag, computer considers an old image
* Unpredictable things might happen

First of all we need to double check our assumption on how lifecycle policies based on `imageCountMoreThan` are handled.

Quoting the [AWS ECR UserGuide](https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html):

> With countType = `imageCountMoreThan`, images are sorted from youngest to oldest based on pushed_at_time and then all images greater than the specified count are expired.

That's indeed what we expect to happen.

### Validating the hypothesis

#### Why does the final image checksum hardly change?

Under normal circumstances, a new image build is triggered by code or dependency changes and those inherently result in a new image checksum.

This particular image is part of the codebase of our API platform. It holds various static assets (think: SVG icons) used in our applications that support our API platform and make their way to devices via a CDN. So while the API code frequently changes, the contents of this image _do not_.

#### Reproducing pushedAt behavior

Next step, validate that pushedAt does not update when the image checksum doesn't change.

For this purpose I use a very basic Dockerfile and a temporary ECR repo:

```
FROM docker.io/library/python:3.10-slim
ARG MY_CONTENTS
RUN echo ${MY_CONTENTS} > /contents.txt
```

Let's build and push some images with various tags in succession:

```
podman build -t 400000000004.dkr.ecr.eu-west-1.amazonaws.com/pushed-at-demo:v1 --build-arg MY_CONTENTS=foo -f Dockerfile .
podman push 400000000004.dkr.ecr.eu-west-1.amazonaws.com/pushed-at-demo:v1

podman build -t 400000000004.dkr.ecr.eu-west-1.amazonaws.com/pushed-at-demo:v2 --build-arg MY_CONTENTS=foo -f Dockerfile .
podman push 400000000004.dkr.ecr.eu-west-1.amazonaws.com/pushed-at-demo:v2

# Here we change the image contents to 'bar'
podman build -t 400000000004.dkr.ecr.eu-west-1.amazonaws.com/pushed-at-demo:v3 --build-arg MY_CONTENTS=bar -f Dockerfile .
podman push 400000000004.dkr.ecr.eu-west-1.amazonaws.com/pushed-at-demo:v3

# Back to original contents of 'foo'
podman build -t 400000000004.dkr.ecr.eu-west-1.amazonaws.com/pushed-at-demo:v4 --build-arg MY_CONTENTS=foo -f Dockerfile .
podman push 400000000004.dkr.ecr.eu-west-1.amazonaws.com/pushed-at-demo:v4
```

Local images looks like this:

```
# > podman images
REPOSITORY                                                   TAG                  IMAGE ID      CREATED         SIZE
400000000004.dkr.ecr.eu-west-1.amazonaws.com/pushed-at-demo  v3                   164918115a2c  2 minutes ago   132 MB
400000000004.dkr.ecr.eu-west-1.amazonaws.com/pushed-at-demo  v1                   c6340b89a726  8 minutes ago   132 MB
400000000004.dkr.ecr.eu-west-1.amazonaws.com/pushed-at-demo  v2                   c6340b89a726  8 minutes ago   132 MB
400000000004.dkr.ecr.eu-west-1.amazonaws.com/pushed-at-demo  v4                   c6340b89a726  8 minutes ago   132 MB
```

... and ECR contents look like this:

```
# > aws ecr describe-images --repository-name=pushed-at-demo
{
    "imageDetails": [
        {
            "registryId": "400000000004",
            "repositoryName": "pushed-at-demo",
            "imageDigest": "sha256:9ec96713ab1e0747bfeb79c964a97e44bcefada9c8d036cbe9c8079f8d39a745",
            "imageTags": [
                "v4",
                "v2",
                "v1"
            ],
            "imageSizeInBytes": 49827764,
            "imagePushedAt": "2022-12-23T12:00:30+01:00",
            "imageManifestMediaType": "application/vnd.oci.image.manifest.v1+json",
            "artifactMediaType": "application/vnd.oci.image.config.v1+json"
        },
        {
            "registryId": "400000000004",
            "repositoryName": "pushed-at-demo",
            "imageDigest": "sha256:c9e5fe97c85ae70ee34cd7b325f465fb0b65117ba95b98cd7fcf97ead22392cc",
            "imageTags": [
                "v3"
            ],
            "imageSizeInBytes": 49827765,
            "imagePushedAt": "2022-12-23T12:04:47+01:00",
            "imageManifestMediaType": "application/vnd.oci.image.manifest.v1+json",
            "artifactMediaType": "application/vnd.oci.image.config.v1+json"
        }
    ]
}
```

As expected, tags are added to the existing image, and the resulting `imagePushedAt` of `v4` is actually older than that of `v3`.

#### Bonus: It's all about the local cache

It's good to understand that the only way this can happen is when local docker/podman hits a cached layer. When building from scratch, a different filesystem timestamp is bound to result in a different final checksum.

```
# deleting cache
podman rmi c6340b89a726 --force

# building 'foo' image again
podman build -t 400000000004.dkr.ecr.eu-west-1.amazonaws.com/pushed-at-demo:v5 --build-arg MY_CONTENTS=foo -f Dockerfile .
podman push 400000000004.dkr.ecr.eu-west-1.amazonaws.com/pushed-at-demo:v5
aws ecr describe-images --repository-name=pushed-at-demo
```

As a result, te `v5` image has a different checksum than `v1..v3` although its file's contents are the same:

```
{
    "imageDetails": [
        {
            "registryId": "400000000004",
            "repositoryName": "pushed-at-demo",
            "imageDigest": "sha256:9ec96713ab1e0747bfeb79c964a97e44bcefada9c8d036cbe9c8079f8d39a745",
            "imageTags": [
                "v4",
                "v2",
                "v1"
            ],
            "imageSizeInBytes": 49827764,
            "imagePushedAt": "2022-12-23T12:00:30+01:00",
            "imageManifestMediaType": "application/vnd.oci.image.manifest.v1+json",
            "artifactMediaType": "application/vnd.oci.image.config.v1+json"
        },
        {
            "registryId": "400000000004",
            "repositoryName": "pushed-at-demo",
            "imageDigest": "sha256:c9e5fe97c85ae70ee34cd7b325f465fb0b65117ba95b98cd7fcf97ead22392cc",
            "imageTags": [
                "v3"
            ],
            "imageSizeInBytes": 49827765,
            "imagePushedAt": "2022-12-23T12:04:47+01:00",
            "imageManifestMediaType": "application/vnd.oci.image.manifest.v1+json",
            "artifactMediaType": "application/vnd.oci.image.config.v1+json"
        },
        {
            "registryId": "400000000004",
            "repositoryName": "pushed-at-demo",
            "imageDigest": "sha256:66ca17bbcea3d3e9eae34bab794bd305370b75f9ceb91b0de1ca768f0b7618a4",
            "imageTags": [
                "v5"
            ],
            "imageSizeInBytes": 49827765,
            "imagePushedAt": "2022-12-23T12:09:28+01:00",
            "imageManifestMediaType": "application/vnd.oci.image.manifest.v1+json",
            "artifactMediaType": "application/vnd.oci.image.config.v1+json"
        }
    ]
}
```

### Ways to mitigate

One of the ways to mitigate is to increase the number of preserved tags. But... this reduces the risk. Does not rule it out. Long-living layer cache combined with files that hardly change, or worse: Get reverted to a previous state ("previous icon was better") can still cause this problem.

The better fix here would be to add the git revision or git tag as content to a file in the image. This could be considered good practice anyway because now a version identifier becomes part of the image, instead of just being a tag.

### Concluding

> Caching is hard

Hopefully this either saves anyone some time, gives some insight into docker image layers or at the very least was mildly entertaining.

If having any form of feedback, don't hesitate to reach out via Twitter or Mastodon.
