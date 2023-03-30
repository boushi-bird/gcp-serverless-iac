variable "repo_location" {
  default = "asia"
}

resource "google_artifact_registry_repository" "docker_registry" {
  project       = var.project
  location      = var.repo_location
  repository_id = "docker"
  format        = "DOCKER"

  depends_on = [
    time_sleep.wait_apis_to_be_enabled,
  ]
}
