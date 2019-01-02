FROM openjdk:11

ENV ES_VERSION="6.5.4"

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

RUN ./elasticsearch-plugin install --batch https://distfiles.compuscene.net/elasticsearch/elasticsearch-prometheus-exporter-${ES_VERSION}.0.zip

CMD ["./elasticsearch"]
