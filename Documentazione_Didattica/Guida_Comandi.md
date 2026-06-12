# Guida ai Comandi del Progetto Riders (Versione Semplificata)

Questa è la tua "Cheat Sheet" (lista rapida) di tutti i comandi necessari per gestire la versione backend del progetto. Questa versione include tutte le protezioni di sicurezza, ma non contiene l'interfaccia grafica né Docker.
Sei attualmente sul branch `fix/backend-security-and-endpoint`.

---

## 🐍 1. Avvio Locale (Metodo Classico)
Per sviluppare e testare l'app direttamente sul tuo PC Windows. Assicurati di avere PostgreSQL acceso e configurato in background sul tuo computer.

**Passo 1: Attivare l'Ambiente Virtuale (VENV)**
```powershell
.\venv\Scripts\Activate.ps1
```
*(Vedrai comparire la scritta `(venv)` verde all'inizio della riga del terminale).*

**Passo 2: Avviare il Server Flask**
```powershell
python main.py
```
*(Ora il sito è online e in ascolto su http://localhost:5000).*

---

## 💣 2. Test e Sicurezza
Poiché questa versione è priva di interfaccia grafica, per testare il funzionamento delle rotte devi usare un client API come **Postman**.

**Eseguire lo Stress Test (Crash Test)**
Se vuoi dimostrare al professore quanto è solido il tuo backend e come gestisce gli errori, lancia questo comando mentre il server è acceso. Fallo da un secondo terminale:
```powershell
python crash_test.py
```
*(Il terminale si riempirà di test automatici che cercheranno di "hackerare" il sistema, fallendo e ottenendo dei perfetti errori 400 gestiti, anziché 500).*

---

## 🐙 3. Gestione GitHub (Invio aggiornamenti)
Se fai nuove modifiche al codice e vuoi aggiornare i tuoi repository online:

```powershell
# 1. Aggiungi tutte le modifiche
git add .

# 2. Crea un pacchetto di salvataggio (Commit)
git commit -m "Il tuo messaggio descrittivo qui"

# 3. Invialo al tuo profilo personale (Versione Semplificata)
git push vito_clean fix/backend-security-and-endpoint:main

# 4. Invialo all'organizzazione dell'esame (Versione Semplificata)
git push org_clean fix/backend-security-and-endpoint:main
```
