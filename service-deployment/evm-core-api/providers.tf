

provider "github" {
  token        = var.github_secrets["token"]
  owner        = var.github_secrets["owner"]
}