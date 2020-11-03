FROM adoptopenjdk/openjdk11:alpine-slim

ENV LANG=C.UTF-8 \
    JAVA_HOME=/opt/java/openjdk \
    PATH=${PATH}:/opt/java/openjdk/bin \
    LANG=C.UTF-8 \
    ES_VERSION="7.7.0"

RUN sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/ $JAVA_HOME/conf/security/java.security

RUN \
    apk --no-cache add bash && \
    mkdir -p /opt/elasticsearch && \
    cd /opt/elasticsearch && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz && \
    tar -zxvf elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz --strip 1 && \
    rm elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz && \
    addgroup -S -g 82 elasticsearch && \
    adduser -S -D -H -u 82 elasticsearch -G elasticsearch && \
    chown -R elasticsearch:elasticsearch /opt/elasticsearch

USER elasticsearch
WORKDIR /opt/elasticsearch/bin

RUN \
    ./elasticsearch-plugin install -b https://github.com/vvanholl/elasticsearch-prometheus-exporter/releases/download/${ES_VERSION}.0/prometheus-exporter-${ES_VERSION}.0.zip && \
    ./elasticsearch-plugin install -b repository-s3

CMD ["./elasticsearch"]
