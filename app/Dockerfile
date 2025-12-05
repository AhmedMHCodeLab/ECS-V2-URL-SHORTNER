# Stage 1: Build with Python 3.11 (matches distroless)
FROM python:3.11-bullseye AS builder

WORKDIR /build
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

COPY src/ ./src/

# Stage 2: Minimal runtime with distroless (Python 3.11)
FROM gcr.io/distroless/python3-debian12

ENV PYTHONPATH=/app:/install/lib/python3.11/site-packages \
    PYTHONUNBUFFERED=1
WORKDIR /app
COPY --from=builder /install/lib/python3.11/site-packages /install/lib/python3.11/site-packages
COPY --from=builder /build/src /app
USER 65532:65532
EXPOSE 8080
CMD ["-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]