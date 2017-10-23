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

## X-Forwarded-Proto

It's quite common to configure proxies to forward the request protocol by means of adding a ``X-Forwarded-Proto`` header to the upstream request.

For [nginx it looks like](https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-load-balancing-with-ssl-termination#virtual-host-file-and-upstream-module):

```
proxy_set_header X-Forwarded-Proto $scheme;
```

For [HAProxy it looks like](http://cbonte.github.io/haproxy-dconv/configuration-1.5.html#7.3.4-ssl_fc):

```
http-request add-header X-Forwarded-Proto https if { ssl_fc }
```

And Amazon ELBs [support it as well](http://docs.aws.amazon.com/elasticloadbalancing/latest/classic/x-forwarded-headers.html#x-forwarded-proto).





Enabling CloudFront CloudFront-Forwarded-Proto header

