
resource "github_repository" "repository" {
  count       = var.env =="dev" ? 1:0
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
  count      = var.env =="dev" ? 1:0
  repository = github_repository.repository[0].name
  branch     = var.env
}

resource "github_repository_webhook" "webhook" {
  repository = var.env == "dev" ? github_repository.repository[0].name:"${var.unit}-${var.code}-${var.feature}"

  configuration {
    url          = "https://jenkins.toolchain.dev.blast.co.id/multibranch-webhook-trigger/invoke?token=${var.unit}-${var.code}-${var.feature}-${var.env}"
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["push"]
  depends_on = [
    github_repository.repository
  ]
}