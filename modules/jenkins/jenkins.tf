provider "jenkins" {
  server_url = "https://jenkins.toolchain.dev.blast.co.id"
  username   = "admin"
  password   = "admin123"
}

resource "jenkins_folder" "folder" {
  name        = "${var.unit}-${var.env}"
  description = "Pipeline for ${var.unit}-${var.code}-${var.feature}-${var.env} service"
}

resource "jenkins_job" "job" {
  name     = "${var.code}-${var.feature}"
  folder   = jenkins_folder.folder.id
  template = file("job.xml")

  parameters = {
    description     = "Job for ${var.unit}-${var.code}-${var.feature}-${var.env}"
    code            = var.code
    feature         = var.feature
    env             = var.env
    credentials_id  = "github_creds"
    github_username = "greyhats13"
    repository      = "efishery-skill-test"
  }
}
