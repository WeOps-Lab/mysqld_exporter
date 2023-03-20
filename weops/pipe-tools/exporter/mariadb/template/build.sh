#!/bin/bash

for version in v10-3 v10-4 v10-5 v10-6 v10-7 v10-8 v10-9; do
  # 单点
  standalone_output_file="standalone_${version}.yaml"
  sed "s/{{VERSION}}/${version}/g" standalone.tpl > ../standalone/${standalone_output_file}

  # 集群主节点
  cluster_primary_output_file="cluster_primary_${version}.yaml"
  sed "s/{{VERSION}}/${version}/g" cluster_primary.tpl > ../cluster/${cluster_primary_output_file}

  # 集群从节点
  cluster_secondary_output_file="cluster_secondary_${version}.yaml"
  sed "s/{{VERSION}}/${version}/g" cluster_secondary.tpl > ../cluster/${cluster_secondary_output_file}
done
