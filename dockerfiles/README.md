# Building images  with build context
- https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#understand-build-context

## Python 2.7
`docker build -t tiangolo/meinheld-gunicorn:python2.7 -f python2.7.dockerfile ../build`

## Python 3.6
`docker build -t tiangolo/meinheld-gunicorn:python3.6 -f python3.6.dockerfile ../build`

## Python 3.6-alpine3.10
`docker build -t tiangolo/meinheld-gunicorn:python3.6-alpine3.10 -f python3.6-alpine3.10.dockerfile ../build`

## Python 3.7
`docker build -t tiangolo/meinheld-gunicorn:python3.7 -f python3.7.dockerfile ../build`

## Python 3.7-alpine3.10
`docker build -t tiangolo/meinheld-gunicorn:python3.7-alpine3.10 -f python3.7-alpine3.10.dockerfile ../build`

## Python 3.8
`docker build -t tiangolo/meinheld-gunicorn:python3.8 -f python3.8.dockerfile ../build`

## Python 3.8-alpine3.10
`docker build -t tiangolo/meinheld-gunicorn:python3.8-alpine3.10 -f python3.8-alpine3.10.dockerfile ../build`