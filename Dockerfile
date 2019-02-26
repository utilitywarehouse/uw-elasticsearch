FROM adoptopenjdk/openjdk11:alpine-slim

ENV LANG=C.UTF-8 \
    JAVA_HOME=/opt/java/openjdk \
    PATH=${PATH}:/opt/java/openjdk/bin \
    LANG=C.UTF-8 \
    ES_VERSION="6.6.1"

RUN sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/ $JAVA_HOME/conf/security/java.security

RUN \
    apk --no-cache add bash && \
    mkdir -p /opt/elasticsearch && \
    cd /opt/elasticsearch && \
    wget http://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz && \
    tar -zxvf elasticsearch-${ES_VERSION}.tar.gz --strip 1 && \
    rm elasticsearch-${ES_VERSION}.tar.gz && \
    addgroup -S -g 82 elasticsearch && \
    adduser -S -D -H -u 82 elasticsearch -G elasticsearch && \
    chown -R elasticsearch:elasticsearch /opt/elasticsearch

USER elasticsearch
WORKDIR /opt/elasticsearch/bin

RUN \
    # needed for mktemp fix, remove >6.6.0 - will be done in Java
    # https://github.com/elastic/elasticsearch/pull/36002
    sed -i 's;\(`mktemp -d -t elasticsearch\)`;\1.XXXXXX`;' elasticsearch-env && \
    ./elasticsearch-plugin install --batch https://distfiles.compuscene.net/elasticsearch/elasticsearch-prometheus-exporter-${ES_VERSION}.0.zip

CMD ["./elasticsearch"]
