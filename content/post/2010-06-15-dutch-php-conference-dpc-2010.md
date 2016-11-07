---
title: Dutch PHP Conference (DPC) 2010
author: Tibo Beijen
layout: post
date: 2010-06-15T17:17:24+00:00
url: /blog/2010/06/15/dutch-php-conference-dpc-2010/
postuserpic:
  - /pa_dpc10_80.png
categories:
  - events
  - report
tags:
  - dpc10
  - dpc_uncon
  - php

---
Past weekend the Amsterdam RAI was the centre of the PHP universe as there the 2010 edition of the [Dutch PHP Conference][1] was held. Similar to past year it consisted of two presentation days, which I attended, preceded by a tutorial day.

Among the presentations I attended on the first day were: 

Kevlin Henney&#8217;s keynote presentation, titled _97 Things every programmer should know_. I suppose every attendant will have recognised some of the things he addressed, like &#8220;Do lots of deliberate practice&#8221; or &#8220;Hard work does not pay off&#8221;.

_Design for Reusability_. In this presentation Derick Rethans showed a number of concepts that can help in making code more reusable. Topics included Dependency Injection Containers, the fact that private methods can never be tested and Tie-Ins. Interesting was that Derick stated that reflection is slow whereas on day 2, in the Doctrine 2 uncon talk reflection was said to be be reasonably fast (in php 5.3 that is).

_Database version control_ by Harrie Verveer was a very interesting talk, if only for the fact that it is a topic I&#8217;m confronted with at my day job. He showed tools like DbDeploy (and Phing), Liquibase, Doctrine Migrations and Akrabat DB Schema Manager. Especially ineresting was how branching can trouble database versioning.

Stephan Hockdoerfer&#8217;s presentation _Testing untestable code_ showed some very unorthodox examples of how to test code that seems untestable, like replacing function names, manipulating the include path or mocking the filesystem. Interesting and besides that it&#8217;s great stuff to scare co-workers with (&#8220;look what trick I&#8217;ve learned!&#8221;).

Due to an unlucky combination of a tiresome week, a busy schedule ahead, a lot of time to kill until 20:30, and possibly age, I missed the social, so I was not devastated when day 2 started.

First presentation of day 2 was titled _Security Centered Design: Exploring the Impact of Human Behaviour_ by Chris Shiflet. Emphasis was not on the technical aspects but on the people using an application. The presentation contained a very effective demonstration of &#8216;change blindness&#8217;. Quote of the presentation, and as far as I&#8217;m concerned whole DPC10: &#8221; If you focus on the technical problem you&#8217;re missing the actual problem&#8221;

Following the keynote talk, Rob Allen covered the topic of _Stress-free deployment_. There was some overlap with the database versioning talk of the previous day but still a lot to learn. Especial interesting I found the part about branching, where Rob showed how branching features as well as releases can be a good solution for some pitfals concerned with release management. Not entirely in line with the branching &#8216;problems&#8217; mentioned in the database versioning talk so it&#8217;s definitely a subject I&#8217;ll look into further.

After the lunch I visited the [Unconference][2] room which I didn&#8217;t regret. Jeroen Keppens opened with a short presentation on a topic we need to look into at my job in the near future: _Integrating Zend_Acl and the domain layer_. Short but very insightful. After two presentations about development for mobile devices (PhoneGap looks very interesting) and Cairo I decided to stay in the uncon room some more (thereby skipping the Domain NoSQL talk) as next on were two ORM-centered presentations: First Juozas Kaziukenas explained the principles of an ORM, followed by Benjamin Eberlei giving insight on Doctrine2. That looked promising yet also, after viewing the generated SQL of some of the more complex examples, spawned a very interesting discussion I had with my co-worker who visited Sebastian Bergmann&#8217;s presentation _The Cake is A Lie_: What problems can arise from generated code that isn&#8217;t tested and nobody is responsible for?

Concluding: Similar to past years this was a refreshing event that fuels the urge to improve by adopting new techniques and better methodologies. Besides that I really liked the Unconference initiative. Till next year!

  * [DPC 2010 slides][3] (joind.in)
  * Twitter: [#dpc10][4] and [#dpc_uncon][5]

 [1]: http://www.phpconference.nl/
 [2]: http://www.phpconference.nl/schedule/unconference
 [3]: http://joind.in/event/view/142#slides
 [4]: http://twitter.com/#search?q=dpc10
 [5]: http://twitter.com/#search?q=dpc_uncon