# uw-elasticsearch

[Setting up ElasticSearch locally on macOS.](mac/README.md)

## Versions update
The version has been updated to `6.0.0` and you can update to newer versions by editing VERSION value in Makefile.

## ==SECURITY CONSIDERATION==
Please note that in newer versions there additional security is enabled by default:
https://www.elastic.co/guide/en/x-pack/current/security-getting-started.html

To disable additional security in containers you need to run it with ENV variable: `xpack.security.enabled=false`, for example:

`docker run -e xpack.security.enabled=false --rm -ti -p 9200:9200 registry.uw.systems/prm/elasticsearch:6.0.0`

## Kubernetes cluster deployment
`10-elasticsearch-cluster.yaml`
```
apiVersion: v1
kind: Service
metadata:
  name: es
  namespace: NAMESPACE
  annotations:
    prometheus.io/scrape: 'true'
    prometheus.io/path:   /_prometheus/metrics
    prometheus.io/port:   '9200'
spec:
  ports:
  - port: 9200
    name: client
  - port: 9300
    name: peer
  clusterIP: None
  selector:
    app: elasticsearch6
---

apiVersion: apps/v1beta2
kind: StatefulSet
metadata:
  name: elasticsearch6
  namespace: NAMESPACE
spec:
  replicas: 3
  serviceName: es
  podManagementPolicy: Parallel
  selector:
    matchLabels:
      app: elasticsearch6
  template:
    metadata:
      labels:
        app: elasticsearch6
    spec:
      restartPolicy: Always
      imagePullSecrets:
        - name: dockerhub-key
      securityContext:
        runAsUser: 1000
        fsGroup: 1000
      containers:
      - name: elasticsearch6
        image: registry.uw.systems/prm/elasticsearch:6.0.0
        env:
          - name: xpack.security.enabled
            value: "false"
          - name: cluster.name
            value: "prm-cluster"
          - name: discovery.zen.ping.unicast.hosts
            value: "elasticsearch6-0.es,elasticsearch6-1.es,elasticsearch6-2.es"
          - name: ES_JAVA_OPTS
            value: "-Xms3g -Xmx3g"
        volumeMounts:
        - name: es6clusterdata
          mountPath: /usr/share/elasticsearch/data
        ports:
        - name: client
          containerPort: 9200
        - name: peer
          containerPort: 9300
        resources:
          requests:
            cpu: 100m
            memory: 200Mi
          limits:
            cpu: 4000m
            memory: 4000Mi

      volumes:
      - name: es6clusterdata
        persistentVolumeClaim:
          claimName: es6clusterdata

  volumeClaimTemplates:
  - metadata:
      name: es6clusterdata
      namespace: NAMESPACE
      annotations:
        volume.beta.kubernetes.io/storage-class: ebs-gp2
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 10Gi

```
