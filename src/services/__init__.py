from .ec2 import EC2Service
from .s3 import S3Service


AVAILABLE_SERVICES = (
    EC2Service,
    S3Service,
)
