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
      if [[ "$object" == "mysql" ]]; then
        helm install ${object}-standalone-${version_suffix} --namespace ${object} \
          -f ./values/bitnami_values.yaml \
          --set image.tag=${version} \
          --set architecture=standalone \
          --set commonLabels.object=${object} \
          --set primary.podLabels.object=${object} \
          --set ${object}.podLabels.object_version=${version_suffix} \
          ./bitnami-${object}

        helm install ${object}-cluster-${version_suffix} --namespace ${object} \
          -f ./values/bitnami_values.yaml \
          --set image.tag=${version} \
          --set architecture=replication \
          --set commonLabels.object=${object} \
          --set primary.podLabels.object=${object} \
          --set secondary.podLabels.object=${object} \
          --set ${object}.podLabels.object_version=${version_suffix} \
          ./bitnami-${object}

      elif [ "$object" == "mariadb" ]; then
        if [[ "$version" == "10.3" || "$version" == "10.4" ]]; then
          helm install ${object}-standalone-${version_suffix} --namespace ${object} \
            -f ./values/bitnami_values.yaml \
            --set image.tag=${version} \
            --set architecture=standalone \
            --set commonLabels.object=${object} \
            --set primary.podLabels.object=${object} \
            --set ${object}.podLabels.object_version=${version_suffix} \
            ./bitnami-${object}

          helm install ${object}-cluster-${version_suffix} --namespace ${object} \
            -f ./values/bitnami_values.yaml \
            --set image.tag=${version} \
            --set architecture=replication \
            --set commonLabels.object=${object} \
            --set primary.podLabels.object=${object} \
            --set secondary.podLabels.object=${object} \
            --set ${object}.podLabels.object_version=${version_suffix} \
            ./bitnami-${object}
        else
        helm install ${object}-standalone-${version_suffix} --namespace ${object} \
          -f ./values/bitnami_values.yaml \
          --set image.tag=${version} \
          --set architecture=standalone \
          --set commonLabels.object=${object} \
          --set primary.podLabels.object=${object} \
          --set ${object}.podLabels.object_version=${version_suffix} \
          --set-string "initdbScripts.user.sql=CREATE USER 'weops'@'%' IDENTIFIED BY 'Weops123!';GRANT PROCESS, SELECT ON *.* TO 'weops'@'%';GRANT REPLICATION CLIENT ON *.* TO 'weops'@'%';GRANT REPLICA MONITOR ON *.* TO 'weops'@'%'" \
          ./bitnami-${object}

        helm install ${object}-cluster-${version_suffix} --namespace ${object} \
          -f ./values/bitnami_values.yaml \
          --set image.tag=${version} \
          --set architecture=replication \
          --set commonLabels.object=${object} \
          --set primary.podLabels.object=${object} \
          --set secondary.podLabels.object=${object} \
          --set ${object}.podLabels.object_version=${version_suffix} \
          --set-string "initdbScripts.user.sql=CREATE USER 'weops'@'%' IDENTIFIED BY 'Weops123!';GRANT PROCESS, SELECT ON *.* TO 'weops'@'%';GRANT REPLICATION CLIENT ON *.* TO 'weops'@'%';GRANT REPLICA MONITOR ON *.* TO 'weops'@'%'" \
          ./bitnami-${object}
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
