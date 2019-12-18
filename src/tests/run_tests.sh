#!/bin/sh

echo "Setting up test infrastructure"
sleep 1

cd terraform

terraform apply -auto-approve

TERRAFORM_OUTPUT=$(terraform output -json | jq -c .) python ../../tests.py

echo "Destroying test infrastructure"
sleep 1

terraform destroy -auto-approve
