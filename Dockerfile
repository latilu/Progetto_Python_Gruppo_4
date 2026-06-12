#scegliamo una versione leggera di Python
FROM python:3.11-slim

#installiamo le dipendenze necessarie per psycopg2 (il driver PostgreSQL per Python)
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

