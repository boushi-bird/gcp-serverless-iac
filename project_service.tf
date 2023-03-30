# Artifact Registry APIを有効にする
resource "google_project_service" "artifactregistry" {
  project = var.project
  service = "artifactregistry.googleapis.com"

  disable_on_destroy = false
}

# Cloud Build APIを有効にする
resource "google_project_service" "cloudbuild" {
  project = var.project
  service = "cloudbuild.googleapis.com"

  disable_on_destroy = false
}

# Cloud Run Admin APIを有効にする
resource "google_project_service" "cloudrun" {
  project = var.project
  service = "run.googleapis.com"

  disable_on_destroy = false
}

# Identity and Access Management (IAM) APIを有効にする
resource "google_project_service" "iam" {
  project = var.project
  service = "iam.googleapis.com"

  disable_on_destroy = false
}

# APIを有効にして間もなくは、各API実行がうまく行かないことがあるので少し待つ
resource "time_sleep" "wait_apis_to_be_enabled" {
  depends_on = [
    google_project_service.artifactregistry,
    google_project_service.cloudbuild,
    google_project_service.cloudrun,
    google_project_service.iam,
  ]

  create_duration = "30s"
}
