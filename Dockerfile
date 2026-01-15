FROM python:3.14

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set working directory
WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-cache

# Copy the application into the container.
COPY . /app

# Expose port
EXPOSE 80

# Healthcheck
HEALTHCHECK --interval=30s --timeout=2s --start-period=5s --retries=3 \
    CMD curl --fail http://localhost:80/health || exit 1

# Run the application.
CMD ["/app/.venv/bin/fastapi", "run", "main.py", "--port", "80", "--host", "0.0.0.0"]
