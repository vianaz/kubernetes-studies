# syntax=docker/dockerfile:1

FROM cgr.dev/chainguard/python:latest-dev AS dev

WORKDIR /app

RUN python -m venv venv
ENV PATH="/app/venv/bin:$PATH"
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

FROM cgr.dev/chainguard/python:latest

WORKDIR /app

COPY --from=dev /app/venv /app/venv
COPY . .

ENV PATH="/app/venv/bin:$PATH"
ENV REDIS_HOST="localhost"

EXPOSE 5000

ENTRYPOINT [ "flask" ]
CMD [ "run", "--host=0.0.0.0" ]