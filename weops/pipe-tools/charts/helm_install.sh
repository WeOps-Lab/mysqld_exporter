#!/bin/bash

# 部署监控对象
object_versions=("5.7" "8.0")
object=mysql

for version in "${object_versions[@]}"; do
    version_suffix="v${version//./-}"

    helm install $object-standalone-$version_suffix --namespace $object -f ./values/standalone_values.yaml \
    --set image.tag=$version \
    --set $object.podLabels.object_version=$version_suffix \
    ./$object
done
