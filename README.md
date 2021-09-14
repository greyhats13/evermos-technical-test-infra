# Evermos Terraform : Everything as a Code
Terraform is no longer limited to Infrasructure as a Code. Thanks to provider ecosystem.

All Evermos technical test infrastructure requirment is deployed in public Cloud Digital Ocean.
Terraform structure contains of modules and deployment. Deployment will source on the module to provision their resource such as service deployment
will invoke Cloudflare, github, and jenkins module.
Deployment can invoke include more module. All the resource is deployed using Terraform including Kubernetes and Helm deployment.
Deployment is consist of 3 deployment type:
- Cloud deployment: to provision resource on the cloud using Terraform DigitalOcean Provider.
- Toolchain deployment: to deploy required tools for services using Terraform Helm Provider.
- Database deployment: mysql and redis deployment using Terraform Helm provider and deployed to Kubernetes as Statefulsets.
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
After All cloud resources, toolchain, database(MySQL, REdis), and CI/CD is setup by Terraform.
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

```bash
def dockerPush(Map args) {
    sh "docker push ${args.docker_username}/${args.service_name}:${args.build_number}"
}

def dockerPushTag(Map args) {
    sh "docker tag ${args.docker_username}/${args.service_name}:${args.build_number} ${args.docker_username}/${args.service_name}:${args.version}"
    sh "docker push ${args.docker_username}/${args.service_name}:${args.version}"
}
```



## Build and run with docker-compose (local)

### Add php-fpm container

<table>
  <tr>
    <th align="left">name</th><td>php-fpm</td>
  </tr>
  <tr>
    <th align="left">image (uri)</th><td>${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/php-fpm:latest</td>
  </tr>
  <tr>
    <th align="left">working directory</th><td>/app</td>
  </tr>
  <tr>
    <th align="left">memory</th><td>300</td>
  </tr>
</table>

### Add nginx container

<table>
  <tr>
    <th align="left">name</th><td>nginx</td>
  </tr>
  <tr>
    <th align="left">image (uri)</th><td>${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/nginx:latest</td>
  </tr>
  <tr>
    <th align="left">port mapping</th><td>tcp 80:80</td>
  </tr>
  <tr>
    <th align="left">memory</th><td>300</td>
  </tr>
  <tr>
    <th align="left">links</th><td>php-fpm</td>
  </tr>
</table>
