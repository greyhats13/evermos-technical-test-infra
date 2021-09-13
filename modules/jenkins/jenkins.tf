provider "jenkins" {
  server_url = "https://jenkins.toolchain.dev.blast.co.id"
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
