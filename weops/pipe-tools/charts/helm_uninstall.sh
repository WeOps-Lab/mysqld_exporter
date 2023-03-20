#!/bin/bash

# 设置需要删除的对象的名称空间
object=("mysql" "mariadb")

for obj in "${object[@]}"
do
  # 删除 Helm chart
  echo "Uninstalling $obj releases ..."
  for RELEASE in $(helm list -n $obj --short)
  do
    helm uninstall -n $obj $RELEASE
  done
done
