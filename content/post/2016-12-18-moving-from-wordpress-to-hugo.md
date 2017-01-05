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
## Introduction

For some years my blog has been inactive. (Now this could imply that 'not much was happening' on a professional level but that hasn't been the case, in contrary) Recently I've been thinking about adding new content and it became clear that my old Wordpress setup wasn't the best fit anymore for my needs. Several people I know have been very possitive about [Hugo][1] and the webserver [Caddy][2] so I decided to give that a try. For hosting I chose [Digital Ocean](https://m.do.co/c/a6a97fed1069) (Referral link, gets you $10 to start with), based on reputation, pricing and their excellent [technical articles](https://www.digitalocean.com/community/tutorials).

## Advantages of Hugo and Caddy over Wordpress

Some of the advantages of the Hugo/Caddy setup over Wordpress as I see them. 

* No more maintenance due to patching of Wordpress and plugins used. [^footnote]
* No more security risks due to [the nature of Wordpress][6] and [some of its plugins][7].
* Implicit backups, content will now at any point be at my laptop, my VPS and Github.
* A workflow similar to my day-to-day coding practice, using commits and branches in a versioning system to track progress.
* Caddy enables 'Let's Encrypt' with basically zero config.
* Http2. Not really important for this site at this stage but 'nice to have' nevertheless.
* Using [Disqus][3] for comments. Not 'owning' the comments could be considered a downside, but for me decoupling the comment system from the technology that creates the site gives me flexibility without having to bother about migrating comments. Plus disqus has an [export][4] function and an [API][5], so content is not entirely locked in.

## Exporting Wordpress content to Hugo 

For exporting wordpress contents to a set of Markdown I used [Wordpress to Hugo convertor][8] which in turn was based on the plugin [Wordpress to Jekyll exporter][9]. As a lot of static site generators use Markdown there are probably a lot of other tools to export wordpress content.

After exporting, a Hugo site structure was created containing the blog posts and pages in Markdown format. Some things needed additional fixing, most notably code blocks, which were exported as HTML fragments using `pre` tags instead of indented code blocks. Cooking up a [python script](https://github.com/TBeijen/tbnl-hugo/blob/master/bin/process_post.py) solved this quite easily.

## Migrating comments to Disqus

Using the [official Disqus Wordpress plugin](https://nl.wordpress.org/plugins/disqus-comment-system/) it's fairly easy to export comments. Be sure to test this first on a test site you've created in your Disqus profile. (Basically: Follow the [Disqus guidelines for development sites](https://help.disqus.com/customer/portal/articles/1053796-best-practices-for-staging-development-and-preview-sites)).

As it turned out, in Disqus https and http are considered different domains. So initially comments didn't show up on my 'production' site (I tested import using http, so missed that part). Although the 'Domain migration tool' seems like the right tool for this conversion I ran into some bumps, resulting in quite a mess. As explained in [this article](https://woorkup.com/migrate-disqus-comments-https/), the 'URL mapper' works fine for this case.

So the main take-away is: Test your export to disqus, including scheme, path or domain changes. 

## Setting up a VPS

### Initial setup using Cloud-Init

For initial server setup I used CloudInit. By providing a ``cloud-config`` script, important parts of the server configuration can be completed even before logging in. This includes:

* User creation
* Setting up access keys
* Packages
* Timezone
* SSH config
* UFW firewall setup

Because of some details I've encrypted the cloud-config using Ansible Vault. There's nothing in there that's not explained in [DigitalOcean's cloud-config tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-cloud-config-for-your-initial-server-setup) and various examples on github.

### Provisioning using Ansible

For configuring everything that would not be similar on all my VPSes, I used Ansible. 

Although for a single VPS this will probably take more time than simply installing and configuring some packages manually, it has some important benefits:

* **Documentation by code**. Following [*If it isn't documented it doesn't exist*](https://blog.codinghorror.com/if-it-isnt-documented-it-doesnt-exist/), the ansible code and comments can be considered documentation of the server configuration. I'm for sure not going to *remember* all manual installation steps.
* **Reproducability**. This will help for example when:
    * Wanting to move to a different host
    * Needing to upgrade packages. It allows for easily testing on Vagrant or spinning up a second VPS, testing that, and then switching DNS to it and shutting down the old one.







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

 [^footnote]: Of course there is the possibility to automate the updating of Wordpress and the plugins. However, this goes against what I consider a good practice: Actually testing any change before blindly putting it in production and hope for the best. Admitted: Guarding against vulnerabilities is definitely the lesser of evils in this case. But essentially that would require setting up restore points and means to test if all plugins still work. For hardening Wordpress a plugin like [Wordfence](https://nl.wordpress.org/plugins/wordfence/) will help a lot. Altogether, I consider it a lot of moving parts for a site where almost nothing 'moves'.



 [1]: https://gohugo.io/
 [2]: https://caddyserver.com/
 [3]: https://disqus.com/
 [4]: https://help.disqus.com/customer/portal/articles/472149-comments-export
 [5]: https://disqus.com/api/docs/
 [6]: http://www.openwall.com/lists/oss-security/2016/11/21/3
 [7]: https://blog.ripstech.com/2016/the-state-of-wordpress-security/
 [8]: https://github.com/SchumacherFM/wordpress-to-hugo-exporter
 [9]: https://github.com/benbalter/wordpress-to-jekyll-exporter

