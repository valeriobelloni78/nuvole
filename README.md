# Nuvole

*Nuvole* è una web-app di musica generativa che gira interamente nel browser, nella scia di **Rada** ma con un motore audio, un'interfaccia e un insieme di funzioni nuovi.

Questo repository contiene il **primo modulo — il cielo**: una **finestra** senza cornice, aperta nella stanza chiara, la cui superficie è una matrice fitta di puntini celesti posati direttamente sulla carta chiara della pagina, senza fondo. Attraverso questa matrice si formano e derivano lentamente delle nuvole: là dove passano, i puntini sbiancano e si assottigliano fino a sciogliersi nel fondo, e la nuvola si legge come una dissolvenza della matrice. Il motore sonoro verrà innestato su questo stesso campo in una fase successiva: la densità delle nuvole che attraversano la finestra è pensata per diventare la sorgente degli eventi generativi.

## Controlli

Sotto la finestra, un righello mostra le bande delle voci — si accende quella su cui sta
passando una nuvola, con il numero della frase che sta leggendo — e un quadrante riporta
la frase dell'insieme, le voci in ascolto e la regione dell'arco. Poi il pannello, in due
sezioni.

**Cielo**

- **Cielo sereno** — quanta parte del cielo resta limpida: alzando il valore diradano le nuvole, abbassandolo il cielo si copre. Essendo le nuvole a chiamare le voci, è anche il comando del silenzio.
- **Vento** — la velocità con cui le nuvole attraversano la finestra. È una *fase di deriva accumulata*, così cambiare la velocità muta il ritmo del vento senza far saltare le nuvole di posizione.
- **Grana** — la distanza fra i puntini della matrice. Infittendo o diradando, le nuvole conservano dimensione e andatura: cambia solo la grana con cui sono disegnate.
- **Ampiezza nuvole** — quanto sono larghe le nuvole rispetto alla finestra.
- **Muta** — quanto in fretta la copertura del cielo si trasforma.
- **Bande** — mostra o nasconde il righello delle voci.

**Suono**

- **Ascolto** — accende e spegne il suono (il primo clic crea il contesto audio: lo esigono i browser).
- **Polso udibile** — rende udibile il battito che tiene insieme le voci, un Do acuto sulla griglia comune.
- **Volume**, **Tempo** — l'ampiezza e il passo del polso.
- **Voci** — quante voci, cioè in quante bande è divisa la finestra.
- **Sensibilità** — quanta nuvola basta perché una voce si svegli.
- **Dispersione** — di quante frasi le voci possono allontanarsi le une dalle altre.
- **Avanzamento** — ogni quanto l'insieme può passare alla frase successiva dell'archivio.
- **Riverbero**, **Registro** — la coda dell'ambiente e il trasporto d'insieme.

## Il suono

Il motore sonoro è nella scia di **In C** di Terry Riley (1964): un archivio di frasi
brevissime in Do che più voci leggono ciascuna per conto proprio, sopra un polso comune.
Le 53 frasi di questa applicazione sono **materiale originale**, non le cellule di Riley,
che sono opera sotto diritto d'autore: se ne adotta il principio, non le note.

A scegliere sono le nuvole. Ogni voce presidia una banda verticale della finestra: quando
una nuvola vi entra, la voce si sveglia, prende a caso una delle frasi disponibili in quel
momento e la ripete; quando la nuvola esce, finisce la lettura e tace. Poiché le nuvole
attraversano le bande in momenti diversi e con durate diverse, nessuna sovrapposizione è
scritta da qualche parte: si formano e si sciolgono come le nuvole che le hanno chiamate.

Di *In C* restano tre regole. Il **polso condiviso**: tutte le frasi partono su un battito,
ma hanno lunghezze diverse e perciò sfasano lentamente l'una rispetto all'altra.
L'**archivio percorso in avanti**: l'insieme avanza di una frase per volta, mai a salti,
così l'armonia deriva per gradi — dal Do puro alla pentatonica, al Fa, alla luce del Fa#,
alla regione di dominante, all'ombra del Si bemolle, e infine al rientro su Do, dove
l'arco si richiude. La **libertà di ciascuna voce** dentro un intorno ristretto di quel
fronte: da qui l'imprevedibilità, senza che l'insieme si sfaldi.

Ne segue che **Cielo sereno è anche il comando del silenzio**: un cielo limpido è quasi
muto, un cielo coperto è un insieme fitto.

Tutto è Web Audio API: nessuna libreria, nessun campione, nessun file esterno — anche il
riverbero è una risposta all'impulso generata al momento.

## Come funziona

Il cielo non è una sequenza di nuvole pre-disegnate ma un **campo continuo di rumore** (`fBm`, moto browniano frazionario) campionato in ogni punto della matrice. Un termine di deriva sposta il campo nel tempo — il *vento* — mentre una seconda scala, più lenta, decide dove il cielo si addensa e dove resta sereno. Le nuvole così non si ripetono mai: nascono, attraversano e si sciolgono ai bordi.

Ogni puntino interpola il proprio colore fra il celeste del sereno e il bianco della nuvola in funzione della densità locale, e insieme si assottiglia: sul fondo chiaro della pagina la nuvola non è una massa che si posa sopra il cielo, ma il cielo stesso che si dirada e svanisce.

## Parametri

Tutti i parametri di resa e di comportamento sono raccolti nell'oggetto `PARAMS` in cima allo script, così da poter regolare in un solo punto la grana della matrice, i due colori del puntino, la velocità del vento e la copertura del cielo.

## Uso

Nessuna dipendenza, nessun build. Basta aprire `index.html` in un browser moderno, oppure pubblicarlo su GitHub Pages.

## Licenza

MIT — vedi il file [LICENSE](LICENSE).
