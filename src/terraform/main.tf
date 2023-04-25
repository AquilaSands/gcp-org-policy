provider "google" {
  impersonate_service_account = var.service_account
}

resource "random_id" "this" {
  keepers = {
    project_name = var.project_name
  }

  byte_length = 2
}

locals {
  project = "${var.project_name}-${random_id.this.hex}"
}

resource "google_project" "this" {
  folder_id       = var.folder_id
  name            = local.project
  project_id      = local.project
  billing_account = var.billing_account
}

resource "google_project_service" "org_policy_api" {
  project = google_project.this.project_id
  service = "orgpolicy.googleapis.com"
}

resource "google_org_policy_policy" "this" {
  name   = "projects/${google_project.this.project_id}/policies/gcp.restrictServiceUsage"
  parent = "projects/${google_project.this.project_id}"

  spec {
    inherit_from_parent = true

    rules {

      values {
        denied_values = [var.restricted_api]
      }
    }
  }
}

resource "google_project_service" "restricted_api" {
  project = google_project.this.project_id
  service = var.restricted_api

  depends_on = [
    google_org_policy_policy.this
  ]
}
