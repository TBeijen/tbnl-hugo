---
title: 'SQL injection & the Kaspersky hack'
author: Tibo Beijen
date: 2009-02-11T18:38:50+00:00
url: /blog/2009/02/11/sql_injection-and-the-kaspersky-hack/
postuserpic:
  - /pa_hull_breach_80.jpg
categories:
  - miscellaneous
tags:
  - mysql
  - php
  - security
  - sql injection

---
Last week I read an article on webwereld titled &#8216;[2008 was year of the SQL injection attack][1]&#8216;. It was based on an [article with the same title on networkworld.com][2]. Apparently SQL injection has taken over the lead from XSS. Not surprisingly the first user-comment stated that almost 100% of the exploits were certainly in PHP applications written by would-be programmers. With things so obvious it&#8217;s of course unneccessary to provide factual data backing up such a statement. So, nothing to win in that discussion. Three days ago news came that [a customer database of Kaspersky was hacked][3]. By using SQL injection. On [a PHP website][4]. Could commenter X be right?
  
<!--more-->


  
It _is_ true that PHP allows novice as well as experienced programmers to achieve &#8216;what they want&#8217;. And the novice might adopt some very bad practices. But does that make PHP an insecure programming language? Compare it to driving a car. Yes, you can drive around like a maniac and wreak havoc on the unaware. But does that make a car an unsecure vehicle? The PHP platform offers enough techniques to rule out SQL injection attacks:

  * Prepared statements. There&#8217;s no need to concat potentially harmful data in SQL statements. Provide them as a parameter when executung a prepared statement. More efficient too.
  * ORM. If you think SQL should be behind an abstraction layer, you can do so. [Propel][5] and [Doctrine][6] are the best known solutions for PHP.
  * Well structured programming. If, for some reason, you want to build queries the old way you can force upon yourself (or your team) some good practices. See example below.

    $dataTainted['un'] = $_POST['un'];
    $dataTainted['pw'] = $_POST['pw'];
    
    // escape all array values using a custom function of some sort
    $dataSafe = mysqlEscapeValues($dataTainted);
    
    $query = &lt;&lt;&lt;SQL
    SELECT
      *
    FROM
      users
    WHERE
      un = "{$dataSafe['un']}"
    AND
      pw = SHA1("{$dataSafe['pw']}")
    SQL;
    

And that's just the coding part of the story. In the area of application design a lot can be done to minimize the consequences of an exploit. For example, different database users can be set up that have different levels of access. Only parts of a website needing customer data then use the credentials that do provide such access.

So, for PHP there are good practices and solutions aplenty. For more information on SQL injection one can start at [OWASP][7] or [Wikipedia][8]. And finally, the subject isn't non-existent in [.NET][9] and [JSP][10].

 [1]: http://webwereld.nl/article/comments/id/54694
 [2]: http://www.networkworld.com/news/2009/020209-sql-injection-attack.html
 [3]: http://www.theregister.co.uk/2009/02/08/kaspersky_compromise_report/
 [4]: http://usa.kaspersky.com/about-us/news-press-releases.php?smnr_id=900000208
 [5]: http://propel.phpdb.org/
 [6]: http://www.doctrine-project.org/
 [7]: http://www.owasp.org/index.php/Guide_to_SQL_Injection
 [8]: http://en.wikipedia.org/wiki/SQL_injection#Real-world_examples
 [9]: http://msdn.microsoft.com/en-us/magazine/cc163917.aspx
 [10]: http://kb.adobe.com/selfservice/viewContent.do?externalId=585ac720