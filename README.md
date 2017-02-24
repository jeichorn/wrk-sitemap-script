# wrk-sitemap-script
wrk lua script to populate the urls to benchmark using an xml sitemap

Requires:
https://github.com/wg/wrk

Docker:
Getting all the deps setup is a pain, see the Dockerfile for what is needed, or just use it

```
docker build -t wrk .
docker run --rm wrk http://example.com/sitemap.xml
```
