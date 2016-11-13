---
title: 'MSDN InTrack: Microsoft Webstack and PHP'
author: Tibo Beijen
date: 2008-12-10T18:02:41+00:00
url: /blog/2008/12/10/msdn-intrack-microsoft-webstack-and-php/
postuserpic:
  - /pa_msdn_php_80.gif
categories:
  - report
tags:
  - iis
  - microsoft
  - msdn
  - php
  - sql server

---
Last week I attended a one-day Microsoft event about what the Microsoft platform has to offer for PHP developers. Four topics were covered: MS Server 2008 &#038; IIS 7, SQL Server, Presentation and the Live platform. As was explicitly mentioned, the event wasn&#8217;t about &#8216;learning PHP&#8217; but about &#8216;what&#8217;s in store&#8217;. It seems like Microsoft [takes PHP&#8217;s growth seriously][1] . In this first post I&#8217;ll cover IIS and SQL Server 2008.

<!--more-->

### MS Server 2008 &#038; IIS 7

The IIS 7 part was quite interesting, the most important facts mentioned being:

  * Modular instead of Monolithic. The extension architecture allows for extra features to be added to IIS 7. Extensions can be [&#8216;official Microsoft extensions&#8217;][2], &#8216;unofficial&#8217; (third party, no MS support) or self-developed.
  * FastCGI PHP. One of those extensions is FastCGI. Apparently FastCGI re-uses a proces as opposed to classic CGI. For [PHP on IIS][3] this means a great performance boost.
  * Multiple PHP versions. Per folder, or even per specific script, the PHP executable can be specified so it is easy to run different PHP versions on one server or to test applications on updated PHP versions.
  * Delegating access to configuration settings. It looked like it was possible to delegate configuration settings at a very detailed level. Delegation is helped by the introduction of &#8216;IIS users&#8217;. The configuration console can be remotely connected to using the IIS user credentials.
  * [Bit rate throttling][4]. Very useful if you are hosting large media files.
  * [Url Rewrite Module][5]. The most notable feature to me was that it allows you to import apache mod_rewrite settings. Very nice.
  * Alternate configuration options. For those suffering from RSI (or just not liking icons) there are several other ways of accessing IIS settings: AppCMD, Powershell, .NET namespaces or the XML configuration files.
IIS 7 made a good impression. It looks like some features very important for PHP development are in there. I think for sysadmins it&#8217;s very nice that all of the configuration can be done from the CLI as that is better suited for repetitive tasks, tooling and documenting.

### SQL server 2008

The SQL server part covered the connecting proces from PHP and the features SQL Server 2008 offers. 

For the PHP examples the [Microsoft SQL Server 2005 Driver for PHP][6] was used. This driver makes available a set of sqlsrv_ functions. In-depth coverage on that subject [can be read here][7]. The driver is only available on windows but luckily there are other options: [MSSQL extension][8], [ODBC extension][9], [PDO_DBLIB][10] and [PDO_ODBC][11].

Next on was coverage on the Server product itself. The part on reports wasn&#8217;t that interesting although the reports created looked very polished. And of course [there&#8217;s a certain demand for that][12]. :). Furthermore, I think displaying the reports using an iFrame isn&#8217;t the type of &#8216;integration&#8217; PHP developers will get very excited about.

Working mainly with CLI or Php(My/Post)Admin I could see the benefits tools like SQL Server Management Studio and SQL Server Profiler can offer. I think they can be of great help optimising queries.

Of further interest to me were the geography and geometry functions. It was nice to see how easy it is to combine, say, travel distance and other attributes in a single query. I&#8217;ve never had to work with geographic data yet but, as co-attendees mentioned a lot of other databases have similar features. For example PostgreSQL has the [PostGIS extension][13] and there is some [spatial functionality in MySQL][14] too.

SQl Server is probably a very good product but I doubt if it will be used much in &#8216;blank sheet&#8217; PHP projects. For companies having a MS infrastructure and wanting to jump on the PHP bandwagon options are plenty&#8230;

 [1]: http://www.microsoft.com/uk/servers/winclientshearts/
 [2]: http://www.iis.net/extensions
 [3]: http://www.iis.net/php
 [4]: http://www.iis.net/extensions/BitRateThrottling
 [5]: http://www.iis.net/extensions/URLRewrite
 [6]: http://www.codeplex.com/SQL2K5PHP
 [7]: http://msdn.microsoft.com/en-us/library/cc793139(SQL.90).aspx
 [8]: http://www.php.net/manual/en/mssql.setup.php
 [9]: http://www.php.net/manual/en/book.uodbc.php
 [10]: http://www.php.net/manual/en/ref.pdo-dblib.php
 [11]: http://www.php.net/manual/en/ref.pdo-odbc.php
 [12]: http://en.wikipedia.org/wiki/Lies,_damned_lies,_and_statistics
 [13]: http://postgis.refractions.net/
 [14]: http://dev.mysql.com/tech-resources/articles/4.1/gis-with-mysql.html