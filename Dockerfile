ARG VERSION
FROM docker.elastic.co/elasticsearch/elasticsearch:${VERSION}

ARG VERSION
RUN ./bin/elasticsearch-plugin install -b https://distfiles.compuscene.net/elasticsearch/elasticsearch-prometheus-exporter-${VERSION}.0.zip
