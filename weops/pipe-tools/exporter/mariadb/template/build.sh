#!/bin/bash

for version in v10-3 v10-4 v10-5 v10-6 v10-7 v10-8 v10-9; do
  # 单点
  standalone_output_file="standalone_${version}.yaml"
  sed "s/{{VERSION}}/${version}/g" standalone.tpl > ../standalone/${standalone_output_file}

  # 集群
  cluster_primary_output_file="cluster_primary_${version}.yaml"
  sed "s/{{VERSION}}/${version}/g" cluster.tpl > ../cluster/${cluster_primary_output_file}
done
