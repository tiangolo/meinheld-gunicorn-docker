from __future__ import print_function

import json
import multiprocessing
import os

workers_per_core_str = os.getenv("WORKERS_PER_CORE", "2")
web_concurrency_str = os.getenv("WEB_CONCURRENCY", None)
host = os.getenv("HOST", "0.0.0.0")
port = os.getenv("PORT", "80")
bind_env = os.getenv("BIND", None)
use_loglevel = os.getenv("LOG_LEVEL", "info")

use_access_log = os.getenv('ACCESS_LOG', None)
use_access_log_to_file = os.getenv('ACCESS_LOG_TO_FILE', None)
use_error_log_to_file = os.getenv('ERROR_LOG_TO_FILE', None)

if bind_env:
    use_bind = bind_env
else:
    use_bind = "{host}:{port}".format(host=host, port=port)

cores = multiprocessing.cpu_count()
workers_per_core = float(workers_per_core_str)
default_web_concurrency = workers_per_core * cores
if web_concurrency_str:
    web_concurrency = int(web_concurrency_str)
    assert web_concurrency > 0
else:
    web_concurrency = int(default_web_concurrency)

# Gunicorn config variables
loglevel = use_loglevel
workers = web_concurrency
bind = use_bind
keepalive = 120
errorlog = "-"

# access log
accesslog = None
if use_access_log:
    accesslog = "-"
    if use_access_log_to_file:
        accesslog = "/var/log/gunicorn.access.log"

# add request time to access log (T)
access_log_format = '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s" "%(T)ss"'

# error log
errorlog = "-"
if use_error_log_to_file:
    errorlog = "/var/log/gunicorn.error.log"

# For debugging and testing
log_data = {
    "loglevel": loglevel,
    "workers": workers,
    "bind": bind,
    "accesslog": accesslog,
    "errorlog": errorlog,

    # Additional, non-gunicorn variables
    "workers_per_core": workers_per_core,
    "host": host,
    "port": port,
}
print(json.dumps(log_data))
