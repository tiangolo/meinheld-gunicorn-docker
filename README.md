[![Test](https://github.com/tiangolo/meinheld-gunicorn-docker/actions/workflows/test.yml/badge.svg)](https://github.com/tiangolo/meinheld-gunicorn-docker/actions/workflows/test.yml) [![Deploy](https://github.com/tiangolo/meinheld-gunicorn-docker/workflows/Deploy/badge.svg)](https://github.com/tiangolo/meinheld-gunicorn-docker/actions?query=workflow%3ADeploy)

## Supported tags and respective `Dockerfile` links

* [`python3.9`, `latest` _(Dockerfile)_](https://github.com/tiangolo/meinheld-gunicorn-docker/blob/master/docker-images/python3.9.dockerfile)
* [`python3.8` _(Dockerfile)_](https://github.com/tiangolo/meinheld-gunicorn-docker/blob/master/docker-images/python3.8.dockerfile)
* [`python3.7`, _(Dockerfile)_](https://github.com/tiangolo/meinheld-gunicorn-docker/blob/master/docker-images/python3.7.dockerfile)
* [`python3.6` _(Dockerfile)_](https://github.com/tiangolo/meinheld-gunicorn-docker/blob/master/docker-images/python3.6.dockerfile)

## Deprecated tags

🚨 These tags are no longer supported or maintained, they are removed from the GitHub repository, but the last versions pushed might still be available in Docker Hub if anyone has been pulling them:

* `python3.9-alpine3.13`
* `python3.8-alpine3.11`
* `python3.7-alpine3.8`
* `python3.6`
* `python3.6-alpine3.8`
* `python2.7`

The last date tags for these versions are:

* `python3.9-alpine3.13-2024-03-11`
* `python3.8-alpine3.11-2024-03-11`
* `python3.7-alpine3.8-2024-03-11`
* `python3.6-2022-11-25`
* `python3.6-alpine3.8-2022-11-25`
* `python2.7-2022-11-25`

---

**Note**: There are [tags for each build date](https://hub.docker.com/r/tiangolo/meinheld-gunicorn/tags). If you need to "pin" the Docker image version you use, you can select one of those tags. E.g. `tiangolo/meinheld-gunicorn:python3.7-2019-10-15`.

# meinheld-gunicorn

[**Docker**](https://www.docker.com/) image with [**Meinheld**](http://meinheld.org/) managed by [**Gunicorn**](https://gunicorn.org/) for high-performance web applications in **[Python](https://www.python.org/)**, with performance auto-tuning.

**GitHub repo**: [https://github.com/tiangolo/meinheld-gunicorn-docker](https://github.com/tiangolo/meinheld-gunicorn-docker)

**Docker Hub image**: [https://hub.docker.com/r/tiangolo/meinheld-gunicorn/](https://hub.docker.com/r/tiangolo/meinheld-gunicorn/)

## Description

Python web applications running with **Meinheld** controlled by **Gunicorn** have some of the [best performances achievable by (older) Python frameworks](https://www.techempower.com/benchmarks/#section=test&runid=a979de55-980d-4721-a46f-77298b3f3923&hw=ph&test=fortune&l=zijzen-7) based on WSGI (synchronous code, instead of ASGI, which is asynchronous) (*).

This applies to frameworks like **Flask** and **Django**.

If you have an already existing application in Flask, Django, or similar frameworks, this image will give you the best performance possible (or close to that).

This image has an "auto-tuning" mechanism included, so that you can just add your code and get **good performance** automatically. And without making sacrifices (like logging).

## Note Python 3.10 and 3.11

The current latest version of Meinheld released is 1.0.2, from May 17, 2020. This version of Meinheld requires an old version of Greenlet (`>=0.4.5,<0.5`) that is not compatible with Python 3.10 and 3.11. That's why the latest version of Python supported in this image is Python 3.9.

### * Note on performance and features

If you are starting a new project, you might benefit from a newer and faster framework like [**FastAPI**](https://github.com/tiangolo/fastapi) (based on ASGI instead of WSGI), and a Docker image like [**tiangolo/uvicorn-gunicorn-fastapi**](https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker).

It would give you about 200% the performance achievable with an older WSGI framework (like Flask or Django), even when using this image.

Also, if you want to use new technologies like WebSockets it would be easier with a newer framework based on ASGI, like **FastAPI**. As the standard ASGI was designed to be able to handle asynchronous code like the one needed for WebSockets.

## Technical Details

### Meinheld

**Meinheld** is a high-performance WSGI-compliant web server.

### Gunicorn

You can use **Gunicorn** to manage Meinheld and run multiple processes of it.

## Alternatives

This image was created to be an alternative to [**tiangolo/uwsgi-nginx**](https://github.com/tiangolo/uwsgi-nginx-docker), providing about 400% the performance of that image.

And to be the base of [**tiangolo/meinheld-gunicorn-flask**](https://github.com/tiangolo/meinheld-gunicorn-flask-docker).

## 🚨 WARNING: You Probably Don't Need this Docker Image

You are probably using **Kubernetes** or similar tools. In that case, you probably **don't need this image** (or any other **similar base image**). You are probably better off **building a Docker image from scratch**.

---

If you have a cluster of machines with **Kubernetes**, Docker Swarm Mode, Nomad, or other similar complex system to manage distributed containers on multiple machines, then you will probably want to **handle replication** at the **cluster level** instead of using a **process manager** in each container that starts multiple **worker processes**, which is what this Docker image does.

In those cases (e.g. using Kubernetes) you would probably want to build a **Docker image from scratch**, installing your dependencies, and running **a single process** instead of this image.

For example, using [Gunicorn](https://gunicorn.org/) you could have a file `app/gunicorn_conf.py` with:

```Python
# Gunicorn config variables
loglevel = "info"
errorlog = "-"  # stderr
accesslog = "-"  # stdout
worker_tmp_dir = "/dev/shm"
graceful_timeout = 120
timeout = 120
keepalive = 5
threads = 3
```

And then you could have a `Dockerfile` with:

```Dockerfile
FROM python:3.9

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./app /code/app

CMD ["gunicorn", "--conf", "app/gunicorn_conf.py", "--bind", "0.0.0.0:80", "app.main:app"]
```

You can read more about these ideas in the [FastAPI documentation about: FastAPI in Containers - Docker](https://fastapi.tiangolo.com/deployment/docker/#replication-number-of-processes) as the same ideas would apply to other web applications in containers.

## When to Use this Docker Image

### A Simple App

You could want a process manager running multiple worker processes in the container if your application is **simple enough** that you don't need (at least not yet) to fine-tune the number of processes too much, and you can just use an automated default, and you are running it on a **single server**, not a cluster.

### Docker Compose

You could be deploying to a **single server** (not a cluster) with **Docker Compose**, so you wouldn't have an easy way to manage replication of containers (with Docker Compose) while preserving the shared network and **load balancing**.

Then you could want to have **a single container** with a **process manager** starting **several worker processes** inside, as this Docker image does.

### Prometheus and Other Reasons

You could also have **other reasons** that would make it easier to have a **single container** with **multiple processes** instead of having **multiple containers** with **a single process** in each of them.

For example (depending on your setup) you could have some tool like a Prometheus exporter in the same container that should have access to **each of the requests** that come.

In this case, if you had **multiple containers**, by default, when Prometheus came to **read the metrics**, it would get the ones for **a single container each time** (for the container that handled that particular request), instead of getting the **accumulated metrics** for all the replicated containers.

Then, in that case, it could be simpler to have **one container** with **multiple processes**, and a local tool (e.g. a Prometheus exporter) on the same container collecting Prometheus metrics for all the internal processes and exposing those metrics on that single container.

---

Read more about it all in the [FastAPI documentation about: FastAPI in Containers - Docker](https://fastapi.tiangolo.com/deployment/docker/), as the same concepts apply to other web applications in containers.

## How to use

You don't have to clone this repo.

You can use this image as a base image for other images.

Assuming you have a file `requirements.txt`, you could have a `Dockerfile` like this:

```Dockerfile
FROM tiangolo/meinheld-gunicorn:python3.9

COPY ./requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

COPY ./app /app
```

It will expect a file at `/app/app/main.py`.

Or otherwise a file at `/app/main.py`.

And will expect it to contain a variable `app` with your "WSGI" application.

Then you can build your image from the directory that has your `Dockerfile`, e.g:

```bash
docker build -t myimage ./
```

## Advanced usage

### Environment variables

These are the environment variables that you can set in the container to configure it and their default values:

#### `MODULE_NAME`

The Python "module" (file) to be imported by Gunicorn, this module would contain the actual application in a variable.

By default:

* `app.main` if there's a file `/app/app/main.py` or
* `main` if there's a file `/app/main.py`

For example, if your main file was at `/app/custom_app/custom_main.py`, you could set it like:

```bash
docker run -d -p 80:80 -e MODULE_NAME="custom_app.custom_main" myimage
```

#### `VARIABLE_NAME`

The variable inside of the Python module that contains the WSGI application.

By default:

* `app`

For example, if your main Python file has something like:

```Python
from flask import Flask
api = Flask(__name__)

@api.route("/")
def hello():
    return "Hello World from Flask"
```

In this case `api` would be the variable with the "WSGI application". You could set it like:

```bash
docker run -d -p 80:80 -e VARIABLE_NAME="api" myimage
```

#### `APP_MODULE`

The string with the Python module and the variable name passed to Gunicorn.

By default, set based on the variables `MODULE_NAME` and `VARIABLE_NAME`:

* `app.main:app` or
* `main:app`

You can set it like:

```bash
docker run -d -p 80:80 -e APP_MODULE="custom_app.custom_main:api" myimage
```

#### `GUNICORN_CONF`

The path to a Gunicorn Python configuration file.

By default:

* `/app/gunicorn_conf.py` if it exists
* `/app/app/gunicorn_conf.py` if it exists
* `/gunicorn_conf.py` (the included default)

You can set it like:

```bash
docker run -d -p 80:80 -e GUNICORN_CONF="/app/custom_gunicorn_conf.py" myimage
```

#### `WORKERS_PER_CORE`

This image will check how many CPU cores are available in the current server running your container.

It will set the number of workers to the number of CPU cores multiplied by this value.

By default:

* `2`

You can set it like:

```bash
docker run -d -p 80:80 -e WORKERS_PER_CORE="3" myimage
```

If you used the value `3` in a server with 2 CPU cores, it would run 6 worker processes.

You can use floating point values too.

So, for example, if you have a big server (let's say, with 8 CPU cores) running several applications, and you have an ASGI application that you know won't need high performance. And you don't want to waste server resources. You could make it use `0.5` workers per CPU core. For example:

```bash
docker run -d -p 80:80 -e WORKERS_PER_CORE="0.5" myimage
```

In a server with 8 CPU cores, this would make it start only 4 worker processes.

#### `WEB_CONCURRENCY`

Override the automatic definition of number of workers.

By default:

* Set to the number of CPU cores in the current server multiplied by the environment variable `WORKERS_PER_CORE`. So, in a server with 2 cores, by default it will be set to `4`.

You can set it like:

```bash
docker run -d -p 80:80 -e WEB_CONCURRENCY="2" myimage
```

This would make the image start 2 worker processes, independent of how many CPU cores are available in the server.

#### `HOST`

The "host" used by Gunicorn, the IP where Gunicorn will listen for requests.

It is the host inside of the container.

So, for example, if you set this variable to `127.0.0.1`, it will only be available inside the container, not in the host running it.

It's is provided for completeness, but you probably shouldn't change it.

By default:

* `0.0.0.0`

#### `PORT`

The port the container should listen on.

If you are running your container in a restrictive environment that forces you to use some specific port (like `8080`) you can set it with this variable.

By default:

* `80`

You can set it like:

```bash
docker run -d -p 80:8080 -e PORT="8080" myimage
```

#### `BIND`

The actual host and port passed to Gunicorn.

By default, set based on the variables `HOST` and `PORT`.

So, if you didn't change anything, it will be set by default to:

* `0.0.0.0:80`

You can set it like:

```bash
docker run -d -p 80:8080 -e BIND="0.0.0.0:8080" myimage
```

#### `LOG_LEVEL`

The log level for Gunicorn.

One of:

* `debug`
* `info`
* `warning`
* `error`
* `critical`

By default, set to `info`.

If you need to squeeze more performance sacrificing logging, set it to `warning`, for example:

You can set it like:

```bash
docker run -d -p 80:8080 -e LOG_LEVEL="warning" myimage
```

### Custom Gunicorn configuration file

The image includes a default Gunicorn Python config file at `/gunicorn_conf.py`.

It uses the environment variables declared above to set all the configurations.

You can override it by including a file in:

* `/app/gunicorn_conf.py`
* `/app/app/gunicorn_conf.py`
* `/gunicorn_conf.py`

### Custom `/app/prestart.sh`

If you need to run anything before starting the app, you can add a file `prestart.sh` to the directory `/app`. The image will automatically detect and run it before starting everything.

For example, if you want to add Alembic SQL migrations (with SQLAlchemy), you could create a `./app/prestart.sh` file in your code directory (that will be copied by your `Dockerfile`) with:

```bash
#! /usr/bin/env bash

# Let the DB start
sleep 10;
# Run migrations
alembic upgrade head
```

and it would wait 10 seconds to give the database some time to start and then run that `alembic` command.

If you need to run a Python script before starting the app, you could make the `/app/prestart.sh` file run your Python script, with something like:

```bash
#! /usr/bin/env bash

# Run custom Python script before starting
python /app/my_custom_prestart_script.py
```

## 🚨 Alpine Python Warning

In short: You probably shouldn't use Alpine for Python projects, instead use the `slim` Docker image versions.

---

Do you want more details? Continue reading 👇

Alpine is more useful for other languages where you build a static binary in one Docker image stage (using multi-stage Docker building) and then copy it to a simple Alpine image, and then just execute that binary. For example, using Go.

But for Python, as Alpine doesn't use the standard tooling used for building Python extensions, when installing packages, in many cases Python (`pip`) won't find a precompiled installable package (a "wheel") for Alpine. And after debugging lots of strange errors you will realize that you have to install a lot of extra tooling and build a lot of dependencies just to use some of these common Python packages. 😩

This means that, although the original Alpine image might have been small, you end up with a an image with a size comparable to the size you would have gotten if you had just used a standard Python image (based on Debian), or in some cases even larger. 🤯

And in all those cases, it will take much longer to build, consuming much more resources, building dependencies for longer, and also increasing its carbon footprint, as you are using more CPU time and energy for each build. 🌳

If you want slim Python images, you should instead try and use the `slim` versions that are still based on Debian, but are smaller. 🤓

## Tests

All the image tags, configurations, environment variables and application options are tested.

## Release Notes

### Latest Changes

* ⬆️ Update black requirement from ^22.10 to ^23.1. PR [#89](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/89) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆️ Update mypy requirement from ^0.991 to ^1.1. PR [#91](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/91) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆️ Bump actions/setup-python from 4.3.0 to 4.5.0. PR [#87](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/87) by [@dependabot[bot]](https://github.com/apps/dependabot).
* 👷 Update latest changes token. PR [#94](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/94) by [@tiangolo](https://github.com/tiangolo).
* 👷 Add GitHub Action for Docker Hub description. PR [#84](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/84) by [@tiangolo](https://github.com/tiangolo).

#### Features

* ✨ Add support for multi-arch builds, including support for arm64 (e.g. Mac M1). PR [#111](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/111) by [@tiangolo](https://github.com/tiangolo).

#### Refactors

* 🔥 Remove Alpine suppport. PR [#110](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/110) by [@tiangolo](https://github.com/tiangolo).

#### Upgrades

* ⬆️ Bump gunicorn from 20.1.0 to 21.2.0. PR [#99](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/99) by [@dependabot[bot]](https://github.com/apps/dependabot).

#### Docs

* 📝 Update test badge in `README.md`. PR [#112](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/112) by [@alejsdev](https://github.com/alejsdev).

#### Internal

* ⬆ Bump actions/setup-python from 4.5.0 to 5.0.0. PR [#105](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/105) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆ Bump peter-evans/dockerhub-description from 3 to 4. PR [#107](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/107) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆️ Bump actions/checkout from 3 to 4. PR [#100](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/100) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆ Bump tiangolo/issue-manager from 0.4.0 to 0.5.0. PR [#108](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/108) by [@dependabot[bot]](https://github.com/apps/dependabot).
* 👷 Update dependabot. PR [#103](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/103) by [@tiangolo](https://github.com/tiangolo).
* 👷 Update latest-changes GitHub Action. PR [#102](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/102) by [@tiangolo](https://github.com/tiangolo).

### 0.4.0

Highlights of this release:

* Support for Python 3.9 and 3.8.
* Deprecation of Python 3.6 and 2.7.
    * The last Python 3.6 and 2.7 images are available in Docker Hub, but they won't be updated or maintained anymore.
    * The last images with a date tag are `python3.6-2022-11-25` and `python2.7-2022-11-25`.
* Upgraded versions of all the dependencies.
* Small improvements and fixes.

#### Features

* ♻️ Add pip flag `--no-cache-dir` to reduce disk size used. PR [#38](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/38) by [@tiangolo](https://github.com/tiangolo).
* ✨ Add support for Python 3.9 and Python 3.9 Alpine. PR [#24](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/24) by [@gv-collibris](https://github.com/gv-collibris).
* Add Python 3.8 with Alpine 3.11. PR [#16](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/16).
* Add support for Python 3.8. PR [#15](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/15).

#### Breaking Changes

* 🔥 Deprecate and remove Python 3.6 and Python 2.7. PR [#75](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/75) by [@tiangolo](https://github.com/tiangolo).
* 🔥 Remove support for Python 2.7. PR [#41](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/41) by [@tiangolo](https://github.com/tiangolo).

#### Docs

* 📝 Add note about why Python 3.10 and 3.11 are note supported. PR [#83](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/83) by [@tiangolo](https://github.com/tiangolo).
* 📝 Add note to discourage Alpine with Python. PR [#42](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/42) by [@tiangolo](https://github.com/tiangolo).
* 📝 Add Kubernetes warning, when to use this image. PR [#40](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/40) by [@tiangolo](https://github.com/tiangolo).
* ✏️ Fix typo duplicate "Note" in Readme. PR [#39](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/39) by [@tiangolo](https://github.com/tiangolo).

#### Internal

* ⬆️ Update mypy requirement from ^0.971 to ^0.991. PR [#80](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/80) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆️ Update black requirement from ^20.8b1 to ^22.10. PR [#79](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/79) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆️ Update docker requirement from ^5.0.3 to ^6.0.1. PR [#78](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/78) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆️ Update autoflake requirement from ^1.3.1 to ^2.0.0. PR [#77](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/77) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆️ Upgrade CI OS. PR [#81](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/81) by [@tiangolo](https://github.com/tiangolo).
* 🔧 Update Dependabot config. PR [#76](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/76) by [@tiangolo](https://github.com/tiangolo).
* 👷 Add scheduled CI. PR [#74](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/74) by [@tiangolo](https://github.com/tiangolo).
* 👷 Add alls-green GitHub Action. PR [#73](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/73) by [@tiangolo](https://github.com/tiangolo).
* 👷 Do not run double CI for PRs, run on push only on master. PR [#72](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/72) by [@tiangolo](https://github.com/tiangolo).
* ⬆️ Update docker requirement from ^4.2.0 to ^5.0.3. PR [#43](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/43) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆️ Update isort requirement from ^4.3.21 to ^5.8.0. PR [#32](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/32) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆️ Update mypy requirement from ^0.770 to ^0.971. PR [#69](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/69) by [@dependabot[bot]](https://github.com/apps/dependabot).
* :arrow_up: Bump actions/checkout from 2 to 3.1.0. PR [#70](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/70) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆️ Update pytest requirement from ^5.4.1 to ^7.0.1. PR [#55](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/55) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆️ Update black requirement from ^19.10b0 to ^20.8b1. PR [#35](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/35) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆️ Bump tiangolo/issue-manager from 0.2.0 to 0.4.0. PR [#30](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/30) by [@dependabot[bot]](https://github.com/apps/dependabot).
* ⬆️ Bump actions/setup-python from 1 to 4.3.0. PR [#71](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/71) by [@dependabot[bot]](https://github.com/apps/dependabot).
* 🔥 Remove unnecessary Travis backup file. PR [#45](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/45) by [@tiangolo](https://github.com/tiangolo).
* 👷 Update Latest Changes GitHub Action. PR [#37](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/37) by [@tiangolo](https://github.com/tiangolo).
* 👷 Add Dependabot and external requirements to get automated upgrade PRs. PR [#29](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/29) by [@tiangolo](https://github.com/tiangolo).
* 👷 Add latest-changes GitHub Action, update issue-manager, and add sponsors funding. PR [#21](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/21) by [@tiangolo](https://github.com/tiangolo).
* Refactor build setup:
    * Migrate to GitHub Actions for CI.
    * Centralize and simplify code and configs.
    * Update tests and types.
    * Move from Pipenv to Poetry.
    * PR [#14](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/14).

### 0.3.0

* Refactor tests to use env vars and add image tags for each build date, like `tiangolo/meinheld-gunicorn:python3.7-2019-10-15`. PR [#8](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/8).

### 0.2.0

* Add support for Python 2.7 (you should use Python 3.7 or Python 3.6). PR [#6](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/6).

* Upgrade Travis. PR [#5](https://github.com/tiangolo/meinheld-gunicorn-docker/pull/5).

### 0.1.0

* Add support for `/app/prestart.sh`.

## License

This project is licensed under the terms of the MIT license.
