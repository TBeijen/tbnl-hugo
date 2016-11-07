---
title: Linux-Fu @ phpGG
author: Tibo Beijen
layout: post
date: 2009-04-17T07:32:52+00:00
url: /blog/2009/04/17/linux-fu-phpgg/
postuserpic:
  - /pa_phpgg_80.gif
categories:
  - events
  - report
tags:
  - bash
  - linux
  - php
  - phpgg

---
Last night there was a phpGG (dutch php user group) [meeting][1] in Utrecht with a presentation by [Lorna Jane][2] titled &#8216;Linux-Fu&#8217;. Attended by about 10 people, console basics &#038; tricks were addressed. I&#8217;m not unfamiliar with Linux so the basics weren&#8217;t that new. For development I mainly use IDE&#8217;s so I just use the console to edit the occasional config file, create some symlinks, that kind of stuff. For those tasks I find myself sticking to set of commands I&#8217;ve learned and just occasionally taking the time to do an in-depth google search for better ways to get the job done. So with regard to linux shell trickery there are things to learn for me. Neat timesavers:

Switching between current and previous directory:

<pre lang="bash">cd -</pre>

Going home can be done without the ~:

<pre lang="bash">cd</pre>

How &#8216;grep&#8217; can beat your IDE. I&#8217;ve been playing around a bit and this is really a quick way of finding all classes within a directory that implement an interface (and it&#8217;s fast!):

<pre lang="bash">grep -i -r 'class ' . | grep implements</pre>

And there&#8217;s &#8216;screen&#8217;. Very useful for handling multiple terminal sessions without the risk of losing them all due to a connection hick-up. Lorna has [some config examples][3] on her site.

So not all was new but there were definitely some nice starting points to investigate further.

 [1]: http://www.phpgg.nl/april2009
 [2]: http://www.lornajane.net/posts/2009/Speaking-at-phpGG
 [3]: http://www.lornajane.net/posts/2008/Colourful-Tabs-in-Screen