import sys

from representation.json import JsonRepresentation
from services import AVAILABLE_SERVICES


def filter_aws_resources(tags):
    unused_resources = {}
    for service in AVAILABLE_SERVICES:
        unused_resources.update(
            {service.service_name: service().list_unused_instances(tags)}
        )

    return unused_resources


if __name__ == "__main__":
    # Args count validation
    if len(sys.argv) == 1:
        sys.exit('no args supplied')

    # Format Validation
    tags = sys.argv[1:]

    for tag in tags:
        if ':' not in tag:
            sys.exit(f'invalid tag format for tag {tag}')

    print(JsonRepresentation.represent(filter_aws_resources(tags)))
