---
title: PHPBenelux meeting at Freshheads
author: Tibo Beijen
date: 2009-09-30T18:48:53+00:00
url: /blog/2009/09/30/phpbenelux-meeting-at-freshheads/
postuserpic:
  - /pa_phpbnl_80.gif
categories:
  - report
tags:
  - freshheads
  - php
  - phpbenelux
  - symfony
  - zend framework

---
Yesterday (sept. 29th) I went to the [Freshheads][1] office in Tilburg to attend the monthly [PHPBenelux][2] meeting. As it appeared it was right around the corner of the 013 venue so it was an easy find. 

Two talks were scheduled and Stefan Koopmanschap kicked off the meeting with a presentation titled &#8220;Integrating Symfony and Zend Framework&#8221; ([slides][3]). After a short introduction pointing out the benefits of using any framework at all, Stefan showed how both Symfony&#8217;s and Zend Framework&#8217;s autoloaders can be initialized in the application&#8217;s bootstrap code. After that using ZF components in symfony was showcased by using Zend\_Service\_Twitter inside a Symfony project. Being quite familiar with Zend Framework that was not really surprising (to me) but the part following was: Integrating Symfony into a Zend Framework project. First of all it was new to me that there are &#8220;[Symfony Components][4]&#8220;. Apparently Symfony is not an all-or-nothing affair anymore. Most of the components were briefly covered of which I especially found the [Event Dispatcher][5] highly interesting.

After a brief pause, Juliette Reinders Folmer hosted the big &#8220;Why Equal Doesn&#8217;t Equal Quiz&#8221;. 65 Questings testing the knowledge of the attendees about the type conversions going on when writing code like:

    $a = null;
    if (empty($a)) echo 'empty';
    
    foreach(array('test','0','etc...') as $val) {
        if ($val) echo 'has value';
    }
    

Questions like the ones above where the easy ones&#8230; Especially interesting where the [ctype family of functions][6]. They are especially usefull for checking database result or GPC data. Although I had seen the ctype functions before I kind of forgot about them so especially there I had wrong answers. Score: 45 out of 65.

The evening concluded with some informal chatting and some beers generously provided by Freshheads. As usual I went home with some new things on my &#8216;got to check that out&#8217; list&#8230;

 [1]: http://www.freshheads.com/
 [2]: http://www.phpbenelux.eu/
 [3]: http://www.slideshare.net/skoop/integrating-symfony-and-zend-framework-2097969
 [4]: http://components.symfony-project.org/
 [5]: http://components.symfony-project.org/event-dispatcher/
 [6]: http://nl.php.net/manual/en/book.ctype.php