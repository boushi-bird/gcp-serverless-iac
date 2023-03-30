resource "google_cloud_run_service" "default" {
  name     = "sample-default-app"
  location = var.region

  autogenerate_revision_name = true

  metadata {
    annotations = {
      "run.googleapis.com/client-name" = "terraform"
    }
  }

  template {
    spec {
      containers {
        image = "nginx:latest"

        ports {
          container_port = 80
        }
      }
    }
  }

  depends_on = [
    time_sleep.wait_apis_to_be_enabled,
  ]

  lifecycle {
    ignore_changes = [
      metadata,
      template,
    ]
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

# Cloud RunサービスのURLを表示
output "default_app_url" {
  value = google_cloud_run_service.default.status[0].url
}
