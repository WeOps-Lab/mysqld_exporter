apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mariadb-exporter-standalone-{{VERSION}}
  namespace: mariadb
spec:
  serviceName: mariadb-exporter-standalone-{{VERSION}}
  replicas: 1
  selector:
    matchLabels:
      app: mariadb-exporter-standalone-{{VERSION}}
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
        app: mariadb-exporter-standalone-{{VERSION}}
        exporter_object: mariadb
        object_mode: standalone
        object_version: {{VERSION}}
        pod_type: exporter
    spec:
      nodeSelector:
        node-role: worker
      shareProcessNamespace: true
      volumes:
        - name: mariadb-client-conf
          configMap:
            name: mariadb-client-conf
      containers:
      - name: mariadb-exporter-standalone-{{VERSION}}
        image: registry-svc:25000/library/mysql-exporter:latest
        imagePullPolicy: Always
        securityContext:
          allowPrivilegeEscalation: false
          runAsUser: 0
        args:
          - --mysqld.host=mariadb-standalone-{{VERSION}}.mariadb
          - --mysqld.port=3306
          - --mysqld.username=weops
          - --mysqld.password=Weops123!
        volumeMounts:
          - mountPath: /client_conf
            name: mariadb-client-conf
        resources:
          limits:
            cpu: 500m
            memory: 300Mi
        ports:
        - containerPort: 9104

---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: mariadb-exporter-standalone-{{VERSION}}
  name: mariadb-exporter-standalone-{{VERSION}}
  namespace: mariadb
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
    app: mariadb-exporter-standalone-{{VERSION}}
