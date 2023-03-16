#!/bin/bash

for version in v5-5 v5-6 v5-7 v8-0-32; do
  # 单点
  standalone_output_file="standalone_${version}.yaml"
  sed "s/{{VERSION}}/${version}/g" standalone.tpl > ../standalone/${standalone_output_file}

  if [[ "$version" != "v5-5" && "$version" != "v5-6" ]]; then
    # 集群主节点
    cluster_primary_output_file="cluster_primary_${version}.yaml"
    sed "s/{{VERSION}}/${version}/g" cluster_primary.tpl > ../cluster/${cluster_primary_output_file}

    # 集群从节点
    cluster_secondary_output_file="cluster_secondary_${version}.yaml"
    sed "s/{{VERSION}}/${version}/g" cluster_secondary.tpl > ../cluster/${cluster_secondary_output_file}
  fi
done
