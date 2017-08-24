---
title: 'Generating https urls in Django using CloudFront'
author: Tibo Beijen
date: 2017-08-25T16:00:00+02:00
url: /2017/08/25/django-https-urls-cloudfront/
categories:
  - articles
tags:
  - AWS
  - CloudFront
  - ELB
  - Nginx
  - Django
  - Django Rest Framework
  - Python
description: Having Django generate absolute url's using https has some challenges when set up behind CloudFront.

---

Recently while testing a new API, built using Django Rest Frameowork and delivered using CloudFront, we noticed the absolute urls it generated to be http, whereas the CloudFront distribution is https only.




Enabling CloudFront CloudFront-Forwarded-Proto header

