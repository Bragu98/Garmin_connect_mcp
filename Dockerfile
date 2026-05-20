FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    MCP_TRANSPORT=http \
    PORT=8000

WORKDIR /app

# Dependencias del sistema mínimas (certificados para HTTPS hacia Garmin)
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Instalar dependencias Python primero (cacheable)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código de la app
COPY . .

# Carpeta donde garminconnect guarda los tokens de sesión.
# Montar como volumen persistente en Easypanel para evitar logins repetidos
# y reducir el riesgo de bloqueo/MFA.
RUN mkdir -p /root/.garmin-mcp-python

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health').read()" || exit 1

CMD ["python", "server.py"]
