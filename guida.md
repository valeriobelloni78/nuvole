# Nuvole · i testi della guida

Tutte le parole della pagina `guida.html` in italiano, per correggerle qui invece
che dettarle nella chat. Modifica quello che vuoi, salva, poi dimmi che l'hai
aggiornato: rileggo il file e riporto tutto nella pagina.

**Questo file non è la sorgente della pagina**, è il tavolo di lavoro. La pagina
legge le parole dal dizionario dentro `guida.html`, dove le stesse voci esistono
in quattro lingue. Correggere qui e non dirmelo lascia i due file disallineati:
la pagina non cambia da sola.

**L'italiano è la lingua madre.** Francese, inglese e giapponese sono traduzioni
di quello che c'è qui: quando cambi un testo italiano, riallineo anche le altre
tre. Non serve che le tocchi tu.

## Tre convenzioni

| Nel file | Nella pagina |
|---|---|
| `**parola**` | risalto: il bianco del testo diventa pieno, senza inclinare |
| `*parola*` | corsivo vero (per i titoli d'opera: *In C*, *Music for Airports*) |
| riga vuota fra due capoversi | due capoversi distinti anche nella pagina |

I titoletti fra parentesi quadre — `[intro]`, `[cielo 1]` e simili — **non vanno
modificati**: servono a me per rimettere ogni pezzo al suo posto. Tutto il resto
è tuo.

Se vuoi togliere un blocco intero, cancella il testo e lascia il titoletto con
sotto la parola `TAGLIARE`.

## Due avvertenze

Le voci contrassegnate **[anche nell'interfaccia]** non vivono solo qui: sono le
stesse parole che compaiono sul pannello dello strumento. Cambiando «Sensibilità»
in questo file lo cambio in tutt'e due i posti, come è giusto — ma sappi che
tocchi anche il comando.

I nomi dei **dieci tratti dell'arco** e dei **quattro strumenti** compaiono nel
quadrante e nel righello dello strumento, dove lo spazio è poco: nomi lunghi ci
stanno male. Sotto ogni nome trovi fra parentesi quante lettere ha oggi.

---

## [testata]

**Voce in alto a sinistra, sotto il filo:** Guida

**Collegamento in alto a destra:** Torna allo strumento

---

## [intro]

Nuvole è una web-app di musica generativa che gira interamente nel browser. Un cielo di puntini attraversato da nuvole lente, e un insieme di voci che le nuvole chiamano a suonare. Non c'è nessuna registrazione: quello che si ascolta si forma mentre lo si ascolta, e non si ripete.

---

## [rubrica cielo]

**Titolo:** Il cielo

## [cielo 1]

La finestra non contiene nuvole disegnate: contiene un campo continuo di rumore, interrogato in ogni punto di una matrice fitta. Dove il campo supera una soglia c'è nuvola, e il puntino sbianca e cresce; sotto quella soglia il puntino ha esattamente il colore del cielo, e perciò non si vede. La matrice c'è tutta, sempre — appare soltanto dove la nuvola la scopre.

## [cielo 2]

Il campo non si muove: si sposta il punto da cui lo si guarda, ed è il vento. Una seconda scala, molto più lenta, decide dove il cielo si addensa e dove resta limpido. Per questo le nuvole non si ripetono mai: nascono, attraversano e si sciolgono ai bordi.

---

## [rubrica suono]

**Titolo:** Il suono

## [suono 1]

Il motore sonoro è nella scia di *In C* di Terry Riley (1964): un archivio di frasi brevissime che più voci leggono ciascuna per conto proprio, sopra un polso comune. Le 53 frasi di Nuvole sono materiale originale, non le cellule di Riley — se ne adotta il principio, non le note.

## [suono 2]

A decidere quando si suona sono le nuvole. La finestra è divisa in bande verticali, una per voce: quando una nuvola entra in una banda, quella voce si sveglia, prende una delle frasi disponibili in quel momento e la ripete; quando la nuvola esce, finisce la lettura e tace. Poiché le bande sono attraversate in momenti diversi e per durate diverse, nessuna sovrapposizione è scritta da qualche parte: si formano e si sciolgono come le nuvole che le hanno chiamate.

## [suono 3]

Ne segue che Cielo sereno è anche il comando del silenzio: un cielo limpido è quasi muto, un cielo coperto è un insieme fitto.

---

## [rubrica arco]

**Titolo:** L'arco

## [arco 1]

L'insieme avanza nell'archivio di una frase per volta, mai a salti, e non lascia indietro nessuno: il fronte aspetta chi sta ancora leggendo. Così l'armonia deriva per gradi lungo dieci tratti, che il quadrante chiama con i nomi del cielo.

## [arco · i dieci tratti]   [anche nell'interfaccia]

Nome a sinistra, glossa a destra. Fra parentesi le lettere del nome oggi.

| Nome | Glossa |
|---|---|
| Sereno (6) | tre soli suoni, la luce piena |
| Cirri (5) | l'aria si apre |
| Velo (4) | il primo peso |
| Radura (6) | una schiarita prima del cambio |
| Controluce (10) | il tratto più luminoso |
| Corrente (8) | la tensione, il movimento |
| Vuoto d'aria (12) | il cielo si svuota |
| Nembo (5) | l'ombra |
| Schiarita (9) | l'ombra si ritira |
| Zenit (5) | la luce torna, e l'arco si chiude |

## [arco 2]

Dopo l'ultimo si ricomincia dal primo: l'arco si richiude dove è cominciato.

---

## [rubrica strumenti]

**Titolo:** Gli strumenti

## [strumenti 1]

I timbri sono quattro, e a scegliere è ancora la nuvola: lo spessore che ha sulla banda decide con quale voce suonare, dal velo sottile alla nuvola piena.

## [strumenti · i quattro]   [anche nell'interfaccia]

Nel righello sotto la finestra di ciascun nome compare **la sola iniziale**: se
cambi un nome, cambia anche quella, e due strumenti non possono cominciare con
la stessa lettera.

| Nome | Glossa |
|---|---|
| Vetro | un glockenspiel: il colpo entra brillante e si schiarisce subito in un suono puro che continua a suonare |
| Legno | un battente su barra di marimba, caldo e corto |
| Onda | un suono semplice e tenuto, il fondo dell'insieme |
| Fiato | un soffio: rumore filtrato stretto attorno alla nota, con una sinusoide sotto che le dà l'intonazione |

## [strumenti 2]

Si possono tenere accesi tutti e quattro, oppure due, oppure uno solo — e allora l'insieme intero suona con quello.

---

## [rubrica comandi]

**Titolo:** I comandi

## [comandi 1]

Il pannello sta sotto la finestra, in due sezioni. Sopra di esso un righello mostra le bande delle voci — si accende quella su cui passa una nuvola, con il numero della frase e l'iniziale dello strumento — e un quadrante riporta la frase dell'insieme, le voci in ascolto e il tratto dell'arco.

## [comandi · cielo]   [anche nell'interfaccia]

| Comando | Glossa |
|---|---|
| Cielo sereno | quanta parte del cielo resta limpida: alzandolo le nuvole diradano, ed è anche il comando del silenzio |
| Vento | la velocità con cui le nuvole attraversano la finestra |
| Grana | la distanza fra i puntini: cambia la retinatura, non la dimensione delle nuvole |
| Ampiezza nuvole | quanto sono larghe le nuvole rispetto alla finestra |
| Muta | quanto in fretta la copertura del cielo si trasforma |
| Bande | mostra o nasconde il righello delle voci |

## [comandi · suono]   [anche nell'interfaccia]

| Comando | Glossa |
|---|---|
| Ascolto | accende e spegne il suono; il primo tocco crea il contesto audio, lo esigono i browser |
| Strumenti | quali dei quattro timbri sono in campo |
| Volume | l'ampiezza d'insieme |
| Tempo | il passo del polso comune |
| Voci | quante voci, cioè in quante bande è divisa la finestra |
| Sensibilità | quanta nuvola basta perché una voce si svegli |
| Dispersione | di quante frasi le voci possono allontanarsi le une dalle altre |
| Avanzamento | ogni quanto l'insieme può passare alla frase successiva |
| Riverbero | la coda dell'ambiente |
| Registro | il trasporto d'insieme, in semitoni |

---

## [rubrica crediti]

**Titolo:** Crediti

## [crediti 1]

Licenza MIT. Nessuna libreria, nessun campione, nessun file esterno: anche il riverbero è una risposta all'impulso generata al momento.

## [crediti · collegamento]

Il codice su GitHub

---

## [firma]   [anche nell'interfaccia]

Chiude tutt'e due le pagine, sotto un filetto.

**Riga del credito:** questo è un progetto open source ideato da Valerio Belloni

**Recapiti:** valeriobelloni.art · valerio.belloni [at] pm.me

L'indirizzo di posta **non è un collegamento**, ed è voluto: scritto con «[at]»
va ricomposto a mano da chi scrive, ed è il prezzo di non darlo in pasto ai
raccoglitori di indirizzi.
