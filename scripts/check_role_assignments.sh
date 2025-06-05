#!/bin/bash

# Get Subscription ID
SUBSCRIPTION_ID=$(az account show --query id -o tsv 2>/dev/null)
if [ -z "$SUBSCRIPTION_ID" ]; then
  echo "Error: Please login to Azure CLI." >&2
  exit 1
fi

# Get User Object ID
USER_OBJECT_ID=$(az ad signed-in-user show --query id -o tsv 2>/dev/null)
if [ -z "$USER_OBJECT_ID" ]; then
  echo "Error: Failed to get user information." >&2
  exit 1
fi

# Check role assignments
roles=$(az role assignment list --subscription "$SUBSCRIPTION_ID" --assignee "$USER_OBJECT_ID" --query "[?roleDefinitionName=='Owner' || roleDefinitionName=='Contributor'].roleDefinitionName" -o tsv 2>/dev/null)

if [[ "$roles" == *"Owner"* ]]; then
  echo "You have 'Owner' role assigned in this subscription."
  exit 0
elif [[ "$roles" == *"Contributor"* ]]; then
  # If Contributor, check for additional roles
  extra_roles=$(az role assignment list --subscription "$SUBSCRIPTION_ID" --assignee "$USER_OBJECT_ID" --query "[?roleDefinitionName=='User Access Administrator' || roleDefinitionName=='Role Based Access Control Administrator'].roleDefinitionName" -o tsv 2>/dev/null)
  if [[ "$extra_roles" == *"User Access Administrator"* ]] || [[ "$extra_roles" == *"Role Based Access Control Administrator"* ]]; then
    echo "You have 'Contributor' and 'User Access Administrator' or 'Role Based Access Control Administrator' role assigned in this subscription."
    exit 0
  else
    echo "Error: 'Contributor' role alone is insufficient. 'User Access Administrator' or 'Role Based Access Control Administrator' role is also required." >&2
    exit 1
  fi
else
  echo "Error: You do not have 'Owner' or 'Contributor' role assigned in this subscription." >&2
  exit 1
fi
