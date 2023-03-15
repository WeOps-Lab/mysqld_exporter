#!/bin/bash

for version in v5-7 v8-0-32; do
  standalone_output_file="standalone_${version}.yaml"
  sed "s/{{VERSION}}/${version}/g" standalone.tpl > ../standalone/${standalone_output_file}

  cluster_output_file="cluster_${version}.yaml"
  sed "s/{{VERSION}}/${version}/g" cluster.tpl > ../cluster/${cluster_output_file}
done
