#!/bin/bash
#
# Script to deploy terraform code and keep track on S3 and dymanoDB table
#

# Variables
DB_TABLE_DEFAULT="cloudlab-portal"
DB_TABLE_DEFAULT_KEYNAME="jviguerasBackendConfig"
DB_TABLE_DEFAULT_CONFIG_ATTRIBUTE="DefaultConfig"
DEPLOYER="jvigueras@fortinet.com"
REGION="eu-south-2"

GITHUB_REPO_URL=""

# Dynamic variables from DynamoDB STATUS table
S3_BUCKET=""
DB_TABLE_EVENTS=""
DB_TABLE_LOCKS=""
DB_TABLE_DEPLOYMENTS=""
S3_BUCKET_PREFIX=""

# Functions
read_default_variables() {
  # ''' Load default variables from DynamoDB STATUS table '''

  echo "Reading default config from DynamoDB..."
  result=$(aws dynamodb --region "${REGION}" get-item \
    --table-name ${DB_TABLE_DEFAULT} \
    --key '{
      "KeyName": {"S": "'${DB_TABLE_DEFAULT_KEYNAME}'"}
    }' \
    --output json)

  if [[ -z $(echo "$result" | jq -r '.Item') ]]; then
    echo "Item not found in DynamoDB."
    return 1
  fi
  
  # Extract map values and update global variables
  S3_BUCKET=$(echo "$result" | jq -r ".Item.${DB_TABLE_DEFAULT_CONFIG_ATTRIBUTE}.M.S3_BUCKET.S")
  S3_BUCKET_PREFIX=$(echo "$result" | jq -r ".Item.${DB_TABLE_DEFAULT_CONFIG_ATTRIBUTE}.M.S3_BUCKET_PREFIX.S")
  DB_TABLE_DEPLOYMENTS=$(echo "$result" | jq -r ".Item.${DB_TABLE_DEFAULT_CONFIG_ATTRIBUTE}.M.DB_TABLE_DEPLOYMENTS.S")
  DB_TABLE_LOCKS=$(echo "$result" | jq -r ".Item.${DB_TABLE_DEFAULT_CONFIG_ATTRIBUTE}.M.DB_TABLE_LOCKS.S")
  DB_TABLE_EVENTS=$(echo "$result" | jq -r ".Item.${DB_TABLE_DEFAULT_CONFIG_ATTRIBUTE}.M.DB_TABLE_EVENTS.S")
 
  return 0
}

write_to_dynamodb() {
  # ''' Write to DynamoDB table '''
  local DB_TABLE=$1
  local stack_name=$2
  local state_file=$3
  local status=$4

  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local s3_url="s3://${S3_BUCKET}/${state_file}"

  echo "Logging status in DynamoDB..."
  aws dynamodb --region "${REGION}" put-item \
    --table-name "${DB_TABLE}" \
    --item '{
      "StackName": {"S": "'${stack_name}'"},
      "Timestamp": {"S": "'${timestamp}'"},
      "StateFileName": {"S": "'${state_file}'"},
      "S3URL": {"S": "'${s3_url}'"},
      "Status": {"S": "'${status}'"},
      "Deployer": {"S": "'${DEPLOYER}'"}
    }'
}

update_status() {
  # ''' Update status to DynamoDB STATUS table '''
  local stack_name=$1
  local status=$2

  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  echo "Updating status in DynamoDB..."
  aws dynamodb --region "${REGION}" update-item \
    --table-name "${DB_TABLE_DEPLOYMENTS}" \
    --key '{
      "StackName": {"S": "'${stack_name}'"},
      "Deployer": {"S": "'${DEPLOYER}'"}
      }' \
    --update-expression "SET #ts = :timestamp, #st = :status" \
    --expression-attribute-names '{"#ts": "Timestamp", "#st": "Status"}' \
    --expression-attribute-values '{
      ":timestamp": {"S": "'${timestamp}'"},
      ":status": {"S": "'${status}'"}
      }'
}

check_item_exists() {
  # ''' Check if item exists in DynamoDB STATUS table '''
  local stack_name=$1

  echo "Checking if item exists in DynamoDB..."
  result=$(aws dynamodb --region "${REGION}" get-item \
    --table-name "${DB_TABLE_DEPLOYMENTS}" \
    --key '{
      "StackName": {"S": "'${stack_name}'"},
      "Deployer": {"S": "'${DEPLOYER}'"}
    }' \
    --output json)

  if [[ -z $(echo "$result" | jq -r '.Item') ]]; then
    return 1 # Item does not exist
  else
    return 0 # Item exists
  fi
}

delete_from_dynamodb() {
  # ''' Delete item in DynamoDB STATUS table '''
  local stack_name=$1

  echo "Deleting metadata from DynamoDB..."
  aws dynamodb --region "${REGION}" delete-item \
    --table-name "${DB_TABLE_DEPLOYMENTS}" \
    --key '{
      "StackName": {"S": "'${stack_name}'"},
      "Deployer": {"S": "'${DEPLOYER}'"}
    }'
}

delete_state_file() {
  # ''' Delete object in S3 bucket '''
  local state_file=$1

  echo "Deleting state file from S3..."
  aws s3 --region "${REGION}" rm "s3://${S3_BUCKET}/${state_file}"
}

terraform_action() {
  # ''' Terraform actions init|apply|destroy '''
  local action=$1
  local stack_name=$2

  local state_file="${S3_BUCKET_PREFIX}/${stack_name}.tfstate"

  case $action in
    init)
      echo "Initializing Terraform..."
      terraform init -backend-config="bucket=${S3_BUCKET}" \
                     -backend-config="key=${state_file}" \
                     -backend-config="region=${REGION}" \
                     -backend-config="dynamodb_table=${DB_TABLE_LOCKS}"
      ;;
    apply)
      echo "Applying Terraform..."
      terraform apply -auto-approve
      if [[ $? -eq 0 ]]; then
        write_to_dynamodb "${DB_TABLE_EVENTS}" "${stack_name}" "${state_file}" "Success"
        if check_item_exists "${STACK_NAME}"; then
          update_status "${stack_name}" "Deployed"
        else
          write_to_dynamodb "${DB_TABLE_DEPLOYMENTS}" "${stack_name}" "${state_file}"  "Deployed"
        fi
      else
        write_to_dynamodb "${DB_TABLE_EVENTS}" "${stack_name}" "${state_file}" "Failed"
      fi
      ;;
    destroy)
      echo "Destroying Terraform..."
      terraform destroy -auto-approve
      if [[ $? -eq 0 ]]; then
        write_to_dynamodb "${DB_TABLE_EVENTS}" "${stack_name}" "${state_file}" "Destroyed"
        update_status "${stack_name}" "Destroyed"
        #delete_state_file "${state_file}"
        #delete_from_dynamodb "${stack_name}"
      else
        write_to_dynamodb "${DB_TABLE_EVENTS}" "${stack_name}" "${state_file}" "DestroyFailed"
      fi
      ;;
    *)
      echo "Invalid action: $action"
      exit 1
      ;;
  esac
}

# Main script
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <init|apply|destroy> <stack-name>"
  exit 1
fi

ACTION=$1
STACK_NAME=$2

if read_default_variables; then
  #git clone "${GITHUB_REPO_URL}"
  terraform_action "${ACTION}" "${STACK_NAME}"
else
  echo "Failed to read default variables from DynamoDB."
  exit 1
fi