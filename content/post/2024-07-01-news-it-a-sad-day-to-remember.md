---
title: "Working in News IT: A sad day to remember"
author: Tibo Beijen
date: 2024-07-01T05:00:00+01:00
url: /2024/07/01/news-it-a-sad-day-to-remember
categories:
  - articles
tags:
  - Breaking news
  - NU.nl
  - SRE
  - MH17
  - Ukraine
description: One of the most impactful news events of the Netherlands, as experienced from a News IT team
thumbnail: img/lego_house_wash_hands.jpg

---

When dealing with traffic of a news site, one quickly learns to expect the unexpected: You know there will be traffic surges, but you can not predict when they will be. 

This is quite unlike for example ecommerce where the holiday season can be predicted. Or big event ticket sales, where the moment tickets will start to sell, is known beforehand. With breaking news however, the moment is sudden, and the traffic surge typically is in the ballpark of 'times 4 within 4 minutes'.

At July 17th, 2014, in the afternoon, I was heading to the train station, when a breaking push was sent out: "Plane gone missing". That set in motion an evening of observing and adjusting our various systems.

## A history of hands-on-deck situations

Before, but also after July 2014, there have been various hands-on-deck troubleshooting sessions, which sometimes ran into the late hours. Some of the most memorable include:

* An afternoon where one after another 3 of our 4 webservers started to suffer from CPU exhaustion, to the point where they weren't able to keep up with the queue of rendering news pages. So for a couple of hours we were limping, fingers crossed, on the single remaining webserver that provided our 4 Varnish cache servers. Miraculously the problems disappeared, but we weren't able to determine the root cause. Luckily it was a one-off.
* Launching a complete rebuild and discovering that the performace test done by a third party, had thoroughly tested Varnish, but not the actual web site in 'cache miss' scenario. We already knew Varnish is great. We learned to take more control when involving third parties. 
* Site being DDoS-ed. This might have been around 2014 as well. CDNs weren't as prevalent back then, so Varnish and HAproxy where the internet-facing components. Our manager back then did the best thing he could do: Handle stakeholder-comms and fetch ~~dinner~~ Döner, while a colleague and I were digging through various metrics. Turned out we were attacked by a [SYN flood](https://en.wikipedia.org/wiki/SYN_flood). 