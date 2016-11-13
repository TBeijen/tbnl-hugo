---
title: Installing PHPUnit on XAMPP Lite (Windows)
author: Tibo Beijen
date: 2009-05-17T13:39:00+00:00
url: /blog/2009/05/17/installing-phpunit-on-xampp-lite-windows/
postuserpic:
  - /pa_phpunit_80.jpg
categories:
  - miscellaneous
tags:
  - pear
  - phpunit
  - windows
  - xampp

---
At my work PHPUnit is &#8216;just there&#8217; but it&#8217;s not on my home machine where I&#8217;m running an out of the box [XAMPP Lite][1] setup. So I visited the [PHPUnit installation manual][2] and all looked easy:

    pear channel-discover pear.phpunit.de
    pear install phpunit/PHPUnit
    

But what I got was a message saying my pear installer was out of date, 1.7.1 was needed. Running &#8216;pear -V&#8217; showed:

    E:\Xampplite\php>pear -V
    PEAR Version: 1.4.5
    PHP Version: 5.2.5
    Zend Engine Version: 2.2.0
    Running on: Windows NT T1720 6.0 build 6000

Allright, upgrading PEAR it is. That was not as straightforward as hoped.
  
<!--more-->

### go-pear

I don&#8217;t know much about PEAR so I found a lot of possible solutions ranging from manually installing specific packages to something a bit more straightforward like &#8216;go-pear&#8217;. Better start simple so &#8216;go-pear&#8217; it is. That started fine but ended up in a number of the following messages:

    Warning: Cannot use a scalar value as an array in phar://go-pear.phar/PEAR/Comma
    nd.php on line 268

After finding the right keywords to put into google I came on [this page on PHPWomen.org][3]. Spot on. After replacing go-pear.phar (rename the old one first, you never know) &#8216;go-pear&#8217; at least stopped showing aforementioned errors but displayed some warnings (Commit Failed) that made me suspicious. And indeed, &#8216;pear -V&#8217; still showed 1.4.5.

### pear upgrade

Luckily I had quite some google tabs open allready so I proceeded with the next strategy:

    E:\Xampplite\php>pear upgrade pear
    downloading PEAR-1.8.1.tgz ...
    Starting to download PEAR-1.8.1.tgz (290,382 bytes)
    ............................................................done: 290,382 bytes
    downloading Archive_Tar-1.3.3.tgz ...
    Starting to download Archive_Tar-1.3.3.tgz (18,119 bytes)
    ...done: 18,119 bytes
    downloading Console_Getopt-1.2.3.tgz ...
    Starting to download Console_Getopt-1.2.3.tgz (4,011 bytes)
    ...done: 4,011 bytes
    upgrade ok: channel://pear.php.net/Archive_Tar-1.3.3
    upgrade ok: channel://pear.php.net/Console_Getopt-1.2.3
    Could not delete E:\Xampplite\php\pear.bat, cannot rename E:\Xampplite\php\.tmpp
    ear.bat
    ERROR: commit failed
    

Bummer. I tried renaming pear.bat but then the installer came with the same message for pear-dev.bat so I looked for a &#8216;real&#8217; solution. Once again finding the right keywords (pear upgrade cannot delete windows) Google did the rest and yielded [a page on pear-forum.org][4]. I was one third on my way to the &#8216;real&#8217; solution that is renaming the following files:

    rename pear.bat _pear.bat
    rename peardev.bat _peardev.bat
    rename pecl.bat _pecl.bat

Followed by:

    _pear upgrade pear

Resulting in:

    E:\Xampplite\php>pear -V
    PEAR Version: 1.8.1
    PHP Version: 5.2.5
    Zend Engine Version: 2.2.0
    Running on: Windows NT T1720 6.0 build 6000

### Victory

Retrying installing of PHPUnit now worked.

    E:\Xampplite>phpunit --version
    PHPUnit 3.3.16 by Sebastian Bergmann.

One final thing. It&#8217;s very convenient to add the php directory to environment path setting to allow for executing &#8216;php&#8217; or &#8216;phpunit&#8217; from whatever project directory. Do so by going to (on Vista, XP might differ):

    Control Panel ->
    System ->
    Advanced system settings ->
    (In the popup, bottom button) Environment Variables ->
    (Lower list) Select path & choose 'edit'

Now add the php directory to the end of the line, in this case &#8220;;E:\Xampplite\php&#8221; (without the quotes). A restart might be needed.

 [1]: http://www.apachefriends.org/en/xampp-windows.html#646
 [2]: http://www.phpunit.de/manual/current/en/installation.html
 [3]: http://www.phpwomen.org/wordpress/2006/11/06/bundled-go-pearphar-broken-in-52-windows-releases/
 [4]: http://www.pear-forum.org/topic1201.html