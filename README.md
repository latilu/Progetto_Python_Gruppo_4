# Progetto Riders - Patch Sicurezza Backend ed Endpoint Media Voti

Questo branch (`fix/backend-security-and-endpoint`) contiene un pacchetto di aggiornamenti essenziali per la stabilità e la sicurezza del backend del Progetto Riders originale, oltre all'implementazione della nuova feature richiesta.

> **Nota:** Questa versione contiene **solo codice di backend**. Non include interfacce grafiche (UI) o file Docker, ed è pensata per essere fusa (merge) nel progetto `main` originale senza alterarne la struttura grafica.

## Nuove Funzionalità Aggiunte
* **Endpoint Media Voti:** È stata aggiunta la rotta `GET /riders/media_voti/<int:rider_id>`. Interroga il database PostgreSQL sfruttando le funzioni aggregate (`AVG`, `ROUND`) per calcolare la media delle recensioni di un singolo rider. Restituisce JSON formattati e messaggi di cortesia nel caso il rider non abbia ancora ricevuto recensioni.

## Patch di Sicurezza e Risoluzione Crash (Hardening)
Durante lo stress test del backend (Crash Testing) sono emerse diverse vulnerabilità che portavano l'API a generare errori di eccezione fatali non gestiti (HTTP 500). Sono state chiuse tramite un refactoring completo dei controlli:

1. **Gestione dell'Ordine di Validazione:**
   I controlli di tipo ed esistenza dei dati nel payload avvengono ora rigorosamente in RAM (Python) *prima* di interrogare il database, proteggendo PostgreSQL da query malformate che facevano cadere il server.

2. **Fix "Trucco dei Booleani":**
   I comandi `isinstance(valore, int)` sono stati sostituiti con controlli più restrittivi (`type(valore) is int`). Questo impedisce l'immissione di valori booleani (`True` / `False`), che nativamente Python valuta come `1` o `0`, corrompendo colonne numeriche del DB come `rating` o `total_deliveries`.

3. **Sanitizzazione "Nomi Fantasma":**
   Introdotto l'uso di `.strip()` sui campi di testo per impedire la registrazione di rider o recensioni composte da soli spazi vuoti (`"   "`), che non venivano bloccate dai vecchi controlli di stringa.

4. **Resilienza URL e Standard REST:**
   Rimosse le decodifiche manuali delle `query_string` nelle rotte (`routes.py`). Il backend ora ignora pacificamente parametri URL extra o non previsti (es. `?foo=bar`) senza causare un blocco dell'API.

## Avvio del progetto
Essendo questo il progetto standard privo di Docker, l'avvio rimane quello classico di sviluppo:
1. Assicurati di avere PostgreSQL in funzione sul tuo sistema locale e di aver impostato le credenziali.
2. Attiva il tuo ambiente virtuale (`venv`).
3. Avvia il server Flask:
   ```bash
   python main.py
   ```
