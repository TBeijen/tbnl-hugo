---
title: 'Enterprise iPhone Applications: First steps'
author: Tibo Beijen
date: 2008-11-17T11:50:38+00:00
url: /blog/2008/11/17/enterprise-iphone-applications-first-steps/
postuserpic:
  - /pa_iphone_dev_80.jpg
categories:
  - articles
tags:
  - iPhone

---
The iPhone is a very popular gadget and this popularity is not limited to long-time and die-hard Mac fan&#8217;s. Enterprises also seem triggered by the iPhone&#8217;s slick appeal, if only because an increasing number of employees has the flashy device lying near them on the conference table. (Or the lunch table for that matter).

So what are a company&#8217;s options if it want to have it&#8217;s own shiny icon at the iPhone home screen? Does the ease of use extend beyond the user-interface? In this guide, doomed to be aged in mere months, I&#8217;ll outline the options one has for developing enterprise software for the iPhone.

<!--more-->

### Software types

There are two types of software that can be run on an iPhone:

  1. Native applications
  2. Web applications

Both have their specific features that can make them the best solution for a given situation.

### 1:Native applications

Native software is developed in objective C, a superset of the C language that adds object-oriented features. Apple provides Iphone SDK available for download at the [iPhone Developer Program][1]. The SDK includes Xcode IDE and an iPhone simulator. The major drawback for anyone not owning a mac is that the SDK is only available for OS X.

#### Distribution

To install software on the iPhone it needs to be digitally signed. Therefore purchasing one of the two [iPhone Developer Programs is needed][2]:

  * **Standard program (US$99)**Offers Ad-Hoc distribution to max. 100 devices and distribution through App Store,
  * **Enterprise program (US$299)** Offers In-house and Ad-Hoc distribution

Applications published through the App Store can be either free or paid software. But software has to be approved by Apple before appearing on the App Store. The acceptance policy of App Store leaves room for debate as [can be read in this article][3].

Concluding that distribution through App Store has it&#8217;s drawbacks, the Developer Program seems
  
preferrable. The Enterprise program still requires an iPhone to be [
  
physically connected to a desktop running iTunes][4] toinstall the software.

#### Features

Native applications have access to a lot of iPhone features, such as:

  * GPS
  * Accelerometer
  * 3D rendering
  * Address book
  * Camera
  * etc.

They can of course connect to online resources. For integration in company networks [VPN solutions are
  
available][5].

#### Alternative

IBM has released a tutorial on how to [use Eclipse to program iPhone applications][6] ([registration required][7])

Installing such software requires jailbreaking the iPhone allowing it to run applications not signed by Apple.

### 2: Web Apps

Web Apps are basically web based applications like any other. Safari on the iPhone uses the same
  
engine as Safari on the desktop so it includes the latest web standards, like:

  * xHTML 1.0
  * CSS 2.1
  * ECMAScript 3 (Javascript)
  * DOM Level 2
  * XmlHttpRequest (AJAX)

#### Features

Compared to native applications the features of web apps are limited. Nevertheless URI schemes allow developers to extend the possibilities beyond the browser&#8217;s scope. The following URI schemes will launch the corresponding iPhone application:

  * mailto: links
  * tel: links
  * Links to google maps
  * Links to youtube
  * Links to iTunes

Besides launching applications the potential of the iPhone&#8217;s touchscreen can be used: The browser&#8217;s javascript can handle multi-touch and gesture events. Custom meta tags can be used to control display behaviour and to provide the application with a &#8216;home&#8217; icon. These topics are extensively covered in Apple&#8217;s [Safari Web Content Guide for iPhone][8], also [available as PDF][9] ([registration required][10]

As of iPhone OS 2.1 meta-tags can be used to make web apps run full screen and to disable the taskbar. This way web apps look just like native apps.

#### Offline use

Just like websites can be read in offline mode not all web apps require a live connection. [Iwebsaver][11] offers a technique to packace a web app (including associated css, javascripts and images) into a single data uri that can be stored on the device. As [explained on this page][12] this technique is not suitable for every web app.

### Conclusion

Native apps and web apps both have their merits and drawbacks. Some of the most important characteristics are outlined below:

<table border="0" cellspacing="0">
  <tr>
    <td>
    </td>
    
    <th>
      Native apps
    </th>
    
    <th>
      Web apps
    </th>
  </tr>
  
  <tr>
    <th>
      Developed using:
    </th>
    
    <td>
      Objective C
    </td>
    
    <td>
      XHTML, css, javascript
    </td>
  </tr>
  
  <tr>
    <th>
      Distribution:
    </th>
    
    <td>
      Desktop with iTunes installed
    </td>
    
    <td>
      Web
    </td>
  </tr>
  
  <tr>
    <th>
      Access to touchscreen?
    </th>
    
    <td>
      yes
    </td>
    
    <td>
      yes
    </td>
  </tr>
  
  <tr>
    <th>
      Access to other iPhone hardware?
    </th>
    
    <td>
      yes
    </td>
    
    <td>
      no
    </td>
  </tr>
  
  <tr>
    <th>
      Access to other iPhone apps?
    </th>
    
    <td>
      yes
    </td>
    
    <td>
      Push only using uri schemes
    </td>
  </tr>
  
  <tr>
    <th>
      Compatibility extends beyond iPhone
    </th>
    
    <td>
      no
    </td>
    
    <td>
      yes
    </td>
  </tr>
</table>

Web apps can be seen as Mash-ups or RIA&#8217;s brought to a small screen. If web development knowledge is available within a company it&#8217;s relatively easy to get into. One can use iPhone specific features but resources are best spent if one makes sure the web app also runs on other mobile devices and desktops. It _is_ a website after all&#8230;

On the other hand, if the application requires use of embedded features, native applications are the way to go. Opting for native application development companies should look into requirements regarding distribution and development platform.

As allready hinted by the possibility of storing web apps on the iPhone and running them fullscreen, there&#8217;s a somewhat greyish area between the black and white. Hotels.com [is a fine example][13] of a hybrid application that uses the best of both worlds.

 [1]: http://developer.apple.com/iphone/program/
 [2]: http://developer.apple.com/iphone/program/apply.html
 [3]: http://www.computerworld.com/action/article.do?command=viewArticleBasic&articleId=9115184
 [4]: http://www.computerworld.com/action/article.do?command=viewArticleBasic&articleId=9095398
 [5]: http://www.apple.com/iphone/enterprise/integration.html
 [6]: https://www6.software.ibm.com/developerworks/education/os-eclipse-iphone-cdt/index.html
 [7]: https://www.ibm.com/account/myibm/profile.do?cc=us&lc=en&page=reg
 [8]: http://developer.apple.com/webapps/docs/documentation/AppleApplications/Reference/SafariWebContent/Introduction/chapter_1_section_1.html
 [9]: http://developer.apple.com/webapps/docs/documentation/AppleApplications/Reference/SafariWebContent/SafariWebContent.pdf
 [10]: http://developer.apple.com/iphone/sdk1/
 [11]: http://iwebsaver.com/
 [12]: http://iwebsaver.com/webmasters/
 [13]: http://blogs.oreilly.com/iphone/2008/08/when-a-native-iphone-app-is-re.html