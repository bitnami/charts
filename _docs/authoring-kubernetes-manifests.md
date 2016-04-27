# Guidelines for writing Kubernetes Templates

## Components

Provide the following minimal set of files.

- `foo-rc.yaml`
- `foo-svc.yaml`
- `README.md`

## Readme

The readme is intended to help users get started with using the bitnami images on their kubernetes clusters. It's function is to:

- Provide brief usage example
- Overview of the architecture (diagrams, screenshots, etc.)
- List Dependencies
- List exposed volumes
- Explain logging features
- List environment variables, secrets, labels, etc.
- Provide URLs to external sources that are helpful
- Licensing information (should be permissive)

## Manifest Files

The manifests should deploy one component. For example, to deploy Redmine the manifests would only deploy the Redmine application components. Dependent components such as MariaDB should be separated into their own repo for better reusability and maintenance.

All manifests should be written in YAML format

- Use `.yaml` extension
- Use 2 spaces for indentation

A good set of manifests typically include:

- A replication controller (`foo-rc.yaml`)
- A service definition (`foo-svc.yaml`)
- A secrets file (`foo-secrets.yaml`)

### Images

- Use versioned images, avoid using the `latest` tag
- If the `latest` tag is used, define `imagePullPolicy: Always`

### Labels

A cluster can be used to deploy multiple applications and services. To be able to correctly filter components in services and replication controllers we should define labels to achieve this.

This section defines a set of labels that should be used.

#### heritage (mandatory)

All manifests must specify the `heritage: bitnami` label in the metadata section. This enables querying a cluster to list all components deployed using manifests made available by Bitnami with: 

```bash
kubectl get pods,rc,services -l heritage=bitnami
```

#### provider (mandatory)

The provider label indicates that the manifests provide  a specific backend service, eg. `mysql`, `mariadb`, `postgresql`, `redis`, etc.

If the manifest configures an application server the provider should be suffixed with `-server`, eg. `redmine-server` in case of a Redmine application server or `wordpress-server` in the case of a `apache + php + wordpress`.

#### app (for applications)

When the manifests deploy more than one replication controller, the `app` label should be defined that groups all the components under one label.

For example, if in a GitLab deployment `gitlab-workhorse` and `sidekiq` are defined in different replication controllers then the manifests should have the `app: gitlab` label that groups these components.

Standalone backend services, eg. MariaDB, will not have a app label. If the MariaDB service is part of an applications manifests (not recommended), then it would have a `app` label.

#### version (when applicable)

To make rolling updates possible the `version` label should be defined and set to the version of the docker image in use. Note that additionally we should ensure that versioned images are also in use for making rolling updates possible.

**IMPORTANT:** Service manifests should not apply the `version` label filters on the `selector` field.

#### other

Custom labels can be be defined to provide fine-grained filtering of pods in services and replication controllers. For example, a MariaDB pod can have a `mode:` label to indicate if it’s a `master` or `slave` allowing the Services to correctly filter Pods.

### Ports

