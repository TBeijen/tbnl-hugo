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

Recently, while developing an API that makes use of [Django Rest Frameowork](http://www.django-rest-framework.org/) and is delivered using CloudFront, we noticed the absolute URLs it generated to be http, whereas the CloudFront distribution is https only. Not really surprising when thinking it through, as in our case Cloudfront did TLS termination and traffic between upstream components was HTTP (We'll look into that, as HTTPS is preferred).

URLs in pages (or JSON data) should match the protocol of the request. Typically you want the protocol to be determined based on facts (so the protocol the client request _has_) instead of configuration (the protocol you _assume the client request to have_). Less configuration. Easy for development setups that might be HTTP-only. No asumptions.

## X-Forwarded-Proto

Let's look a bit into how reverse proxies forward the client's request protocol. 

It's quite common to configure reverse proxies to forward the request protocol by means of adding a ``X-Forwarded-Proto`` header to the upstream request.

For [nginx it looks like](https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-load-balancing-with-ssl-termination#virtual-host-file-and-upstream-module):

```
proxy_set_header X-Forwarded-Proto $scheme;
```

For [HAProxy it looks like](http://cbonte.github.io/haproxy-dconv/configuration-1.5.html#7.3.4-ssl_fc):

```
http-request add-header X-Forwarded-Proto https if { ssl_fc }
```

And Amazon ELBs [support it as well](http://docs.aws.amazon.com/elasticloadbalancing/latest/classic/x-forwarded-headers.html#x-forwarded-proto).

Note that these configurations _set_ the ``X-Forwarded-Proto`` header but do not _propagate_ it.

The setup of an application using Cloudfront typically looks like this:

<pre>             
 Application -- ELB -- Cloudfront -- Client
(uwsgi/nginx)          
</pre>

Now this leaves for a lot of variations in what protocols are used between layers:

* For custom origins, [CloudFront can be configured](http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/HTTPandHTTPSRequests.html) to match the client protocol for backend requests, or use only HTTP or HTTPS.
* Likewise, for ELBs listeners can be configured for HTTP and HTTPS, mirroring the client request, or always map to either HTTP or HTTPS on the instances (the application).
* Any additional or alternate reverse proxies offer likewise flexibility, as briefly illustrated above.

The main take-away is that, to have reliable info in your application about the actual client request protocol, you'd either have to:

* Rigourously match the downstream request protocol accross all layers.
* Use TCP mode wherever possible.
* Forward incoming	``X-Forwarded-Proto`` headers. But that's not the best of practices, as that information shouldn't be provided by client but be based on the actual request protocol.
* Determine the client request protocol at the layer nearest to the client, and propagate that in a way that isn't overwritten by upstream layers.

That last option is exactly what is offered by CloudFront's ``Cloudfront-Forwarded-Proto`` header.

## Cloudfront-Forwarded-Proto

By default CloudFront doesn't set the ``Cloudfront-Forwarded-Proto`` header. This header can be added to the 'Whitelist headers' when configuring behaviours.

{{< figure src="/img/django_cloudfront__aws_behaviour_whitelist.png" title="AWS CloudFront Behaviour Configuration: Whitelist Headers" >}}

Note the setting 'Cache Based on Selected Request Headers'. This has the not-so-fine-grained options _None (improves caching)_, _Whitelist_ and _All_. So, adding the the ``Cloudfront-Forwarded-Proto`` header to the whitelist not only causes the client's request protocol to be available to the application, it also configures CloudFront to cache based on client request protocol.

Typically this is a good thing as it:

* Allows links on a page to be generated matching the request protocol.
* Prevents redirect loops in case you redirect clients from HTTP to HTTPS from your application server (note that CloudFront behaviours can be configured to do this as well).

## Django configuration

Having set up CloudFront as described, configuring a Django application accordingly is trivial by adding to ``settings``:

```
SECURE_PROXY_SSL_HEADER = ('HTTP_CLOUDFRONT_FORWARDED_PROTO', 'https')
```

## Wrapping it up

This articles shows how to have a Django application obey the client's request protocol when using CloudFront. 

Other CDNs will likely offer similar configuration options (e.g. [Fastly allows setting request headers](https://docs.fastly.com/guides/basic-configuration/adding-or-modifying-headers-on-http-requests-and-responses#) when using ``req.proto`` as source).

Added advantage is that by doing so, large part of the architecture can be changed without requiring any configuration change. Examples would be swapping out ELBs with ALBs or moving the application to Kubernetes.
