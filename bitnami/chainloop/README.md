# Chainloop Helm Chart

[Chainloop](https://github.com/chainloop-dev/chainloop) is an open-source software supply chain control plane, a single source of truth for artifacts plus a declarative attestation crafting process.

## Introduction

This chart bootstraps a [Chainloop](https://github.com/chainloop-dev/chainloop) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (If built-in PostgreSQL is enabled)

Compatibility with the following Ingress Controllers has been verified, other controllers might or might not work.

- [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [Traefik](https://doc.traefik.io/traefik/providers/kubernetes-ingress/)

## TL;DR

Deploy Chainloop in [development mode](#development) by running

```console
helm install [RELEASE_NAME] oci://ghcr.io/chainloop-dev/charts/chainloop --set development=true
```

> **CAUTION**: Do not use this mode in production, for that, use the [standard mode](#standard-default) instead.

## Installing the Chart

This chart comes in **two flavors**, `standard` and [`development`](#development).

### Standard (default)

![Deployment](https://raw.githubusercontent.com/chainloop-dev/chainloop/main/docs/img/deployment.png)

The default deployment mode relies on external dependencies to be available in advance.

The Helm Chart in this mode includes

- Chainloop [Controlplane](https://github.com/chainloop-dev/chainloop/tree/main/app/controlplane)
- Chainloop [Artifact proxy](https://github.com/chainloop-dev/chainloop/tree/main/app/artifact-cas)
- A PostgreSQL dependency enabled by default

During installation, you'll need to provide

- Open ID Connect Identity Provider (IDp) settings i.e [Auth0 settings](https://auth0.com/docs/get-started/applications/application-settings#basic-information)
- Connection settings for a secrets storage backend, either [Hashicorp Vault](https://www.vaultproject.io/) or [AWS Secrets Manager](https://aws.amazon.com/secrets-manager)
- ECDSA (ES512) key-pair used for Controlplane to CAS Authentication

Instructions on how to create the ECDSA keypair can be found [here](#generate-a-ecdsa-key-pair).

#### Installation examples for standard mode

> **NOTE**: **We do not recommend passing nor storing sensitive data in plain text**. For production, please consider having your overrides encrypted with tools such as [Sops](https://github.com/mozilla/sops), [Helm Secrets](https://github.com/jkroepke/helm-secrets) or [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets).

Deploy Chainloop configured to talk to the bundled PostgreSQL an external OIDC IDp and a Vault instance.

```console
helm install [RELEASE_NAME] oci://ghcr.io/chainloop-dev/charts/chainloop \
    # Open ID Connect (OIDC)
    --set controlplane.auth.oidc.url=[OIDC URL] \
    --set controlplane.auth.oidc.clientID=[clientID] \
    --set controlplane.auth.oidc.clientSecret=[clientSecret] \
    # Secrets backend
    --set secretsBackend.vault.address="https://[vault address]:8200" \
    --set secretsBackend.vault.token=[token] \
    # Server Auth KeyPair
    --set casJWTPrivateKey="$(cat private.ec.key)" \
    --set casJWTPublicKey="$(cat public.pem)"
```

Deploy using AWS Secrets Manager instead of Vault

```console
helm install [RELEASE_NAME] oci://ghcr.io/chainloop-dev/charts/chainloop \
    # Open ID Connect (OIDC)
    # ...
    # Secrets backend
    --set secretsBackend.backend=awsSecretManager \
    --set secretsBackend.awsSecretManager.accessKey=[AWS ACCESS KEY ID] \
    --set secretsBackend.awsSecretManager.secretKey=[AWS SECRET KEY] \
    --set secretsBackend.awsSecretManager.region=[AWS region]\
    # Server Auth KeyPair
    # ...
```

or using GCP Secret Manager

```console
helm install [RELEASE_NAME] oci://ghcr.io/chainloop-dev/charts/chainloop \
    # Open ID Connect (OIDC)
    # ...
    # Secrets backend
    --set secretsBackend.backend=gcpSecretManager \
    --set secretsBackend.gcpSecretManager.projectId=[GCP Project ID] \
    --set secretsBackend.gcpSecretManager.serviceAccountKey=[GCP Auth KEY] \
    # Server Auth KeyPair
    # ...
```

or Azure KeyVault

```console
helm install [RELEASE_NAME] oci://ghcr.io/chainloop-dev/charts/chainloop \
    # Open ID Connect (OIDC)
    # ...
    # Secrets backend
    --set secretsBackend.backend=azureKeyVault \
    --set secretsBackend.azureKeyVault.tenantID=[AD tenant ID] \
    --set secretsBackend.azureKeyVault.clientID=[Service Principal ID] \
    --set secretsBackend.azureKeyVault.clientSecret=[Service Principal secret] \
    --set secretsBackend.azureKeyVault.vaultURI=[Azure KeyVault URI]
    # Server Auth KeyPair
    # ...
```

Connect to an external PostgreSQL database instead

```console
helm install [RELEASE_NAME] oci://ghcr.io/chainloop-dev/charts/chainloop \
    # Open ID Connect (OIDC)
    # ...
    # Secrets backend
    # ...
    # Server Auth KeyPair
    # ...
    # External DB setup
    --set postgresql.enabled=false \
    --set controlplane.externalDatabase.host=[DB_HOST] \
    --set controlplane.externalDatabase.user=[DB_USER] \
    --set controlplane.externalDatabase.password=[DB_PASSWORD] \
    --set controlplane.externalDatabase.database=[DB_NAME]
```

### Development

To provide an easy way to give Chainloop a try, this Helm Chart has an **opt-in development** mode that can be enabled with the flag `development=true`

> IMPORTANT: DO NOT USE THIS MODE IN PRODUCTION

![Deployment](https://raw.githubusercontent.com/chainloop-dev/chainloop/main/docs/img/deployment-dev.png)

The Helm Chart in this mode includes

- Chainloop [Controlplane](https://github.com/chainloop-dev/chainloop/tree/main/app/controlplane)
- Chainloop [Artifact proxy](https://github.com/chainloop-dev/chainloop/tree/main/app/artifact-cas)
- A PostgreSQL dependency enabled by default
- **A pre-configured Hashicorp Vault instance running in development mode (unsealed, in-memory, insecure)**
- **A pre-configured Dex OIDC instance.**

The pre-setup users configuration on the Chart include two users, the information is as follows:
```text
username: sarah@chainloop.local
password: password

username: john@chainloop.local
password: password
```

The overall OIDC configuration can be found at [dex-values.yaml](./charts/dex/values.yaml)

> **CAUTION**: Do not use this mode in production, for that, use the [standard mode](#standard-default) instead.

#### Installation examples for development mode

Deploy by leveraging built-in Vault and PostgreSQL instances

```console
helm install [RELEASE_NAME] oci://ghcr.io/chainloop-dev/charts/chainloop --set development=true
```

## AirGap and Relocation Support

This chart is compatible with relocation processes performed by the [Helm Relocation Plugin](https://github.com/vmware-labs/distribution-tooling-for-helm)

This is a two-step process (wrap -> unwrap)

- Pull all the container images and Helm chart and wrap them in an intermediate tarball.
- Unwrap the tarball and push container images, update the Helm Chart with new image references and push it to the target registry.

For example: to relocate to an Azure Container Registry

```sh
helm dt wrap oci://ghcr.io/chainloop-dev/charts/chainloop
# 🎉  Helm chart wrapped into "chainloop-1.77.0.wrap.tgz"

# Now you can take the tarball to an air-gapped environment and unwrap it like this
helm dt unwrap chainloop-1.77.0.wrap.tgz oci://chainloop.azurecr.io --yes
#  Unwrapping Helm chart "chainloop-1.77.0.wrap.tgz"
#    ✔  All images pushed successfully
#    ✔  Helm chart successfully pushed
#
# 🎉  Helm chart unwrapped successfully: You can use it now by running "helm install oci://chainloop.azurecr.io/chart/chainloop --generate-name"
```

## How to guides

### CAS upload speeds are slow, what can I do?

Chainloop uses gRPC streaming to perform artifact uploads. This method is susceptible to being very slow on high latency scenarios. [#375](https://github.com/chainloop-dev/chainloop/issues/375)

To improve upload speeds, you need to increase [http2 flow control buffer](https://httpwg.org/specs/rfc7540.html#DisableFlowControl). This can be done in NGINX by setting the following annotation in the ingress resource.

```yaml
# Improve upload speed by adding client buffering used by http2 control-flows
nginx.ingress.kubernetes.io/client-body-buffer-size: "3M"

```

Note: For other reverse proxies, you'll need to find the equivalent configuration.

### Generate a ECDSA key-pair

An ECDSA key-pair is required to perform authentication between the control-plane and the Artifact CAS

You can generate both the private and public keys by running

```bash
# Private Key (private.ec.key)
openssl ecparam -name secp521r1 -genkey -noout -out private.ec.key
# Public Key (public.pem)
openssl ec -in private.ec.key -pubout -out public.pem
```

Then, you can either provide it in a custom `values.yaml` file override

```yaml
casJWTPrivateKey: |-
  -----BEGIN EC PRIVATE KEY-----
  REDACTED
  -----END EC PRIVATE KEY-----
casJWTPublicKey: |
  -----BEGIN PUBLIC KEY-----
  REDACTED
  -----END PUBLIC KEY-----
```

or as shown before, provide them as imperative inputs during Helm Install/Upgrade `--set casJWTPrivateKey="$(cat private.ec.key)"--set casJWTPublicKey="$(cat public.pem)"`

### Enable a custom domain with TLS

Chainloop uses three endpoints so we'll need to enable the ingress resource for each one of them.

See below an example of a `values.yaml` override

```yaml
controlplane:
  ingress:
    enabled: true
    hostname: cp.chainloop.dev

  ingressAPI:
    enabled: true
    hostname: api.cp.chainloop.dev

cas:
  ingressAPI:
  enabled: true
  hostname: api.cas.chainloop.dev
```

A complete setup that uses

- [NGINX as ingress Controller](https://kubernetes.github.io/ingress-nginx)
- [cert-manager](https://cert-manager.io/) as TLS provider

would look like

```yaml
controlplane:
  ingress:
    enabled: true
    tls: true
    ingressClassName: nginx
    hostname: cp.chainloop.dev
    annotations:
      # This depends on your configured issuer
      cert-manager.io/cluster-issuer: "letsencrypt-prod"

  ingressAPI:
    enabled: true
    tls: true
    ingressClassName: nginx
    hostname: api.cp.chainloop.dev
    annotations:
      nginx.ingress.kubernetes.io/backend-protocol: "GRPC"
      cert-manager.io/cluster-issuer: "letsencrypt-prod"

cas:
  ingressAPI:
    enabled: true
    tls: true
    ingressClassName: nginx
    hostname: api.cas.chainloop.dev
    annotations:
      nginx.ingress.kubernetes.io/backend-protocol: "GRPC"
      cert-manager.io/cluster-issuer: "letsencrypt-prod"
      # limit the size of the files that go through the proxy
      # 0 means to not check the size of the request so we do not get 413 error.
      # For now we are going to set a limit on 100MB files
      # Even though we send data in chunks of 1MB, this size refers to all the data sent in the streaming connection
      nginx.ingress.kubernetes.io/proxy-body-size: "100m"
```

Remember, once you have set up your domain, make sure you use the [CLI pointing](#configure-chainloop-cli-to-point-to-your-instance) to it instead of the defaults.

### Connect to an external PostgreSQL database

```yaml
# Disable built-in DB
postgresql:
  enabled: false

# Provide with external connection
controlplane:
  externalDatabase:
    host: 1.2.3.4
    port: 5432
    user: chainloop
    password: [REDACTED]
    database: chainloop-controlplane-prod
```

Alternatively, if you are using [Google Cloud SQL](https://cloud.google.com/sql) and you are running Chainloop in Google Kubernetes Engine. You can connect instead via [a proxy](https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine#proxy)

This method can also be easily enabled in this chart by doing

```yaml
# Disable built-in DB
postgresql:
  enabled: false

# Provide with external connection
controlplane:
  sqlProxy:
    # Inject the proxy sidecar
    enabled: true
    ## @param controlplane.sqlProxy.connectionName Google Cloud SQL connection name
    connectionName: "my-sql-instance"
  # Then you'll need to configure your DB settings to use the proxy IP address
  externalDatabase:
    host: [proxy-sidecar-ip-address]
    port: 5432
    user: chainloop
    password: [REDACTED]
    database: chainloop-controlplane-prod
```

### Use AWS secrets manager

Instead of using [Hashicorp Vault](https://www.vaultproject.io/) (default), you can use [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/) by adding these settings in your `values.yaml` file

```yaml
secretsBackend:
  backend: awsSecretManager
  awsSecretManager:
    accessKey: [KEY]
    secretKey: [SECRET]
    region: [REGION]
```

### Use GCP secret manager

Or [Google Cloud Secret Manager](https://cloud.google.com/secret-manager) with the following settings

```yaml
secretsBackend:
  backend: gcpSecretManager
  gcpSecretManager:
    projectId: [PROJECT_ID]
    serviceAccountKey: [KEY]
```

### Use Azure KeyVault

[Azure KeyVault](https://azure.microsoft.com/en-us/products/key-vault/) is also supported

```yaml
secretsBackend:
  backend: azureKeyVault
  azureKeyVault:
    tenantID: [TENANT_ID] # Active Directory Tenant ID
    clientID: [CLIENT_ID] # Registered application / service principal client ID
    clientSecret: [CLIENT_SECRET] # Service principal client secret
    vaultURI: [VAULT URI] # Azure Key Vault URL

```

### Deploy in keyless mode with file-based CA

*This feature is experimental, as it doesn't yet support verification.*

You can enable keyless signing mode by providing a custom Certificate Authority.
For example, these commands generate a self-signed certificate with an RSA private key of length 4096 and AES256 encryption with a validity of 365 days:

```bash
> openssl genrsa -aes256 -out ca.key 4096
...
> openssl req -new -x509 -sha256 -key ca.key -out ca.crt -days 365
...
```

Then you can configure your deployment values with:

```yaml
controlplane:
  keylessSigning:
    enabled: true
    backend: fileCA
    fileCA:
      cert: |
        -----BEGIN CERTIFICATE-----
        ...
        -----END CERTIFICATE-----
      key: |
        -----BEGIN ENCRYPTED PRIVATE KEY-----    
        ...
        -----END ENCRYPTED PRIVATE KEY-----
      keyPass: "REDACTED"  
```

### Insert custom Certificate Authorities (CAs)

In some scenarios, you might want to add custom Certificate Authorities to the Chainloop deployment. Like in the instance where your OIDC provider uses a self-signed certificate. To do so, add the PEM-encoded CA certificate to the `customCAs` list in either `controlplane` or `cas` sections, in your `values.yaml` file like in the example below.

```yaml
  customCAs:
    - |-
      -----BEGIN CERTIFICATE-----
      MIIFmDCCA4CgAwIBAgIQU9C87nMpOIFKYpfvOHFHFDANBgkqhkiG9w0BAQsFADBm
      BhMCVVMxMzAxBgNVBAoTKihTVEFHSU5HKSBJbnRlcm5ldCBTZWN1cml0eSBSZXNl
      REDACTED
      5CunuvCXmEQJHo7kGcViT7sETn6Jz9KOhvYcXkJ7po6d93A/jy4GKPIPnsKKNEmR
      7DiA+/9Qdp9RBWJpTS9i/mDnJg1xvo8Xz49mrrgfmcAXTCJqXi24NatI3Oc=
      -----END CERTIFICATE-----
```

### Send exceptions to Sentry

You can configure different sentry projects for both the controlplane and the artifact CAS

```yaml
# for controlplane
controlplane:
  ...
  sentry:
    enabled: true
    dsn: [your secret sentry project DSN URL]
    environment: production
# Artifact CAS
cas:
  ...
  sentry:
    enabled: true
    dsn: [your secret sentry project DSN URL]
    environment: production
```

### Enable Prometheus Monitoring in GKE

Chainloop exposes Prometheus compatible `/metrics` endpoints that can be easily scraped by a Prometheus data collector Server.

Google Cloud has a [managed Prometheus offering](https://cloud.google.com/stackdriver/docs/managed-prometheus/setup-managed) that could be easily enabled by setting `--set GKEMonitoring.enabled=true`. This will inject the required `PodMonitoring` custom resources.

### Configure Chainloop CLI to point to your instance

Once you have your instance of Chainloop deployed, you need to configure the [CLI](https://github.com/chainloop-dev/chainloop/releases) to point to both the CAS and the Control plane gRPC APIs like this.

```bash
chainloop config save \
  --control-plane my-controlplane.acme.com:443 \
  --artifact-cas cas.acme.com:443
```

## Parameters

### Global parameters

| Name                      | Description                                                                                                                                                            | Value   |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`    | Global Docker image registry                                                                                                                                           | `""`    |
| `global.imagePullSecrets` | Global Docker registry secret names as an array                                                                                                                        | `[]`    |
| `development`             | Deploys Chainloop pre-configured FOR DEVELOPMENT ONLY. It includes a Vault instance in development mode and pre-configured authentication certificates and passphrases | `false` |

### Common parameters

| Name                | Description                                       | Value |
| ------------------- | ------------------------------------------------- | ----- |
| `kubeVersion`       | Override Kubernetes version                       | `""`  |
| `commonAnnotations` | Annotations to add to all deployed objects        | `{}`  |
| `commonLabels`      | Labels to add to all deployed objects             | `{}`  |
| `extraDeploy`       | Array of extra objects to deploy with the release | `[]`  |

### Secrets Backend

| Name                                                | Description                                                                               | Value       |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------- |
| `secretsBackend.backend`                            | Secrets backend type ("vault", "awsSecretManager" or "gcpSecretManager", "azureKeyVault") | `vault`     |
| `secretsBackend.secretPrefix`                       | Prefix that will be pre-pended to all secrets in the storage backend                      | `chainloop` |
| `secretsBackend.vault.address`                      | Vault address                                                                             |             |
| `secretsBackend.vault.token`                        | Vault authentication token                                                                |             |
| `secretsBackend.awsSecretManager.accessKey`         | AWS Access KEY ID                                                                         |             |
| `secretsBackend.awsSecretManager.secretKey`         | AWS Secret Key                                                                            |             |
| `secretsBackend.awsSecretManager.region`            | AWS Secrets Manager Region                                                                |             |
| `secretsBackend.gcpSecretManager.projectId`         | GCP Project ID                                                                            |             |
| `secretsBackend.gcpSecretManager.serviceAccountKey` | GCP Auth Key                                                                              |             |
| `secretsBackend.azureKeyVault.tenantID`             | Active Directory Tenant ID                                                                |             |
| `secretsBackend.azureKeyVault.clientID`             | Registered application / service principal client ID                                      |             |
| `secretsBackend.azureKeyVault.clientSecret`         | Service principal client secret                                                           |             |
| `secretsBackend.azureKeyVault.vaultURI`             | Azure Key Vault URL                                                                       |             |

### Authentication

| Name               | Description                                                           | Value |
| ------------------ | --------------------------------------------------------------------- | ----- |
| `casJWTPrivateKey` | ECDSA (ES512) private key used for Controlplane to CAS Authentication | `""`  |
| `casJWTPublicKey`  | ECDSA (ES512) public key                                              | `""`  |

### Control Plane

| Name                                           | Description                                                                                     | Value             |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------- |
| `controlplane.replicaCount`                    | Number of replicas                                                                              | `2`               |
| `controlplane.image.registry`                  | Image registry                                                                                  | `REGISTRY_NAME`   |
| `controlplane.image.repository`                | Image repository                                                                                | `REPOSITORY_NAME` |
| `controlplane.containerPorts.http`             | controlplane HTTP container port                                                                | `8000`            |
| `controlplane.containerPorts.grpc`             | controlplane gRPC container port                                                                | `9000`            |
| `controlplane.containerPorts.metrics`          | controlplane prometheus metrics container port                                                  | `5000`            |
| `controlplane.tlsConfig.secret.name`           | name of a secret containing TLS certificate to be used by the controlplane grpc server.         | `""`              |
| `controlplane.pluginsDir`                      | Directory where to look for plugins                                                             | `/plugins`        |
| `controlplane.referrerSharedIndex`             | Configure the shared, public index API endpoint that can be used to discover metadata referrers |                   |
| `controlplane.referrerSharedIndex.enabled`     | Enable index API endpoint                                                                       | `false`           |
| `controlplane.referrerSharedIndex.allowedOrgs` | List of UUIDs of organizations that are allowed to publish to the shared index                  | `[]`              |
| `controlplane.onboarding.name`                 | Name of the organization to onboard                                                             |                   |
| `controlplane.onboarding.role`                 | Role of the organization to onboard                                                             |                   |
| `controlplane.prometheus_org_metrics`          | List of organizations to expose metrics for using Prometheus                                    |                   |
| `controlplane.migration.image.registry`        | Image registry                                                                                  | `REGISTRY_NAME`   |
| `controlplane.migration.image.repository`      | Image repository                                                                                | `REPOSITORY_NAME` |
| `controlplane.migration.ssl`                   | Connect to the database using SSL (required fro AWS RDS, etc)                                   | `false`           |

### Control Plane Database

| Name                                     | Description                                                                                           | Value  |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------- | ------ |
| `controlplane.externalDatabase`          | External PostgreSQL configuration. These values are only used when postgresql.enabled is set to false |        |
| `controlplane.externalDatabase.host`     | Database host                                                                                         | `""`   |
| `controlplane.externalDatabase.port`     | Database port number                                                                                  | `5432` |
| `controlplane.externalDatabase.user`     | Non-root username                                                                                     | `""`   |
| `controlplane.externalDatabase.database` | Database name                                                                                         | `""`   |
| `controlplane.externalDatabase.password` | Password for the non-root username                                                                    | `""`   |

### Control Plane Authentication

| Name                                         | Description                                                                                            | Value |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ----- |
| `controlplane.auth.passphrase`               | Passphrase used to sign the Auth Tokens generated by the controlplane. Leave empty for auto-generation | `""`  |
| `controlplane.auth.oidc.url`                 | Full authentication path, it should match the issuer URL of the Identity provider (IDp)                | `""`  |
| `controlplane.auth.oidc.clientID`            | OIDC IDp clientID                                                                                      | `""`  |
| `controlplane.auth.oidc.clientSecret`        | OIDC IDp clientSecret                                                                                  | `""`  |
| `controlplane.auth.oidc.loginURLOverride`    | Optional OIDC login URL override, useful to point to custom login pages                                |       |
| `controlplane.auth.oidc.externalURL`         | Optional External URL for the controlplane to the outside world                                        |       |
| `controlplane.auth.allowList.rules`          | List of domains or emails to allow                                                                     |       |
| `controlplane.auth.allowList.selectedRoutes` | List of selected routes to allow. If not set it applies to all routes                                  |       |
| `controlplane.auth.allowList.customMessage`  | Custom message to display when a user is not allowed                                                   |       |

### Control Plane Networking

| Name                                               | Description                                                                                                                      | Value                    |
| -------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `controlplane.service.type`                        | Service type                                                                                                                     | `ClusterIP`              |
| `controlplane.service.ports.http`                  | controlplane service HTTP port                                                                                                   | `80`                     |
| `controlplane.service.ports.https`                 | controlplane service HTTPS port                                                                                                  | `443`                    |
| `controlplane.service.nodePorts.http`              | Node port for HTTP                                                                                                               | `""`                     |
| `controlplane.service.nodePorts.https`             | Node port for HTTPS                                                                                                              | `""`                     |
| `controlplane.service.clusterIP`                   | controlplane service Cluster IP                                                                                                  | `""`                     |
| `controlplane.service.loadBalancerIP`              | controlplane service Load Balancer IP                                                                                            | `""`                     |
| `controlplane.service.loadBalancerSourceRanges`    | controlplane service Load Balancer sources                                                                                       | `[]`                     |
| `controlplane.service.externalTrafficPolicy`       | controlplane service external traffic policy                                                                                     | `Cluster`                |
| `controlplane.service.annotations`                 | Additional custom annotations for controlplane service                                                                           | `{}`                     |
| `controlplane.service.extraPorts`                  | Extra ports to expose in controlplane service (normally used with the `sidecars` value)                                          | `[]`                     |
| `controlplane.service.sessionAffinity`             | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `controlplane.service.sessionAffinityConfig`       | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `controlplane.serviceAPI.type`                     | Service type                                                                                                                     | `ClusterIP`              |
| `controlplane.serviceAPI.ports.http`               | controlplane service HTTP port                                                                                                   | `80`                     |
| `controlplane.serviceAPI.ports.https`              | controlplane service HTTPS port                                                                                                  | `443`                    |
| `controlplane.serviceAPI.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                     |
| `controlplane.serviceAPI.nodePorts.https`          | Node port for HTTPS                                                                                                              | `""`                     |
| `controlplane.serviceAPI.clusterIP`                | controlplane service Cluster IP                                                                                                  | `""`                     |
| `controlplane.serviceAPI.loadBalancerIP`           | controlplane service Load Balancer IP                                                                                            | `""`                     |
| `controlplane.serviceAPI.loadBalancerSourceRanges` | controlplane service Load Balancer sources                                                                                       | `[]`                     |
| `controlplane.serviceAPI.externalTrafficPolicy`    | controlplane service external traffic policy                                                                                     | `Cluster`                |
| `controlplane.serviceAPI.annotations`              | Additional custom annotations for controlplane service                                                                           |                          |
| `controlplane.serviceAPI.extraPorts`               | Extra ports to expose in controlplane service (normally used with the `sidecars` value)                                          | `[]`                     |
| `controlplane.serviceAPI.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `controlplane.serviceAPI.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `controlplane.ingress.enabled`                     | Enable ingress record generation for controlplane                                                                                | `false`                  |
| `controlplane.ingress.pathType`                    | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `controlplane.ingress.hostname`                    | Default host for the ingress record                                                                                              | `cp.dev.local`           |
| `controlplane.ingress.ingressClassName`            | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `controlplane.ingress.path`                        | Default path for the ingress record                                                                                              | `/`                      |
| `controlplane.ingress.annotations`                 | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `controlplane.ingress.tls`                         | Enable TLS configuration for the host defined at `controlplane.ingress.hostname` parameter                                       | `false`                  |
| `controlplane.ingress.selfSigned`                  | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `controlplane.ingress.extraHosts`                  | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `controlplane.ingress.extraPaths`                  | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `controlplane.ingress.extraTls`                    | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `controlplane.ingress.secrets`                     | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `controlplane.ingress.extraRules`                  | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `controlplane.ingressAPI.enabled`                  | Enable ingress record generation for controlplane                                                                                | `false`                  |
| `controlplane.ingressAPI.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `controlplane.ingressAPI.hostname`                 | Default host for the ingress record                                                                                              | `api.cp.dev.local`       |
| `controlplane.ingressAPI.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `controlplane.ingressAPI.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `controlplane.ingressAPI.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. |                          |
| `controlplane.ingressAPI.tls`                      | Enable TLS configuration for the host defined at `controlplane.ingress.hostname` parameter                                       | `false`                  |
| `controlplane.ingressAPI.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `controlplane.ingressAPI.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `controlplane.ingressAPI.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `controlplane.ingressAPI.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `controlplane.ingressAPI.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `controlplane.ingressAPI.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### Controlplane Misc

| Name                                                             | Description                                                                                                                                                                                                                                         | Value            |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `controlplane.resourcesPreset`                                   | Set init container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `micro`          |
| `controlplane.resources`                                         | Set controlplane container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                      | `{}`             |
| `controlplane.podSecurityContext.enabled`                        | Enable controlplane pods' Security Context                                                                                                                                                                                                          | `true`           |
| `controlplane.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy for controlplane pods                                                                                                                                                                                            | `Always`         |
| `controlplane.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface for controlplane pods                                                                                                                                                                                | `[]`             |
| `controlplane.podSecurityContext.supplementalGroups`             | Set filesystem extra groups for controlplane pods                                                                                                                                                                                                   | `[]`             |
| `controlplane.podSecurityContext.fsGroup`                        | Set fsGroup in controlplane pods' Security Context                                                                                                                                                                                                  | `1001`           |
| `controlplane.containerSecurityContext.enabled`                  | Enabled controlplane container' Security Context                                                                                                                                                                                                    | `true`           |
| `controlplane.containerSecurityContext.seLinuxOptions`           | Set SELinux options in controlplane container                                                                                                                                                                                                       | `{}`             |
| `controlplane.containerSecurityContext.runAsUser`                | Set runAsUser in controlplane container' Security Context                                                                                                                                                                                           | `1001`           |
| `controlplane.containerSecurityContext.runAsGroup`               | Set runAsGroup in controlplane container' Security Context                                                                                                                                                                                          | `1001`           |
| `controlplane.containerSecurityContext.runAsNonRoot`             | Set runAsNonRoot in controlplane container' Security Context                                                                                                                                                                                        | `true`           |
| `controlplane.containerSecurityContext.readOnlyRootFilesystem`   | Set readOnlyRootFilesystem in controlplane container' Security Context                                                                                                                                                                              | `true`           |
| `controlplane.containerSecurityContext.privileged`               | Set privileged in controlplane container' Security Context                                                                                                                                                                                          | `false`          |
| `controlplane.containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in controlplane container' Security Context                                                                                                                                                                            | `false`          |
| `controlplane.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in controlplane container                                                                                                                                                                                        | `["ALL"]`        |
| `controlplane.containerSecurityContext.seccompProfile.type`      | Set seccomp profile in controlplane container                                                                                                                                                                                                       | `RuntimeDefault` |
| `controlplane.sentry.enabled`                                    | Enable sentry.io alerting                                                                                                                                                                                                                           | `false`          |
| `controlplane.sentry.dsn`                                        | DSN endpoint                                                                                                                                                                                                                                        | `""`             |
| `controlplane.sentry.environment`                                | Environment tag                                                                                                                                                                                                                                     | `production`     |

### Keyless signing configuration

| Name                                                       | Description                                                                                                                                                              | Value           |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------- |
| `controlplane.keylessSigning.enabled`                      | Activates or deactivates the feature                                                                                                                                     | `false`         |
| `controlplane.keylessSigning.backend`                      | The backend to use. Currently only "fileCA" and "ejbcaCA" are supported                                                                                                  | `fileCA`        |
| `controlplane.keylessSigning.fileCA.cert`                  | The PEM-encoded certificate of the file based CA                                                                                                                         | `""`            |
| `controlplane.keylessSigning.fileCA.key`                   | The PEM-encoded private key of the file based CA                                                                                                                         | `""`            |
| `controlplane.keylessSigning.fileCA.keyPass`               | The secret key pass                                                                                                                                                      | `""`            |
| `controlplane.keylessSigning.ejbcaCA.serverURL`            | The url of the EJBCA service ("https://host/ejbca")                                                                                                                      | `""`            |
| `controlplane.keylessSigning.ejbcaCA.clientKey`            | PEM-encoded the private key for EJBCA cert authentication                                                                                                                | `""`            |
| `controlplane.keylessSigning.ejbcaCA.clientCert`           | PEM-encoded certificate for EJBCA cert authentication                                                                                                                    | `""`            |
| `controlplane.keylessSigning.ejbcaCA.certProfileName`      | Name of the certificate profile to use in EJBCA                                                                                                                          | `""`            |
| `controlplane.keylessSigning.ejbcaCA.endEntityProfileName` | Name of the Entity Profile to use in EJBCA                                                                                                                               | `""`            |
| `controlplane.keylessSigning.ejbcaCA.caName`               | Name of the CA issuer to use in EJBCA                                                                                                                                    | `""`            |
| `controlplane.customCAs`                                   | List of custom CA certificates content                                                                                                                                   | `[]`            |
| `controlplane.automountServiceAccountToken`                | Mount Service Account token in controlplane pods                                                                                                                         | `false`         |
| `controlplane.hostAliases`                                 | controlplane pods host aliases                                                                                                                                           | `[]`            |
| `controlplane.deploymentAnnotations`                       | Annotations for controlplane deployment                                                                                                                                  | `{}`            |
| `controlplane.podLabels`                                   | Extra labels for controlplane pods                                                                                                                                       | `{}`            |
| `controlplane.podAffinityPreset`                           | Pod affinity preset. Ignored if `controlplane.affinity` is set. Allowed values: `soft` or `hard`                                                                         | `""`            |
| `controlplane.podAntiAffinityPreset`                       | Pod anti-affinity preset. Ignored if `controlplane.affinity` is set. Allowed values: `soft` or `hard`                                                                    | `soft`          |
| `controlplane.nodeAffinityPreset.type`                     | Node affinity preset type. Ignored if `controlplane.affinity` is set. Allowed values: `soft` or `hard`                                                                   | `""`            |
| `controlplane.nodeAffinityPreset.key`                      | Node label key to match. Ignored if `controlplane.affinity` is set                                                                                                       | `""`            |
| `controlplane.nodeAffinityPreset.values`                   | Node label values to match. Ignored if `controlplane.affinity` is set                                                                                                    | `[]`            |
| `controlplane.affinity`                                    | Affinity for controlplane pods assignment                                                                                                                                | `{}`            |
| `controlplane.nodeSelector`                                | Node labels for controlplane pods assignment                                                                                                                             | `{}`            |
| `controlplane.tolerations`                                 | Tolerations for controlplane pods assignment                                                                                                                             | `[]`            |
| `controlplane.updateStrategy.type`                         | controlplane deployment strategy type                                                                                                                                    | `RollingUpdate` |
| `controlplane.priorityClassName`                           | controlplane pods' priorityClassName                                                                                                                                     | `""`            |
| `controlplane.topologySpreadConstraints`                   | Topology Spread Constraints for controlplane pod assignment spread across your cluster among failure-domains                                                             | `[]`            |
| `controlplane.schedulerName`                               | Name of the k8s scheduler (other than default) for controlplane pods                                                                                                     | `""`            |
| `controlplane.terminationGracePeriodSeconds`               | Seconds controlplane pods need to terminate gracefully                                                                                                                   | `""`            |
| `controlplane.lifecycleHooks`                              | for controlplane containers to automate configuration before or after startup                                                                                            | `{}`            |
| `controlplane.extraEnvVars`                                | Array with extra environment variables to add to controlplane containers                                                                                                 | `[]`            |
| `controlplane.extraEnvVarsCM`                              | Name of existing ConfigMap containing extra env vars for controlplane containers                                                                                         | `""`            |
| `controlplane.extraEnvVarsSecret`                          | Name of existing Secret containing extra env vars for controlplane containers                                                                                            | `""`            |
| `controlplane.extraVolumes`                                | Optionally specify extra list of additional volumes for the controlplane pods                                                                                            | `[]`            |
| `controlplane.extraVolumeMounts`                           | Optionally specify extra list of additional volumeMounts for the controlplane containers                                                                                 | `[]`            |
| `controlplane.sidecars`                                    | Add additional sidecar containers to the controlplane pods                                                                                                               | `[]`            |
| `controlplane.initContainers`                              | Add additional init containers to the controlplane pods                                                                                                                  | `[]`            |
| `controlplane.pdb.create`                                  | Enable/disable a Pod Disruption Budget creation                                                                                                                          | `true`          |
| `controlplane.pdb.minAvailable`                            | Minimum number/percentage of pods that should remain scheduled                                                                                                           | `""`            |
| `controlplane.pdb.maxUnavailable`                          | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `controlplane.pdb.minAvailable` and `controlplane.pdb.maxUnavailable` are empty. | `""`            |
| `controlplane.autoscaling.vpa.enabled`                     | Enable VPA for controlplane pods                                                                                                                                         | `false`         |
| `controlplane.autoscaling.vpa.annotations`                 | Annotations for VPA resource                                                                                                                                             | `{}`            |
| `controlplane.autoscaling.vpa.controlledResources`         | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                           | `[]`            |
| `controlplane.autoscaling.vpa.maxAllowed`                  | VPA Max allowed resources for the pod                                                                                                                                    | `{}`            |
| `controlplane.autoscaling.vpa.minAllowed`                  | VPA Min allowed resources for the pod                                                                                                                                    | `{}`            |
| `controlplane.autoscaling.vpa.updatePolicy.updateMode`     | Autoscaling update policy                                                                                                                                                | `Auto`          |
| `controlplane.autoscaling.hpa.enabled`                     | Enable HPA for controlplane pods                                                                                                                                         | `false`         |
| `controlplane.autoscaling.hpa.minReplicas`                 | Minimum number of replicas                                                                                                                                               | `""`            |
| `controlplane.autoscaling.hpa.maxReplicas`                 | Maximum number of replicas                                                                                                                                               | `""`            |
| `controlplane.autoscaling.hpa.targetCPU`                   | Target CPU utilization percentage                                                                                                                                        | `""`            |
| `controlplane.autoscaling.hpa.targetMemory`                | Target Memory utilization percentage                                                                                                                                     | `""`            |

### Artifact Content Addressable (CAS) API

| Name                         | Description                                                                             | Value             |
| ---------------------------- | --------------------------------------------------------------------------------------- | ----------------- |
| `cas.replicaCount`           | Number of replicas                                                                      | `2`               |
| `cas.image.registry`         | Image registry                                                                          | `REGISTRY_NAME`   |
| `cas.image.repository`       | Image repository                                                                        | `REPOSITORY_NAME` |
| `cas.containerPorts.http`    | controlplane HTTP container port                                                        | `8000`            |
| `cas.containerPorts.grpc`    | controlplane gRPC container port                                                        | `9000`            |
| `cas.containerPorts.metrics` | controlplane prometheus metrics container port                                          | `5000`            |
| `cas.tlsConfig.secret.name`  | name of a secret containing TLS certificate to be used by the controlplane grpc server. | `""`              |

### CAS Networking

| Name                                      | Description                                                                                                                      | Value                    |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `cas.service.type`                        | Service type                                                                                                                     | `ClusterIP`              |
| `cas.service.ports.http`                  | cas service HTTP port                                                                                                            | `80`                     |
| `cas.service.ports.https`                 | cas service HTTPS port                                                                                                           | `443`                    |
| `cas.service.nodePorts.http`              | Node port for HTTP                                                                                                               | `""`                     |
| `cas.service.nodePorts.https`             | Node port for HTTPS                                                                                                              | `""`                     |
| `cas.service.clusterIP`                   | cas service Cluster IP                                                                                                           | `""`                     |
| `cas.service.loadBalancerIP`              | cas service Load Balancer IP                                                                                                     | `""`                     |
| `cas.service.loadBalancerSourceRanges`    | cas service Load Balancer sources                                                                                                | `[]`                     |
| `cas.service.externalTrafficPolicy`       | cas service external traffic policy                                                                                              | `Cluster`                |
| `cas.service.annotations`                 | Additional custom annotations for cas service                                                                                    | `{}`                     |
| `cas.service.extraPorts`                  | Extra ports to expose in cas service (normally used with the `sidecars` value)                                                   | `[]`                     |
| `cas.service.sessionAffinity`             | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `cas.service.sessionAffinityConfig`       | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `cas.serviceAPI.type`                     | Service type                                                                                                                     | `ClusterIP`              |
| `cas.serviceAPI.ports.http`               | cas service HTTP port                                                                                                            | `80`                     |
| `cas.serviceAPI.ports.https`              | cas service HTTPS port                                                                                                           | `443`                    |
| `cas.serviceAPI.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                     |
| `cas.serviceAPI.nodePorts.https`          | Node port for HTTPS                                                                                                              | `""`                     |
| `cas.serviceAPI.clusterIP`                | cas service Cluster IP                                                                                                           | `""`                     |
| `cas.serviceAPI.loadBalancerIP`           | cas service Load Balancer IP                                                                                                     | `""`                     |
| `cas.serviceAPI.loadBalancerSourceRanges` | cas service Load Balancer sources                                                                                                | `[]`                     |
| `cas.serviceAPI.externalTrafficPolicy`    | cas service external traffic policy                                                                                              | `Cluster`                |
| `cas.serviceAPI.annotations`              | Additional custom annotations for cas service                                                                                    |                          |
| `cas.serviceAPI.extraPorts`               | Extra ports to expose in cas service (normally used with the `sidecars` value)                                                   | `[]`                     |
| `cas.serviceAPI.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `cas.serviceAPI.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `cas.ingress.enabled`                     | Enable ingress record generation for controlplane                                                                                | `false`                  |
| `cas.ingress.pathType`                    | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `cas.ingress.hostname`                    | Default host for the ingress record                                                                                              | `cas.dev.local`          |
| `cas.ingress.ingressClassName`            | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `cas.ingress.path`                        | Default path for the ingress record                                                                                              | `/`                      |
| `cas.ingress.annotations`                 | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `cas.ingress.tls`                         | Enable TLS configuration for the host defined at `controlplane.ingress.hostname` parameter                                       | `false`                  |
| `cas.ingress.selfSigned`                  | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `cas.ingress.extraHosts`                  | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `cas.ingress.extraPaths`                  | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `cas.ingress.extraTls`                    | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `cas.ingress.secrets`                     | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `cas.ingress.extraRules`                  | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `cas.ingressAPI.enabled`                  | Enable ingress record generation for controlplane                                                                                | `false`                  |
| `cas.ingressAPI.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `cas.ingressAPI.hostname`                 | Default host for the ingress record                                                                                              | `api.cas.dev.local`      |
| `cas.ingressAPI.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `cas.ingressAPI.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `cas.ingressAPI.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. |                          |
| `cas.ingressAPI.tls`                      | Enable TLS configuration for the host defined at `controlplane.ingress.hostname` parameter                                       | `false`                  |
| `cas.ingressAPI.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `cas.ingressAPI.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `cas.ingressAPI.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `cas.ingressAPI.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `cas.ingressAPI.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |
| `cas.ingressAPI.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |

### CAS Misc

| Name                     | Description                            | Value        |
| ------------------------ | -------------------------------------- | ------------ |
| `cas.sentry.enabled`     | Enable sentry.io alerting              | `false`      |
| `cas.sentry.dsn`         | DSN endpoint                           | `""`         |
| `cas.sentry.environment` | Environment tag                        | `production` |
| `cas.customCAs`          | List of custom CA certificates content | `[]`         |

### CAS Misc

| Name                                                    | Description                                                                                                                                                                                                                                         | Value            |
| ------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `cas.resourcesPreset`                                   | Set init container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if volumePermissions.resources is set (volumePermissions.resources is recommended for production). | `micro`          |
| `cas.resources`                                         | Set cas container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                               | `{}`             |
| `cas.podSecurityContext.enabled`                        | Enable cas pods' Security Context                                                                                                                                                                                                                   | `true`           |
| `cas.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy for cas pods                                                                                                                                                                                                     | `Always`         |
| `cas.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface for cas pods                                                                                                                                                                                         | `[]`             |
| `cas.podSecurityContext.supplementalGroups`             | Set filesystem extra groups for cas pods                                                                                                                                                                                                            | `[]`             |
| `cas.podSecurityContext.fsGroup`                        | Set fsGroup in cas pods' Security Context                                                                                                                                                                                                           | `1001`           |
| `cas.containerSecurityContext.enabled`                  | Enabled cas container' Security Context                                                                                                                                                                                                             | `true`           |
| `cas.containerSecurityContext.seLinuxOptions`           | Set SELinux options in cas container                                                                                                                                                                                                                | `{}`             |
| `cas.containerSecurityContext.runAsUser`                | Set runAsUser in cas container' Security Context                                                                                                                                                                                                    | `1001`           |
| `cas.containerSecurityContext.runAsGroup`               | Set runAsGroup in cas container' Security Context                                                                                                                                                                                                   | `1001`           |
| `cas.containerSecurityContext.runAsNonRoot`             | Set runAsNonRoot in cas container' Security Context                                                                                                                                                                                                 | `true`           |
| `cas.containerSecurityContext.readOnlyRootFilesystem`   | Set readOnlyRootFilesystem in cas container' Security Context                                                                                                                                                                                       | `true`           |
| `cas.containerSecurityContext.privileged`               | Set privileged in cas container' Security Context                                                                                                                                                                                                   | `false`          |
| `cas.containerSecurityContext.allowPrivilegeEscalation` | Set allowPrivilegeEscalation in cas container' Security Context                                                                                                                                                                                     | `false`          |
| `cas.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped in cas container                                                                                                                                                                                                 | `["ALL"]`        |
| `cas.containerSecurityContext.seccompProfile.type`      | Set seccomp profile in cas container                                                                                                                                                                                                                | `RuntimeDefault` |
| `cas.automountServiceAccountToken`                      | Mount Service Account token in cas pods                                                                                                                                                                                                             | `false`          |
| `cas.hostAliases`                                       | cas pods host aliases                                                                                                                                                                                                                               | `[]`             |
| `cas.deploymentAnnotations`                             | Annotations for cas deployment                                                                                                                                                                                                                      | `{}`             |
| `cas.podLabels`                                         | Extra labels for cas pods                                                                                                                                                                                                                           | `{}`             |
| `cas.podAffinityPreset`                                 | Pod affinity preset. Ignored if `cas.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                             | `""`             |
| `cas.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `cas.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                        | `soft`           |
| `cas.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `cas.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                       | `""`             |
| `cas.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `cas.affinity` is set                                                                                                                                                                                           | `""`             |
| `cas.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `cas.affinity` is set                                                                                                                                                                                        | `[]`             |
| `cas.affinity`                                          | Affinity for cas pods assignment                                                                                                                                                                                                                    | `{}`             |
| `cas.nodeSelector`                                      | Node labels for cas pods assignment                                                                                                                                                                                                                 | `{}`             |
| `cas.tolerations`                                       | Tolerations for cas pods assignment                                                                                                                                                                                                                 | `[]`             |
| `cas.updateStrategy.type`                               | cas deployment strategy type                                                                                                                                                                                                                        | `RollingUpdate`  |
| `cas.priorityClassName`                                 | cas pods' priorityClassName                                                                                                                                                                                                                         | `""`             |
| `cas.topologySpreadConstraints`                         | Topology Spread Constraints for cas pod assignment spread across your cluster among failure-domains                                                                                                                                                 | `[]`             |
| `cas.schedulerName`                                     | Name of the k8s scheduler (other than default) for cas pods                                                                                                                                                                                         | `""`             |
| `cas.terminationGracePeriodSeconds`                     | Seconds cas pods need to terminate gracefully                                                                                                                                                                                                       | `""`             |
| `cas.lifecycleHooks`                                    | for cas containers to automate configuration before or after startup                                                                                                                                                                                | `{}`             |
| `cas.extraEnvVars`                                      | Array with extra environment variables to add to cas containers                                                                                                                                                                                     | `[]`             |
| `cas.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars for cas containers                                                                                                                                                                             | `""`             |
| `cas.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars for cas containers                                                                                                                                                                                | `""`             |
| `cas.extraVolumes`                                      | Optionally specify extra list of additional volumes for the cas pods                                                                                                                                                                                | `[]`             |
| `cas.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for the cas containers                                                                                                                                                                     | `[]`             |
| `cas.sidecars`                                          | Add additional sidecar containers to the cas pods                                                                                                                                                                                                   | `[]`             |
| `cas.initContainers`                                    | Add additional init containers to the cas pods                                                                                                                                                                                                      | `[]`             |
| `cas.pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                                                     | `true`           |
| `cas.pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                                                      | `""`             |
| `cas.pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `cas.pdb.minAvailable` and `cas.pdb.maxUnavailable` are empty.                                                                                              | `""`             |
| `cas.autoscaling.vpa.enabled`                           | Enable VPA for cas pods                                                                                                                                                                                                                             | `false`          |
| `cas.autoscaling.vpa.annotations`                       | Annotations for VPA resource                                                                                                                                                                                                                        | `{}`             |
| `cas.autoscaling.vpa.controlledResources`               | VPA List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory                                                                                                                                                      | `[]`             |
| `cas.autoscaling.vpa.maxAllowed`                        | VPA Max allowed resources for the pod                                                                                                                                                                                                               | `{}`             |
| `cas.autoscaling.vpa.minAllowed`                        | VPA Min allowed resources for the pod                                                                                                                                                                                                               | `{}`             |
| `cas.autoscaling.vpa.updatePolicy.updateMode`           | Autoscaling update policy                                                                                                                                                                                                                           | `Auto`           |
| `cas.autoscaling.hpa.enabled`                           | Enable HPA for cas pods                                                                                                                                                                                                                             | `false`          |
| `cas.autoscaling.hpa.minReplicas`                       | Minimum number of replicas                                                                                                                                                                                                                          | `""`             |
| `cas.autoscaling.hpa.maxReplicas`                       | Maximum number of replicas                                                                                                                                                                                                                          | `""`             |
| `cas.autoscaling.hpa.targetCPU`                         | Target CPU utilization percentage                                                                                                                                                                                                                   | `""`             |
| `cas.autoscaling.hpa.targetMemory`                      | Target Memory utilization percentage                                                                                                                                                                                                                | `""`             |

### Dependencies

| Name                                 | Description                                                                                            | Value                                                                                    |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------- |
| `postgresql.enabled`                 | Switch to enable or disable the PostgreSQL helm chart                                                  | `true`                                                                                   |
| `postgresql.auth.enablePostgresUser` | Assign a password to the "postgres" admin user. Otherwise, remote access will be blocked for this user | `false`                                                                                  |
| `postgresql.auth.username`           | Name for a custom user to create                                                                       | `chainloop`                                                                              |
| `postgresql.auth.password`           | Password for the custom user to create                                                                 | `chainlooppwd`                                                                           |
| `postgresql.auth.database`           | Name for a custom database to create                                                                   | `chainloop-cp`                                                                           |
| `postgresql.auth.existingSecret`     | Name of existing secret to use for PostgreSQL credentials                                              | `""`                                                                                     |
| `vault.server.args`                  | Arguments to pass to the vault server. This is useful for setting the server in development mode       | `["server","-dev"]`                                                                      |
| `vault.server.config`                | Configuration for the vault server. Small override of default Bitnami configuration                    | `storage "inmem" {}
disable_mlock = true
ui = true
service_registration "kubernetes" {}` |
| `vault.server.extraEnvVars[0].name`  | Root token for the vault server                                                                        | `VAULT_DEV_ROOT_TOKEN_ID`                                                                |
| `vault.server.extraEnvVars[0].value` | The value of the root token. Default: notasecret                                                       | `notasecret`                                                                             |
| `vault.server.extraEnvVars[1].name`  | Address to listen on development mode                                                                  | `VAULT_DEV_LISTEN_ADDRESS`                                                               |
| `vault.server.extraEnvVars[1].value` | The address to listen on. Default: [::]:8200                                                           | `[::]:8200`                                                                              |

## License

Copyright &copy; 2023 The Chainloop Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[https://www.apache.org/licenses/LICENSE-2.0](https://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
