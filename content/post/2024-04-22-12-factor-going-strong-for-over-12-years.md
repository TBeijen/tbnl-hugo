---
title: "12 Factor: Going strong for over 12 years"
author: Tibo Beijen
date: 2024-04-22T08:00:00+01:00
url: /2024/04/22/12-factor-going-strong-for-over-12-years
categories:
  - articles
tags:
  - Cloud Native
  - Kubernetes
  - Operations
  - Development
description: The 12 factor methodology is more than 12 years old. How did it age in the cloud-native era?
thumbnail: img/foobar.png

---

## Introduction

In a presentation about CI/CD I gave a while ago, I briefly mentioned the [12 factor methodology](https://12factor.net/). Somewhere along the lines of "You might find some good practices there", and summarizing it as:

```
artifact
configuration +
---------------
deployment
```

After the talk, a colleague of way back, came to me and said: "You were way to mild in _suggesting_ it. It's mandatory, people _should_ follow those practices."

And yes, he's right. In the past, I have onboarded quite a number of applications into Kubernetes, that we had already built with 12 factor in mind. That process usually was fairly smooth, so you start to take things for granted. Until you bump into applications that are tough to operate, that is...

The 12 factor methodology has been [initiated almost 14 years ago](https://github.com/heroku/12factor/commit/2b06e7deabb64bb759f9fc6f4d9b6fcc546921bb) at Heroku, a company that was 'cloud native', focused on developer experience and ease of operation. So, it's no surprise it still _is_ relevant.

So, let's glance over the 12 factors, and put them in the context of cloud native applications.


