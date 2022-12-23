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

Recently we occasionally experienced a specific ECR production image being absent that really should not have been purged by our lifecycle hooks. It happened in two scenarios:

* EKS node replacement, new node can't pull image.
* Rollback (yes, we occasionally make mistakes). The rollback involved multiple images, all but this particular one were still present on ECR. As they should.

So far we've been lucky. The node replacement affected only one of multiple pods, leaving enough of them running. The rollback caused the particular deployment to stay at the most recent version, which was not a problem since it was compatible with what was successfully rolled back (and was the actual target of the roll-back).

At some point luck will run out, so let's investigate before that.

### ECR lifecycle policies

Our ECR repository lifecycle policy looks like this:

```json
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

This has worked quite nicely for the past 4 years or so, only downside being very inactive non-prod deployments sometimes needing a re-build because those images get purged. Except for the mysterious case described above.

### Cloudtrail

Checking cloudtrail we could indeed observe our rollback target `tag-1-253-0` being removed at an earlier date than a tag that's older (`tag-1-251-0`)

Relevant part of the CloudTrail data:

```json
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





Mitigate:

* Increase number of tags, reducing chance
* Write revision, forcing each tag to result in unique checksum
* Split prod/non-prod image repos

