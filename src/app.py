from flask import Flask
from src.routes import riders_bp
from src.postgres.postgres_handlers import inizializza_db, esegui_reset_db
import sys

def create_app():
    app = Flask(__name__)
    try:
        inizializza_db()
        esegui_reset_db()
    except Exception as e:
        print(f"ERRORE DI AVVIO: Impossibile connettersi a PostgreSQL. Dettaglio: {e}")
        sys.exit(1)     #Se il DB non risponde, per sicurezza chiudo l'app forzatamente
    app.register_blueprint(riders_bp)
    return app