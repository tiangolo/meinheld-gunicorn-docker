FROM python:3.8-alpine3.11

LABEL maintainer="Sebastian Ramirez <tiangolo@gmail.com>"

RUN apk add --no-cache --virtual .build-deps gcc libc-dev \
    && pip install meinheld gunicorn \
    && apk del .build-deps gcc libc-dev

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY ./start.sh /start.sh
RUN chmod +x /start.sh

COPY ./gunicorn_conf.py /gunicorn_conf.py

COPY ./app /app
WORKDIR /app/

ENV PYTHONPATH=/app

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]

# Run the start script, it will check for an /app/prestart.sh script (e.g. for migrations)
# And then will start Gunicorn with Meinheld
CMD ["/start.sh"]
