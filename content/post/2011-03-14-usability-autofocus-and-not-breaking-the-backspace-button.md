---
title: 'Usability: Autofocus and not breaking the backspace-button'
author: Tibo Beijen
date: 2011-03-14T11:32:39+00:00
url: /blog/2011/03/14/usability-autofocus-and-not-breaking-the-backspace-button/
postuserpic:
  - /pa_backspace_mac1_80.jpg
categories:
  - articles
tags:
  - html5
  - javascript
  - jquery
  - jquery plugin
  - usability

---
A while ago during a project we were asked to implement autofocus on the generic search field that every page in the application has. At a first glance a pretty straightforward task, from a technical perspective that is. Not from a user perspective, as indicated by a colleague mentioning his dislike of such autofocus fields &#8220;because they prevent backspace going to the previous page&#8221;. In this post I will outline some usability considerations and conclude with a jQuery plugin that will take away some of the possible hindrance of autofocusing a field.

### Usability considerations

There are some things to consider to determine if such automatic focusing of a search field is actually helpful to the user navigating to the page. Who is _the_ user?

As I was discussing this case with [an interaction designer friend][1] (dutch) of mine, he brought up the idea of mimicking the browser&#8217;s backspace behaviour, and discussing it further we concluded that this might be useful in some cases but is definitely not a &#8216;one size fits all&#8217; solution.

#### Different goals

Different users will probably have different goals when navigating to a page. On the google page or a login screen the majority of the users&#8217; goal is to type something in the first input field. On a lot of other pages this won&#8217;t be so obvious. Question then is: Will focusing a search field, if not help, instead _hinder_ the user? For example: A user might have navigated to a page by accident. In that case not being able to go to the previous page by pressing &#8216;backspace&#8217; might indeed hinder the user.

#### Different expectations

Not every user navigates to the previous page by using &#8216;backspace&#8217;, some might not even be aware of that possibility. Not every user expects text entered to automatically appear in an input field. Some users might have enabled the option to directly find text in a page when typing text and find this functionality suddenly broken.

[Dive into HTML5][2] has some other nice examples of how autofocus might _not_ be helpful.

### What size fits all?

As mentioned before, there is no &#8216;one size fits all&#8217; solution. Questions that need to be asked include:

  * How many users might be helped by adding autofocus to a common search field?
  * How many users might instead be hindered by autofocus?
  * Are there pages where autofocus on more specific fields (like the main form) is needed which will break consistency throughout the site?

This means studying your site, the target audience, their goals and expectations and based on that finding a balance.

### Restoring the backspace: jQuery autofocusBackspace plugin

If the conclusion of aforementioned considerations is that autofocus indeed _is_ helpful, there is more than one way to achieve this: The first is using the HTML5 autofocus attribute. Another is using javascript to focus the field.

As not all browsers support the autofocus attribute yet, and we wanted to preserve the browser&#8217;s backspace functionality, I created a jQuery plugin that does just that:

  * It focuses the first matching element 
      * It responds to &#8216;backspace&#8217; by navigating to the previous page. 
          * Only until a user has entered text 
              * Only until the element loses focus</ul> </ul> 
                Refer to GitHub for the [jQuery plugin autospaceBackspace][3]. 
                
                Feel free to report problems or ideas for improvement.

 [1]: http://www.architecto.nl
 [2]: http://diveintohtml5.org/detect.html#input-autofocus
 [3]: https://github.com/TBeijen/jQuery-plugin-autofocusBackspace