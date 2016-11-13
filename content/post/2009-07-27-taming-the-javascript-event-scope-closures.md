---
title: 'Taming the Javascript event scope: Closures'
author: Tibo Beijen
date: 2009-07-27T13:52:44+00:00
url: /blog/2009/07/27/taming-the-javascript-event-scope-closures/
postuserpic:
  - /pa_eventscope_80.gif
categories:
  - miscellaneous
tags:
  - closure
  - javascript
  - jquery

---
When doing client-side developing there are times that jQuery&#8217;s get-this-do-that nature doesn&#8217;t provide all that is needed. For more complex applications I usually find myself creating javascript objects that &#8216;control&#8217; a specific part of the page&#8217;s interaction. In the objects the application&#8217;s state is tracked, references to other objects (could be relevant DOM nodes) are stored and event handlers are set.

One of the problems typically encountered when dealing with javascript event handlers is that they have their own take on the &#8216;this&#8217; keyword. Closures to the rescue.
  
<!--more-->


  
A simple (and rather useless) example:

html:

    </head>
    
    
    
    <div id="scope">
      <div>
        <p>
          
        </p>
                
        
        <input type="button" value="btn 1" />
            
      </div>
          
      
      <div>
        <p>
          
        </p>
                
        
        <input type="button" value="btn 2" />
            
      </div>
      
    </div>
    


<p>
  javascript:
</p>


    
    function controllerExample(node,idx)
    {
        this.node = node;
        this.idx = idx;
        this.clickCount = 0;
    
        this.setEventHandlers();
    }
    controllerExample.prototype.setEventHandlers = function()
    {
          $(this.node).find('input').bind('click',this.handleClick);
    }
    controllerExample.prototype.handleClick = function(event)
    {
        this.clickCount++;
        $(this.node).find('p').text(
            'Button is clicked '+this.clickCount+' time(s)'
        );
    }
    


<h3>
  &#8216;this&#8217; is wrong
</h3>


<p>
  Now that doesn&#8217;t work&#8230; When the click event fires the handleClick() function is executed but the scope is not the controllerExample instance. On execution the &#8216;this&#8217; keyword points to the input element. So we see &#8216;Button is clicked NaN time(s)&#8217;.
</p>


<p>
  The Prototype javascript library has a solution for this by extending the basic function object type with the bind() and bindAsEventListener() methods. Very nice but to include Prototype just for that&#8230; bad idea. It&#8217;s perfectly possible to separately implement a similar bind() function method but that still creates an additional (besides jQuery) dependency for that method. Let&#8217;s keep the mess to a minimum and keep it &#8216;in&#8217; the controllerExample object.
</p>


<h3>
  Closure
</h3>


<p>
  Prototype&#8217;s bind() function uses what is called a closure: A function defined within a function. The benefit is that the inner function, which in the following example is returned by the outer function, has access to the outer functions local variables <em>after</em> the outer function has returned.
</p>


<p>
  Properly &#8216;binding&#8217; the handleClick event handler now looks like this:
</p>


    
    controllerExample.prototype.setEventHandlers = function()
    {
        var _scope = this;
        var getHandleClick = function() {
            console.log(this); // window
            console.log(_scope); // controllerExample
            return function(event) {
                return _scope.handleClick.call(_scope,event);
            }
        }
        $(this.node).find('input').bind('click',getHandleClick());
    }
    


<p>
  getHandleClick() returns a function that, when executing, still has access to _scope which <em>is</em> the correct scope. The console.log lines are there to illustrate that inside the inner function we can&#8217;t use &#8216;this&#8217;. The getHandleClick() function has no object scope so it&#8217;s &#8216;this&#8217; is the window scope. But the object scope can be passed into by copying &#8216;this&#8217; to a new variable _scope and use that inside the closure.
</p>


<p>
  More information about closures: <a href="http://www.javascriptkit.com/javatutors/closures.shtml">Javascript closures 101</a> (basic) and <a href="http://www.jibbering.com/faq/faq_notes/closures.html">This article on jibbering.com</a> (advanced).
</p>


<h3>
  routeEvent
</h3>


<p>
  Now the above is fine if there&#8217;s just one or two event handlers to be added but is not really &#8216;generic&#8217;. So let&#8217;s create a more generic &#8216;routeEvent&#8217; method that creates a closure for the eventHandler that is passed in:
</p>


    
    controllerExample.prototype.setEventHandlers = function()
    {
        $(this.node).find('input').bind(
            'click',
            this.routeEvent(this.handleClick)
        );
    }
    // ...
    controllerExample.prototype.routeEvent = function(eventHandler)
    {
        var _scope = this;
        return function(event) {
            return eventHandler.call(_scope,event);
        }
    }
    


<p>
  Now the handleClick() method will be called with the correct &#8216;this&#8217; and is also provided with the jQuery event object.
</p>


<p>
  A demo putting it al together can be seen <a href="/static/event_scope_closure/">here</a>.
</p>