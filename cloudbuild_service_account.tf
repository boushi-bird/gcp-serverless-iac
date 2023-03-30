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
