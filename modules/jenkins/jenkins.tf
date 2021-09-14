data "terraform_remote_state" "jenkins" {
  backend = "s3"
  config = {
    bucket  = "greyhats13-tfstate"
    key     = "${var.unit}-toolchain-jenkins.tfstate"
    region  = "ap-southeast-1"
    profile = "${var.unit}-${var.env}"
  }
}

provider "jenkins" {
  server_url = "https://${data.terraform_remote_state.jenkins.outputs.jenkins_cloudflare_endpoint}"
  username   = var.jenkins_secrets["username"]
  password   = var.jenkins_secrets["password"]
}

resource "jenkins_folder" "folder" {
  name        = "${var.unit}-${var.code}-${var.feature}"
  description = "Pipeline for ${var.unit}-${var.code}-${var.feature}-${var.env} service"
}

resource "jenkins_job" "job" {
  name     = "${var.unit}-${var.code}-${var.feature}-${var.env}"
  folder   = jenkins_folder.folder.id
  template = file("${path.module}/job.xml")

  parameters = {
    description       = "Job for ${var.unit}-${var.code}-${var.feature}-${var.env}"
    unit              = var.unit
    code              = var.code
    feature           = var.feature
    env               = var.env
    credentials_id    = var.credentials_id[0]
    github_username   = var.github_username
    github_repository = var.github_repository
  }
}
