variable "organisation_id" {
  description = "The organization id for the associated services"
}

variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
}

variable "folder_id" {
  description = "Folder ID for the project container"
}

variable "project_id" {
  description = "ID for the project"
}

variable "gcp_region" {
  description = "GCP Region"
  default = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone"
  default = "us-central1-b"
}