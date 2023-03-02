#!/bin/bash

# 卸载监控对象
object=mysql

# Uninstall mysql deployments
for RELEASE in $(helm list -n $object --short)
do
  echo "Uninstalling $RELEASE ..."
  helm uninstall -n $object $RELEASE
done
