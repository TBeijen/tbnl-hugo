---
title: Fixing mysqldump on Zend Server CE on OS X
author: Tibo Beijen
date: 2011-03-01T07:37:56+00:00
url: /blog/2011/03/01/fixing-mysqldump-on-zend-server-ce-on-os-x/
postuserpic:
  - /pa_zendserver_80.png
categories:
  - miscellaneous
tags:
  - configuration
  - mysql
  - os x
  - server administration
  - zend server

---
A while ago I installed Zend Server Community Edition on OS X which was pretty straightforward. It was only recently that I found out that, as opposed to `mysql` which worked fine, `mysqldump` didn&#8217;t work correctly and terminated with the error:
  
``A while ago I installed Zend Server Community Edition on OS X which was pretty straightforward. It was only recently that I found out that, as opposed to `mysql` which worked fine, `mysqldump` didn&#8217;t work correctly and terminated with the error:
  
`` 
  
Inspecting the mysql configuration contained in `/usr/local/zend/mysql/data/my.cnf` confirmed that the section [client] showed the socket as returned by executing `SHOW VARIABLES;` from the mysql client: `/usr/local/zend/mysql/tmp/mysql.sock`

Although it is possible to specify the socket by using mysqldump&#8217;s `--socket` switch, that doesn&#8217;t really seem a &#8216;solution&#8217;. 

Apparently mysqldump, as opposed to the mysql client does not use the server-specific settings contained in `/usr/local/zend/mysql/data/my.cnf`. The comments in my.cnf state:

    # You can copy this file to
    # /etc/my.cnf to set global options,
    # mysql-data-dir/my.cnf to set server-specific options (in this
    # installation this directory is /usr/local/zend/mysql/data) or
    # ~/.my.cnf to set user-specific options.
    

After copying `/usr/local/zend/mysql/data/my.cnf` to `/etc/my.cnf` mysqldump worked as expected.

In `/etc/my.cnf` I have included only the setting needed to get mysqldump running:

    # Specifying socket to use for mysql/mysqldump
    # For other settings refer to /usr/local/zend/mysql/data/my.cnf
    [client]
    socket      = /usr/local/zend/mysql/tmp/mysql.sock
    

Hope this saves anyone running into the same issue some time.

**Update** (alternative solutions):
  
As Joel Clermont pointed out it is also possible to create a symlink on the socket location expected by mysqldump to the real socket location. This can be done by executing:
  
```A while ago I installed Zend Server Community Edition on OS X which was pretty straightforward. It was only recently that I found out that, as opposed to `mysql` which worked fine, `mysqldump` didn&#8217;t work correctly and terminated with the error:
  
``A while ago I installed Zend Server Community Edition on OS X which was pretty straightforward. It was only recently that I found out that, as opposed to `mysql` which worked fine, `mysqldump` didn&#8217;t work correctly and terminated with the error:
  
`` 
  
Inspecting the mysql configuration contained in `/usr/local/zend/mysql/data/my.cnf` confirmed that the section [client] showed the socket as returned by executing `SHOW VARIABLES;` from the mysql client: `/usr/local/zend/mysql/tmp/mysql.sock`

Although it is possible to specify the socket by using mysqldump&#8217;s `--socket` switch, that doesn&#8217;t really seem a &#8216;solution&#8217;. 

Apparently mysqldump, as opposed to the mysql client does not use the server-specific settings contained in `/usr/local/zend/mysql/data/my.cnf`. The comments in my.cnf state:

    # You can copy this file to
    # /etc/my.cnf to set global options,
    # mysql-data-dir/my.cnf to set server-specific options (in this
    # installation this directory is /usr/local/zend/mysql/data) or
    # ~/.my.cnf to set user-specific options.
    

After copying `/usr/local/zend/mysql/data/my.cnf` to `/etc/my.cnf` mysqldump worked as expected.

In `/etc/my.cnf` I have included only the setting needed to get mysqldump running:

    # Specifying socket to use for mysql/mysqldump
    # For other settings refer to /usr/local/zend/mysql/data/my.cnf
    [client]
    socket      = /usr/local/zend/mysql/tmp/mysql.sock
    

Hope this saves anyone running into the same issue some time.

**Update** (alternative solutions):
  
As Joel Clermont pointed out it is also possible to create a symlink on the socket location expected by mysqldump to the real socket location. This can be done by executing:
  
``` 

Another possible approach is to create a symlink at `/etc/my.cnf` to `/usr/local/zend/mysql/data/my.cnf`. This has the downside that it requires loosening the default permissions (`drwxr-x---`) on the data folder by allowing &#8216;others&#8217; to enter it. Commands to execute:
  
