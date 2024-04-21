
Dev
===

If not set up theme yet:

```sh
git submodule update --init --recursive
```

```sh
docker run --rm -ti -v $(pwd):$(pwd) -w $(pwd) -p 1313:1313 cage1016/docker-hugo:0.17 server -w --bind=0.0.0.0 ./
```

Specific local version:

```sh
hugo-0.62.2 server -w --buildFuture --buildDrafts --bind=0.0.0.0 ./
```

TODO
====

- Upgrade Hugo version and theme to be compatible with up-to-date Hugo
- Containerize it all
- Consider throwing it all on GCP free tier
  - https://snyke.net/post/kubernetes-playground/
 
References
==========

### Docs
* https://gohugo.io/variables/

### Other themes:
* https://github.com/panr/hugo-theme-terminal/blob/master/layouts/partials/head.html

