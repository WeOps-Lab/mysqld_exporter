object_versions=("5.7" "5.6" "5.5" "8.0.32")
object=mysql

for version in "${object_versions[@]}"; do
    version_suffix="v${version//./-}"

    if [[ "$version" == "5.5" || "$version" == "5.6" ]]; then
      helm install $object-standalone-$version_suffix --namespace $object -f ./values/mysql_values.yaml \
      --set imageTag=$version \
      --set architecture=standalone \
      --set $object.podLabels.object_version=$version_suffix \
      ./mysql

      helm install $object-cluster-$version_suffix --namespace $object -f ./values/mysql_values.yaml \
      --set imageTag=$version \
      --set architecture=replication \
      --set $object.podLabels.object_version=$version_suffix \
      ./mysql

    else
      helm install $object-standalone-$version_suffix --namespace $object -f ./values/bitnami_mysql_values.yaml \
      --set image.tag=$version \
      --set architecture=standalone \
      --set $object.podLabels.object_version=$version_suffix \
      ./bitnami-mysql

      helm install $object-cluster-$version_suffix --namespace $object -f ./values/bitnami_mysql_values.yaml \
      --set image.tag=$version \
      --set architecture=replication \
      --set $object.podLabels.object_version=$version_suffix \
      ./bitnami-mysql
    fi
done
