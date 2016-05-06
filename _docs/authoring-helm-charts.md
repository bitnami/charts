# Guidelines for writing Helm Classic Charts

A Chart is a unit of Kubernetes manifests describing one or more kubernetes objects (i.e. RC, Pod, Service, etc) that provides a recipe for installing and running a containerized application inside of Kubernetes.

This document describes guidelines for writing Helm Classic Charts and builds on the guidelines laid out by the [Authoring Kubernetes Manifests Guide](authoring-kubernetes-manifests.md).

## Chart Directory

A typical Chart directory consists of the following files:

```
foo
├── Chart.yaml
├── manifests
│   └── foo-svc.yaml
├── README.md
└── tpl
    ├── foo-rc.yaml
    ├── foo-secrets.yaml
    └── values.toml
```

- The chart name is the top-level directory name.
- `manifests/` directory contains the kubernetes manifests.
- `tpl/` directory contains helmc generator templates and `values.toml`.
- Manifests are prefixed with the chart name.
- Replication controller manifests bear the `-rc` suffix.
- Service manifests bear the `-svc` suffix.
- Secrets manifests bear `-secret` suffix.
- Manifests should be written in `YAML` with 2 space indentation.

*Manifests can also be written in the JSON format. The `YAML` format is preferred for readability.*

## Chart.yaml

The [Chart.yaml](https://github.com/helm/helm-classic/blob/master/docs/awesome.md#the-chartyaml-file) format is defined by the [Helm Classic](https://github.com/helm/helm-classic) project and looks like this:

```yaml
name: <chart-name>
home: <project-homepage>
source:
- <links to images used in chart>
version: <version>
description: <short-description>
maintainers:
- Author <author@example.com>
dependencies:
- name: <chart-name>
  repo: <git-clone-url>
  version: <version>
details: |-
  <one-paragraph-description>
```

- `name`: chart name, same as the top-level chart directory
- `home`: URL to the project homepage (eg. http://redmine.org)
- `source`: List of URL's to resource used in the chart, eg. https://github.com/bitnami/bitnami-docker-redmine
- `version`: version of the chart
- `description`: A short one line chart description
- `maintainers`: List of maintainers with their email
- `dependencies`: List of charts this chart depends on
  + `name`: Name of the chart
  + `repo`: Git URL to chart repo
  + `version`: Semver version filter
- `details`: One paragraph description of the chart

Refer to the [dependency resolution](https://github.com/helm/helm-classic/blob/master/docs/awesome.md#dependency-resolution) section of the Helm Classic docs to learn about how Helm Classic handles dependencies.

## Manifest Files

The [Authoring Kubernetes Manifests Guide](authoring-kubernetes-manifests.md) provides guidelines to write Kubernetes manifests files. The topics covered include Replication Controllers, Services, Secrets, Labels, Health Checks, Environment variables and so on. The same guidelines apply while authoring Charts.

In this section we only look at Labels and Generators.

### Labels

A cluster can be used to deploy multiple applications and services. To be able to correctly filter components in services and replication controllers we should define labels.

This section defines a set mandatory labels that should be used.

#### heritage

All manifests must specify the `heritage: bitnami` label in the metadata section. This enables querying a cluster to list all components deployed using manifests made available by Bitnami with:

```bash
kubectl get pods,rc,services -l heritage=bitnami
```

#### provider

The provider label indicates that the manifests provide  a specific backend service, eg. `mysql`, `mariadb`, `postgresql`, `redis`, etc.

If the manifest configures an application server the provider should be suffixed with `-server`, eg. `redmine-server` in case of a Redmine application server or `wordpress-server` in the case of a `apache + php + wordpress`.

#### app (for applications)

When the manifests deploy more than one replication controller, the `app` label should be defined that groups all the components under one label.

For example, if in a GitLab deployment `gitlab-workhorse` and `sidekiq` are defined in different replication controllers then the manifests should have the `app: gitlab` label that groups these components.

Standalone backend services, eg. MariaDB, will not have a app label. If the MariaDB service is part of an applications manifests (not recommended), then it would have a `app` label.

#### version (when applicable)

To make rolling updates possible the `version` label should be defined and set to the version of the docker image in use. Note that we should ensure that versioned images are in use for making rolling updates possible.

**IMPORTANT:** Service manifests should not apply the `version` label filters on the `selector` field.

#### other

Custom labels can be be defined to provide fine-grained filtering of pods in services and replication controllers. For example, a MariaDB pod can have a `mode:` label to indicate if it’s a `master` or `slave` allowing the Services to correctly filter Pods.

### Generators

Helm Classic includes a templating solution to based on Go templates and supports most of the [Sprig](https://github.com/Masterminds/sprig) functions.

Running `helmc generate <chart-name>` compiles manifest files from the templates. The `tpl/` directory should be used for the templates and a `values.toml` file for customizing env variables and secrets.

`tpl/values.toml` provides a clean way for users configure environment variables, secrets, etc. The `values.toml` should define place holders for the configurable parameters with default values, which can be `nil`.

The following is an example of a `values.toml` file.

```toml
postgresUser = "postgres"
postgresPassword = ""
postgresDb = ""
```

Templates are manifests files with sprig functions that are evaluated during the compilation. The first line of a template should specify the command that should be executed to compile the template.

```
#helm:generate helmc tpl -d tpl/values.toml -o manifests/foo-rc.yaml $HELM_GENERATE_FILE
```

This instructs `helmc generate` to execute the listed command where the compiled output will be generated in the `manifests/` directory. `-d` specifies the file containing values to substitute into the template.

The following snippet demostrates the substitution of a value specified in `tpl/values.toml`.

```yaml
        env:
        - name: POSTGRES_USER
          value: {{ .postgresUser | quote }}
```

When compiled, `.postgresUser` will be replaced with the value of `postgresUser` specified in `values.toml`.

All environment variables should be quoted as the kubernetes linter will error out if the value begins with a number or is a truth value. The sprig `quote` function ensures that the final evaluated output is quoted with double quotes.

Learn more about [Helm Classic Generate and Templates](https://github.com/helm/helm-classic/blob/master/docs/generate-and-template.md)

## Readme

The readme file should provide brief instructions on how to deploy the chart and its dependencies. It should avoid listing detailed setup and configuration instructions.

## Examples

Examples manifests following these guidelines can be found in the Official [Bitnami Helm Classic Charts Repo](https://github.com/bitnami/charts)

## References

- [Helm Classic](https://github.com/helm/helm-classic)
- [Helm Classic Charts](https://github.com/helm/charts)
- [Authoring Helm Classic Charts](https://github.com/helm/helm-classic/blob/master/docs/authoring_charts.md)
- [The Helm Classic Guide to Writing Awesome Charts](https://github.com/helm/helm-classic/blob/master/docs/awesome.md)
- [Helm Classic Generate and Template](https://github.com/helm/helm-classic/blob/master/docs/generate-and-template.md)
- [Authoring Kubernetes Manifests Guide](authoring-kubernetes-manifests.md)

