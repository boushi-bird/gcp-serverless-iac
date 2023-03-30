variable "project" {}
variable "region" {
  default = "asia-northeast1"
}

provider "google" {
  project = var.project
  region  = var.region
}
