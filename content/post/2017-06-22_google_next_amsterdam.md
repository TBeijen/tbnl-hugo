---
title: 'Google Next 2017 Amsterdam'
author: Tibo Beijen
date: 2017-06-22T16:00:00+02:00
url: /2017/06/22/google-next-2017-amsterdam/
categories:
  - articles
tags:
  - Google
  - GCP
  - Kubernetes
  - Istio
  - Firebase
  - Spanner
description: Recap of the Google Cloud Next event that took place at 2017 june 21 in Amsterdam.

---
Similar to the summits organized by 'that other public cloud provider', Google hosts an event intended on showcasing what's new in their cloud platform. At wednesday june 21 this [took place in Amsterdam](https://cloudplatformonline.com/Next-Amsterdam-2017.html).

The event was located in de [Kromhouthal in Amsterdam Noord](https://www.google.nl/maps/place/De+Kromhouthal/@52.3832816,4.9183379,17z/data=!3m1!4b1!4m5!3m4!1s0x47c609abb3be496b:0x1a140c53c426f7c7!8m2!3d52.3832816!4d4.9205266). When using public transport this requires taking the ferry, adding to the vibe of 'a day out'. Being an old ship construction facility, the industrial setting was a very good fit for the event. Besides that, all aspects of the organization were very professional and top notch.

Adding to the value was the fact that our colleagues Johnny Mijnhout and Istvan Fonay did a presentation on the use of Firebase in the NUsport app ([Android](https://play.google.com/store/apps/details?id=hu.sanoma.nusport&hl=nl)/[iOS](https://itunes.apple.com/nl/app/nusport-sportnieuws-scorebord-en-live-videos/id369357122?mt=8)).

## Topics

Although the [diversity of topics was quite large](https://cloudplatformonline.com/Next-Amsterdam-2017-Schedule.html), there was quite some focus on Kubernetes, G Suite, Big Data and Machine Learning. Not suprisingly topics that are Google-specific or Google excels at.

### Kubernetes

Stand-out topic for me was [Kubernetes](https://kubernetes.io/). It really takes Docker to the next level and I'm quite confident that it will find it's way in many organizations. Mentioned multiple times as a very promisiong addition was [Istio](https://istio.io/), which enhances Kubernetes by adding policy enforcement, reporting and a multitude of deployment strategies, including A/B testing, canary releases and rolling updates. Things you want but typically require quite some plumbing.

### Machine learning

Throughout several presentations the capabilities of Google Cloud Machine Learning were showcased. A good example being the automated removal of Personal Identifiable Information (PII) from chat data. Other samples being [Cloud Video Intelligence](https://cloud.google.com/video-intelligence/) and [Cloud Vision API](https://cloud.google.com/vision/).

### Spanner

A relational database that is web scale?[^footnote_webscale] One that defies the [CAP theorem](https://en.wikipedia.org/wiki/CAP_theorem)? That is [Spanner](https://cloud.google.com/spanner/). It sounds like magic but it was explained rather well: The CAP in 'CAP theorem' stands for Consistency, Availability and Partition tolerance. The theorem states that you can't have all three, you need to sacrifice one. So, if you 'sacrifice' partition tolerance, but have a network that's so fast and redundantly set up that in reality partitioning will never happen.... then you can build Spanner. (Obviously it's not available for download).

### Firebase

As customer case of Kubernetes, the NUsport app was presented. This presents users with a liveblog for several sports categories, containing text, images, videos and score updates. This technology was later implemented in the NU.nl apps ([Android](https://play.google.com/store/apps/details?id=nl.sanomamedia.android.nu&hl=nl)/[iOS](https://itunes.apple.com/nl/app/nu-nl/id382059927?mt=8)) and [website](http://www.nu.nl) as well, which has an active userbase of well over a million.

The main driver for our NUsport app to use Firebase was the requirement for real-time updates combined with short time to market. We can truly say Firebase allowed us to meet those requirements. Previously we have built similar functionality using Node.js and websockets but, especially considering sports data is 'same for everyone'[^footnote_nusport], Firebase helps in keeping things simple and focus on features first.

The NUsport app uses 3 parts of the Firebase platform: Real-time database, Cloud messaging and Remote config. Using it at scale we went through some learnings:

* **Bandwith**. Even though a timeline is small (<1 MB), and individual additions a lot smaller than that, having hundreds of thousands of users adds up. So be on top of that. It helps to structure your data with the limiting of overhead in mind.
* **Sharding**. For NUsport capacity was sufficient. For NU.nl we needed to shard to multiple Firebase databases because a single database was not sufficient for the amount of concurrent connections needed.

## Summarizing

A very interesting event. Of course there is the 'we want you to use our product' factor, which is why it's free, but that's fine. Beyond the commercial aspect there's simply a lot of information to digest, also on a technical level. And discussing topics off-track with Googlers or people from the partner companies is inspiring and gives insights as well.

With the seemingly increasing effort Google puts into it's cloud platform I'm curious how the size of the customer base of Google and of 'that other public cloud provider' will look like next year.


 [^footnote_webscale]: Little bit of pun intended. NoSQL has it's use cases, but for data that is more structured than flat.... look at relational databases first. 
 [^footnote_nusport]: Clients can filter content, and there's some basic structuring preventing needless bandwith usage
