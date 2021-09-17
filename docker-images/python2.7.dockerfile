FROM python:2.7

LABEL maintainer="Sebastian Ramirez <tiangolo@gmail.com>"

# Install requirements
# Newer versions don't support Python 2.7 (Python 2.7 reached end of life long ago)
# So for this tag just install whatever is available for Python 2.7, don't use
# Dependabot's updated requirements
RUN pip install --no-cache-dir meinheld gunicorn

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
