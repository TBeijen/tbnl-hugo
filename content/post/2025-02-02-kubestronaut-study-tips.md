---
title: "Study tips for becoming a Kubestronaut"
author: Tibo Beijen
date: 2025-02-10T05:00:00+01:00
url: /2025/02/10/study-tops-for-becoming-a-kubestronaut
categories:
  - articles
tags:
  - CNCF
  - Certification
  - CKAD
  - CKA
  - CKS
description: Tips for studying and preparing for the five CNCF exams that grant the Kubestronaut title
thumbnail: 

---

## Introduction

## Order of exams

## Practice and take notes

## Keep it simple, make it routine

## CKAD, CKA and CKS 

Use one practice exam.

## KCNA and KCSA

Relatively easy. Use practice exams to gauge one's readiness.

Free resources;

* https://www.itexams.com/exam/KCNA - Not used myself. Looks free and representative although UI a bit clunky.

## During the exam

Disable smooth scrolling

Consider reducing font size

Open a note in mousepad and keep open

## CLI essentials

Muscle memory

`--dry-run=client -o yaml`
`--grace-period=0 --force`

Use `k explain`

```sh
k explain ciliumnetworkpolicy.spec.egressDeny
```

Use `man`

```sh
man Dockerfile
man docker-run
man docker-build
```

Search & navigate 

Vim basics

select, cut, copy, paste. Remove line, increase/decrease indent

```sh
# curl with max timeout 1 sec
curl -m 1 http://my-svc.my-ns.svc.cluster.local

# When asked for formatting displaying 'time in nanoseconds'
falco --list |grep nano

# -n: Create 16-char length base64 pw without newline being appended to value
echo -n "this-is-very-sec" |base64
```


## Concluding

