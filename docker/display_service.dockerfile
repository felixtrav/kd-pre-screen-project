FROM python:3.12-slim

LABEL "org.opencontainers.image.source"="https://github.com/felixtrav/kd-pre-screen-project"
LABEL "org.opencontainers.image.authors"="Felix Travieso"

WORKDIR /app

COPY ./src/requirements.txt /app

RUN pip install --no-cache-dir -r requirements.txt

COPY ./src /app

ENTRYPOINT [ "gunicorn", "--bind", "0.0.0.0:80", "display_service:app" ]