Always define named ports in the replication controller templates. Whenever possible name the ports with the IANA defined service name (eg. http://www.speedguide.net/port.php?port=80).

Avoid using `hostPort` in the manifests unless absolutely necessary. When you bind a Pod to a `hostPort`, there are a limited number of places that pod can be scheduled, due to port conflicts — you can only schedule as many such Pods as there are nodes in your Kubernetes cluster.

## Replication Controller

Pods aren't intended to be treated as durable. They won't survive scheduling failures, node failures, etc. A Replication Controller (RC) provides better lifecycle management. We recommend using a replication controller even if a single instance of the Pod will be deployed at any given time.

A replication controller ensures that a specified number of pods "replicas" are running at any one time. It replaces pods that are deleted or terminated for any reason.

The following in an sample of a simple `ReplicationController.yaml` manifest:

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: mariadb
  labels:
    provider: mariadb
    version: 5.5.46-0-r01
    heritage: bitnami
spec:
  replicas: 1
  selector:
    provider: mariadb
    version: 5.5.46-0-r01
    heritage: bitnami
  template:
    metadata:
      labels:
        provider: mariadb
        version: 5.5.46-0-r01
        heritage: bitnami
    spec:
      containers:
      - name: mariadb
        image: bitnami/mariadb:5.5.46-0-r01
        env:
        - name: MARIADB_PASSWORD
          value: my_password
        ports:
        - name: mysql
          containerPort: 3306
```

Here we’ve set the `selector` field to filter based on the `provider`, `version` and `heritage` labels. This ensures that only Pods bearing these labels are under the purview of the replication controller.

If the manifest defines additional labels you may want to add them to the `selector` so that the replication controller correctly picks up the correct Pods at any give time.

### Environment Variables

The manifest file should include placeholders for configurable parameters exposed by images as environment variables. Defining environment variables for parameters that expose sensitive information should be avoided and instead be defined in a Secret manifest.

The README should appropriately document or link to the image documentation for information on the environment variables.

### Health Checks

For better lifecycle management the replication controller manifests should define liveness and readiness probes using the `livenessProbe` and `readinessProbe` fields respectively.

Three primitives are available for setting up these probes:

- HTTP check (`httpGet`)

  A webhook is used to determine the healthiness of the container. The check is deemed successful if the hook returns with `200` or `399` status code.

- Container Execution Check (`exec`)

  A command is executed inside the container. Exiting the check with status `0` is considered a success.

- TCP Socket Check (`tcpSocket`)

  A connection to a TCP socket is attempted. The container is considered healthy if the connection can be established.

#### Liveness Probe

A liveness probe checks if the container is running and responding normally. If the liveness probe fails, the container is terminated and subject to the restart policy it will be restarted. In replication controllers the default restart policy is to always restart a terminated container.

The following example adds a `livenessProbe` to our sample RC manifest.

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: mariadb
  labels:
    provider: mariadb
    version: 5.5.46-0-r01
    heritage: bitnami
spec:
  replicas: 1
  selector:
    provider: mariadb
    version: 5.5.46-0-r01
    heritage: bitnami
  template:
    metadata:
      labels:
        provider: mariadb
        version: 5.5.46-0-r01
        heritage: bitnami
    spec:
      containers:
      - name: mariadb
        image: bitnami/mariadb:5.5.46-0-r01
        env:
        - name: MARIADB_PASSWORD
          value: my_password
        ports:
        - name: mysql
          containerPort: 3306
        livenessProbe:
          exec:
            command:
            - mysqladmin
            - ping
          initialDelaySeconds: 30
          timeoutSeconds: 5
```

Here an `exec` probe is setup to check the status of the MariaDB server at 5 second intervals using the `mysqladmin ping` command. The Pod will be restarted if the command returns an error for any reason.

To allow the container to boot up before the liveness probe kicks in the `initialDelaySeconds` should be configured. It's value should be high enough to allow the container to start or the container will be prematurely terminated by the probe.

#### Readiness Probe

When a Pod is started, regardless of its initialization state, it is configured to receive traffic. Ideally the Pod should receive traffic only when it's ready to avoid downtime, especially in horizontally scalable deployments.

A readiness probe checks if a container is ready to service requests and is used to signal to the endpoints controller that even though a container is running it should not receive any traffic from a proxy. Additionally it helps containers to recover from temporary service disruptions.

The setup of a readiness probe is similar to a liveness probe. Building on our sample replication controller manifest the following snippet adds a `readinessProbe`.

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: mariadb
  labels:
    provider: mariadb
    version: 5.5.46-0-r01
    heritage: bitnami
spec:
  replicas: 1
  selector:
    provider: mariadb
    version: 5.5.46-0-r01
    heritage: bitnami
  template:
    metadata:
      labels:
        provider: mariadb
        version: 5.5.46-0-r01
        heritage: bitnami
    spec:
      containers:
      - name: mariadb
        image: bitnami/mariadb:5.5.46-0-r01
        env:
        - name: MARIADB_PASSWORD
          value: my_password
        ports:
        - name: mysql
          containerPort: 3306
        livenessProbe:
          exec:
            command:
            - mysqladmin
            - ping
          initialDelaySeconds: 30
          timeoutSeconds: 5
        readinessProbe:
          exec:
            command:
            - mysqladmin
            - ping
          initialDelaySeconds: 5
          timeoutSeconds: 1
```

Because we want the Pod to start receiving traffic as soon as it's ready a lower `initialDelaySeconds` value is specified.

A lower `timeoutSeconds` ensures that the Pod does not receive any traffic as soon as it becomes unresponsive. If the failure was temporary, the Pod would resume normal functioning after it has recovered.

### Lifecycle hooks

To terminate a container Kubernetes sends the `TERM` signal to `PID 1` of the container and if container is not terminated within a 10 second grace period a `KILL` signal is sent to forcefully terminate the container. In most cases this default behaviour is sufficient for the graceful termination of the daemons and processes running inside the container.

However, in some containerized applications may expect a custom termination sequence for its clean and graceful termination. For such cases a `preStop` hook can be setup to define a command that should be executed before the default container termination behaviour is executed.

For example, the NGINX daemon expects the `QUIT` signal to initiate a clean shutdown of the daemon. This can be achieved by setting up a `preStop` hook to initiate the shutdown with the command `nginx -s quit`.

The following snippet demonstrates the use of a `preStop` lifecycle hook.

```yaml
apiVersion: v1
kind: ReplicationController
...
    spec:
      containers:
      - name: nginx
        image: bitnami/nginx:1.9.9-0
        ...
        lifecycle:
          preStop:
            exec:
              command: ["nginx", "-s", "quit"]
```

Similarly a `postStart` hook can be specified to execute a command after a container has been started.

### Volumes

Volumes are required to persist a containers data and should be specified as `emptyDir` volumes in the replication controllers manifest. Continuing with our sample, the following snippet defines a volume named `data` for persistence of the MariaDB data.

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: mariadb
  labels:
    provider: mariadb
    version: 5.5.46-0-r01
    heritage: bitnami
spec:
  replicas: 1
  selector:
    provider: mariadb
    version: 5.5.46-0-r01
    heritage: bitnami
  template:
    metadata:
      labels:
        provider: mariadb
        version: 5.5.46-0-r01
        heritage: bitnami
    spec:
      containers:
      - name: mariadb
        image: bitnami/mariadb:5.5.46-0-r01
        env:
        - name: MARIADB_PASSWORD
          value: my_password
        ports:
        - name: mysql
          containerPort: 3306
        volumeMounts:
        - name: data
          mountPath: /bitnami/mariadb
        livenessProbe:
          exec:
            command:
            - mysqladmin
            - ping
          initialDelaySeconds: 30
          timeoutSeconds: 5
        readinessProbe:
          exec:
            command:
            - mysqladmin
            - ping
          initialDelaySeconds: 5
          timeoutSeconds: 1
      volumes:
      - name: data
        emptyDir: {}
```

## Services

A Service is an abstraction which defines a logical set of Pods and a policy by which to access them - sometimes called a micro-service. The set of Pods targeted by a Service is determined by label selectors. The following is a sample of a simple `Service.yaml` manifest.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mariadb
  labels:
    provider: mariadb
    heritage: bitnami
spec:
  ports:
  - name: mysql
    port: 3306
    targetPort: mysql
  selector:
    provider: mariadb
    heritage: bitnami
```

We’ve specified the label selectors `provider` and `heritage`. This will ensure that only the desired Pods will receive traffic from this Service. Notice that the `version` label is not used in the label selectors as its inclusion will not allow for rolling updates. If your Pods use additional labels, such as `mode`, you may want to add them to the selector field of the Service manifest.

Lastly, named ports are used to specify the `targetPort` field. This enables us to change the port numbers in the replication controller manifests without the need to change the Service manifests.

#### Load Balancer

A backend Service is generally accessed by containers within the cluster and as such the Service is not required to be exposed outside the cluster.

A frontend Service on the other hand, would typically be accessed externally over the internet. Such Services should be configured as `type: LoadBalancer`.

### Secrets

Objects of type secret are intended to hold sensitive information, such as passwords, OAuth tokens, and ssh keys. Putting this information in a secret is safer and more flexible than putting it verbatim in a pod definition or in a docker image.

A simple `Secrets.yml` file would look like:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mariadb
  labels:
    provider: mariadb
    heritage: bitnami
type: Opaque
data:
  mariadb-password: dmFsdWUtMg0K
```

## Examples

Examples manifests following these guidelines can be found in the Official [Bitnami Helm Charts Repo](https://github.com/bitnami/charts)

## References

- [Kubernetes User Guide](http://kubernetes.io/v1.0/docs/user-guide/)
- [Replication Controller](http://kubernetes.io/v1.0/docs/user-guide/replication-controller.html)
- [Service](http://kubernetes.io/v1.0/docs/user-guide/services.html)
- [Labels](http://kubernetes.io/v1.0/docs/user-guide/labels.html)
- [Volumes](http://kubernetes.io/v1.0/docs/user-guide/volumes.html)
- [Health Checks](http://kubernetes.io/v1.0/docs/user-guide/production-pods.html#liveness-and-readiness-probes-aka-health-checks)
- [Lifecycle hooks](http://kubernetes.io/v1.0/docs/user-guide/production-pods.html#lifecycle-hooks-and-termination-notice)
- [Secrets](http://kubernetes.io/v1.0/docs/user-guide/secrets.html)
- [Lifetime of a Pod](http://kubernetes.io/v1.0/docs/user-guide/pod-states.html)
- [Helm Docs](https://github.com/helm/helm/tree/master/docs)
- [Helm Authoring Guide](https://github.com/helm/helm/blob/master/docs/authoring_charts.md)
- [Kubernetes Configuration Best Practices](http://kubernetes.io/docs/user-guide/config-best-practices/)
