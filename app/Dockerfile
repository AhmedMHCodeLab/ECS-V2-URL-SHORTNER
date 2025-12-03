# Stage 1: Build with Python 3.11 (matches distroless)
FROM python:3.11-bullseye AS builder

WORKDIR /build

# Install system build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Copy application source
COPY src/ ./src/

# Stage 2: Minimal runtime with distroless (Python 3.11)
FROM gcr.io/distroless/python3-debian12

# Set Python environment
ENV PYTHONPATH=/app:/install/lib/python3.11/site-packages \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copy only compiled dependencies
COPY --from=builder /install/lib/python3.11/site-packages /install/lib/python3.11/site-packages

# Copy application code
COPY --from=builder /build/src /app

# Run as non-root
USER 65532:65532

# Expose application port
EXPOSE 8080

# Run application
CMD ["-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]