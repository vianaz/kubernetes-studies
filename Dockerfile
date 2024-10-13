FROM python:3.12 AS base
WORKDIR /app

FROM base AS builder
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM base AS final
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY . .
ENV REDIS_HOST localhost
ENTRYPOINT [ "python" ]
CMD [ "-m", "flask", "run", "--host=0.0.0.0" ]