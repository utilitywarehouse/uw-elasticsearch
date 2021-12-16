FROM eclipse-temurin:17-jdk

ENV LANG=C.UTF-8 \
    ES_JAVA_HOME=/opt/java/openjdk \
    PATH=${PATH}:/opt/java/openjdk/bin \
    LANG=C.UTF-8 \
    ES_VERSION="7.16.1"

RUN sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/ $JAVA_HOME/conf/security/java.security

RUN \
    mkdir -p /opt/elasticsearch && \
    cd /opt/elasticsearch && \
    curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz && \
    tar -zxvf elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz --strip 1 && \
    rm elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz && \
    addgroup --system --gid 82 elasticsearch && \
    adduser --system --disabled-password --no-create-home --uid 82 elasticsearch --ingroup elasticsearch && \
    chown -R elasticsearch:elasticsearch /opt/elasticsearch

USER elasticsearch
WORKDIR /opt/elasticsearch/bin

RUN \
    ./elasticsearch-plugin install -b https://github.com/vvanholl/elasticsearch-prometheus-exporter/releases/download/${ES_VERSION}.0/prometheus-exporter-${ES_VERSION}.0.zip && \
    ./elasticsearch-plugin install -b repository-s3

CMD ["./elasticsearch"]
