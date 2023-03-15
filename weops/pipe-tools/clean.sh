#!/bin/bash
kubectl delete -f ./exporter -n mysql
kubectl delete -f ./exporter/standalone -n mysql

# 卸载监控对象
cd charts
bash helm_uninstall.sh

