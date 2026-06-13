#import os
from src.config import LISTA_VEICOLI_AMMESSI

#LISTA_VEICOLI_AMMESSI = os.getenv("LISTA_VEICOLI_AMMESSI")

def controllo_veicolo_valido(veicolo):
    return veicolo in LISTA_VEICOLI_AMMESSI
