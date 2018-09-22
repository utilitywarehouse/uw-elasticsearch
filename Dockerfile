FROM openjdk:11

ENV ES_VERSION="5.6.12"
ENV ES_PROM_EXPORTER_VERSION="5.6.11.0"

RUN \
 apt-get update && \
 mkdir -p /opt/elasticsearch && \
 cd /opt/elasticsearch && \
 wget http://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz && \
 tar -zxvf elasticsearch-${ES_VERSION}.tar.gz --strip 1 && \
 rm elasticsearch-${ES_VERSION}.tar.gz && \
 addgroup --gid 82 elasticsearch && \
 useradd --gid 82 --uid 82 elasticsearch && \
 chown -R elasticsearch:elasticsearch /opt/elasticsearch

USER elasticsearch
WORKDIR /opt/elasticsearch/bin

RUN ./elasticsearch-plugin install --batch https://distfiles.compuscene.net/elasticsearch/elasticsearch-prometheus-exporter-${ES_PROM_EXPORTER_VERSION}.zip

CMD ["./elasticsearch"]
