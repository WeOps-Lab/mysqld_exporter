apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql-exporter-cluster-primary-{{VERSION}}
  namespace: mysql
spec:
  serviceName: mysql-exporter-cluster-primary-{{VERSION}}
  replicas: 1
  selector:
    matchLabels:
      app: mysql-exporter-cluster-primary-{{VERSION}}
  template:
    metadata:
      annotations:
        telegraf.influxdata.com/interval: 1s
        telegraf.influxdata.com/inputs: |+
          [[inputs.cpu]]
            percpu = false
            totalcpu = true
            collect_cpu_time = true
            report_active = true

          [[inputs.disk]]
            ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]

          [[inputs.diskio]]

          [[inputs.kernel]]

          [[inputs.mem]]

          [[inputs.processes]]

          [[inputs.system]]
            fielddrop = ["uptime_format"]

          [[inputs.net]]
            ignore_protocol_stats = true

          [[inputs.procstat]]
          ## pattern as argument for pgrep (ie, pgrep -f <pattern>)
            pattern = "exporter"
        telegraf.influxdata.com/class: opentsdb
        telegraf.influxdata.com/env-fieldref-NAMESPACE: metadata.namespace
        telegraf.influxdata.com/limits-cpu: '300m'
        telegraf.influxdata.com/limits-memory: '300Mi'
      labels:
        app: mysql-exporter-cluster-primary-{{VERSION}}
        exporter_object: mysql
        object_mode: cluster
        object_version: {{VERSION}}
        pod_type: exporter
    spec:
      nodeSelector:
        node-role: worker
      shareProcessNamespace: true
      volumes:
        - name: mysql-client-conf
          configMap:
            name: mysql-client-conf
      containers:
      - name: mysql-exporter-cluster-primary-{{VERSION}}
        image: registry-svc:25000/library/mysql-exporter:latest
        imagePullPolicy: Always
        securityContext:
          allowPrivilegeEscalation: false
          runAsUser: 0
        args:
          - --config.my-cnf=/client_conf/mysql_client_cluster_primary_{{VERSION}}.cnf
        volumeMounts:
          - mountPath: /client_conf
            name: mysql-client-conf
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
          limits:
            cpu: 300m
            memory: 300Mi
        ports:
        - containerPort: 9104

---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: mysql-exporter-cluster-primary-{{VERSION}}
  name: mysql-exporter-cluster-primary-{{VERSION}}
  namespace: mysql
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9104"
    prometheus.io/path: '/metrics'
spec:
  ports:
  - port: 9104
    protocol: TCP
    targetPort: 9104
  selector:
    app: mysql-exporter-cluster-primary-{{VERSION}}
