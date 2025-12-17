---
title: "Reflecting on certification and Golden Kubestronaut"
author: Tibo Beijen
date: 2025-12-17T05:00:00+01:00
url: /2025/12/17/reflecting-on-certification-golden-kubestronaut
categories:
  - articles
tags:
  - Kubestronaut
  - CNCF
  - Certification
  - Kubernetes
description: Reflecting on certification and the Golden Kubestronaut title
thumbnail: img/certification-header.jpg

---

Recently I passed the last of the exams that grants the [Golden Kubestronaut](https://training.linuxfoundation.org/resources/kubestronaut-program/) title. And it was quite the journey.

About fifteen years ago, I dabbled a bit in certification via PHP and Zend. Back then, PHP tried to be corporate Java, including the design patterns and certifications that come with it. And I went along! Let's say it has been a phase, in which I built quite some monstrosities [^footnote_monstrosities]. Then came a long period in which I had ample opportunity to explore and learn, not really needing or caring much for certification. A privilege in a way.

Certification sometimes seems to be a divisive topic: People that have them, applaud them. People that don't, dislike them. So far I have been mostly neutral about certification: Not great, not terrible[^footnote_notgreat_notterrible].

And now I have fifteen of them. Sixteen even, if counting the odd AWS Solutions Architect Associate exam. How did that come? And did it change my look at certification? (Spoiler: Not really)

{{< figure src="/img/certification-kubestronauts.jpg" title="Kubestronauts reflecting on their accomplishments. Source: AI augmented with Powerpoint and WTF-8" >}}

## My Kubernetes journey in a nutshell

My Kubernetes journey started in 2018. Back then I worked at [NU.nl](https://www.nu.nl), a large Dutch news site. Coming from a lift-and-shift migration to AWS, we had EC2 instead of co-located VMs, but other than that, not a lot was 'cloud native'. We were struggling with managing Python versions and virtual-envs on mutable infrastructure, scripted deploys and a lack of auto-scaling.

Containers were already something I was focusing on: The artifacts in our 'to-be' landscape. So when Kubernetes entered the stage, everything 'clicked': A system that allowed all of our workloads to run in a scalable, consistent way. Furthermore providing unlimited adaptability and the ability to offer great return on investment, by allowing any improvement to directly apply to all workloads: The platform mindset.

Our new commenting system gave us a nice, isolated greenfield project to get our feet wet, we dove in, explored many topics, [made some obvious mistakes](https://www.tibobeijen.nl/2019/02/01/learning-from-kubernetes-cluster-failure/), and learned a lot.

## Why?

If already having managed to learn a lot about Kubernetes in well over seven years, and working in tech for over twenty years, then why all of a sudden start with certificates?

Well, one thing led to another. Having worked mostly with EKS, I had the CKA and CKS exams on my radar for a while. Mostly to explore where gaps in my knowledge existed.

Also, I started working for a consultancy company. In that field, certification is valued a lot, creating a nice incentive. So, the goal for me was twofold:

* First and foremost: Learn new things
* Secondary: Easily slap a badge on experience I already had

CKA, and especially CKS, did not disappoint and gave me new perspectives, along with changing jobs and working in a more security-focused role. But this put me in an interesting spot: Although not the initial goal, I now had completed the hard part of the Kubestronaut requirements. And, maybe more importantly: I felt I had enough experience to back up the Kubestronaut title. 

Kubestronaut I became. A title I appreciate, since it represents the open source community and ecosystem that is the CNCF landscape. Let's just say it suits me a bit better than being all-in on a single big tech corporation.

But I also found myself dreading the moment two years ahead, when the first certificate would expire. Renewing CKS I could see as somewhat valuable, refreshing my knowledge. The others not so much.

And then the CNCF [announced the Golden Kubestronaut program](https://www.cncf.io/announcements/2025/04/01/cncf-launches-golden-kubestronaut-program-and-expands-cloud-native-education-initiatives/), and one thing stood out:

> For life

Three paths became clear:

* Just don't bother, enjoy the two years of Kubestronaut and let it all expire.
* Repeat the five exams every two years. A considerable amount of money and quite some effort for what feels like a chore.
* Continue the journey all the way to Golden, learning new things in the process.

Losing things (the horror!). Repeating the same. Or instead, exploring and learning new topics? Easy pick!

Having been immersed in the study process for quite some months, how do I now feel about certification?

## Certification: Not great

### The value

Over the years I have worked with, and work with amazing people. Some have certificates, some don't. Frankly speaking, I don't see any correlation: Curious, motivated, smart people will show those traits, certified or not.

Taking it further, I might have even become a bit skeptical about certificates. I have interviewed candidates with resumes full of certificates who couldn't tell what role they were interviewing for, or struggled to ask meaningful questions. And there have been cases of similar profiles being hired, but then having a hard time showing problem-solving skills or motivation.

These are outliers, and the system can set people up to fail: Not all consultancy shops value proper matching or preparation, and some client environments have a culture that numbs people down.

It just highlights that certificates _by themselves_ don't paint the full picture. To illustrate:

<iv style="width:50%;margin:0 auto">
{{< figure src="/img/certification-matrix.svg" title="Balancing certification and soft and hard skills" >}}
</div>

### The format

Some exams are just filled with facts. To me, grasping concepts is what matters. Exact details one can look up, like one does in professional life: Not verifying details, that are easy to verify, is _not_ a flex.

Looking back at for example [AWS Solutions Architect Associate](https://aws.amazon.com/certification/certified-solutions-architect-associate/): For me it has been one third learning, one third facts I forgot straight away, and one third facts that are probably outdated because of the never-ending stream of service updates[^footnote_aws_sap]. That's two third being facts one can and should look up anyway. Make no mistake: I learned things, and the one third that sticks _has_ value. Just the overall experience I don't find very satisfying.

However, the performance-based exams, such as CKA and CKS gave me a much better impression: One _needs_ to have a decent understanding of the topic, and the exam might include some actual troubleshooting. Furthermore there is the ability to look up examples and command line flags so the exam format is much closer to reality.

### The learning

While studying one exam after another, I noticed some parallels with a game I used to play: [Ingress](https://ingress.com/en). Let me explain.

Ingress is a geomobile game, a predecessor to Pokemon Go. You go outside, walk around and play. Part of the game is the ability to do a mission, usually walking around and hacking a specific set of portals in order. Completing the mission grants you a badge. Multiple mission badges might form a banner.

Let's take this banner I did at some point in Helsinki, as a metaphor:

{{< figure src="/img/certification-ingress-helsinki.jpg" title="Ingress banner that can be accomplished in Helsinki" >}}

So, when abroad for a business or city trip, it's very tempting to go out and complete a banner. The good thing is: The banner creates an incentive to go out and explore, and running into fellow players (the community!). The banner might even take you to places you otherwise wouldn't have visited.

But there are downsides as well: Everything tends to become focused on completing the banner. Instead of looking around and absorbing the atmosphere, one is looking at its cell phone, figuring out where the next portal is. Casually ending up at a nice spot? Bummer, need to move on, train is leaving in an hour and there are badges to complete.

Studying exams tends to be a bit like that. It's prescriptive and linear. There is no creativity, no 'identifying of problems to solve'. The focus shifts from exploring to time management. Instead of wondering how to get the most out of an afternoon in Helsinki, the process becomes: Choose a banner that's doable in an afternoon. Follow the path, rinse and repeat.

### The visibility

Another similarity to Ingress is that the banners themselves become the talking point. Instead of talking about where to find the best _korvapuusti_ (a cinnamon roll) in Helsinki, the topic becomes: What banners are you planning to do? In a way the banners can become a distraction to the experience.

Finally: Some players in Ingress are just crazy: If you happen to capture a portal at night they consider 'theirs', they get out of their bed, into their car, drive out, and capture it back. 

Now there is nothing wrong with dedication and being fanatic. The point is: There will always be other players with more badges, who get them faster, who spend more time, have more points, and be more vocal about it. That's ok, and it can be inspiring! But it can also become a rat race one gets caught up in, perhaps losing the ability to enjoy and appreciate one's own journey.

## Certification: Not terrible!

Now the previous might come across as a bit critical to certificates. I think it just illustrates that certificates can be a valuable _part of the package_, as long as they don't _become_ the package. They can help getting you into a conversation, but after that their value quickly dissipates.

Let's highlight some good parts of certification:

### Objective

We live in times where AI is able to generate very convincing content. Whether it's social media posts, open source contributions, or even one's homelab repository: It becomes increasingly hard to distinguish 'just talk' from 'also walk'. Even hiring interviews, albeit remote, are [not immune](https://newsletter.pragmaticengineer.com/p/the-pulse-146) to 'AI augmentation'. 

Think what you will about certification, but that fact alone makes certifications unlikely to go anywhere soon.

### Study path

Some topics lend themselves to explore via a homelab or pet project, or by contributing to an open source project. But it requires coming up with an idea first, or find a suitable 'first issue', so there might be a bit of a barrier. And, when having passed that barrier, you might find yourself deep diving into parts of a topic, while skipping others. 

When looking at learning from that perspective, the aforementioned linear nature of certificate study, has an upside as well: It is easy to 'just start' and the curriculum will make sure you at least touch various topics at a basic level.

Furthermore, there are certifications, like [CISSP](https://en.wikipedia.org/wiki/Certified_Information_Systems_Security_Professional), that are not technical. There simply is no pet project for that subject matter.

### Scalable

Recruiters might filter resumes on certificates because it's so easy to measure. It scales. I can't say I particularly endorse this gatekeeping aspect of certification, but it is what it is. And, trying to apply a 'glass half-full approach', when having certificates, this scaling can benefit candidates as well and more easily get you noticed.

### Show of dedication

Dedication and motivation comes in many forms, and studying is one of them. While mostly theoretical, so probably best balanced by more hands-on ways of learning, it _is_ a way of learning. And the time it takes is real.

### Breaking into tech

If trying to land your first job in tech, you might not have existing work to show. Certification _might_ help, but choose wisely, you can spend your money and time only once. 

For example: Spend $100 on a refurbished mini PC, or a couple of years worth of Hetzner VMs, then slap on ArgoCD, turn it inside out, while coding and posting about your learnings. That might very well be money better spent, than the [GitOps Associate](https://training.linuxfoundation.org/certification/certified-gitops-associate-cgoa/) exam.

Balance probably is key here. If also demonstrating hands-on ability, then certification _might_ help with the aforementioned scalability, and put some additional visibility on the dedication one has.

There are many people on LinkedIn, mentoring and coaching people to land their first job. Absorb what they have to say.

### Tariffs

Whether you are a freelance professional, or work for a consultancy company, tariffs need to be negotiated. Referrals can help. But even then: Being a great dependable team player, one of most important qualities to have, can still be hard to price into a higher tariff.

### CNCF adoption in corporates

Big companies are risk averse. They happily pay vendors or training centers large sums of money to be able to choose paved paths. Can we buy 'premium support'? Can we hire trained people? The classic "Nobody ever got fired for buying IBM"[^footnote_ibm]. 

While Kubernetes itself can be considered pretty much established, the entire CNCF landscape is not there yet. Big vendors such as AWS, Microsoft all have certification programs and partner programs, that allow corporates to buy off risk. 

Certification, as well as the project governance by the CNCF, will help in putting open source solutions on the map of big, risk-averse organizations.

## The Golden Kubestronaut program

When looking at the Kubestronaut program, one can observe a clear trajectory:

* Kubestronaut: Focuses on the core itself, deeply understanding Kubernetes, culminating in the CKS exam.
* Golden Kubestronaut: Advances into the wider ecosystem. The additional components one needs to turn Kubernetes into a usable platform, such as observability, policies and advanced networking.

Now, if looking at difficulty, the arc flattens a bit when going from Kubestronaut to Golden Kubestronaut. The sheer volume is the main challenge, but CKS I still find the hardest exam of the entire series. And if I had to recommend a single one, it would be CKS, hands down.

Interestingly, two exams are coming that might bend the flattened arc upwards a bit:

* [Cloud Native Platform Engineer (CNPE)](https://training.linuxfoundation.org/certification/certified-cloud-native-platform-engineer-cnpe/). A hands-on exam, launched in November, and a requirement for Golden Kubestronaut starting March. 1st 2026. It is perceived as quite difficult by the first takers.
* [Certified Kubernetes Network Engineer (CKNE)](https://training.linuxfoundation.org/kubernetes-network-engineer-program/). Not a lot is known yet, but it is announced to be a 'practical exam'.

By the looks of it, those two will be worthy additions to the Golden Kubestronaut program, adding a bit more depth to the vast breadth.

The CNCF exams are not cheap at $250 for associate, and $445 for hands-on exams. So, there is a bit of a pay-to-win ring to it. But in their defence:

* There are bundles which reduce cost by about 10% when comparing to the individual exams
* Most importantly: There are occasional reductions of 50% and sometimes even 60%!
* Purchases are valid for a year. So you can buy during one of the reductions, even if studying does not fit your schedule immediately
* A re-take is included in case you fail the first attempt
* Most of the hands-on exams include two [killer.sh](https://killer.sh/) practice exams, which are very valuable

The validity of two years is rather short, and sadly CNCF (nor AWS for that matter) offer the [renewal procedure that Microsoft does](https://learn.microsoft.com/en-us/credentials/certifications/renew-your-microsoft-certification).

It's serious money one needs to budget, but from a CNCF perspective perhaps not the cash-grab some people claim it to be. Looking at the [2024 report](https://www.cncf.io/reports/cncf-annual-report-2024/), training makes up 7.5% of fundraising, although, given the very marketable Kubestronaut program, I expect this figure to be higher in 2025.

Finally, I can't help but think [Linux Foundation Certified System Administrator (LFCS)](https://training.linuxfoundation.org/certification/linux-foundation-certified-sysadmin-lfcs/) would fit better in the regular Kubestronaut program. Linux is the foundation on top of which all other parts are built. Now it feels a bit like an afterthought.

## What does it mean?

There are many, many ways to learn: Working in a team, colleagues and mentors, pet projects, contributing to open source, video courses, conference talks, attending meetups or conferences, fixing things at 2am and wondering how to prevent the next mishap. 

More on the educating side of things, mentoring, training people, conducting workshops, speaking, writing, are ways of learning as well. And that is just professional life. Building character for a large part happens in personal life.

Each have their strong and weak points: A homelab is a great source of experimenting and learning, but doesn't have the scale at which a lack of automation becomes painful. A video course, while informative, might not 'click' until one encounters the topic in professional life. Similarly, studying certification brings knowledge, but does not focus on the ability to explain things to non-technical stakeholders.

So, all of the above contribute to personal growth in different ways, and in that regard, certification is no different. But, let's face it, certificates are a very visible component of personal branding. And that's ok, but it probably attributes to their sometimes mixed response. The diagram in the 'value' section, in my opinion, illustrates the pitfall to avoid. 

As I stated in my [LinkedIn post](https://www.linkedin.com/posts/tibobeijen_kubestronaut-goldenkubestronaut-cncf-activity-7401881647786278913-rCV5), I see the Golden Kubestronaut title foremost as raising the bar of the professional that I aspire to be, and perhaps a bit as a display of dedication and perseverance. 

If I visit a community event, for every certificate I now have, there will be people with deeper experience on that topic. Great people to learn from and talk to. And there will be people contributing a _lot_ to the community. Nothing changed about that, and if anything, the title emphasizes the need to keep learning, and bring a balanced perspective into any conversation.

Would I recommend it? Sure! Read the above, and if you're still enthusiastic, go for it! It's rewarding and you will grow as a professional. But ultimately: Learning is key and certification is just one of the many learning paths. It is worth noting though, that I am well aware of being in a privileged position: To be able to consider certification a 'nice to have'. 

What stayed the same? The questions one asks, are often more interesting than the education one shows.

Thoughts? Don't hesitate to find me on [LinkedIn](https://www.linkedin.com/in/tibobeijen/), [BlueSky](https://bsky.app/profile/tibobeijen.nl) or [CNCF Slack](https://cloud-native.slack.com/archives/D018RE9CA4T).

[^footnote_monstrosities]: Let's call it my [Gang of Four](https://martinfowler.com/bliki/GangOfFour.html) phase
[^footnote_notgreat_notterrible]: Yes, that's a [reference](https://en.wikipedia.org/wiki/Chernobyl_(miniseries)). And one that is very relevant to tech, since it shows how bad culture will lead to very bad outcomes.
[^footnote_aws_sap]: People have told me I should try AWS Software Architect Professional instead, since it focuses more on understanding and less on facts and I'll probably like it better. Maybe...
[^footnote_ibm]: Emphasis on _classic_. Not sure if picking IBM is as safe these days.
