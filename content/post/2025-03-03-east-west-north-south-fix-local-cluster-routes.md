---
title: "East, west, north, south: How to fix your local cluster routes"
author: Tibo Beijen
date: 2025-03-03T05:00:00+01:00
url: /2025/03/03/east-west-north-south-fix-local-cluster-routes
categories:
  - articles
tags:
  - Development
  - Kubernetes
  - K3D
  - Cert-manager
  - OSx
description: How to easily apply the bits of glue needed to run applications on local clusters without friction.
thumbnail: 

---

## Introduction

Recently I needed to test a Keycloak upgrade. This required me to deploy both the new Keycloak version and a sample OIDC application on my local Kubernetes setup. And it pointed me to a thing I kept postponing:

> Improve my local development DNS, routing and TLS setup

## The challenge

Until recently, I used urls like `keycloak.127.0.0.1.nip.io:8443`. This points to `127.0.0.1` port `8443` which forwards to a local [k3d]() cluster. At the same time it provides a unique hostname that can be used for configuring ingress. 

Nice. But not without flaws.

For starters, this works for routing traffic _to_ the K3D cluster, we could call this 'north-south'. But not for routing traffic _within_ the cluster (east-west). This becomes apparent when trying to setup an OIDC sample application[^footnote_oidc], such as [the one shipped with DEX](https://github.com/dexidp/dex/pkgs/container/example-app). The domain pointing to Keycloak is used in two places: By the browser of the user logging in, so in this case from the host OS, _and_ directly from the backend, so within the cluster. 

This puts us in a catch-22: nip.io, or an entry in `/etc/hosts` only works for north-south. `svc.cluster.local` only works for east-west. 

Another problem is that the default certificates issued by Traefik are not trusted by other systems or browsers. So we frequently need to bypass security warnings, which by itself is indicative of a problem and encourages bad habits. Furthermore, even if we manage to configure our setup to use the ingress service from within the cluster, it depends on the backend application if it allows to bypass TLS host checking.

To improve this, we need to address some things. In this article:

{{< toc >}}

## Improvement 1: TLS certificates and trust

### Create CA certificate and key

The ingress configurations in the cluster need to serve a certificate that is trusted by browsers and systems. One way could be registering a public (sub)domain for internal use, and use [Let's Encrypt](https://letsencrypt.org/) certificates, using [DNS-01 challenge](https://letsencrypt.org/docs/challenge-types/#dns-01-challenge) for verification.

Another way is to create a self-signed Certificate Authority (CA), use that to issue TLS certificates, and ensure the CA is trusted by the relevant systems. I chose this approach since it's mostly a setup-once affair, and doesn't require me to deal with API tokens of my DNS provider. 

One important thing to be aware of, is that adding a CA to a trust bundle, has any certificate signed by it, to be trusted. So, if the CA signs a certificate for e.g. `myaccount.google.com`, your browser will trust it. This can be mitigated by adding [NameConstraints](https://wiki.mozilla.org/CA:NameConstraints). This reduces the risk of adding self-signed CAs to your trust bundles.

Create a `ca.ini` file:

```
[ req ]
default_bits       = 4096
distinguished_name = req_distinguished_name
req_extensions     = v3_req
prompt             = no

[ req_distinguished_name ]
CN = Development Setup .local CA
O = LocalDev
C = NL

[ v3_req ]
basicConstraints = critical, CA:TRUE
keyUsage = critical, keyCertSign, cRLSign
nameConstraints = critical, permitted;DNS:.local
```

Create key, certificate signing request (csr) and signed certificate:

```
openssl ecparam -name prime256v1 -genkey -noout -out ca.key
openssl req -new -key ca.key -out ca.csr -config ca.ini
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt -days 3650 -extfile ca.ini -extensions v3_req
# Show the certificate
openssl x509 -noout -text -in ca.crt
```

Note the name constraints section:

```
X509v3 extensions:
    X509v3 Name Constraints: critical
        Permitted:
          DNS:.local
```

Let's test if name constraints works:

```
# Create a certificate for example.com
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 \
  -CA ca.crt -CAkey ca.key \
  -nodes -keyout example.com.key -out example.com.crt -subj "/CN=example.com" \
  -addext "subjectAltName=DNS:example.com,DNS:*.example.com,IP:10.0.0.1"
# Ok, so we can create a certificate outside the name constraints
# Let's verify it
openssl verify -verbose -CAfile ca.crt example.com.crt
```

This results in:

```
CN=example.com
error 47 at 0 depth lookup: permitted subtree violation
error example.com.crt: verification failed
```

Good! Now add the CA to Keychain:

```
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ca.crt
```

### Setup Kubernetes cluster issuer and trust bundle


```


Note: If not wanting to setup DNSmasq, one could segment k3d clusters like `myapp.cl1.127.0.0.1.nip.io`. 

Next steps:

* Local haproxy port 443
* Internal, publicly resolvable domain name. Let's encrypt. Easier to use accross environments, e.g. home network, VPS-es.

final paragraph.

[^footnote_oidc]: Yes, we are mixing Keycloak and DEX. The beauty of standards such as OIDC.
