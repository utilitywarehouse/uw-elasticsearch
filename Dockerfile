FROM ubuntu:26.04

ARG ES_VERSION=8.19.25
ENV ES_VERSION=${ES_VERSION} \
    ES_HOME=/opt/elasticsearch \
    LANG=C.UTF-8

RUN set -eux; \
    groupadd --system --gid 82 elasticsearch; \
    useradd --system --uid 82 --gid 82 --home-dir "${ES_HOME}" --no-create-home --shell /usr/sbin/nologin elasticsearch; \
    apt-get update; \
    apt-get install -y --no-install-recommends curl ca-certificates; \
    tarball="elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz"; \
    cd /tmp; \
    curl -fsSLO "https://artifacts.elastic.co/downloads/elasticsearch/${tarball}"; \
    curl -fsSLO "https://artifacts.elastic.co/downloads/elasticsearch/${tarball}.sha512"; \
    sha512sum -c "${tarball}.sha512"; \
    mkdir -p "${ES_HOME}"; \
    tar -xzf "${tarball}" -C "${ES_HOME}" --strip-components=1; \
    java_security="${ES_HOME}/jdk/conf/security/java.security"; \
    sed -i 's/^#networkaddress.cache.ttl=-1$/networkaddress.cache.ttl=10/' "${java_security}"; \
    grep -qx 'networkaddress.cache.ttl=10' "${java_security}"; \
    chown -R elasticsearch:elasticsearch "${ES_HOME}"; \
    rm -f "${tarball}" "${tarball}.sha512"; \
    apt-get purge -y --auto-remove curl; \
    rm -rf /var/lib/apt/lists/*

USER elasticsearch
WORKDIR /opt/elasticsearch/bin

RUN ./elasticsearch-plugin install --batch \
        "https://github.com/mindw/elasticsearch-prometheus-exporter/releases/download/${ES_VERSION}.0/prometheus-exporter-${ES_VERSION}.0.zip"

CMD ["./elasticsearch"]
