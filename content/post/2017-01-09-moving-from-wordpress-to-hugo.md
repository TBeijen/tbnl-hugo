---
title: 'Moving from Wordpress to Hugo'
author: Tibo Beijen
date: 2017-01-09T10:00:00+01:00
url: /2017/01/09/moving-from-wordpress-to-hugo/
categories:
  - articles
tags:
  - Wordpress
  - Hugo
  - Caddy
  - Ansible
description: For some years my blog has been inactive. Now this could imply that 'not much was happening' on a professional level but that hasn't been the case, in contrary. Recently I've been thinking about adding new content and it became clear that my old Wordpress setup wasn't the best fit anymore for my needs. Several people I know have been very positive about Hugo and the webserver Caddy so I decided to give that a try.

---
## Introduction

For some years my blog has been inactive. Now this could imply that 'not much was happening' on a professional level but that hasn't been the case, in contrary. Recently I've been thinking about adding new content and it became clear that my old Wordpress setup wasn't the best fit anymore for my needs. Several people I know have been very positive about [Hugo](https://gohugo.io/) and the webserver [Caddy](https://caddyserver.com/) so I decided to give that a try. For hosting I chose [Digital Ocean](https://m.do.co/c/a6a97fed1069) (Referral link, gets you $10 to start with), based on reputation, pricing and their excellent [technical articles](https://www.digitalocean.com/community/tutorials).

In this post I'll summarize the steps taken to migrate content to Hugo and setup Hugo and Caddy on a VPS. Provisioning code using Ansible is [on GitHub](https://github.com/TBeijen/tbnl-provision/).

### TL;DR:

* Exporting to Wordpress is fairly easy but the resulting files might need some postprocessing.
* Test your export to disqus, including scheme, path or domain changes.
* Use Snap packages instead of your distro's standard package manager to install the latest Hugo version.
* Setting up Let's Encrypt using Caddy is very easy (easy as in actually doing nothing). Testing it if your site is not yet accessible under the intended domain name will be harder.
* Be aware of Systemd's ``ProtectHome`` feature to save a lot of time figuring out why deploy keys or scripts won't work when invoked from Caddy.
* Pushover and Uptimerobot make for great finishing touches.

The old Wordpress site:

![The old Wordpress site](/img/wordpress_to_hugo__wordpress_site.png)

## Advantages of Hugo and Caddy over Wordpress

Some of the advantages of the Hugo/Caddy setup over Wordpress as I see them:

