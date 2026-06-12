# Capire il Progetto: Guida Passo Passo (Versione Semplificata)

In questo documento spiegheremo il progetto backend come se stessimo organizzando il "dietro le quinte" di un'azienda logistica. Nessun termine tecnico difficile, solo la logica pura di come funziona il flusso delle informazioni.

---

## 1. Cos'è questo progetto?
L'idea di base è aver creato le API (le interfacce di comunicazione) per il gestionale di un'azienda di consegne.
Il nostro sistema, puramente "dietro le quinte", permette di:
- Inserire nel database nuovi corrieri (**Riders**) indicando il loro nome e che veicolo usano.
- Fornire la lista di tutti i corrieri (o filtrarli per chi usa la moto, l'auto, ecc.).
- Permettere di registrare nel database le recensioni lasciate dai clienti (da 1 a 5 stelle) per un corriere.
- Calcolare in automatico e restituire la **Media Voti** di ciascun corriere.

---

## 2. L'Architettura a Strati: I tre uffici dell'azienda
Immagina il tuo progetto informatico come un palazzo di tre piani in cui lavorano impiegati diversi. Ognuno ha un compito specifico e *non* fa il lavoro degli altri.

### 📞 Piano Terra: Il Centralino (File `routes.py`)
È il punto di contatto con l'esterno. I clienti e le applicazioni esterne inviano pacchi di informazioni via Internet (ad esempio tramite Postman). Il Centralino (`routes.py`) non si occupa del contenuto del pacco: legge solo l'indirizzo scritto sopra. 
Esempio: *"Ah, questo pacchetto è indirizzato all'indirizzo `/insert_rider`. Lo accetto e lo mando immediatamente all'Ufficio Controlli!"*.

### 🔍 Primo Piano: L'Ufficio Controlli e Logica (File `riders_handlers.py`)
È il cervello dell'azienda. Riceve l'ordine dal Centralino e ispeziona minuziosamente i dati (questo è il nostro scudo di sicurezza).
Python qui fa i controlli aziendali: *"Vediamo... Il nome è un numero finto o è vero testo? Il veicolo Moto è consentito dal nostro regolamento? Sì, è nella lista dei veicoli ammessi."*. Se c'è un problema (un hackeraggio o un errore), questo ufficio respinge la richiesta con un gentile errore 400. Se i dati sono sani, inoltra il lavoro all'Archivio.

### 🗄️ Cantina: L'Archivio di Ferro (File `postgres_handlers.py` e PostgreSQL)
È il magazzino sotterraneo. Il suo unico scopo è ricordare le cose in modo permanente e sicuro. 
Questo è l'unico ufficio in cui si parla la lingua segreta **SQL**. Riceve i dati filtrati dall'Ufficio Controlli e li trasforma in comandi per PostgreSQL dicendo: `INSERT INTO riders (name, vehicle) VALUES ('Vito', 'moto')`. Inoltre sa interrogare l'archivio con comandi sofisticati per fare calcoli (es. la media voti usando la formula `AVG(rating)`).

---

## 3. Il viaggio di una richiesta: Cosa succede quando usi Postman?
Facciamo finta che tu stia usando Postman per aggiungere una recensione da 5 stelle per il rider numero 3.

1. **L'Invio:** Postman spedisce un pacchetto JSON contenente `{rider_id: 3, rating: 5}` alla rotta `/insert_review`.
2. **L'Accoglienza:** Il `routes.py` riceve il pacco. Legge il JSON e lo lancia all'`inserisci_recensione_handlers`.
3. **L'Ispezione di Sicurezza:** Python verifica che 3 sia davvero un numero (evitando attacchi booleani o stringhe vuote) e che il voto (5) sia compreso tra 1 e 5. Dato che l'ispezione è superata, invia il comando a `inserisci_recensione_db`.
4. **Il Salvataggio:** Il `postgres_handlers.py` prenota il Database PostgreSQL, deposita le 5 stelle al sicuro nel magazzino e ottiene un numero di conferma dell'avvenuto deposito.
5. **Il Ritorno:** L'informazione fa il percorso inverso fino a tornare a Postman, che ti mostra una bellissima spunta verde e un JSON di successo: "Recensione creata!".

---

## 4. Perché lo abbiamo diviso in tanti file? 
Per il principio della **Separazione delle Responsabilità**.
Se un domani decidi di cambiare il Database (da PostgreSQL a un altro archivio come MongoDB o Oracle), dovrai modificare **solo ed esclusivamente** il file `postgres_handlers.py`. Il Centralino (`routes.py`) e l'Ufficio Controlli (`riders_handlers.py`) continueranno a lavorare esattamente come prima, ignari del fatto che la "Cantina" sia stata sostituita.

Scrivere codice separato in questi "strati" e usare la Programmazione Difensiva per bloccare i crash ti rende un vero sviluppatore backend. Significa che il tuo sistema è nato per poter essere sicuro, crescere ed essere modificato facilmente.
