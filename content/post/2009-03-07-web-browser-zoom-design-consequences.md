---
title: 'Web Browser Zoom: Design consequences'
author: Tibo Beijen
date: 2009-03-07T18:57:19+00:00
url: /blog/2009/03/07/web-browser-zoom-design-consequences/
postuserpic:
  - /pa_browser_zoom_80.jpg
categories:
  - articles
tags:
  - accessibility
  - design
  - usability

---
Over the years the display size of the average computer screen has increased. As a consequence nowadays more and more websites are designed with a 1024 width screen in mind. For example: [BBC][1], [Adobe][2] and [The New York Times][3]. With at least 78% of the users using a 1024 or higher resolution screen the time seems right to move away from the 800px designs. But what about accessibility? And usability? And is full page zooming really better than text scaling?
  
<!--more-->

### Screen resolution

Take [the february 2009 stats of thecounter.com][4]. Based on those stats a target resolution of 1024 seems reasonable: At least 78% of the people view websites at that resolution or higher. 

Of course the need for the increased width depends on the specific elements that have to be displayed. When left- and right columns are narrow, a width of 1024 might lead to very long lines which are hard to read.

### Accessibility guideline: text size

Accessibility guidelines ([W3C WCAG 1.0 point 3.4][5]) state that relative units are to be used when specifying text size. That way, users can easily adjust the size of text. For some time, browsers (except \*sigh\* IE6) allowed users to adjust the displayed text size by using key combinations or ctrl+scrollwheel. This posed a challenge to CSS coding as it wasn&#8217;t always easy to keep everything in place when text size was increased. Or, probably worse, text would flow out of the box and become unreadable. See below image of a [page on eurogamer.net][6]. In the left-column navigation and bottom parts of the page elements will overlap when text size is increased.

<div id="attachment_182" style="width: 505px" class="wp-caption aligncenter">
  <img src="/media/wp-content/uploads/2009/03/eurogamer_textsize_example.png" alt="Eurogamer text size example" title="Eurogamer text size example"   class="size-full wp-image-182" srcset="http://www.dev.tibobeijen.nl/blog/wp-content/uploads/2009/03/eurogamer_textsize_example.png 495w, http://www.dev.tibobeijen.nl/blog/wp-content/uploads/2009/03/eurogamer_textsize_example-300x164.png 300w" sizes="(max-width: 495px) 100vw, 495px" />
  
  <p class="wp-caption-text">
    Eurogamer text size example
  </p>
</div>

Nowadays quite some web browsers have replaced text scaling with page zooming. This definitely makes life easier for CSS coders. It will also help user experience when increasing text size because relative placement of elements is preserved, as opposed to situations where some columns are stretched in different amounts. But there is a side-effect.

### The misinterpretation of statistics and its disastrous consequences

When a website already fills the entire viewport in it&#8217;s original size, as soon as display size is increased, horizontal scroll bars will appear and the rightmost content will move out of view. So now let&#8217;s turn the [aforementioned stats around][4]. At least 51% of the visitors have a screen resolution of 1024 or _less_. So basically this means that when a page is designed to have a minimum width of, say, 1000px, half of the visitors will have problems increasing the displayed size.

Although official accessibility standards don&#8217;t seem to mention horizontal scrolling, it&#8217;s safe to say that having to scroll horizontally doesn&#8217;t _help_ accessibility. And from a usability perspective it&#8217;s [most certainly bad practice][7].

<p class="remark">
  Regarding accessibility standards not mentioning horizontal scrolling: I searched <a href="http://www.drempelvrij.nl/webrichtlijnen">the standards document of the dutch government</a> which includes all WCAG guidelines (and more). I searched for the words screen (dutch: scherm), horizontal (dutch: horiz) and scroll. Nothing. A downside of these kind of checklists: technology moves on continuously while standards only get update once every x years. But that&#8217;s a different subject&#8230;
</p>

### Browser overview: Text scaling or Full page zooming?

Acknowledging this side-effect it&#8217;s good to know exactly how today&#8217;s browsers perform zooming. See the table below.

