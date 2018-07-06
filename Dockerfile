FROM openjdk:10
RUN mkdir -p /opt/elasticsearch
WORKDIR /opt/elasticsearch

RUN apt-get update
RUN wget http://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.0.tar.gz
RUN tar -zxvf elasticsearch-6.3.0.tar.gz --strip 1
RUN rm elasticsearch-6.3.0.tar.gz

WORKDIR /opt/elasticsearch/bin

RUN addgroup --gid 82 elasticsearch
RUN useradd --gid 82 --uid 82 elasticsearch
RUN chown -R elasticsearch:elasticsearch /opt/elasticsearch
USER elasticsearch

RUN ./elasticsearch-plugin install --batch https://distfiles.compuscene.net/elasticsearch/elasticsearch-prometheus-exporter-6.3.0.1.zip

CMD ["./elasticsearch"]
