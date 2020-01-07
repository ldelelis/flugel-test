from time import sleep
import os
import socket

import requests


def resolve_endpoint(endpoint, retry_cutoff, delay=1):
    print(f'Attempting to resolve {endpoint}...')
    try:
        response = requests.get(f'http://{endpoint}')
        print(response.content)
        exit(0)
    except (requests.exceptions.ConnectionError, socket.gaierror):
        if delay >= retry_cutoff:
            print("Max retry time exceeded. Manually check cluster status")
            exit(1)
        delay *= 2
        print(f'Connection error: load balancer not ready. Trying again in {delay} seconds')
        sleep(delay)
        resolve_endpoint(endpoint, retry_cutoff, delay)


if __name__ == '__main__':
    endpoint = os.getenv('TERRAFORM_OUTPUT')
    retry_cutoff = os.getenv('RETRY_CUTOFF', 300)  # max seconds to wait for
    resolve_endpoint(endpoint, retry_cutoff)
