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

This is quite unlike for example ecommerce where the holiday season can be predicted. Or big event ticket sales, where the moment tickets will start to sell, is known beforehand. With breaking news however, the moment is sudden, and the traffic surge typically is in the ballpark of 'times 4, within 4 minutes'.

At July 17th, 2014, in the afternoon, I was heading to the train station, when on our [HipChat](https://en.wikipedia.org/wiki/HipChat) channels there were messages about a missing airplane. That set in motion an evening of observing and adjusting our various systems.

## A brief history of hands-on-deck situations

Before, but also after July 2014, there have been various hands-on-deck troubleshooting sessions, which sometimes ran into the late hours. Some of the most memorable include:

### Meltdown

An afternoon where one after another 3 of our 4 webservers started to suffer from CPU exhaustion, to the point where they weren't able to keep up with the queue of rendering news pages. So for a couple of hours we were limping, fingers crossed, on the single remaining webserver that provided our 4 [Varnish](https://varnish-cache.org/) cache servers. Miraculously the problems disappeared, but we weren't able to determine the root cause. Luckily it was a one-off.

### Cache miss
Launching a complete rebuild and discovering that the performace test done by a third party, had thoroughly tested Varnish, but not the actual web site in 'cache miss' scenario. We already knew Varnish is great. We learned in a painful way to take more control when involving third parties.

### DDoS
Site being DDoS-ed. This might have been around 2014 as well. CDNs weren't as prevalent back then, so Varnish and HAproxy where the internet-facing components. Our manager back then did the best thing he could do: Handle stakeholder-comms and fetch ~~dinner~~ Döner, while a colleague and I were digging through various metrics. Turned out we were attacked by a [SYN flood](https://en.wikipedia.org/wiki/SYN_flood). 

After some rather fruitless mitigation attempts, we ultimately had our datacenter configure the Netscaler firewall with a geo-block, targeting Asia and South America, the origins of our malformed traffic. 

Blocking a couple of continents was not decided lightly, but considering being a Dutch news site, it was deemed acceptable for a brief period. The digital vandals got bored, disappeared, and the next day we lifted the geo restriction.

And, as these things go, a CDN with DDoS mitigation capabilities got prioritized.

### A sunny afternoon

Besides things breaking down in various ways, normal, legitimate traffic can cause quite some impact as well. And that sunny 2014 day might have been one of the busiest days in NU.nl history.

## Breaking News

I remember it was a bright, sunny afternoon, and I just left the Sanoma office in Hoofddorp. Heading to the train station, someone mentioned on HipChat that a plane had gone missing above Ukraine. I'm not sure if it was in an editor channel, or one of our team members giving us a heads up of a possible breaking news push coming up.

Either way, I checked the [Flightradar](https://www.flightradar24.com/) link to the missing airplane and I can remember noticing the altitude graph showed no descend, but just 'stopped'. Worried, but hoping it would turn out to be just a transponder failure, I knew editors were busy trying to get information _and_ confirmation from authorities and sources such as [ANP](https://www.anp.nl/).

Unsurprisingly, while still commuting, a breaking news push message appeared on my NU.nl mobile app:

> 17:13 Passenger aircraft, flying from Amsterdam, crashed over Ukraine 

## Dealing with high-volume traffic

### Anatomy of a push message

Let's see what happens when a 'breaking news' push is sent out:

* Editors mark a news article as 'breaking' and publish it.
* This triggers our 'push notification service', containing basic details like title and article id.
* The push notification service has a list of subscribed device ids and invokes the push APIs of Google and Apple.
* Within a couple of minutes, millions of Android and iOS devices receive the NU.nl push message.
* A certain percentage of users, more or less immediately opens the article. This results in traffic to our web-facing systems.
* This percentage depends greatly on the nature of the news and the time of day. At the end of afternoons, traffic is normally already high. This news had a high 'open rate'[^footnote_open_rate].
* After the initial burst of traffic, traffic volume ebbs down but remains high for a certain period. Also people find their way to the desktop website where traffic will go up.

TODO: Graph traffic burst

### Handling traffic anno 2014

Mid 2014 we had an API stack, based on Python and Django, that was providing data to the mobile apps. Furthermore, we had a stack delivering the website, based on PHP[^footnote_surviving_a_plane_crash]. We were in the process of building a brand new, responsive website _on top_ of API that was already used by the mobile app.

Everything was running on co-located hardware in two datacenters. No Cloud. No CDN. No horizontal or vertical scaling options.

Caching was the game, and we had become quite good at that. At the edge we used Varnish, an amazing product with stellar performance[^footnote_fastly]. Within applications, we used memcache in the old PHP parts, and Redis in the Python applications. Because of the various layers of cache, even during traffic bursts, the underlying MySQL database saw hardly any traffic increase and was not a component to worry about.

Video and images were handled by the 'mediatool' service, hosted in the same datacenters, having a similar setup: Varnish taking the brunt of the traffic impact.

A schematic view of our setup:

Traffic hitting one of our systems could result in the following caching scenarios:

* Cache hit by Varnish: _Extremely fast, very few system resources used_
* Cache miss by varnish, pregenerated HTML on desktop site: _Quite fast, some system resources used_
* Cache miss by, dynamically generated content: _Not so fast, most resource intensive_

### Metrics to check and knobs to dial

At moments where the amount of traffic is extraordinally high, there were some metrics to check:

* Varnish

    * Cache hit ratio - Needs to be high, a drop in that will cause extra load on the web servers
    * Cache evictions - Varnish memory usage will not just increase, it is fairly constant since Varnish will purge cache following lru. Will reflect on cache hit ratio as well. 
    * CPU - This is proportional to traffic.

    



https://en.wikipedia.org/wiki/Malaysia_Airlines_Flight_17


[^footnote_open_rate]: One might think it's the impactful news items that have the highest open rate, but actually the more gossipy articles tend to rank the highest.
[^footnote_surviving_a_plane_crash]: The website stack was, at a high level, still similar to the one described in a talk "[Surviving a Plane Crash](https://www.slideshare.net/peter_ibuildings/surviving-a-plane-crash)" at the Dutch PHP Conference in 2009. A [different plane crash](https://en.wikipedia.org/wiki/Turkish_Airlines_Flight_1951) by the way.
[^footnote_fastly]: Varnish is so good, [Fastly built it's CDN on top of it](https://www.fastly.com/blog/benefits-using-varnish/).