---
title: "Reflecting on Golden Kubestronaut and Certificates"
author: Tibo Beijen
date: 2025-12-10T05:00:00+01:00
url: /2025/12/10/reflecting-on-golden-kubestronaut-certificates
categories:
  - articles
tags:
  - Kubestronaut
  - CNCF
  - Certification
  - Kubernetes
description: Reflecting on the Golden Kubestronaut title, and certification in general
thumbnail: img/c4_blastbeats_header.jpg

---

Recently I passed the last of the exams that grants the [Golden Kubestronaut](https://training.linuxfoundation.org/resources/kubestronaut-program/) title. And it was quite the journey.

About twenty years ago, I dabbled a bit in certification via PHP and Zend. Back then, PHP tried to be corporate Java, including the design patterns and certifications that come with it. And I went along. Let's say it has been a phase, in which I built quite some monstrosities [^footnote_monstrosities]. Then came a long period in which I had ample opportunity to explore and learn, not really caring much for certification. A privilege really.

Certification sometimes seems to be a divisive topic: People that have them, applaud them. People that don't, dislike them. So far I have been mostly neutral about certification: Not great, not terrible[^footnote_notgreat_notterrible].

And now I have fifteen of them. Sixteen even, if counting the odd AWS Solutions Architect Associate exam. How did that come? And did it change my look at certification? (Spoiler: Not really)

## My Kubernetes journey in a nutshell

My Kubernetes journey started in 2018. Back then I worked at [NU.nl](https://www.nu.nl), a large dutch news site. Coming from a lift-and-shift migration to AWS, we had EC2 instead of co-located VMs, but other than that, not a lot was 'cloud native'. We were struggling with managing python versions and virtual-envs on mutable infrastructure, scripted deploys and a lack of auto-scaling.

Containers were already something I was focusing on: The artifacts in our 'to-be' landscape. So when Kubernetes entered the stage, everything 'clicked': A system that allowed all of our workloads to run in a scalable, consistent way. Furthermore providing unlimited adaptability and the ability to offer great return on investment, by allowing any improvement to directly apply to all workloads: The plaform mindset.

Our new commenting platform gave us a nice, isolated greenfield project to wet our feet, we dove in, explored many topics, [made some obvious mistakes](https://www.tibobeijen.nl/2019/02/01/learning-from-kubernetes-cluster-failure/), and learned a lot.

## Why?

If already having managed to learn a lot about Kubernetes in well over six years, and working in tech for over twenty years, then why all of a sudden start with certificates?

Well, one thing lead to another. Having worked mostly with EKS, I had the CKA and CKS exams on my radar for a while. Mostly to explore where gaps in my knowledge existed.

Also, I started working for a consultancy company. In that field, certification is valued a lot, creating a nice incentive. So, the goal for me was twofold:

* First and foremost: Learn new things
* Secondary: Easily slap a badge on experience I already had

CKA, and especially CKS, did not disappoint and gave me new perspectives, along with working in a more security-focused role at DHL. But this put me in an interesting spot: Although not the initial goal, I now had completed the hard part of the Kubestronaut requirements. And, maybe more importantly: I had the feeling to have enough experience to back up the Kubestronaut title. 

So Kubestronaut I became. A title I appreciate, since it represents the open source community and ecosytem that is the CNCF landscape. Let's just say it suits me a bit better than being all-in on a single big tech corporation.

But I also found myself dreading the moment two years ahead, when the first certificate would expire. Renewing CKA and CKS I could see as somewhat valueable, the others not so much.

And then the CNCF [announced the Golden Kubestronaut program](https://www.cncf.io/announcements/2025/04/01/cncf-launches-golden-kubestronaut-program-and-expands-cloud-native-education-initiatives/), and one thing stood out:

> For life

Two paths became clear:

* Repeat the five exams every two years. A considerable amount of money and quite some effort for what feels like a chore.
* Continue the journey all the way to Golden, learning new things in the process.

Repeating the same. Or instead, exploring and learning new topics? Easy pick!

Having been immersed in the study process for most of the past year, how do I now feel about certification?

## Certification: Not great

### The value

Over the years I have worked with, and work with amazing people. Some have certificates, some don't. Frankly speaking, I don't see any correlation: Curious, motivated, smart people will show those traits, certified or not.

Taking it further, I might have even become a bit sceptical about certificates. I have interviewed candidates that had resumes filled with certificates, but couldn't even tell what role they were interviewing for, nor had any meaningful question to ask. And there have been cases of similar profiles, turning out to display no problem-solving skills, and no intrinsic motivation.

Now luckily these are outliers, and there can be factors contributing to this. Some consultancy companies are not even trying to properly match candidates or prepare them in any way. And some of the places consultants are positioned at, have a tendency to numb people down.

It just highlights that certificates _by themselves_ don't paint the full picture. To illustrate:


Diagram soft & hard skills - certificates

### The format

Some exams are just filled with facts. To me, grasping concepts is what matters. Exact details one can look up, like one does in professional life: Not verifying details, that are easy to verify, is _not_ a flex.

Looking back at for example [AWS Solutions Architect Associate](https://aws.amazon.com/certification/certified-solutions-architect-associate/): For me it has been one third learning, one third facts I forgot straight away, and one third facts that are probably outdated because of the never-ending stream of service updates[^footnote_aws_sap]. Make no mistake: I learned things, and the one third that sticks _has_ value. Just the overall experience I don't find very satisfying.

However, the performance-based exams, such as CKA and CKS gave me a much better impression: One _needs_ to have a decent understanding of the topic, and the exam might include some actual troubleshooting. Furthermore there is the ability to look up examples and command line flags so the exam format is much closer to reality.

### The learning

While studying one exam after another, I noticed some parallels with a game I used to play: [Ingress](https://ingress.com/en). Let me explain.

Ingress is a geomobile game, a predecessor to Pokemon Go. You go outside, walk around and play. Part of the game is the ability to do a mission, usually wakling around and hacking a specific set of portals in order. Completing the mission grants you a badge. Multiple mission badges might form a banner.

Let's take this banner I did at some point in Helsinki, as a metaphor:

So, when abroad for a business or city trip, it's very tempting to go out and complete a banner. The good thing is: The banner creates an incentive to go out and explore, and running into fellow players (the community!). The banner might even take you to places you otherwise wouldn't have visited.

But there are downsides as well: Everything tends to become focused on completing the banner. Instead of looking around and absorbing the atmosphere, one is looking at it's cell phone, figuring out where the next portal is. Casually ending up at a nice spot? Bummer, need to move on, train is leaving in an hour and there are badges to complete.

Studying exams tends to be a bit like that. It's prescriptive and linear. There is no creativity, no 'identifying of problems to solve'. Instead of wondering how to get the most out of an afternoon in Helsinki, the process becomes: Choose a banner that's doable in an afternoon. Follow the path, rinse and repeat.

### The visibility

Another similarity to Ingress is that the banners themselves become the talking point. Instead of talking about where to find the best _korvapuusti_ (a cinamon roll) in Helsinki, the topic becomes: What banners are you planning to do? In a way the banners can become a distraction to the experience.

Finally: Some players in Ingress are just crazy: If you happen to capture a portal at night they consider 'theirs', they get out of their bed, into their car, drive out, and capture it back. 

Now there is nothing wrong with dedication and being fanatic. The point is: There will always be other players with more badges, who get them faster, who spend more time, have more points, and be more vocal about it. That's ok, and it can be inspiring! But it can also become a rat race one gets caught up in, perhaps losing the ability to enjoy and appreciate one's own journey.

## Certification: Not terrible!

Now the previous might come across as a bit critical to certificates. I think it just illustrates that certificates can be a valuable _part of the package_, as long as they don't _become_ the package. They can help getting you into a converstion, but after that their value quickly dissipates.

Let's highlight some good parts of certification:

### Objective

We live in times where AI is able to generate very convincing content. Whether it's social media posts, open source contributions, or even one's homelab repository: It becomes increasingly hard to distinguish 'just talk' from 'also walk'. Or 'theoretical knowleged' from 'able to apply and solve problems'. Even real conversations, albeit remote, are [not immune](https://newsletter.pragmaticengineer.com/p/the-pulse-146) to 'AI augmentation'. 

Find of certification what you want, but that fact alone will make them unlikely to go anywhere soon.

### Study path




* Scalable
* Study path
* Tarifs
* Show of dedication and motivation
* Way of breaking into tech
* CNCF tech stack

One can discuss the value of certification



For all of the above one can discuss 

All of the above can help 







## The Golden Kubestronaut program

## What does it mean?

Certificates, learn from team mates, mentors, homelab, video courses, hallway tracks, 





[^footnote_monstrosities]: Let's call it my 'Gang of Four phase'
[^footnote_notgreat_notterrible]: Yes, that's a [reference](https://en.wikipedia.org/wiki/Chernobyl_(miniseries)). And one that is very relevant to tech, since it shows how bad culture will lead to very bad outcomes.
[^footnote_aws_sap]: People have told me I should try AWS Software Architect Professional instead, since it focuses more on understanding and less on facts and I'll probably like it better. Maybe...