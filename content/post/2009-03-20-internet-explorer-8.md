---
title: Internet Explorer 8
author: Tibo Beijen
date: 2009-03-20T08:32:07+00:00
url: /blog/2009/03/20/internet-explorer-8/
postuserpic:
  - /pa_internetexplorer_80.jpg
categories:
  - miscellaneous
tags:
  - internet explorer
  - microsoft

---
Yesterday Internet Explorer 8 is released. I consider that a good things as it will move more people farther away from the severe case of release abuse called IE6. [Improvements][1] include integrated developer tools for css analysis and script profiling and debugging. 

And there is &#8216;Compatibility View&#8217;. Developers can specify, by adding a specific meta tag, that IE7 rendering should be used. There seem to be some tricky aspects related to Compatibility View:

  * It&#8217;s [not 100% compatible][2] with the &#8216;real&#8217; IE7
  * For intranets IE8 will behave differently, using [smart defaults based on zone evaluation][3]. That by itself sounds alarming. What it means is that Microsoft (and sadly they&#8217;re right) assumes that a lot of intranets, also called line of business applications, will malfunction when confronted with a new browser.

The latter will be something to take into account when developing and testing intranets. Another concern I heard about (and share) is that if a lot of developers will start using Compatibility View, a lot of bad practices will stick around and development for IE as a whole will &#8216;freeze&#8217;. Instead of move forward to a more standards compliant level.

As [IE6 isn&#8217;t dead yet][4] there are now _three_ IE versions to test for. Microsoft offers free downloadable virtual machines with IEx installed as a solution. Virtualization is &#8216;hot&#8217; but some might find Microsoft&#8217;s solution a bit of a hassle. [IETester][5] looks like a nice alternative (haven&#8217;t tried it yet) altough it seems to require Vista.

 [1]: http://msdn.microsoft.com/en-us/library/cc288472(VS.85).aspx
 [2]: http://blogs.msdn.com/ie/archive/2009/03/12/site-compatibility-and-ie8.aspx
 [3]: http://blogs.msdn.com/ie/archive/2008/08/27/introducing-compatibility-view.aspx
 [4]: http://www.thecounter.com/stats/2009/February/browser.php
 [5]: http://my-debugbar.com/wiki/IETester/HomePage