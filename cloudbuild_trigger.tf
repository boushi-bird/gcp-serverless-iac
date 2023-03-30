# アプリケーションが格納されているGitHubリポジトリのURI
variable "app_repo_uri" {}

# CloudBuildトリガー
resource "google_cloudbuild_trigger" "default_deploy" {
  name = "sample-default-app-deploy"

  filename = "cloudbuild.yaml"

  service_account = google_service_account.cloudbuild_service_account.id

  source_to_build {
    uri       = var.app_repo_uri
    ref       = "refs/heads/main"
    repo_type = "GITHUB"
  }

  substitutions = {
    _CONTAINER_REGISTRY     = "${var.repo_location}-docker.pkg.dev/${var.project}/docker"
    _IMAGE_NAME             = google_cloud_run_service.default.name
    _CLOUD_RUN_SERVICE_NAME = google_cloud_run_service.default.name
    _REGION                 = google_cloud_run_service.default.location
  }

  depends_on = [
    time_sleep.wait_apis_to_be_enabled,
  ]
}
