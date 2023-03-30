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

resource "google_service_account" "cloudbuild_service_account" {
  account_id = "cloudbuild-sa"
}

resource "google_project_iam_member" "act_as" {
  project = var.project
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "logs_writer" {
  project = var.project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

# Artifact RegistryへPushをするために追加
resource "google_project_iam_member" "artifactregistry_writer" {
  project = var.project
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

# Cloud Runサービスにデプロイをするために追加
resource "google_project_iam_member" "cloudrun_developer" {
  project = var.project
  role    = "roles/run.developer"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}
