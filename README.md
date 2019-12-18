# AWS Tag Searcher

This script takes multiple tags in a `key:value` format as input, and filters existing EC2 and S3 instances for matching tags

## Setup

This repo provides multiple ways to execute the script:

### Locally

Dependencies for the script are provided in the `requirements.txt` file. Simply install them with `pip install -r requirements.txt`, sourcing a virtualenv should it be needed.

Environment variables need to be set in order for the script to work. `boto3` reads access key and secret key from `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` respectively. The recommended way of dealing with env variables is by using [direnv](https://direnv.net/).

Alternatively, if you've set up these values in an AWS profile with its CLI, you can pass the `AWS_PROFILE_NAME` variable to the script.

Once the execution environment is setup, the script is called by running `main.py` and passing the tag pairs as command line arguments. For example:

`python3 src/main.py unused:false`

### Docker

There is a `Dockerfile` available, with the required environment setup to run the script. However, some environment variables need to be set during container startup for it to work.

The following is an example execution command to run the script with Docker:

```sh
docker build . --rm -t aws_tag_searcher
docker run -e AWS_ACCESS_KEY_ID=\<your aws access ID\> -e AWS_SECRET_ACCESS_KEY=\<your aws secret key\> aws_tag_searcher tag1:value tag2:othervalue
```

Additionally, you can pass the `AWS_DEFAULT_REGION` variable, should you need to work in a different region (by default, the script works on `us-east-1`).

## Running the tests

This repo provides a Python test suite, along with a Terraform module, and a wrapper execution script.

This testing suite depends on the project's requirements, as well as the `jq` command line util to parse Terraform's output.

The wrapper script `run_tests.sh` takes care of setting up the test infrastructure, passing its state to the test suite, and tearing down said infrastructure, all without manual intervention.