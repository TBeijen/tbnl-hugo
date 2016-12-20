---
title: 'Moving from Wordpress to Hugo'
author: Tibo Beijen
date: 2016-12-18T12:00:00+01:00
url: /2016/12/18/moving-from-wordpress-to-hugo/
categories:
  - articles
tags:
  - Wordpress
  - Hugo
  - Caddy
  - Ansible
description: For some years my blog has been inactive. (Now this could imply that 'not much was happening' on a professional level but that hasn't been the case, in contrary) Recently I've been thinking about adding new content and it became clear that my old Wordpress setup wasn't the best fit anymore for my needs. Several people I know have been very possitive about Hugo and the webserver Caddy so I decided to give that a try.

---
### Introduction

For some years my blog has been inactive. (Now this could imply that 'not much was happening' on a professional level but that hasn't been the case, in contrary) Recently I've been thinking about adding new content and it became clear that my old Wordpress setup wasn't the best fit anymore for my needs. Several people I know have been very possitive about [Hugo][1] and the webserver [Caddy][2] so I decided to give that a try.

### Advantages of Hugo and Caddy over Wordpress

Some of the advantages of the Hugo/Caddy setup over Wordpress as I see them. 

* No more maintenance due to patching of Wordpress and it's numerous plugins [^footnote]
* Implicit backups, content will now at any point be at my laptop, my VPS and Github
* A workflow similar to my day-to-day coding practice, using commits and branches in a versioning system to track progress
* Caddy enables 'Let's Encrypt' with basically zero config
* Http2. Not really important for this site at this stage but 'nice to have' nevertheless.
* Using [Disqus][3] for comments. Not 'owning' the comments could be considered a downside, but for me decoupling the comment system from the technology that creates the site gives me flexibility without having to bother about migrating comments. Plus disqus has an [export][4] function and an [API][5], so content is not entirely locked in.





Introduction
	Why
	Advantages
	https://gohugo.io/
	Integration caddy
	https://caddyserver.com/

	http://blog.getpelican.com/

Exporting
	Exporting from Wordpress
		https://github.com/SchumacherFM/wordpress-to-hugo-exporter
		https://github.com/benbalter/wordpress-to-jekyll-exporter

	Exporting comments
		https://nl.wordpress.org/plugins/disqus-comment-system/

Setting up Hugo
	
	Livereload https://gohugo.io/extras/livereload/
	Some tweaks to exported content: bin script

Setting up VPS using Ansible

	Hugo
		Simply apt (currently 0.16)
	Caddy
		Excellent caddy ansible galaxy role.
		Why excellent? (Vagrantfile covering multiple OS. Attention to idempotence. Some of these aspects have been very well summarized in a recent blogpost by ..., with which I  )

		Good tutorial: https://daplie.com/articles/lets-encrypt-on-digital-ocean-with-caddy/

 [^footnote]: Of course there is the possibility to automate the updating of Wordpress and the plugins. However, this goes against what I consider a good practice: Actually testing any change before blindly putting it in production and hope for the best. Guarding against vulnerabilities is definitely the lesser of evils in this case. But essentially that would require setting up restore points and means to test if all plugins still work. A plugin like [Wordfence](https://nl.wordpress.org/plugins/wordfence/) will help a lot. Altogether, I consider it a lot of moving parts for a site where almost nothing 'moves'.



 [1]: https://gohugo.io/
 [2]: https://caddyserver.com/
 [3]: https://disqus.com/
 [4]: https://help.disqus.com/customer/portal/articles/472149-comments-export
 [5]: https://disqus.com/api/docs/
