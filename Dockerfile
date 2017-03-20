FROM registry.uw.systems/base_images/uw-alpine-java:openjdk-8
RUN mkdir -p /opt/elasticsearch
WORKDIR /opt/elasticsearch

RUN apk --update add --no-cache wget ca-certificates bash
RUN wget http://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.2.tar.gz
RUN tar -zxvf elasticsearch-5.2.2.tar.gz --strip 1
RUN rm elasticsearch-5.2.2.tar.gz

WORKDIR /opt/elasticsearch/bin

RUN addgroup -g 82 -S elasticsearch
RUN adduser -u 82 -D -S -G elasticsearch elasticsearch
RUN chown -R elasticsearch:elasticsearch /opt/elasticsearch
USER elasticsearch

CMD ["./elasticsearch"]
