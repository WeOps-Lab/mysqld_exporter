#!/bin/bash

function install_single_version {
  local object=$1
  local version=$2
  local architecture=$3
  local initdbScripts=$4

  helm install ${object}-standalone-${version//./-} --namespace ${object} \
    -f ./values/bitnami_values.yaml \
    --set image.tag=${version} \
    --set architecture=${architecture} \
    --set commonLabels.object=${object} \
    --set primary.podLabels.object=${object} \
    --set secondary.podLabels.object=${object} \
    --set ${object}.podLabels.object_version=v${version//./-} \
    ${initdbScripts} \
    ./bitnami-${object}
}

function install_object {
  local object=$1
  local versions=("${!2}")

  for version in "${versions[@]}"; do
    if [[ "$version" == "5.5" || "$version" == "5.6" ]]; then
      helm install ${object}-standalone-${version//./-} --namespace ${object} \
        -f ./values/mysql_values.yaml \
        --set imageTag=${version} \
        ./mysql
    else
      if [[ "$object" == "mysql" ]]; then
        install_single_version ${object} ${version} "standalone"

        install_single_version ${object} ${version} "replication"
      elif [ "$object" == "mariadb" ]; then
        if [[ "$version" == "10.3" || "$version" == "10.4" ]]; then
          install_single_version ${object} ${version} "standalone"

          install_single_version ${object} ${version} "replication"
        else
          install_single_version ${object} ${version} "standalone" "--set-string initdbScripts.user.sql='CREATE USER \"weops\"@\"%\" IDENTIFIED BY \"Weops123!\"; GRANT PROCESS, SELECT ON *.* TO \"weops\"@\"%\"; GRANT REPLICATION CLIENT ON *.* TO \"weops\"@\"%\"; GRANT REPLICA MONITOR ON *.* TO \"weops\"@\"%\"'"

          install_single_version ${object} ${version} "replication" "--set-string initdbScripts.user.sql='CREATE USER \"weops\"@\"%\" IDENTIFIED BY \"Weops123!\"; GRANT PROCESS, SELECT ON *.* TO \"weops\"@\"%\"; GRANT REPLICATION CLIENT ON *.* TO \"weops\"@\"%\"; GRANT REPLICA MONITOR ON *.* TO \"weops\"@\"%\"'"
        fi
      fi
    fi
  done
}

object1_versions=("5.7" "5.6" "5.5" "8.0.32")
object1=mysql

object2_versions=("10.3" "10.4" "10.5" "10.6" "10.7" "10.8" "10.9")
object2=mariadb

install_object ${object1} object1_versions[@]
install_object ${object2} object2_versions[@]
