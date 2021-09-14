
provider "github" {
  token = var.github_secrets["token"]
  owner = var.github_secrets["owner"]
}

resource "github_repository" "repository" {
  count       = var.env == "dev" ? 1 : 0
  name        = "${var.unit}-${var.code}-${var.feature}"
  description = "Repository for ${var.unit}-${var.code}-${var.feature} service"
  visibility  = "public"
  auto_init   = "true"
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      etag
    ]
  }
}

resource "github_branch" "branch" {
  count      = var.env == "dev" ? 1 : 0
  repository = github_repository.repository[0].name
  branch     = var.env
}

data "terraform_remote_state" "jenkins" {
  backend = "s3"
  config = {
    bucket  = "greyhats13-tfstate"
    key     = "${var.unit}-toolchain-jenkins.tfstate"
    region  = "ap-southeast-1"
    profile = "${var.unit}-${var.env}"
  }
}

resource "github_repository_webhook" "webhook" {
  repository = var.env == "dev" ? github_repository.repository[0].name : "${var.unit}-${var.code}-${var.feature}"

  configuration {
    url          = "https://${data.terraform_remote_state.jenkins.outputs.jenkins_cloudflare_endpoint}/multibranch-webhook-trigger/invoke?token=${var.unit}-${var.code}-${var.feature}-${var.env}"
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["push"]
  depends_on = [
    github_repository.repository
  ]
}

resource "github_repository_webhook" "staging" {
  repository = var.env == "dev" ? github_repository.repository[0].name : "${var.unit}-${var.code}-${var.feature}"

  configuration {
    url          = "https://${data.terraform_remote_state.jenkins.outputs.jenkins_cloudflare_endpoint}/multibranch-webhook-trigger/invoke?token=${var.unit}-${var.code}-${var.feature}-stg"
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["pull_request"]
  depends_on = [
    github_repository.repository
  ]
}

resource "github_repository_webhook" "production" {
  repository = var.env == "dev" ? github_repository.repository[0].name : "${var.unit}-${var.code}-${var.feature}"

  configuration {
    url          = "https://${data.terraform_remote_state.jenkins.outputs.jenkins_cloudflare_endpoint}/multibranch-webhook-trigger/invoke?token=${var.unit}-${var.code}-${var.feature}-prd"
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["release"]
  depends_on = [
    github_repository.repository
  ]
}