<table id="browser_widths" cellspacing="0">
  <tr>
    <th class="c1">
    </th>
    
    <th class="c2">
      IE7
    </th>
    
    <th class="c3">
      FF3
    </th>
    
    <th class="c4">
      Opera 9
    </th>
    
    <th class="c5">
      Safari
    </th>
    
    <th class="c6">
      Chrome
    </th>
  </tr>
  
  <tr>
    <th>
      Default scaling
    </th>
    
    <td>
      zoom
    </td>
    
    <td>
      zoom
    </td>
    
    <td>
      zoom
    </td>
    
    <td>
      text
    </td>
    
    <td>
      text
    </td>
  </tr>
  
  <tr>
    <td colspan="6" class="subheading">
      Zoom options
    </td>
  </tr>
  
  <tr>
    <th>
      All content
    </th>
    
    <td>
      yes
    </td>
    
    <td>
      yes
    </td>
    
    <td>
      yes
    </td>
    
    <td>
      no
    </td>
    
    <td>
      no
    </td>
  </tr>
  
  <tr>
    <th>
      Text only
    </th>
    
    <td>
      menu
    </td>
    
    <td>
      menu
    </td>
    
    <td>
      no
    </td>
    
    <td>
      yes
    </td>
    
    <td>
      yes
    </td>
  </tr>
  
  <tr>
    <td colspan="6" class="subheading">
      Zoom percentages
    </td>
  </tr>
  
  <tr>
    <th>
      Step 1
    </th>
    
    <td>
      110
    </td>
    
    <td>
      111
    </td>
    
    <td>
      110
    </td>
    
    <td>
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <th>
      Step 2
    </th>
    
    <td>
      120
    </td>
    
    <td>
      123
    </td>
    
    <td>
      120
    </td>
    
    <td>
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <th>
      Step 3
    </th>
    
    <td>
      130
    </td>
    
    <td>
      131
    </td>
    
    <td>
      130
    </td>
    
    <td>
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <th>
      Step 4
    </th>
    
    <td>
      140
    </td>
    
    <td>
      143
    </td>
    
    <td>
      140
    </td>
    
    <td>
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <th>
      Step 5
    </th>
    
    <td>
      150
    </td>
    
    <td>
      154
    </td>
    
    <td>
      150
    </td>
    
    <td>
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td colspan="6" class="subheading">
      Widths (original is 800px)
    </td>
  </tr>
  
  <tr>
    <th>
      Step 1
    </th>
    
    <td>
      880
    </td>
    
    <td>
      888
    </td>
    
    <td>
      880
    </td>
    
    <td>
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <th>
      Step 2
    </th>
    
    <td>
      960
    </td>
    
    <td>
      980
    </td>
    
    <td>
      960
    </td>
    
    <td>
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <th>
      Step 3
    </th>
    
    <td>
      1040
    </td>
    
    <td>
      1044
    </td>
    
    <td>
      1040
    </td>
    
    <td>
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <th>
      Step 4
    </th>
    
    <td>
      1120
    </td>
    
    <td>
      1142
    </td>
    
    <td>
      1120
    </td>
    
    <td>
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <th>
      Step 5
    </th>
    
    <td>
      1200
    </td>
    
    <td>
      1230
    </td>
    
    <td>
      1200
    </td>
    
    <td>
    </td>
    
    <td>
    </td>
  </tr></tbody> </table> 
  
  <p class="caption">
    Browser zoom characteristics
  </p>
  
  <h3>
    Conclusion
  </h3>
  
  <p>
    Although stats suggest 1024 is a solid choice, it&#8217;s obvious that there are considerations to be taken into account. If liquid design with a minimum of 800px is not an option and one chooses to design for a (minimum) resolution of 1024px the least one can do is try to avoid putting essential navigation or use cues in the rightmost part of the site.
  </p>
  
  <p>
    See image below of <a href="http://www.play.com/">Play.com</a>: The top part with the currency selectors and link to the visitor&#8217;s account-page <em>do</em> sticks to the right size of the screen.
  </p>
  
  <p class="remark">
    In this case I think it&#8217;s a coincidence as the cart button does extend beyond the visible area. The selectors are positioned absolutely from the right size of a container that doesn&#8217;t have it&#8217;s css attribute position set to &#8216;relative&#8217;. So positioning is done with respect to the BODY element. Although that has a min-width of 990px it somehow works out this way.
  </p>
  
  <div id="attachment_198" style="width: 499px" class="wp-caption aligncenter">
    <img src="/media/wp-content/uploads/2009/03/playcom_header_example.png" alt="Play.com header example" title="Play.com header example"   class="size-full wp-image-198" srcset="http://www.dev.tibobeijen.nl/blog/wp-content/uploads/2009/03/playcom_header_example.png 489w, http://www.dev.tibobeijen.nl/blog/wp-content/uploads/2009/03/playcom_header_example-300x95.png 300w" sizes="(max-width: 489px) 100vw, 489px" />
    
    <p class="wp-caption-text">
      Play.com header example
    </p>
  </div>
  
  <p>
    One last tip: IE7 keeps a centered column centered when zooming in, as opposed to Firefox and Opera. So when in IE7 horizontal scroll bars appear, bits are falling of the left side of the screen as well.
  </p>

 [1]: http://www.bbc.co.uk/
 [2]: http://www.adobe.com/
 [3]: http://www.times.com/
 [4]: http://www.thecounter.com/stats/2009/February/res.php
 [5]: http://www.w3.org/TR/WCAG10/#gl-structure-presentation
 [6]: http://www.eurogamer.net/articles/bioshock-2-set-seven-years-later
 [7]: http://www.useit.com/alertbox/20050711.html