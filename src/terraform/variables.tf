variable "folder_id" {
  description = "The folder id in the format 'folders/1234' under which the project will be created."
  type        = string
}

variable "project_name" {
  description = "The name of the project to create."
  type        = string
}

variable "restricted_api" {
  description = "The name of the API to restrict."
  type        = string
}

variable "service_account" {
  description = "The servive account to impersonate. Your account must have access to the service account and be granted roles/iam.serviceAccountOpenIdTokenCreator"
  type        = string
}

variable "billing_account" {
  description = "The billing account id."
  type        = string
}
