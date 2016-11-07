---
title: Jumping in and out of jQuery land
author: Tibo Beijen
layout: post
date: 2009-04-02T21:34:59+00:00
url: /blog/2009/04/02/jumping-in-and-out-of-jquery-land/
postuserpic:
  - /pa_jquery_80.gif
categories:
  - miscellaneous
tags:
  - javascript
  - jquery

---
Recently I started using jQuery in some projects. In past projects I have mainly been using Prototype and the fact that jQuery also has a $() function made me feel at home right away. That same fact put me a bit off-guard as both functions are in fact quite different:

  * Prototype extends the selected HTML node with added functionality and returns it. Argument should be a HTML node or element id.
  * jQuery selects the HTML node (or nodes) and stores the selection in a jQuery object, which then is returned. Argument should be a css-like selector.

So, as opposed to Prototype, jQuery&#8217;s $() method can select a single element as well as a collection of elements. The existence of [Prototype&#8217;s $$() function][1] also kind of suggests that Prototype&#8217;s $() doesn&#8217;t do that. And&#8230; when passing just an id to jQuery&#8217;s $() (e.g. $(&#8216;myDiv&#8217;)) it is discovered soon enough that nothing is selected but air.

By using jQuery&#8217;s $() functionwe&#8217;re leaving the DOM-zone and enter jQuery land. Although jQuery can do a lot, situations might occur where one needs to get the &#8216;real&#8217; DOM elements. For instance, to pass them as argument to components that don&#8217;t talk jQuery. Luckily it&#8217;s just as easy to go back, by using the get() accessor.

Some simplified HTML code example boxes:

<pre lang="html4strict"><div class="codeBox">
  <a href="#">copy to clipboard</a>
      <code>Some code</code>
  
</div>


<div class="codeBox">
  <a href="#">copy to clipboard</a>
      <code>More code</code>
  
</div>
</pre>

Accompanied by the following javascript:

<pre lang="javascript">$(document).ready(function(){
    initCodeBox();
});

function initCodeBox()
{
    $('.codeBox a').bind('click',function() {
        var htmlNode = $(this).siblings('code').get(0);
        if (htmlNode) copyContentsToClipboard(htmlNode);
        return false;
    });
}

function copyContentsToClipboard(htmlNode)
{
        // js selecting the text contents of a DOM node, simplified to: 
    alert(htmlNode.innerHTML);
}
</pre>

It&#8217;s clear that, as long as existing code doesn&#8217;t conflict with the $() function, it&#8217;s very easy to start using jQuery in existing projects.

 [1]: http://www.prototypejs.org/api/utility#method-$$