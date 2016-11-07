---
title: 'Usability: What does this button do?'
author: Tibo Beijen
layout: post
date: 2009-10-09T14:01:48+00:00
url: /blog/2009/10/09/usability-what-does-this-button-do/
postuserpic:
  - /pa_deedee_button_80.png
categories:
  - articles
tags:
  - development
  - graphic design
  - usability

---
In software development projects, paying proper attention to usability aspects, can greatly help &#8216;getting the <del datetime="2009-09-20T10:22:43+00:00">message </del>functionality across&#8217;. [Usability][1] is a field of expertise on its own and involves techniques like [wireframes][2], [prototyping][3] and [card sorting][4]. Not every project is the same and (sadly) lack of time or budget can prevent specialized interaction designers to be involved in the project. This means that making the application &#8216;usable&#8217; becomes the responsibility of graphic designers or developers (or it is neglected altogether). Not an easy combination of tasks&#8230;
  
<!--more-->


  
When developing or visually designing an application one goes into much detail which makes it hard to step back and look at the application from an end user&#8217;s perspective. To help measure and improve usability there are numerous [usability checklists][5] out there, some of them focusing on [specific subjects like forms][6]. Such lists can be very complete (and thereby very long) and because of that difficult to continuously use during development. They tend to be more useful as an evaluation tool than as a development tool.

To help during development (or design) it helps to keep in mind that a user using an application is all about interaction and exchanging information. At any given moment while using an application, a user might wonder things like:

  * What did that button do?
  * What will this button do?
  * What does this label mean?
  * How can I find the page I&#8217;m looking for?

Summarized: action and information, past and future as illustrated below:
  


<div id="attachment_501" style="width: 510px" class="wp-caption aligncenter">
  <img src="http://www.tibobeijen.nl/blog/wp-content/uploads/2009/09/usability_application_state_diagram_01.gif" alt="Usability: Application State Diagram" title="Usability: Application State Diagram" width="500" height="350" class="size-full wp-image-501" srcset="http://www.dev.tibobeijen.nl/blog/wp-content/uploads/2009/09/usability_application_state_diagram_01.gif 500w, http://www.dev.tibobeijen.nl/blog/wp-content/uploads/2009/09/usability_application_state_diagram_01-300x210.gif 300w" sizes="(max-width: 500px) 100vw, 500px" />
  
  <p class="wp-caption-text">
    Usability: Application State Diagram
  </p>
</div>

### Four quadrants

#### I. Past actions

This translates to &#8216;feedback&#8217;. Is it at any point clear to the user what the application is doing or has done, following the user&#8217;s commands? Is the feedback form sent? Are modifications done through the CMS visible online? Is the application really still busy or is something going wrong?

#### II. Future actions

Feed forward. For a user to &#8216;trust&#8217; an application he needs to be able to predict what will happen when he performs certain actions. Take for instance a webshop: After clicking &#8216;place order&#8217;, will there be a screen to review and possibly cancel the order process? Or, after saving a page in a CMS, will it be possible to preview a page before it&#8217;s visible on the live site?

#### III. Past information

This focuses mainly on how information is displayed at a given point. Is important information clearly recognizable? Is it clear what is displayed? For example a product page on a webshop: Can editorials and user comments be clearly distinguished?

#### IV. Future information

This covers navigation and thereby how all the information and possible interaction of an application is structured. To efficiently use an application a user needs to be able to predict where to find information and how to get there. This involves structuring navigation and perhaps also tailoring navigation to accommodate for common usage scenarios.

### What this diagram does not

The above diagram focuses on the state of an application at a given point and therefore doesn&#8217;t look at the bigger picture. This means it doesn&#8217;t:

  * Cover consistency throughout the application.
  * Prioritize functionality.
  * Match functionality with user goals.
  * Look into characteristics of the targetted users (like experience with similar applications) or the environment the application is used in.

### What this diagram can do

Taking back a step once in a while _during_ development and applying this diagram on the application that is being created, can help to quickly point out certain usability flaws. This is especially true when there is no dedicated usability expert in the team. Having a certain amount of knowledge of the more elaborate checklists mentioned earlier will help. Besides being used as a quick evaluation tool this diagram can also be used to structure usability-related thoughts and ideas and predict their effectiveness. Hopefully that will help creating a better user experience.

 [1]: http://en.wikipedia.org/wiki/Usability
 [2]: http://www.usabilityfirst.com/glossary/term_645.txl
 [3]: http://www.usabilitynet.org/tools/prototyping.htm
 [4]: http://en.wikipedia.org/wiki/Card_sorting
 [5]: http://www.usereffect.com/topic/25-point-website-usability-checklist
 [6]: http://www.alistapart.com/articles/sensibleforms