FROM python:3.11-slim

WORKDIR /app

# Install system dependencies for build requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp

RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy source code
COPY src/ .

CMD ["python", "main.py"]
