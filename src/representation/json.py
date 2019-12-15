import json

from .base import Representation


class JsonRepresentation(Representation):
    @staticmethod
    def represent(resources):
        return(json.dumps(resources))
