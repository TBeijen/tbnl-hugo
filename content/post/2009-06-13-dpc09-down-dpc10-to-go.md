---
title: DPC09 down, DPC10 to go
author: Tibo Beijen
layout: post
date: 2009-06-13T21:29:57+00:00
url: /blog/2009/06/13/dpc09-down-dpc10-to-go/
postuserpic:
  - /pa_dpc2009_80.jpg
categories:
  - events
  - report
tags:
  - dpc09
  - php

---
The [biggest PHP event in Holland][1] is over. Two great days have passed and it feels like it were just two hours. I didn&#8217;t attend the tutorial day so at friday after a brief intro by Cal Evans (with great [cartoony][2] [visuals][3]) the event kicked off with the opening keynote by Andrei Zmievski. A talk about what makes PHP the language it is and about where PHP is heading with 5.3 and 6. It had humor, appealing imagery and a nice metaphor comparing PHP to a ball of nails: &#8216;whatever you throw it at it sticks to&#8217;. For me what showed the maturity of PHP, was the fact PHP6 is undergoing (or will so) compatibility tests with respect to packages like Drupal, WordPress and Zend Framework.
  
<!--more-->


  
Next I attended Michelangelo van Dam&#8217;s talk about SPL. With some parts of SPL I was allready quite familiar but some, like SplFileInfo I have to keep in mind for later use. Although a bit short the talk gave a nice overview. I liked that performance of the SPL examples was compared to the &#8216;native&#8217; PHP approach, showing that SPL is actually _faster_. 

Michael Wittke then showed how how PHP can be compiled and run on ARM chipset based devices like the Nokia 810. A bit academic but it&#8217;s great to see the unorthodox things that _can_ be done with PHP.

After that the guys from IBM demonstrated a new platform [Websphere sMash][4]. Take a look at the site for what it&#8217;s about. I was expecting it to be more enterprise oriented and there were some powerful examples but I for myself don&#8217;t (yet) see the real advantage. Especially as using sMash-specific functions ties a developed app to the (non-free) sMash platform. On the other hand, the possibilities offered by the good integration with Java libraries like [Lucene][5] and [POI][6] looked very interesting.

Next was a talk from Stefan Esser looking security topics like SQL injection, XSS and CSRF from a Zend Framework perspective. Important topic but I must admit I didn&#8217;t get much new information out of it although preventing CSRF by subclassing Zend_Form to add a hash element was a nice example.

Last talk of the day was about how the dutch news site [nu.nl][7] is built and how it handles peak traffic. Content was the same as covered in [the techportal article][8] but it was nice to get a peek at how the CMS looks like.

The rest of the evening can be summarised with: Strand Zuid, sun, drinks, not so much food, social event, inspiring (at least for me) chats with some of the speakers, Nieuwmarkt, Leidseplein.

### Day 2

The alarm clock won the battle and I was just in time for Eli White&#8217;s presentation about scalable applications. Really great talk covering a lot of techniques for building application in such a way that database capacity can be expanded. I&#8217;m definitely going to give [the presentation slides][9] another look.

Next on schedule was Paul Reinheimer. Colleagues of mine were enthousiast about his talk of the first day and he certainly is a great speaker. Content was interesting too, touching usability aspects (I like) and addressing some pitfalls with respect to asynchronous requests and the browser&#8217;s &#8216;back button&#8217;.

After that Eli had another great talk, this time about release management. He covered SVN branching and tagging strategies, release scripts and it definitely made some of the puzzle pieces &#8216;fit&#8217;. 

The last break-out session I attended was about DTrace, a kernel module to analyse the load of the C system calls PHP executes. Good to know about the possibilities but I don&#8217;t think I&#8217;ll be going that road in the near future. Xdebug is a bit &#8216;closer&#8217;.

The event was concluded with the Cal &#038; Ivo show where Cal &#038; Ivo interviewed some of the speakers and some (twitter-) questions from the audience were answered. The tweets and images running in the background grabbed the atmosphere well and formed a nice way of closing the event.

So. A very nice event it was. Just like last year I got home full of new ideas. It&#8217;s very inspiring to meet new people that are equally enthusiast about their profession. Next year, count me in.

  * [#dpc tweets][10]
  * [Google &#8216;dpc09&#8217; search][11]
  * [Flickr &#8216;dpc09&#8217; search][12]

 [1]: http://www.phpconference.nl/
 [2]: http://www.flickr.com/photos/patrickvdvelden/3619317740/
 [3]: http://www.flickr.com/photos/mwesten/3619637934/
 [4]: http://www.projectzero.org/
 [5]: http://www.projectzero.org/blog/index.php/2008/10/28/searching-for-information-with-php-java-and-apache-lucene/
 [6]: http://www.projectzero.org/blog/index.php/2009/01/27/extract-text-from-a-ms-word-format-doc-file-from-php/
 [7]: http://www.nu.nl
 [8]: http://techportal.ibuildings.com/2009/04/23/surviving-a-plane-crash/
 [9]: http://eliw.com/presentations/
 [10]: http://twitter.com/#search?q=dpc
 [11]: http://www.google.com/search?q=dpc09
 [12]: http://www.flickr.com/search/?q=dpc09