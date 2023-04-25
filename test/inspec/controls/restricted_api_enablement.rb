# frozen_string_literal: true

title 'Restricted API enablement blocked for all methods'

project_id = input('project_id')
restricted_api = input('restricted_api')

project_no_prefix = project_id.delete_prefix('projects/')

control 'restricted-api-blocked' do
  impact 1.0
  title 'Restricted API enablement blocked for all methods'
  desc 'This test checks that the restricted API was not enabled via Terraform and
    that it cannot be enabled via the gcloud CLI or by calling the REST endpoint.'

  constraint = 'constraints/gcp.restrictServiceUsage'

  # Test the policy exists and is set
  describe google_organization_policy(name: project_id, constraint: constraint) do
    it { should exist }
    its('list_policy.denied_values') { should include restricted_api }
  end

  describe google_project_service(project: project_no_prefix, name: restricted_api) do
    it { should exist }
    its('state') { should cmp 'DISABLED' }
  end
end
