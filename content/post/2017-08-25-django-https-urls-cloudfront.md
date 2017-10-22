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
description: Having Django generate absolute URLs using https has some challenges when set up behind CloudFront.

---

Recently while developing a new API, built using Django Rest Frameowork and delivered using CloudFront, we noticed the absolute URLs it generated to be http, whereas the CloudFront distribution is https only. Not really surprising when thinking it through, as in our case Cloudfront did TLS termination and traffic between upstream components was HTTP.

URLs in pages (or JSON data) should match the protocol of the request. Typically you want the protocol to be determined based on facts (so the protocol _the client request _has_) instead of configuration (the protocol you _assume the client request to be_). Less config. Easy for development setups that might be HTTP-only. Less configuration. No asumptions.




Enabling CloudFront CloudFront-Forwarded-Proto header

