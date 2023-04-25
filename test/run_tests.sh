#!/bin/zsh

inputs_path='./inspec/inputs.generated.yml'

# Read the terraform outputs as JSON,
# filter the data using jq to extract the required values in the required format,
# and use Ruby to convert to YAML then save the result in a temporary file to pass to inspec exec.
terraform output -json -state=../src/terraform/terraform.tfstate |
jq "{restricted_api: .restricted_api.value, project_id: .project_id.value}" |
ruby -ryaml -rjson -e 'puts YAML.dump(JSON.parse(STDIN.read))' > "$inputs_path"

echo 'YAML file contents for inspec exec.'
cat "$inputs_path"

# Run the inspec tests
inspec exec ./inspec -t gcp:// --input-file="$inputs_path"

# Clean up the temp file.
rm "$inputs_path"
