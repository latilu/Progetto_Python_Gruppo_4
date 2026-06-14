#scegliamo una versione leggera di Python
FROM python:3.11-slim

#installiamo le dipendenze necessarie per psycopg2 (il driver PostgreSQL per Python)
# libpq-dev > È la libreria di sviluppo per PostgreSQL. È necessaria per compilare il driver psycopg2 (che comunica con il tuo DB Postgres) all'interno del container.
# gcc > È il compilatore C. Poiché psycopg2 non è solo Python ma ha parti scritte in C per essere veloce, il sistema ha bisogno di un compilatore per "costruirlo" durante l'installazione.
# -y > Risponde automaticamente "sì" a tutte le domande di conferma dell'installazione, evitando che il processo si blocchi in attesa di un input umano.
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

#creiamo una directory per l'applicazione
WORKDIR /app

#scriviamo delle variabili d'ambiente necessarie
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PORT=8082

# copiamo il file requirements.txt nella directory di lavoro del container.
# questo file contiene l'elenco delle dipendenze Python necessarie per eseguire l'applicazione.
COPY requirements.txt .

#installiamo le dipendenze Python
RUN pip install --no-cache-dir -r requirements.txt

#copiamo il codice dell'applicazione nella directory di lavoro
COPY . .

#esponiamo la porta su cui l'applicazione ascolterà
EXPOSE 8082

#comando per avviare l'applicazione
CMD ["python", "main.py"]

