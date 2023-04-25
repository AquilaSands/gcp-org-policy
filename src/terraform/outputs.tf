
output "project_id" {
  description = "The project id."
  value       = google_project.this.id
}

output "restricted_api" {
  description = "The name of the restricted API."
  value       = google_org_policy_policy.this.spec[0].rules[0].values[0].denied_values[0]
}
