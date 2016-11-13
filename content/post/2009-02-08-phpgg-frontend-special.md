---
title: PHPgg Frontend Special
author: Tibo Beijen
date: 2009-02-08T12:18:42+00:00
url: /blog/2009/02/08/phpgg-frontend-special/
postuserpic:
  - /pa_phpgg_80.gif
categories:
  - report
tags:
  - adobe
  - frontend
  - javascript
  - microsoft
  - php
  - phpgg

---
Last saturday (2009 jan 24th) I attended the [phpGG Frontend Special][1]. phpGG stands for &#8216;PHP Gebruikersgroep&#8217; which translates to &#8216;PHP user group&#8217;. The meeting was held in a nice little theater in The Hague and was attended by what looked like about 50 people. The four main presentations scheduled:

  * Microsoft &#8211; User Experience on the web
  * Adobe &#8211; Flex/AIR 
  * Javascript &#8211; 8 Reasons every PHP developer should love it 
  * The frontend is your friend

<!--more-->

### Microsoft &#8211; User Experience on the web

First speaker was Bram Veenhof, of whom I allready attended a presentation two months ago. Here the available time was more limited so less subjects were covered. He started with some coverage on the forthcoming Windows 7. Interesting features were addressed like: Dockable windows, swappable taskbar buttons and functionallity in preview windows. Next on was Silverlight and most specifically the video and deepzoom capabilities. 

Two parts that were both interesting in their own right but not really connected to each other. In my opinion he had better addressed the XAML, Javascript integration some more. I think that is one of the strong points of Silverlight when it comes to smooth integration in a PHP driven application. 

### Adobe &#8211; Flex/AIR

Next on was Mihai Corlan, Adobe Platform Evangelist as he described himself. First part of his presentation was about Flex. For me it&#8217;s been a while since I&#8217;ve done Flash Development so I was curious about what&#8217;s happening on the Adobe front. Mihai summarized Flex as &#8216;Just another way to create a Flash app&#8217;. The Flex platform consists of:

  * 2 Languages: MXML and Actionscript 3
  * Compilers
  * Rich Component Library
  * Debuggers
  * Flex SDK (Open Source) 
  * Flex Builder IDE (Eclipse so it runs nice alongside Zend Studio)

As for the benefit of RIA&#8217;s he showed a little demo of a very graphical intuitive interface allowing users to report details about car damage. 

After the topic was Adobe Air. Adobe Air allows web developers to develop beyond the browser. Api&#8217;s like file access, drag &#038; drop, allow for desktop apps to be developed using techniques familiar to Flash/Flex developers. Very interesting and probably much easier than starting to learn writing apps in Objective C or Java. 

The link to PHP was addressed by the way Flex and Air applications communicate with online back-end software: REST, Web Services and RPC. Areas where PHP is at it&#8217;s best, especially with the arrival of Zend Framework&#8217;s AMF component. The AMF component provides RPC connectivity that is easy to implement and very efficient. 

### Javascript &#8211; 8 Reasons every PHP developer should love it

After a good lunch and a couple of short talks by phpwomen, fronteers and phpGG it was Boy Baukema&#8217;s (Ibuildings) turn to (try to) make PHP developers like Javascript. On the technical side he pointed out some similarities like closures and closures. Furthermore he showed statics telling us that less than 1% of today&#8217;s user agents don&#8217;t support javascript. This includes search engines and paranoids. After his presentation he repeated his question about how many of us like javascript. I couldn&#8217;t tell much difference but then again, 40 minutes is very little time to convert server-side freaks. In my opinion liking javascript starts with liking to create a good user experience. If you do, you&#8217;ll probably also like Flash and Silverlight. If you don&#8217;t, no problem. Leave it to people who do.

### The frontend is your friend

The last presentation of the day was given by Robert Jan Verkade (Eend). Interesting and graphically of high quality. Something tells me Robert Jan is a fan of Queen. He focused on the different stakeholders involved in a project and how they interact: The front-end (HTML, CSS, JS), The back-end (PHP), the users and the contractor. He showed some examples of good and bad practice. Most notable advices on of good practice where reducing the number of external css and javascript files and placing javascript at the bottom of the page. Furthermore he had some good tips on how php- and frontend developers can make eachother&#8217;s lives a bit easier. (PHP-ers: Don&#8217;t mess with the HTML! :)).

He put quite some emphasis on valid HTML so I couldn&#8217;t resist asking about wether he meant &#8216;valid&#8217; or &#8216;well formed&#8217; and what his opinion was on using non-W3C attributes to drive javascript behaviour (something I&#8217;m very pragmatic about). An entirely different discussion that doesn&#8217;t need a winner but I was curious if he or someone else would have some interesting (for me new) views on the subject. Somebody in the audience mentioned that custom attributes are part of the HTML5 recommendation. So the topic is definitively &#8216;out there&#8217;.

Conclusion: A nice day. Interesting subject and interesting presentations. And of course it&#8217;s nice to meet some new people working in this field. As it pointed out phpGG has just recently become more active again after having been dormant for a long period. So on that part 2009 looks promising.

For the web 2.0 afficionados: [Flickr][2] & [Twitter][3]

 [1]: http://phpgg.nl/frontendspecial2008
 [2]: http://www.flickr.com/photos/tags/phpggfs/
 [3]: http://search.twitter.com/search?q=phpggfs