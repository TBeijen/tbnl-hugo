---
title: 'Thousands of modules can&#8217;t be wrong, right?'
author: Tibo Beijen
layout: post
date: 2009-02-20T17:48:58+00:00
url: /blog/2009/02/20/thousands-of-modules-cant-be-wrong-right/
postuserpic:
  - /pa_drupal_80.gif
categories:
  - articles
tags:
  - customization
  - drupal
  - joomla!
  - open source
  - php
  - project management
  - wordpress

---
Yesterday I attended a presentation showcasing [Drupal][1]. Like Joomla! and WordPress an easy install routine presents the user with a lot of functionality right out of the box. By adding modules as needed one can achieve whatever he wants. So it seems&#8230; After the showcase part, the session continued into a case study. The case at hand was a project were all sorts of specific functionality (think: facebook, digg, etc. web 2.0 you know) was required. And it didn&#8217;t go as smooth and quick as expected. How come?
  
<!--more-->


  
No two projects are the same and within this scope it&#8217;s important to distinguish two types of project:

  1. There&#8217;s the ones that fit well into &#8216;the CMS mold&#8217;: Content is aggregated, put in the right drawer (=stored), perhaps sorted a bit and finally displayed. There are of course requirements but there&#8217;s usually a certain flexibility to them. Take for example images: It&#8217;s nice if the CMS will resize uploaded images as needed but if not then that is usually not a show-stopper.
  2. The one&#8217;s where requirements are specific, out of the ordinary, and probably detailed. Some functionality might be provided by a traditional CMS, but there&#8217;s a lot more. Future requirements are undetermined but might be very diverse.

Confection clothing vs. tailor made suits really. The project discussed clearly matched the second description.

### Thousands of Drupal modules must be right. Wrong!

For the first type of project it is obvious that applications like Drupal, Joomla! and WordPress are unbeatable. If that does the job well enough there&#8217;s no point in coding yourself. Besides that, the community will provide you with free upgrades and enhanced functionallity as updates are released!

The second type of project is different though. What I believe went wrong in the case discussed, was that right at the start of the project the assumption was made that &#8216;the needed modules were sure somewhere out there&#8217;. Even if they _are_ it may be hard to find them. Some simplified math: 2332 modules ([wikipedia][2]). 1 minute to quickly scan a module and take note if interested. 40 working hours a week equaling 2400 minutes. So it takes about a week to make a first inventory. Not entirely true of course but the time you win, you lose again by comparing the nitty gritty details between similar modules.

### Module creep

Once the needed modules are found a situation like illustrated below might occur:
  


<div id="attachment_171" style="width: 510px" class="wp-caption aligncenter">
  <img src="http://www.tibobeijen.nl/blog/wp-content/uploads/2009/02/module_creep.png" alt="Module Creep" title="Module Creep" width="500" height="394" class="size-full wp-image-171" srcset="http://www.dev.tibobeijen.nl/blog/wp-content/uploads/2009/02/module_creep.png 500w, http://www.dev.tibobeijen.nl/blog/wp-content/uploads/2009/02/module_creep-300x236.png 300w" sizes="(max-width: 500px) 100vw, 500px" />
  
  <p class="wp-caption-text">
    Module Creep
  </p>
</div>

The modules found provide most of the functionallity neccessary. And more. Enough to pass whatever requirements check you want to perform. But take for example module E. That&#8217;s just there to cover for that little bit of &#8216;must have&#8217; requirements. And modules B and D provide functionality that&#8217;s totally irrelevant. Depending on implementation details, for visitors or editors the user experience will be less focused. More is not always better. Maintenance and implementation might be harder than planned too.

### Customization

So the second type of project might lead to the conclusion that customization is required. And that conclusion by itself poses all kinds of new questions, like:

  * _Does_ the application architecture allow for customization?
  * Can enhancements and original software be kept separate? In other words: what is the quality of the application&#8217;s architecture?
  * Are the resources (time/money/knowledge/management support) to build custom enhancements available?
  * What are the risks of core- or module upgrades causing the custom enhancements to fail?
  * What are considerations with respect to licensing?
  * How well can risks involved be estimated?

These are questions that should be addressed very early in the project. Finally some aspects to take into consideration when trying to answer these questions: 

  * Besides looking from a functional point of view, technical details have to be addressed. That expertise has to be (made) available.
  * Experience from previous projects or case studies greatly helps answering these questions. That experience is not always there.

 [1]: http://drupal.org/
 [2]: http://en.wikipedia.org/wiki/Drupal#Contributed_modules