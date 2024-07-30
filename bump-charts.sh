#!/bin/bash

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

declare -a charts=("airflow" "apisix" "appsmith" "argo-cd" "argo-workflows" "clickhouse" "concourse" "discourse" "drupal" "ejbca" "elasticsearch" "ghost" "gitea" "grafana-loki" "grafana-mimir" "grafana-tempo" "harbor" "jaeger" "janusgraph" "joomla" "jupyterhub" "kafka" "keycloak" "kong" "kubeapps" "magento" "mastodon" "matomo" "mediawiki" "milvus" "mlflow" "moodle" "oauth2-proxy" "odoo" "opencart" "parse" "phpbb" "phpmyadmin" "prestashop" "kube-prometheus" "redmine" "schema-registry" "scylladb" "seaweedfs" "solr" "sonarqube" "spring-cloud-dataflow" "supabase" "thanos" "valkey" "wordpress")
for chart in "${charts[@]}"; do
    git checkout -b "chore/bump-${chart}-chart-version"
    bump_chart_version "bitnami/${chart}" 3
    helm dep update --skip-refresh "bitnami/${chart}"
    git add "bitnami/${chart}" && git commit -sm "[bitnami/${chart}] Bump chart version"
    git checkout main
done
for chart in "${charts[@]}"; do
    git push origin "chore/bump-${chart}-chart-version"
    gh pr create --title "[bitnami/${chart}] Bump chart version" --base main --head "juan131:chore/bump-${chart}-chart-version" --repo bitnami/charts --body "### Description of the change

Bump chart version

### Checklist

- [x] Chart version bumped in Chart.yaml according to [semver](http://semver.org/). This is *not necessary* when the changes only affect README.md files.
- [x] Title of the pull request follows this pattern [bitnami/<name_of_the_chart>] Descriptive title
- [x] All commits signed off and in agreement of [Developer Certificate of Origin (DCO)](https://github.com/bitnami/charts/blob/main/CONTRIBUTING.md#sign-your-work)
" 
done
for chart in "${charts[@]}"; do
    gitfork-remove-branch "chore/bump-${chart}-chart-version"
done
