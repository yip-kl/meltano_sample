# Define variables
provider "google-beta" {
  project = "adroit-hall-301111"
  region  = "us-central1"
}

variable "project_id" {
 description = "GCP project ID"
 type        = string
 default     = "adroit-hall-301111"
}

# Create a repository for the image
resource "google_artifact_registry_repository" "meltano-repo" {
  location      = "us-central1"
  repository_id = "meltano-repo"
  description   = "Meltano docker repository"
  format        = "DOCKER"
}

# Create Cloud Composer
resource "google_service_account" "custom_service_account" {
  account_id   = "custom-service-account"
  display_name = "Example Custom Service Account"
}

resource "google_project_iam_member" "custom_service_account" {
  project  = var.project_id
  member   = format("serviceAccount:%s", google_service_account.custom_service_account.email)
  // Role for Public IP environments
  role     = "roles/composer.worker"
}

# resource "google_service_account_iam_member" "custom_service_account" {
#   provider = google-beta
#   service_account_id = google_service_account.custom_service_account.name
#   role = "roles/composer.ServiceAgentV2Ext"
#   member = format("serviceAccount:service-%s@cloudcomposer-accounts.iam.gserviceaccount.com", var.project_id)
# }

resource "google_composer_environment" "example_environment" {
  provider = google-beta
  name = "example-environment"

  config {

    // Add your environment configuration here
    software_config {
      image_version = "composer-2.6.4-airflow-2.6.3"
    }

    environment_size = "ENVIRONMENT_SIZE_SMALL"

  }
}