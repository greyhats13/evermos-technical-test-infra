resource "digitalocean_project" "project" {
  name        = var.project_name
  description = "Project for ${var.project_name}"
  purpose     = var.purpose
  environment = var.env == "dev" ? "Development":(
                  var.env == "stg" ? "Staging":"Production"
  )
}