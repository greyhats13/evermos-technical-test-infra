# Evermos Terraform : Everything as a Code
Terraform is no longer limited to Infrasructure as a Code. Thanks to provider ecosystem.

All Evermos technical test infrastructure requirment is deployed in public Cloud Digital Ocean.
Terraform structure contains of modules and deployment. Deployment will source on the module to provision their resource such as service deployment
will invoke Cloudflare, github, and jenkins module.
Deployment can invoke include more module. All the resource is deployed using Terraform including Kubernetes and Helm deployment.
Deployment is consist of 3 deployment type:
- Cloud deployment: to provision resource on the cloud using Terraform DigitalOcean Provider.
```terraform
provider "digitalocean" {
  token = var.do_token
}

data "terraform_remote_state" "project" {
  backend = "s3"
  config = {
    bucket  = "greyhats13-tfstate"
    key     = "${var.unit}-project-${var.env}.tfstate"
    region  = "ap-southeast-1"
    profile = "${var.unit}-${var.env}"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "greyhats13-tfstate"
    key     = "${var.unit}-vpc-network-${var.env}.tfstate"
    region  = "ap-southeast-1"
    profile = "${var.unit}-${var.env}"
  }
}

#assign k8s cluster to project
resource "digitalocean_project_resources" "project_resource" {
  project = data.terraform_remote_state.project.outputs.do_project_id
  resources = [
    digitalocean_kubernetes_cluster.cluster.urn
  ]
}

data "digitalocean_kubernetes_versions" "versions" {
  version_prefix = var.version_prefix
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = "${var.unit}-${var.code}-${var.feature[0]}-${var.env}"
  region  = var.region
  version = data.digitalocean_kubernetes_versions.versions.latest_version

  node_pool {
    name       = "${var.unit}-${var.code}-${var.feature[1]}-${var.env}"
    size       = var.node_type
    auto_scale = var.auto_scale
    min_nodes  = var.min_nodes
    max_nodes  = var.max_nodes
    labels     = var.node_labels
    dynamic "taint" {
      for_each = length(var.node_taint) > 0 ? var.node_taint : {}
      content {
        key    = taint.value["key"]
        value  = taint.value["value"]
        effect = taint.value["effect"]
      }
    }
  }
  tags     = [var.unit, var.code, var.feature[0], var.env]
  vpc_uuid = data.terraform_remote_state.vpc.outputs.do_vpc_id
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
```
- Toolchain deployment: to deploy required tools for services using Terraform Helm Provider.
- Database deployment: mysql and redis deployment using Terraform Helm provider and deployed to Kubernetes cluster as Statefulsets.
- Service deployment: provision github, jenkins job, and cloudflare for CI/CD deployment requirement.


Cloud deployment::
K8s cluster, VPC, Digital Ocean project.

Toolchain Deployment:
Ingress-nginx, jenkins, cert-manager, and metrics server.

Database deployment :
MySQL, Redis as Stateful Sets.

Service deployment:
Cloudflare record (service endpoint), Github repository and webhook, Jenkins folder, and jobs.


# Evermos CI/CD:
After All cloud resources, toolchain, database(MySQL, REdis), and CI/CD is setup by Terraform. The CI/CD is using Feature Branch workflow. 
- Push event will trigger dev pipeline
- Pull request to Main(master) will trigger Staging pipeline
- Release tag will trigger production pipeline.
It is not 100% implemented due to limited times. So, most of the versioning strategy is a part of feature branch formality.

CI/CD is setup as pipeline as a code in Jenkinsfile. It contains three stages:
1. Source(Checkout)
If delivery team perform push event, the webhook will trigger pipeline.
Jenkins will pull the current push and start to build.
```bash
def scm = checkout([$class: 'GitSCM', branches: [[name: runBranch]], userRemoteConfigs: [[credentialsId: 'gitlab-auth-token', url: repo_url]]])
```
2. Build
Jenkins will build the services as docker container. Jenkins will build the container based what is defined on Dockerfile.
```bash
def dockerBuild(Map args) {
    sh "docker build -t ${args.docker_username}/${args.service_name}:${args.build_number} ."
}
```
3. Push and Tagging to Hub Docker registry
After build the docker images, Jenkins will login to Dockerhub.
```bash
docker.withRegistry("", docker_creds) {
    dockerPush(docker_username: docker_username, service_name: service_name, build_number: build_number)

    dockerPushTag(docker_username: docker_username, service_name: service_name, build_number: build_number, version: version)
  }
}

```
Thus, Jenkins will tagging the docker images based on version (determined) by the environment, and eventually push then to Hub Docker registry.
```bash
def dockerPush(Map args) {
    sh "docker push ${args.docker_username}/${args.service_name}:${args.build_number}"
}

def dockerPushTag(Map args) {
    sh "docker tag ${args.docker_username}/${args.service_name}:${args.build_number} ${args.docker_username}/${args.service_name}:${args.version}"
    sh "docker push ${args.docker_username}/${args.service_name}:${args.version}"
}
```
I have implemented versioning for docker. For development will have alpha version and the tag of build version. Staging will be assigned with beta version tag, and production will be assigned with latest version and release tag.

4. Helm Deployment
After push the docker images to Hub Docker, Jenkins will initiate helm deployment. Helm files is given name based on their development such as values-dev.yaml, values-stg.yaml, and values.yaml(prd). Helm deployment consist of three steps which is.
a. To verifiy whether helm chart is in well formed
```bash
sh "helm lint -f ${helm_values}"
```
b. It will performed debugging check without having to really install the helm to the K8s cluster;
```bash
sh "helm -n ${namespace} install ${service_name} -f ${helm_values} . --dry-run --debug"
```
c. After all the check, we performed the Helm deployment.
```bash
sh "helm -n ${namespace} upgrade --install ${service_name} -f ${helm_values} . --recreate-pods"
```

# Helm Charts for services, Ingress, SSL
Helm chart really make our life easier. We didn't have to perform
```bash
helm upgrade --install -f values.yaml . -n <namespace>
```
manually. All the kubernetes deployment in this assigment is performed using Helm chart and many of them is performed using Terraform or Jenkins CI/CD.
1. Service Deployment (microservices)
For this technical test, I have customized the helm chart for service deployment from ```bash helm create sampleservice``` and add configmap and secrets to the helm templates then associated them with environment variable on deployment (envFrom).
2. Ingress-Nginx
I exposed my sample services to the internet using Ingress Nginx. Ingress Nginx is using DO load balancer. All of the services ingress is assigned to Nginx ingress class on the annotation, and exposed their services to the internet.
3. SSL/TLS
My sample services ingres also using TLS/SSL from LetsEncrypt cert-maanger by assigning the cluster issuer on the ingress annotation.

5. Helm chart for deploying Redis and MySQL as Stateful Sets.
Most of data layer deployment need persistency such as Redis, MySQL, MongoDB, Elasticsearch (ECK). I deployed Redis as stateful sets to the kubernetes cluster.




