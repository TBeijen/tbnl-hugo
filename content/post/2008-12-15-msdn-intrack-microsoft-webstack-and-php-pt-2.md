---
title: 'MSDN InTrack: Microsoft Webstack and PHP Pt. 2'
author: Tibo Beijen
date: 2008-12-15T11:38:25+00:00
url: /blog/2008/12/15/msdn-intrack-microsoft-webstack-and-php-pt-2/
postuserpic:
  - /pa_msdn_php_80.gif
categories:
  - report
tags:
  - microsoft
  - msdn
  - php
  - silverlight

---
Following my first post on the MSDN inTrack day I&#8217;ll now cover the second half of the day. The two topics featured were the presentation side of things and the Microsoft Live platform.
  
<!--more-->

### Presentation

In this part different topics were addressed such as Microsoft Software of interest for PHP developers, the forthcoming Internet Explorer 8 and (of course) Silverlight.

#### Expression

Microsoft apparently has a whole new range of development software called &#8216;Expression <insert flavor here>&#8216;. Akin to Vista there are different flavors and akin to Vista that may cause confusion. Most emphasis was on &#8216;Expression Web&#8217;, a WYSIWYG editor replacing Frontpage. It looked quite decent in it&#8217;s own right but it is no IDE like Zend Studio. I think in PHP environments it&#8217;s most suited towards front-end developers who are mainly focused on templating.

#### IE 8

It looks like Internet Explorer 8 will have some very welcome features. (In my opinion just the fact that there will be an IE8 is a good thing as that will make IE6 &#8216;really old&#8217; and hopefully extinct soon. Good news for anyone involved in CSS and JS coding). For developers interesting features will be:

  * JS-debugger with breakpoints and all (no more mystery line-numbers)
  * By default a web developer toolbar
  * [Code profiler][1] (think: Yslow)

Promising indeed. Now what remains on my wish-list is an easy way to run IE6 and IE7 alongside IE8&#8230;

#### Silverlight

On to Silverlight. One can&#8217;t but have noticed Microsoft is promoting it&#8217;s new web technology. And while Microsoft bashers will probably keep seeing it as &#8216;Just a M$ alternative to Flash&#8217;, it has some very nice features. Apparantly Silverlight is very powerful when it comes to handling video. A fine example was given in the form of last year&#8217;s [Amstel Gold coverage][2] featuring a single stream showing different camera&#8217;s. Another nice feature is Deep Zoom of which two interesting examples were shown: [Hard Rock Memorabilia][3] and [Yosemite park][4]. Not needed in your typical CMS application but very nice nevertheless.

But what I liked most about Silverlight (besides the obvious show-off examples) was the way it integrates into a HTML page: Silverlight events will be [processed by the page&#8217;s javascript][5]. This means that when developing RIA&#8217;s all of the behaviour scripting can be centralised and will cover both HTML and Silverlight parts of the page. Furthermore, Silverlight object elements can be [accessed in a way similar to the HTML DOM][6]. I haven&#8217;t yet worked with Silverlight but based on this I expect integration to be smooth.

### Live Platform

Final part of the day was about Microsoft&#8217;s Live Platform. Different features were showcased, like easily publishing video content by using Expression <insert video flavour>. Neat in it&#8217;s own right but the relation to PHP was as thin as any web service. Most interesting I found the existence of Sky Drive. 25Gb of free storage. I&#8217;ll keep that in mind if I need to share the occasional file.

Concluding: Espcially the IIS and Silverlight parts were of real interest from a PHP developer&#8217;s perspective. Some of the other subjects were &#8216;nice to know&#8217; and came across as more &#8216;promotional&#8217; than &#8216;informative&#8217;. That aside, it looks like Microsoft is well aware of the increasing popularity of PHP. I wouldn&#8217;t be surprised if Silverlight will make it&#8217;s way into quite some PHP applications.

 [1]: http://msdn.microsoft.com/en-us/library/cc848895(VS.85).aspx
 [2]: http://wielrennen.nos.nl/index/silverlight
 [3]: http://memorabilia.hardrock.com/
 [4]: http://www.xrez.com/yose_proj/yose_deepzoom/new/XRez%20Xtreme%20Pano/index.html
 [5]: http://msdn.microsoft.com/en-us/library/cc189042(VS.95).aspx
 [6]: http://msdn.microsoft.com/en-us/library/cc903955(VS.95).aspx