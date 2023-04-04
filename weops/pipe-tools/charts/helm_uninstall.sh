#!/bin/bash
function uninstall_object {
  local object=$1
  local versions=("${!2}")

  for version in "${versions[@]}"; do
    version_suffix="v${version//./-}"

    if [[ "$version" == "5.5" || "$version" == "5.6" ]]; then
      helm uninstall ${object}-standalone-${version_suffix} --namespace ${object}

    else
      if [[ "$version" != "10.3" && "$version" != "10.4" ]] && [[ "$object" == "mariadb" ]]; then
        helm uninstall ${object}-standalone-${version_suffix} --namespace ${object}
        helm uninstall ${object}-cluster-${version_suffix} --namespace ${object}
      else
        helm uninstall ${object}-standalone-${version_suffix} --namespace ${object}
        helm uninstall ${object}-cluster-${version_suffix} --namespace ${object}
      fi
    fi
  done
}

object1_versions=("5.7" "5.6" "5.5" "8.0.32")
object1=mysql

object2_versions=("10.3" "10.4" "10.5" "10.6" "10.7" "10.8" "10.9")
object2=mariadb

uninstall_object ${object1} object1_versions[@]
uninstall_object ${object2} object2_versions[@]


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
