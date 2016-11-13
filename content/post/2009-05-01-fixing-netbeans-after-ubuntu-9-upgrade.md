---
title: Fixing Netbeans after Ubuntu 9 upgrade
author: Tibo Beijen
date: 2009-05-01T09:20:14+00:00
url: /blog/2009/05/01/fixing-netbeans-after-ubuntu-9-upgrade/
postuserpic:
  - /pa_ubuntu_white_80.png
categories:
  - miscellaneous
tags:
  - linux
  - netbeans
  - ubuntu

---
This morning I upgraded my Ubuntu machine using the auto-update. As I just recently started using Ubuntu I&#8217;m very pleased at how some features work compared to Vista. (Vista users will probably be familiar with the auto-update restart that has a terrific feel for timing by always presenting you the choice for postponing the restart when you have several documents opened and are away for a coffee break.) After my self initiated restart everything worked like a charm, OpenOffice is updated to version 3 (nice for the docx workflow) but&#8230; Netbeans didn&#8217;t start. Now that&#8217;s bad for productivity. Running from the console showed the following:

    Cannot find java. Please use the --jdkhome switch.
    

a After a little bit of googling I learned there is a netbeans.conf somewhere. On my system it&#8217;s location is:

    ~/netbeans-6.7-m2/etc/netbeans.conf
    

In there, look for a line like

    netbeans_jdkhome="/usr/lib/jvm/java-6-sun-1.6.0.13/jre"
    

and change the version number to the correct version. For me it worked like a charm, I hope it helps someone.