
Dev
===

docker run --rm -ti -v $(pwd):$(pwd) -w $(pwd) -p 1313:1313 cage1016/docker-hugo:0.17 server -w --bind=0.0.0.0 ./


TODO
====

- Upgrade Hugo version and theme to be compatible with up-to-date Hugo
- Containerize it all
- Consider throwing it all on GCP free tier
  - https://snyke.net/post/kubernetes-playground/
 
