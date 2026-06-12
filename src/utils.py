import os
import psycopg2
from flask import jsonify

# Estrae la stringa e la converte in una lista vera e propria, con fallback sicuro
raw_lista = os.getenv("LISTA_VEICOLI_AMMESSI", "auto,moto,scooter,bicicletta,furgone")
LISTA_VEICOLI_AMMESSI = [v.strip().lower() for v in raw_lista.split(',')]

def controllo_veicolo_valido(veicolo):
    return veicolo.lower() in LISTA_VEICOLI_AMMESSI


                




