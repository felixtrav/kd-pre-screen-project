FROM python:3.12-slim

WORKDIR /app

COPY ./src/requirements.txt /app

RUN pip install --no-cache-dir -r requirements.txt

COPY ./src /app

ENTRYPOINT [ "gunicorn", "--bind", "0.0.0.0:80", "reset_service:app" ]