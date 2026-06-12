# Diario di Bordo: Analisi Didattica del Progetto (Versione Semplificata)

Questo documento è stato scritto per te, come materiale di studio. Riassume tutte le scelte ingegneristiche e le sfide che abbiamo affrontato insieme in questo progetto. Ti tornerà utilissimo per preparare l'esposizione all'esame e per fissare concetti chiave di Ingegneria del Software.

---

## 1. Sicurezza e Hardening delle API (Il cuore dell'Esame)
Il codice originale del progetto "funzionava", ma si basava sul presupposto che gli utenti inserissero sempre dati corretti (*Happy Path*). Abbiamo trasformato le API in una "fortezza", applicando il concetto di **Defensive Programming** (Programmazione Difensiva).

* **L'Ordine di Validazione e la prevenzione del `500 Internal Server Error`**: Nel codice originale, quando arrivava una richiesta, il server interrogava subito il database PostgreSQL. Se i dati erano spazzatura (es. una stringa al posto di un ID numerico), PostgreSQL andava in panico lanciando un'eccezione fatale che faceva crashare la richiesta (`500`). La nostra soluzione è stata quella di validare rigidamente i dati in RAM (su Python) *prima* di scomodare il DB. Se il dato non ha senso, blocchiamo la richiesta alla frontiera restituendo un elegante **`400 Bad Request`**.
* **L'Ereditarietà dei Booleani**: Abbiamo scoperto un bug insidioso legato a `isinstance(valore, int)`. In Python, la classe `bool` è figlia della classe `int`. Questo significava che inserendo `True` al posto di un numero di consegne, il programma lo accettava e lo trasformava nel numero `1`. Abbiamo patchato questa vulnerabilità sostituendo il controllo con l'istruzione rigida **`type(valore) is int`**.
* **Sanitizzazione "Nomi Fantasma"**: Un utente malevolo avrebbe potuto inserire un rider chiamandolo `"   "` (solo spazi vuoti). Il controllo `if not nome` falliva perché una stringa con spazi per Python è "piena". Abbiamo blindato la logica usando **`.strip()`**, che rimuove gli spazi invisibili e smaschera le stringhe vuote.
* **Standard REST e Query String**: Il vecchio server andava in crash se l'URL conteneva parametri extra non previsti (es. `?foo=bar`). Per rispettare lo standard REST, abbiamo rimosso le macchinose decodifiche testuali (`query_string.decode`) e ci siamo affidati all'oggetto nativo `request.args` di Flask, che sa ignorare i parametri spazzatura senza rompersi.

---

## 2. La Struttura Architetturale: Separation of Concerns
Abbiamo costruito questo progetto applicando fin da subito il principio della **Separazione delle Responsabilità** (Separation of Concerns). Invece di avere un unico file `main.py` gigante, abbiamo suddiviso il cervello dell'applicazione in strati specializzati:
* **`routes.py`**: Il "centralinista". Questo file si occupa esclusivamente di intercettare la richiesta HTTP in ingresso (decidendo se è una GET, una POST, o una DELETE) e di inoltrarla al reparto competente.
* **`riders_handlers.py`**: Il "controllore di volo". Contiene la logica di business. Qui avvengono le validazioni. Se i dati sono coerenti, questo strato "chiama" il livello del database.
* **`postgres_handlers.py`**: Il "magazziniere". È l'unico file che sa "parlare" il linguaggio SQL. Nasconde la complessità della connessione al database agli altri strati del programma.

---

## 3. L'Estensione dell'API: Sviluppo del nuovo Endpoint `media_voti`
Per arricchire il progetto originale e dimostrare capacità di sviluppo backend, abbiamo implementato un nuovo Endpoint dedicato alla consultazione statistica (la media voti).

Questa aggiunta è stata fatta in modo "verticale" attraversando tutti e 3 i livelli dell'architettura:
1. Abbiamo aggiunto una query SQL nel file del database: `SELECT ROUND(AVG(rating), 1) FROM reviews WHERE rider_id = %s`. L'uso di funzioni aggregate (`AVG`) direttamente in PostgreSQL è molto più performante rispetto a estrarre tutti i voti e fare la media in RAM con Python.
2. Abbiamo aggiunto un blocco logico nell'handler per gestire scenari particolari (es. se un rider non ha ancora recensioni).
3. Abbiamo esposto la rotta HTTP in `routes.py` all'indirizzo `/riders/media_voti/<int:rider_id>`.
