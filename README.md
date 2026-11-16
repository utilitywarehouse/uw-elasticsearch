# uw-elasticsearch

Container image of [Elasticsearch](https://www.elastic.co/elasticsearch) built
from the official upstream tarball with the
[Prometheus exporter plugin](https://github.com/mindw/elasticsearch-prometheus-exporter)
preinstalled, so metrics are served at `/_prometheus/metrics`. The image is
published to `quay.io/utilitywarehouse/elasticsearch`.

## Upgrading

Never skip a major version. Upgrade to the latest minor of your current major
first, then to the next major (for example 7.17 -> 8.19 -> 9.x). Elasticsearch
only reads indices created by the previous major, so indices created two majors
back must be reindexed (or removed) before upgrading. Follow Elastic's upgrade
documentation: https://www.elastic.co/docs/deploy-manage/upgrade
