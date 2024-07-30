#!/bin/bash

replace_in_file() {
    local filename="${1:?filename is required}"
    local match_regex="${2:?match regex is required}"
    local substitute_regex="${3:?substitute regex is required}"
    local posix_regex=${4:-true}

    local result

    # We should avoid using 'sed in-place' substitutions
    # 1) They are not compatible with files mounted from ConfigMap(s)
    # 2) We found incompatibility issues with Debian10 and "in-place" substitutions
    local -r del="/" # Use a non-printable character as a 'sed' delimiter to avoid issues
    if [[ $posix_regex = true ]]; then    
        result="$(sed -E "1,${del}${match_regex}${del}s${del}${match_regex}${del}${substitute_regex}${del}" "$filename")"
    else
        result="$(sed "1,${del}${match_regex}${del}s${del}${match_regex}${del}${substitute_regex}${del}" "$filename")"
    fi
    echo "$result" > "$filename"
}

get_sematic_version () {
    local version="${1:?version is required}"
    local section="${2:?section is required}"
    local -a version_sections

    #Regex to parse versions: x.y.z
    local -r regex='([0-9]+)(\.([0-9]+)(\.([0-9]+))?)?'

    if [[ "$version" =~ $regex ]]; then
        local i=1
        local j=1
        local n=${#BASH_REMATCH[*]}

        while [[ $i -lt $n ]]; do
            if [[ -n "${BASH_REMATCH[$i]}" ]] && [[ "${BASH_REMATCH[$i]:0:1}" != '.' ]];  then
                version_sections[j]="${BASH_REMATCH[$i]}"
                ((j++))
            fi
            ((i++))
        done

        local number_regex='^[0-9]+$'
        if [[ "$section" =~ $number_regex ]] && (( section > 0 )) && (( section <= 3 )); then
             echo "${version_sections[$section]}"
             return
        else
            stderr_print "Section allowed values are: 1, 2, and 3"
            return 1
        fi
    fi
}

bump_chart_version() {
    local chart_path="${1:?chart path is required}"
    local section="${2:?section is required}"

    current_version="$(yq '.version' "${chart_path}/Chart.yaml")"
    major_version="$(get_sematic_version "$current_version" 1)"
    minor_version="$(get_sematic_version "$current_version" 2)"
    patch_version="$(get_sematic_version "$current_version" 3)"
    new_version=""
    case $section in
        1) new_version="$((major_version+1)).0.0" ;;
        2) new_version="${major_version}.$((minor_version+1)).0" ;;
        3) new_version="${major_version}.${minor_version}.$((patch_version+1))" ;;
    esac

    yq --indent 2 -i ".version = \"$new_version\"" "${chart_path}/Chart.yaml"
}

declare -a charts=("airflow" "apache" "apisix" "appsmith" "argo-cd" "argo-workflows" "aspnet-core" "cassandra" "cert-manager" "cilium" "clickhouse" "concourse" "consul" "contour" "deepspeed" "discourse" "dokuwiki" "dremio" "drupal" "ejbca" "elasticsearch" "etcd" "external-dns" "flink" "fluent-bit" "fluentd" "flux" "ghost" "gitea" "grafana" "grafana-loki" "grafana-mimir" "grafana-operator" "grafana-tempo" "haproxy" "harbor" "influxdb" "jaeger" "janusgraph" "jasperreports" "jenkins" "joomla" "jupyterhub" "kafka" "keycloak" "kiam" "kibana" "kong" "kube-prometheus" "kube-state-metrics" "kubeapps" "kuberay" "kubernetes-event-exporter" "logstash" "magento" "mariadb" "mariadb-galera" "mastodon" "matomo" "mediawiki" "memcached" "metallb" "metrics-server" "milvus" "minio" "mlflow" "mongodb" "mongodb-sharded" "moodle" "multus-cni" "mxnet" "mysql" "nats" "neo4j" "nessie" "nginx" "nginx-ingress-controller" "node-exporter" "oauth2-proxy" "odoo" "opencart" "opensearch" "osclass" "parse" "phpbb" "phpmyadmin" "pinniped" "postgresql" "postgresql-ha" "prestashop" "prometheus" "pytorch" "rabbitmq" "rabbitmq-cluster-operator" "redis" "redis-cluster" "redmine" "schema-registry" "scylladb" "sealed-secrets" "seaweedfs" "solr" "sonarqube" "spark" "spring-cloud-dataflow" "suitecrm" "supabase" "tensorflow-resnet" "thanos" "tomcat" "valkey" "valkey-cluster" "vault" "whereabouts" "wildfly" "wordpress" "zookeeper")
for chart in "${charts[@]}"; do
    git checkout -b "chore/${chart}-global-storageclass"
    replace_in_file "bitnami/${chart}/values.yaml" "global.storageClass Global StorageClass" "global.defaultStorageClass Global default StorageClass"
    replace_in_file "bitnami/${chart}/values.yaml" "storageClass:" "defaultStorageClass:"
    readme-generator -v "bitnami/${chart}/values.yaml" -r "bitnami/${chart}/README.md"
    bump_chart_version "bitnami/${chart}" 3
    helm dep update --skip-refresh "bitnami/${chart}"
    git add "bitnami/${chart}" && git commit -sm "[bitnami/${chart}] Global StorageClass as default value"
    git checkout main
done
for chart in "${charts[@]}"; do
    git push origin "chore/${chart}-global-storageclass"
    gh pr create --title "[bitnami/${chart}] Global StorageClass as default value" --base main --head "juan131:chore/${chart}-global-storageclass" --repo bitnami/charts --body "### Description of the change

This PR deprecates _global.storageClass_ in favor of _global.defaultStorageClass_ given it's more convenient for this parameter to behave as a fallback instead of taking precedence over more specific values.

This PR shouldn't be merged until the changes in the common helpers at this [PR](https://github.com/bitnami/charts/pull/24863) are merged and published.

### Checklist

- [x] Chart version bumped in Chart.yaml according to [semver](http://semver.org/). This is *not necessary* when the changes only affect README.md files.
- [x] Variables are documented in the values.yaml and added to the README.md using [readme-generator-for-helm](readme-generator-for-helm)
- [x] Title of the pull request follows this pattern [bitnami/<name_of_the_chart>] Descriptive title
- [x] All commits signed off and in agreement of [Developer Certificate of Origin (DCO)](https://github.com/bitnami/charts/blob/main/CONTRIBUTING.md#sign-your-work)
" 
done
