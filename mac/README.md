# Setting up ElasticSearch locally on macOS

Make sure that you have logged in with Docker, use `docker login https://registry.uw.systems` (username & password can be found in LastPass), so
that it's possible to download dependencies from UW registry.

1. Clone `uw-elasticsearch` repository.
2. Copy paste `config` directory and `docker-compose.yml` to your project.
3. Update the copied `docker-compose.yml` and update `services.elasticsearch.build.context` to point to `uw-elasticsearch` repository.
4. Run `docker-compose up`
5. If experiencing issues with Kibana accessing ElasticSearch, you might need to update the `test_config/kibana.yml` - `elasticsearch.url` property to have the correct IP.

To find out the correct IP ElasticSearch IP,
* Find out the ElasticSearch container name, by running `docker ps` (will be something like `*_elasticsearch_1`)
* Access logs by running `docker logs -f {container name}`
* search for `publish_address` which will indicate the ElasticSearch instance IP address.
* Copy paste the IP address in the `test_config/kibana.yml` and restart.