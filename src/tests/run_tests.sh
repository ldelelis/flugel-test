#!/bin/sh

while true; do
    case $1 in
    --tags)
        shift
        TEST_TAGS=1
        ;;
    --cluster)
        shift
        TEST_CLUSTER=1
        ;;
    --|*)
        break
        ;;
    esac
done

test_infra() {
    echo "Setting up test infrastructure"
    sleep 1

    TERRAFORM_PATH=$1
    TEST_PATH=$2
    OUTPUT_PATH=$3

    cd $TERRAFORM_PATH

    terraform apply -auto-approve

    TERRAFORM_OUTPUT=$(terraform output -json | jq -cr .$OUTPUT_PATH) python $TEST_PATH

    echo "Destroying test infrastructure"
    sleep 1

    terraform destroy -auto-approve
    cd ../..
}

if [ "${TEST_TAGS:-0}" -eq 1 ]; then
    echo "Testing tags module..."
    sleep 1
    test_infra terraform/tags ../../test_tags.py
fi

if [ "${TEST_CLUSTER:-0}" -eq 1 ]; then
    echo "Testing cluster module..."
    sleep 1
    test_infra terraform/cluster ../../test_cluster.py k8s_load_balancer_ip.value
fi
