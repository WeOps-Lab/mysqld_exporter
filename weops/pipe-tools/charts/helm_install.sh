#!/bin/bash

function install_object {
  local object=$1
  local versions=("${!2}")

  for version in "${versions[@]}"; do
    version_suffix="v${version//./-}"

    if [[ "$version" == "5.5" || "$version" == "5.6" ]]; then
      helm install ${object}-standalone-${version_suffix} --namespace ${object} \
        -f ./values/mysql_values.yaml \
        --set imageTag=${version} \
        ./mysql

    else
      helm install ${object}-standalone-${version_suffix} --namespace ${object} \
        -f bitnami_values.yaml \
        --set image.tag=${version} \
        --set architecture=standalone \
        --set ${object}.podLabels.object_version=${version_suffix} \
        ./bitnami-${object}

      helm install ${object}-cluster-${version_suffix} --namespace ${object} \
        -f bitnami_values.yaml \
        --set image.tag=${version} \
        --set architecture=replication \
        --set ${object}.podLabels.object_version=${version_suffix} \
        ./bitnami-${object}
    fi
  done
}

object1_versions=("5.7" "5.6" "5.5" "8.0.32")
object1=mysql

object2_versions=("10.3" "10.4" "10.5" "10.6" "10.7" "10.8" "10.9")
object2=mariadb

install_object ${object1} object1_versions[@]
install_object ${object2} object2_versions[@]
