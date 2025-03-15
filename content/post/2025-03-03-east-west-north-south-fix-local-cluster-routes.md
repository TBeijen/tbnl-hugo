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

Another problem is that the default certificates issued by Traefik, are not trusted by other systems or browsers. So we frequently need to bypass security warnings, which by itself is indicative of a problem and encourages bad habits. Furthermore, even if we manage to configure our setup to use the ingress service from within the cluster, it depends on the backend application if it allows bypassing TLS host checking.

To improve this, we need to address some things. In this article:

{{< toc >}}

☞ Don't fancy reading? Head straight to the [github repo containing taskfile automation](https://github.com/TBeijen/dev-cluster-config)

## The plan

So, let's identify and configure the components needed to create a smooth local kubernetes setup, providing trusted TLS and predictable endpoints. 

This will result in applications being accessible via the following pattern:

| k3d cluster | Hostnames                | HTTP port | HTTPS port |
|-------------|--------------------------|-----------|------------|
| cl0         | *.cl0.k3d.local          | 10080     | 10443      |
| cl1         | *.cl1.k3d.local          | 11080     | 11443      |
| cl2         | *.cl2.k3d.local          | 12080     | 12443      |
| etc, etc... |                          |           |            |


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

Let's test if name constraints works by issuing a certificate that does not match the name constraint:

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

We can now install [cert-manager](https://cert-manager.io/docs/) to issue TLS certificates and [trust-manager](https://cert-manager.io/docs/trust/trust-manager/) to distribute trust bundles:

```
helm repo add jetstack https://charts.jetstack.io --force-update

# cert-manager
# Note the NameConstraints feature gates!
helm upgrade --install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true \
  --set webhook.featureGates="NameConstraints=true" \
  --set featureGates="NameConstraints=true"

# trust-manager
helm upgrade --install \
  trust-manager jetstack/trust-manager \
  --namespace cert-manager
```

Add the CA certificate and create a `ClusterIssuer`:

```
kubectl -n cert-manager create secret tls root-ca --cert=ca.crt --key=ca.key

cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: root-ca
spec:
  ca:
    secretName: root-ca
EOF
```

Create a trust `Bundle`:

```
cat <<EOF | kubectl apply -f -
apiVersion: trust.cert-manager.io/v1alpha1
kind: Bundle
metadata:
  name: default-ca-bundle
spec:
  sources:
  - useDefaultCAs: true
  - secret:
      name: "root-ca"
      key: "tls.crt"
  target:
    configMap:
      key: "bundle.pem"
    namespaceSelector:
      matchLabels:
        trust: enabled
```

Now the bits of configuration we need to remember when setting up applications:

* The cluster issuer name is `root-ca`, so Ingress objects need the annotation `cert-manager.io/cluster-issuer: root-ca`
* The CA bundle, including our issuer CA, can be found in a configmap `default-ca-bundle` under key `pundle.pem`, _if_ the namespace is labeled `trust: enabled`.

**Note:** Since I consider dev clusters ephemeral and short-lived, topics like safely rotating issuer certificates don't need attention. When setting up trust manager in production environments, be sure to consider [what namespace to install](https://cert-manager.io/docs/trust/trust-manager/installation/#trust-namespace) in and [prepare for issuer certificate rotation](https://cert-manager.io/docs/trust/trust-manager/#cert-manager-integration-intentionally-copying-ca-certificates).

## Improvement 2: Fixing north-south routing

As mentioned in the introduction, DNS resolvers like `nip.io` are helpful for routing from host to development cluster, but will not work within the cluster: It will resolve to `127.0.0.1` and the target service won't be there.

One way to handle this is to install [Dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html), and configure resolving on the host in such a way that `.local` will use `127.0.0.1` to resolve DNS. Which will then respond with `127.0.0.1`. Using the port matching the K3D cluster will then ensure the correct cluster receives the traffic.

```
brew install dnsmasq
# Ensure service can bind to port 53 and starts at reboot
sudo brew services start dnsmasq
```

Configure Dnsmasq, use `brew --prefix` to determine where the config is located. On a silicon Mac that will be `/opt/homebrew`.

Ensure the following line in `/opt/homebrew/etc/dnsmasq.conf` is uncommented:

```
conf-dir=/opt/homebrew/etc/dnsmasq.d/,*.conf
```

Then we can configure Dnsmasq to resolve `.local` to `127.0.0.1`:

```
echo "address=/local/127.0.0.1" > $(brew --prefix)/etc/dnsmasq.d/local.conf
```

Finally we tell OSX to use Dnsmasq at `127.0.0.1` to resolv DNS queries for `.local`:

```
sudo sh -c "echo 'nameserver 127.0.0.1' > /etc/resolver/local"
```

Be aware tools like `dig` and `nslookup` behave a bit different from the usual program on OSx so they are not the best way to test.
If we have set up a K3D cluster, forwarding host ports to the http and https ports using `-p`, we could try to reach an application:

```
# Assuming we have set up keycloak and port 10443 is forwarded to k3d https port
# Using -k since curl does not use the system trust bundle, so is not aware of our CA
curl -k https://keycloak.cl0.k3d.local:10443/ -I
HTTP/2 302
location: https://keycloak.cl0.k3d.local:10443/admin/
```

Application is there. Good. Let's move on.

## Improvement 3: Fixing east-west routing




## Combining and automating







Note: If not wanting to setup DNSmasq, one could segment k3d clusters like `myapp.cl1.127.0.0.1.nip.io`. Or somehow bind an ip to the host, that allows routing from the host, as well as from within the cluster.



Next steps:

* Local haproxy port 443
* Internal, publicly resolvable domain name. Let's encrypt. Easier to use accross environments, e.g. home network, VPS-es.

final paragraph.

[^footnote_oidc]: Yes, we are mixing Keycloak and DEX. The beauty of standards such as OIDC.