````A while ago I installed Zend Server Community Edition on OS X which was pretty straightforward. It was only recently that I found out that, as opposed to `mysql` which worked fine, `mysqldump` didn&#8217;t work correctly and terminated with the error:
  
``A while ago I installed Zend Server Community Edition on OS X which was pretty straightforward. It was only recently that I found out that, as opposed to `mysql` which worked fine, `mysqldump` didn&#8217;t work correctly and terminated with the error:
  
`` 
  
Inspecting the mysql configuration contained in `/usr/local/zend/mysql/data/my.cnf` confirmed that the section [client] showed the socket as returned by executing `SHOW VARIABLES;` from the mysql client: `/usr/local/zend/mysql/tmp/mysql.sock`

Although it is possible to specify the socket by using mysqldump&#8217;s `--socket` switch, that doesn&#8217;t really seem a &#8216;solution&#8217;. 

Apparently mysqldump, as opposed to the mysql client does not use the server-specific settings contained in `/usr/local/zend/mysql/data/my.cnf`. The comments in my.cnf state:

    # You can copy this file to
    # /etc/my.cnf to set global options,
    # mysql-data-dir/my.cnf to set server-specific options (in this
    # installation this directory is /usr/local/zend/mysql/data) or
    # ~/.my.cnf to set user-specific options.
    

After copying `/usr/local/zend/mysql/data/my.cnf` to `/etc/my.cnf` mysqldump worked as expected.

In `/etc/my.cnf` I have included only the setting needed to get mysqldump running:

    # Specifying socket to use for mysql/mysqldump
    # For other settings refer to /usr/local/zend/mysql/data/my.cnf
    [client]
    socket      = /usr/local/zend/mysql/tmp/mysql.sock
    

Hope this saves anyone running into the same issue some time.

**Update** (alternative solutions):
  
As Joel Clermont pointed out it is also possible to create a symlink on the socket location expected by mysqldump to the real socket location. This can be done by executing:
  
```A while ago I installed Zend Server Community Edition on OS X which was pretty straightforward. It was only recently that I found out that, as opposed to `mysql` which worked fine, `mysqldump` didn&#8217;t work correctly and terminated with the error:
  
``A while ago I installed Zend Server Community Edition on OS X which was pretty straightforward. It was only recently that I found out that, as opposed to `mysql` which worked fine, `mysqldump` didn&#8217;t work correctly and terminated with the error:
  
`` 
  
Inspecting the mysql configuration contained in `/usr/local/zend/mysql/data/my.cnf` confirmed that the section [client] showed the socket as returned by executing `SHOW VARIABLES;` from the mysql client: `/usr/local/zend/mysql/tmp/mysql.sock`

Although it is possible to specify the socket by using mysqldump&#8217;s `--socket` switch, that doesn&#8217;t really seem a &#8216;solution&#8217;. 

Apparently mysqldump, as opposed to the mysql client does not use the server-specific settings contained in `/usr/local/zend/mysql/data/my.cnf`. The comments in my.cnf state:

    # You can copy this file to
    # /etc/my.cnf to set global options,
    # mysql-data-dir/my.cnf to set server-specific options (in this
    # installation this directory is /usr/local/zend/mysql/data) or
    # ~/.my.cnf to set user-specific options.
    

After copying `/usr/local/zend/mysql/data/my.cnf` to `/etc/my.cnf` mysqldump worked as expected.

In `/etc/my.cnf` I have included only the setting needed to get mysqldump running:

    # Specifying socket to use for mysql/mysqldump
    # For other settings refer to /usr/local/zend/mysql/data/my.cnf
    [client]
    socket      = /usr/local/zend/mysql/tmp/mysql.sock
    

Hope this saves anyone running into the same issue some time.

**Update** (alternative solutions):
  
As Joel Clermont pointed out it is also possible to create a symlink on the socket location expected by mysqldump to the real socket location. This can be done by executing:
  
``` 

Another possible approach is to create a symlink at `/etc/my.cnf` to `/usr/local/zend/mysql/data/my.cnf`. This has the downside that it requires loosening the default permissions (`drwxr-x---`) on the data folder by allowing &#8216;others&#8217; to enter it. Commands to execute:
  
```` 
  
Granting more permissions can be a security consideration but on most development setups this probably won&#8217;t be an issue.

Additional info about Zend Server CE on OS X:

  * [Zend Server CE Documentation][1]
  * [Rob Allen: Some notes on Zend Server CE for Mac OS X][2]

 [1]: http://files.zend.com/help/Zend-Server-Community-Edition/zend-server-community-edition.htm
 [2]: http://akrabat.com/php/some-notes-on-zend-server-ce-for-mac-os-x/