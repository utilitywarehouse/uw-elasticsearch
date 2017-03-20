FROM openjdk:8-jdk
RUN mkdir -p /opt/elasticsearch
WORKDIR /opt/elasticsearch

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.2.tar.gz
RUN tar -zxvf elasticsearch-5.2.2.tar.gz --strip 1
RUN rm elasticsearch-5.2.2.tar.gz

WORKDIR /opt/elasticsearch/bin

RUN useradd -ms /bin/bash elasticsearch
RUN chown -R elasticsearch:elasticsearch /opt/elasticsearch
USER elasticsearch

CMD ["./elasticsearch"]