* No more maintenance due to patching of Wordpress and plugins used. [^footnote_wordpress]
* No more security risks due to [the nature of Wordpress](http://www.openwall.com/lists/oss-security/2016/11/21/3) and [some of its plugins](https://blog.ripstech.com/2016/the-state-of-wordpress-security/).
* Implicit backups, content will now at any point be at my laptop, my VPS and GitHub.
* A workflow similar to my day-to-day coding practice, using commits and branches in a versioning system to track progress.
* Caddy enables 'Let's Encrypt' with basically zero config.
* Http2. Not really important for this site at this stage but 'nice to have' nevertheless.
* Using [Disqus](https://disqus.com/) for comments. Not 'owning' the comments could be considered a downside, but for me decoupling the comment system from the technology that creates the site gives me flexibility without having to bother about migrating comments. Plus disqus has an [export](https://help.disqus.com/customer/portal/articles/472149-comments-export) function and an [API](https://disqus.com/api/docs/), so content is not entirely locked in.

Regardless of the advantages, the design was outdated and templates were not responsive, so work needed to be done anyway.

## Exporting Wordpress content to Hugo 

For exporting wordpress content to Markdown I used [Wordpress to Hugo convertor](https://github.com/SchumacherFM/wordpress-to-hugo-exporter) which in turn was based on the plugin [Wordpress to Jekyll exporter](https://github.com/benbalter/wordpress-to-jekyll-exporter). As a lot of static site generators use Markdown there are probably a lot of other tools to export wordpress content.

After exporting, a Hugo site structure was created containing the blog posts and pages in Markdown format. Some things needed additional fixing, most notably code blocks, which were exported as HTML fragments using `pre` tags instead of indented code blocks. Cooking up a [python script](https://github.com/TBeijen/tbnl-hugo/blob/master/bin/process_post.py) solved this quite easily.

## Migrating comments to Disqus

Using the [official Disqus Wordpress plugin](https://nl.wordpress.org/plugins/disqus-comment-system/) it's fairly easy to export comments. Be sure to test this first on a test site you've created in your Disqus profile. (Basically: Follow the [Disqus guidelines for development sites](https://help.disqus.com/customer/portal/articles/1053796-best-practices-for-staging-development-and-preview-sites)).

As it turned out, in Disqus https and http are considered different domains. So initially comments didn't show up on my 'production' site (I tested import using http, so missed that part). Although the 'Domain migration tool' seems like the right tool for this conversion I ran into some bumps, resulting in quite a mess. As explained in [this article](https://woorkup.com/migrate-disqus-comments-https/), the 'URL mapper' works fine for this case.

## Initial VPS setup using Cloud-Init

For initial server setup I used CloudInit. By providing a ``cloud-config`` script, important parts of the server configuration can be completed even before logging in. This includes:

* User creation
* Setting up access keys
* Packages
* Timezone
* SSH config
* UFW firewall setup

Because of some details I've encrypted the cloud-config using Ansible Vault. There's nothing in there that's not explained in [DigitalOcean's cloud-config tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-cloud-config-for-your-initial-server-setup) and various examples on GitHub.

## Provisioning VPS using Ansible

For configuring everything not covered by Cloud-Init, I used Ansible. 

Although for a single VPS this will probably take more time than simply installing and configuring some packages manually, it has some important benefits:

* **Documentation by code**. Following [*If it isn't documented it doesn't exist*](https://blog.codinghorror.com/if-it-isnt-documented-it-doesnt-exist/), the ansible code and comments can be considered documentation of the server configuration. I'm for sure not going to *remember* all manual installation steps.
* **Reproducability**. This will help for example when:
    * Wanting to move to a different host
    * Needing to upgrade packages. It allows for easily testing on Vagrant or spinning up a second VPS, testing that, and then switching DNS to it and shutting down the old one.

### Setting up Hugo 

The easiest way of installing Hugo is using your distro's pacakage manager, in my case `apt`. On Ubuntu this installed version 0.16 (Dec. 2016). The downside is that the latest version of Hugo is usually not available yet in the default repositories.

Currently Hugo is [already at v0.18.1](https://github.com/spf13/hugo/releases) so I'll upgrade soon. As Hugo seems to tend towards using ``snap`` packages, I'll look into that. Sadly there doesn't seem to be an Ansible module for snap packages yet.

### Setting up Caddy

For Caddy a fine[^footnote_caddy] role exists on Ansible Galaxy: [antoiner77.caddy](https://galaxy.ansible.com/antoiner77/caddy/). Nevertheless, I copied it to my project and modified some parts:

* I added an optional ``-email`` switch to the ``ExecStart`` command in the systemd config file ``caddy.service``.
* I set ``ProtectHome`` to ``false`` in ``caddy.service``.
* I used a template file for ``Caddyfile`` instead of defining it directly in group vars. As there's some conditionals in there and length is quite a bit larger than the default example, I find a template to be more readable and easier to maintain (For example: No yaml indenting needed).

#### Reflecting on the above
Although present both in cli command and Caddyfile in a [Let's Encrypt in 90 seconds](https://daplie.com/articles/lets-encrypt-in-literally-90-seconds/) tutorial on Daplie.com, based on [the Caddy cli docs](https://caddyserver.com/docs/cli) the ``-email`` switch doesn't seem neccessary. Quoting: *"Email address to use ...if not specified for a site in the Caddyfile"*.

Furthermore, after I started using the Caddy role, there has been an update that includes the [systemd service file in the role](https://github.com/antoiner77/caddy-ansible/blob/master/templates/caddy.service), instead of copying it from the Caddy source files. This will make it much easier to make parts of it configurable via group vars.

Lastly, optionally overriding a default Caddyfile template provided by the role would be doable using 
[Ansible's with_first_found](http://docs.ansible.com/ansible/playbooks_loops.html#finding-first-matched-files) construct.

I plan to issue a PR with some of these tweaks to the Caddy role.

## Configuring Caddy

The Caddyfile template looks like this:

```
# redirect no subdomain to www
#
tibobeijen.nl{% if not caddy_lets_encrypt %}:80{% endif %} {
  redir / {scheme}://{{ caddy_site_domain }}{uri} 302
}

# handle /anno2003/
#
{{ caddy_site_domain }}{% if not caddy_lets_encrypt %}:80{% endif %}/anno2003/ {
  proxy / localhost:8080 {
    transparent
  }
}

# main site
#
{{ caddy_site_domain }}{% if not caddy_lets_encrypt %}:80{% endif %} {
  # make sure /anno2003/ always has trailing slash
  redir /anno2003 /anno2003/ 302
  gzip
  root /var/html/tbnl/public
{% if caddy_lets_encrypt %}  tls {{ caddy_email }}
{% endif %}
  errors {
  	404 404.html
  }
  git {
    repo github.com/TBeijen/tbnl-hugo 
    hook /webhook {{ webhook_secret }}
    hook_type github
    path ../source
    branch master
    then bash -c "git submodule update --init --recursive"
    then hugo -b http{% if caddy_lets_encrypt %}s{% endif %}://{{ caddy_site_domain }}/ --destination=/var/html/tbnl/public
    then {{ caddy_home }}/pushover "Site updated"
  }
}
```

### Let's encrypt on non-accessible hosts

I've added a variable ``caddy_lets_encrypt``. This allowed me to test the setup on a non-HTTPS Vagrant setup. Furthermore, it allowed me to start using Caddy's 0-config Let's Encrypt feature without breaking things, as Caddy will not start when it can't validate the domain. As I initially still had my Wordpress site running elsewhere this would case problems. So my roll-out has been:

* Provision Caddyfile supporting port 80 only
* Change DNS, 'launch' the Hugo/Caddy site
* Re-provision with HTTPS enabled

Be sure to read the Caddy (automatic https guid)[https://caddyserver.com/docs/automatic-https]. Especially note that:

* If you're using one of the supported DNS provider, you might not need the 'if caddy_lets_encrypt' conditionals I used.
* There is a (staging environment for Let's Encrypt)[https://letsencrypt.org/docs/staging-environment/]. I only read about that aftwerwards and didn't run into problems, but that looks to be just luck.

### Docker?

For fun I keep [my first site](https://www.tibobeijen.nl/anno2003/) alive, a JS-heavy SPA from the times when [XMLHttpRequest](XMLHttpRequest) wasn't widely available yet. I'm interested to see how long it takes before it really breaks. So far it still works pretty neat, on desktop resolutions that is. I'm going to write in more detail about that in another post.

### Building Hugo
Caddy's [git extension](https://caddyserver.com/docs/git) is what really makes the Caddy & Hugo combination fly. A push to the master branch is all that it takes to trigger Caddy to check out the code and build a new Hugo site.

### ProtectHome False?
I had two things on my wishlist that weren't implemented as smoothly as hoped for:

* Using a git submodule to check out the Hugo theme
* Sending a notfication via [Pushover](https://pushover.net/) when the site has been updated

I originally had the theme submodule defined as ssh link. However, when installing Caddy reported errors about not being able to access the deploy key I provisioned in the caddy home folder. Double checking permissions, trying the same steps as caddy user, all worked fine. This point I worked around by switching the submodule reference to https.

When setting up the pushover script I ran into the same issue, and then discovered that systemd has the ability to protect home folders, which is turned on in the systemd script provided by Caddy. This could also have been worked around by adding the curl command directly in the Caddyfile.

As Caddy doesn't run as root and file permissions already provide a good level of protection with regard to ssh keys, I found no reason to not disable the ``ProtectHome`` feature. The security part now looks like this:

```
; Use private /tmp and /var/tmp, which are discarded after caddy stops.
PrivateTmp=true
; Use a minimal /dev
PrivateDevices=true
; Hide /home, /root, and /run/user. Nobody will steal your SSH-keys.
ProtectHome=false
; Make /usr, /boot, /etc and possibly some more folders read-only.
ProtectSystem=full
; … except /etc/ssl/caddy, because we want Letsencrypt-certificates there.
;   This merely retains r/w access rights, it does not add any new. Must still be writable on the host!
ReadWriteDirectories=/etc/ssl/caddy
```

### Pushover
Pushover is a great notification service that allows sending notifications using a variety of delivery formats for applications you can configure in detail. We use it in our team for monitoring notifications. By setting different icons it's easy to distinguish 'hobby stuff is broken' from 'people are gonna call any second now'.

Sending a pushover notification (Ansible template):

```
#!/bin/bash
curl -s -F "token={{ pushover_api_token }}" \
-F "user={{ pushover_user_key }}" \
-F "title={{ pushover_title }}" \
-F "message=$1" https://api.pushover.net/1/messages.json
```

The result:

![Pushover notification for site update](/img/wordpress_to_hugo__pushover_notification.png)

### Bonus: Uptimerobot

Having set up Pushover already, an easy finishing touch is setting up basic monitoring. [Uptimerobot](https://uptimerobot.com/) has a free plan allowing up to 50 monitors at 5 minute intervals. It has integration with Pushover, although it asks for the 'user key' instead of the application-specific 'API token', so you can also set up an application-specific e-mail address in Pushover and use that.

## Summary

All in all the process of moving from Wordpress to Hugo was pretty smooth. Extracting content was fairly easy although it required quite some post-processing. Migrating the content was a similar experience: There might be some bumps, you need to test, but it's perfectly doable.

Caddy en Hugo make a very good combination. Especially if your use cases stay somewhat simple, Caddy is perfect. For complexer environments I suppose the benefit of practically 0-config will disappear at some point, leveling the playing field when comparing with for example Nginx.

For me this has been a welcome upgrade. Ditching the maintenance and plugin-bloat allows returning focus on what a blog is about: Content.

Good luck setting up your own Caddy/Hugo site!

 [^footnote_wordpress]: Of course there is the possibility to automate the updating of Wordpress and the plugins. However, this goes against what I consider a good practice: Actually testing any change before blindly putting it in production and hope for the best. Admitted: Guarding against vulnerabilities is definitely the lesser of evils in this case. But essentially that would require setting up restore points and means to test if all plugins still work. For hardening Wordpress a plugin like [Wordfence](https://nl.wordpress.org/plugins/wordfence/) will help a lot. Altogether, I consider it a lot of moving parts for a site where almost nothing 'moves'.
 [^footnote_caddy]: What makes the Caddy role 'fine'? Multi-platform. Ongoing development. A Vagrantfile that makes it easy to test and contribute. And a sign of good understanding of Ansible: Tests that focus on role execution being idempotent, meaning repeated runs of the same config will record 0 changes.
