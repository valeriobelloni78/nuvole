# Nuvole

*Nuvole* è una web-app di musica generativa che gira interamente nel browser, nella scia di **Rada** ma con un motore audio, un'interfaccia e un insieme di funzioni nuovi.

Questo repository contiene il **primo modulo — il cielo**: una **finestra** senza cornice, aperta nella stanza chiara, la cui superficie è una matrice fitta di puntini celesti posati direttamente sul cielo della pagina, senza fondo proprio, e segnata soltanto da un contorno bianco finissimo. I puntini del cielo sereno hanno esattamente il colore del cielo: ci sono, ma non si vedono. Si vedono solo quelli che le nuvole hanno sbiancato — la matrice appare unicamente dove c'è nuvola, e la nuvola è l'unica figura. Il motore sonoro verrà innestato su questo stesso campo in una fase successiva: la densità delle nuvole che attraversano la finestra è pensata per diventare la sorgente degli eventi generativi.

## Controlli

I comandi principali — *Cielo sereno* e *Vento*, *Volume*, *Tempo*, *Voci* e
*Sensibilità* — sono quadranti ad arco: una scala di tacche in cerchio, un pallino che vi
corre dentro, e sotto il nome e il valore. Gli altri restano cursori a filetto.

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
- **Strumenti** — quali dei quattro timbri sono in campo. Uno solo, o più d'uno: in tal caso ogni voce ne sorteggia uno a ogni risveglio.
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
così l'armonia deriva per gradi. Il quadrante non ne dice i nomi armonici ma quelli del
cielo, che è ciò che si sente: *Sereno*, *Cirri*, *Velo*, *Radura*, *Controluce*,
*Corrente*, *Vuoto d'aria*, *Nembo*, *Schiarita*, *Zenit* — e poi si ricomincia, perché
l'arco si richiude dove è cominciato. Fra una regione e l'altra l'archivio ha una **cerniera**: quattro
frasi costruite sui soli suoni comuni, dove il grado vecchio si ritira prima che entri il
nuovo. Senza, il Fa e il Fa# — o il Si e il Si bemolle — finirebbero per sovrapporsi, e
basta questo perché tutto suoni stonato. La **libertà di ciascuna voce** dentro un intorno
ristretto del fronte: da qui l'imprevedibilità, senza che l'insieme si sfaldi. E infine la
regola che tiene: **nessuno resta indietro**. Il fronte aspetta chi sta ancora leggendo, e
una voce lasciata indietro finisce la sua frase e ne prende una aggiornata.

Ne segue che **Cielo sereno è anche il comando del silenzio**: un cielo limpido è quasi
muto, un cielo coperto è un insieme fitto.

### Quattro strumenti

Le frasi non sono eseguite da un timbro solo. **Onda** è un suono semplice e tenuto, il
fondo dell'insieme; **Vetro** è un glockenspiel, sintesi FM con l'indice che decade in
due decimi di secondo — il colpo entra brillante e si schiarisce in una sinusoide che
continua a suonare; **Legno** è un battente su barra di marimba, caldo e corto, con il
parziale a due ottave che se ne va per primo; **Fiato** è un soffio, rumore filtrato
stretto attorno alla nota con una sinusoide sotto che le dà l'intonazione. La differenza
sta quasi tutta nella forma dell'attacco e nella lunghezza della coda, non nella forma
d'onda: è l'attacco a dire che strumento è.

**A scegliere lo strumento è la nuvola stessa.** I quattro stanno su un asse che va dal
velo sottile alla nuvola piena — Vetro, Legno, Onda, Fiato — e lo spessore della nuvola
sulla banda decide quale suona: un velo che passa chiama la campana, un banco fitto
chiama il fiato. Non è una metafora aggiunta dopo: è la stessa densità che disegna i
puntini bianchi a decidere il timbro, e nel righello sotto la finestra si legge
l'iniziale dello strumento accanto al numero della frase.

Si possono tenere accesi tutti e quattro, oppure due, oppure uno solo — e allora
l'insieme intero suona con quello. Quando ne sono accesi meno di quattro, l'asse si
ridistribuisce fra quelli rimasti.

Tutto è Web Audio API: nessuna libreria, nessun campione, nessun file esterno — anche il
riverbero è una risposta all'impulso generata al momento.

## Come funziona

Il cielo non è una sequenza di nuvole pre-disegnate ma un **campo continuo di rumore** (`fBm`, moto browniano frazionario) campionato in ogni punto della matrice. Un termine di deriva sposta il campo nel tempo — il *vento* — mentre una seconda scala, più lenta, decide dove il cielo si addensa e dove resta sereno. Le nuvole così non si ripetono mai: nascono, attraversano e si sciolgono ai bordi.

Ogni puntino interpola il proprio colore fra il celeste del sereno — che è il colore stesso della pagina, e perciò invisibile — e il bianco della nuvola, e insieme cresce di raggio in funzione della densità locale: la nuvola emerge dal nulla come una retinatura che si infittisce, e nel dissolversi torna a confondersi con il cielo.

## Parametri

Tutti i parametri di resa e di comportamento sono raccolti nell'oggetto `PARAMS` in cima allo script, così da poter regolare in un solo punto la grana della matrice, i due colori del puntino, la velocità del vento e la copertura del cielo.

## Lingue e guida

L'interfaccia è in **italiano, francese, inglese e giapponese**; la lingua si sceglie in
testata e si conserva fra una visita e l'altra. La [guida](guida.html) è una pagina a sé,
tradotta anch'essa, e spiega il cielo, il suono, l'arco delle dieci regioni, i quattro
strumenti e tutti i comandi.

## Uso

Nessuna dipendenza, nessun build. Basta aprire `index.html` in un browser moderno, oppure pubblicarlo su GitHub Pages.

## Licenza

MIT — vedi il file [LICENSE](LICENSE).
