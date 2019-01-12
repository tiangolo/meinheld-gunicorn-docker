import sys


def app(env, start_response):
    version = "{}.{}".format(sys.version_info.major, sys.version_info.minor)
    start_response("200 OK", [("Content-Type", "text/plain")])
    message = "Test app. From Meinheld with Gunicorn. Using Python {}".format(version)
    return [message.encode("utf-8")]
