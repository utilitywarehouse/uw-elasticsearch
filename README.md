# uw-elasticsearch

[Setting up ElasticSearch locally on macOS.](mac/README.md)

## Versions update
The version has been updated to `5.6.3` and you can update to newer versions by editing VERSION value in Makefile.

## SECURITY CONSIDERATION
Please note that in newer versions there additional security is enabled by default:
https://www.elastic.co/guide/en/x-pack/5.6/security-getting-started.html

To disable additional security in containers you need to run it with ENV variable: `xpack.security.enabled=false`, for example:

`docker run -e xpack.security.enabled=false --rm -ti -p 9200:9200 registry.uw.systems/prm/elasticsearch:5.6.3`
