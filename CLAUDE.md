# Nuvole — nota per Claude Code

Questo file orienta una sessione di Claude Code aperta nella cartella del progetto.
È la continuazione di un lavoro iniziato in Claude (Cowork): qui trovi stato, scelte
e prossimi passi, così da riprendere senza ricostruire il contesto.

## Cos'è

*Nuvole* è una **web-app di musica generativa** che gira interamente nel browser,
nella scia di **Rada** (l'app di Valerio: otto linee sonore con periodi coprimi,
tributo a *Music for Airports*), ma con **motore audio, interfaccia e funzioni nuovi**.

Nessun build, nessuna dipendenza a runtime: un unico `index.html` autoconsistente
(HTML + CSS + JS in un solo file). Target di pubblicazione: GitHub Pages, licenza MIT
(come Rada).

## Stato attuale — Modulo 1: il cielo (completato)


- **La stanza è il cielo**: fondo piatto `#5e9bc9`, tutte le scritte e tutti i comandi
  in bianco. La finestra è segnata da un **contorno bianco finissimo** (1px), unico
  riquadro della pagina; il marchio *Nuvole* è allineato a sinistra sopra il vetro,
  con accanto un **punto che respira** (come in Rada2, `.logoPunto`): qui però il
  respiro dura **quattro battiti del polso**, cioè 5,45 s ai 44 bpm fissi.
  Si ferma con `prefers-reduced-motion`
  (canvas 2D responsive, largo quanto `.stanza`, max 980px).
- **Figura e fondo invertiti** (scelta di Valerio, agosto 2026). Il canvas è trasparente
  e `PARAMS.celeste` è **identico al fondo della pagina**: la matrice del cielo sereno
  c'è ma non si vede, e affiorano **solo i puntini bianchi**, che sono le nuvole.
  Nel campo, il puntino interpola verso il bianco e insieme **cresce**
  (`raggioBase` 1.1 → `raggioNuvola` 2.6), perché ora la nuvola è la figura e non il
  vuoto — l'inverso della resa precedente su carta chiara, dove il puntino si
  assottigliava fino a sparire.
- **Due vincoli da non rompere**: (1) `PARAMS.celeste` e il `background` del `body`
  devono restare lo stesso colore, altrimenti la matrice del sereno riaffiora;
  (2) il fondo deve restare **piatto** — anche un gradiente lieve la farebbe riapparire
  a fasce. L'alone (`glow`) è spento: costa `shadowBlur` su migliaia di puntini.
- **Pannello di controllo** sotto la finestra, tutto in tempo reale:
  - *Cielo sereno* — soglia delle nuvole (alto = cielo limpido).
  - *Vento* — velocità di attraversamento.

## Architettura del codice (`index.html`, tag `<script>`)

- `PARAMS` — parametri di resa e comportamento in un solo luogo (griglia, i due colori
  `celeste`→`nuvola`, campo-nuvole, deriva). Alcuni pilotati dal pannello.
- Rumore: `hash2` → `valueNoise` (value-noise 2D) → `fbm` (4 ottave). `smoothstep`.
- `CampoNuvole.densita(col, row, dx, dy, tm)` — **il modello del cielo**. Combina una
  scala di *forma* (dettaglio delle nuvole) e una di *massa* (dove il cielo si addensa),
  poi applica `smoothstep(soglia, soglia+ampiezza, …)`. Restituisce 0..1.
- `Cielo` — dimensionamento della finestra e loop di rendering.
- `Pannello` — wiring degli slider.

## Scelte progettuali da conoscere

- **Densità della matrice**: `PARAMS.passo` (9px) governa la finezza della griglia;
  `PARAMS.passoRif` (22px) è il passo su cui sono tarate scale del rumore e velocità
  del vento. `fattoreGriglia()` riporta le une e l'altra al passo reale, così cambiare
  `passo` infittisce i puntini **senza** rimpicciolire le nuvole né rallentarle.
  Misurati ~5400 puntini a 60 fps.
- **Taratura del campo**: l'fBm si concentra su valori bassi (misurati: min ~0, p50 ~0.14,
  max ~0.28). `soglia`/`ampiezza` sono tarate su questa distribuzione reale, non a occhio.
  Se cambi le scale del rumore, ri-misura la distribuzione prima di ritoccare la soglia.
- **Ogni visita, un cielo diverso** (`Cielo.cieloIniziale`). Il campo di rumore è
  deterministico — `hash2` non ha seme — e la deriva partiva da zero: ogni caricamento
  si apriva perciò sullo stesso identico cielo, e due sessioni con gli stessi comandi
  vedevano passare le stesse nuvole agli stessi minuti (misurato: impronta del campo
  invariata dopo il ricaricamento). Ora la deriva parte da un punto a caso: tre
  spostamenti indipendenti — `phaseX` (forma e massa), `phaseY` (solo forma), `tempo`
  (il tempo lento della copertura) — ricavati da un solo numero con tre moltiplicatori
  irrazionali. Con **`?cielo=<numero>`** quel numero si sceglie, e il cielo torna
  riproducibile: serve a condividerlo e serve alle misure. Il seme è moltiplicato per
  997 perché numeri vicini darebbero cieli quasi identici — uno scarto di 1 vale meno
  di un periodo del rumore.
  *Nota per chi verifica*: il pannello d'anteprima di Claude Code carica le pagine come
  `data:` URL, dove `location.search` è vuoto e la query non arriva mai. Il ramo del
  seme va provato estraendo la funzione ed eseguendola con una `location` finta, come
  è stato fatto qui (dieci caricamenti senza seme: dieci cieli diversi; `?cielo=42` due
  volte: identici; seme malformato: si torna al caso).
- **Vento a fase accumulata**: la deriva usa `phaseX/phaseY` accumulate per frame
  (`+= vento * dt`), non il tempo assoluto. Così cambiare la velocità muta il *ritmo*
  e non fa **saltare** le nuvole di posizione. Il `dt` è clampato per la tab in background.
- **Slider "Cielo sereno"** mappa su `PARAMS.soglia` (range ~0.10–0.21); **"Vento"** su
  `PARAMS.ventoX` (0–2.5) con `ventoY = ventoX * 0.18`.

## Le quattro lingue e la guida

Aggiunte sulla scia di Rada2, con la stessa architettura ma **senza file esterni**:
ogni pagina porta con sé il proprio dizionario, così restano due soli file
autoconsistenti (`index.html` e `guida.html`).

- `LINGUE` = it · fr · en · ja; `TESTI` è un dizionario per lingua. **Le frasi stanno
  intere**, non si compongono concatenando pezzi: l'ordine delle parole cambia da una
  lingua all'altra e nessun incollaggio può prevederlo. Dove serve un numero c'è `{n}`,
  e lo mette `Tn(chiave, n)` — per questo anche «15 s», «3 frasi», «0 st» passano dal
  dizionario e non da una concatenazione.
- **Scelta della lingua**: indirizzo (`?lang=ja`) → scelta salvata in `localStorage`
  (chiave `nuvole.lang`) → preferenze del browser → inglese. Ogni accesso a
  `localStorage` è protetto da `try/catch`: su `file://` e in navigazione privata può
  essere vietato, e l'app deve funzionare comunque. È anche il motivo per cui i due
  collegamenti fra strumento e guida **portano la lingua nell'indirizzo**: è la via che
  funziona sempre.
- **Applicazione**: `data-i18n` scrive `textContent`, `data-i18n-aria` l'etichetta per
  chi non vede. Ma metà delle stringhe dell'interfaccia non sta nel markup: sta nei
  valori dei comandi. Perciò `Pannello` tiene un elenco `rinfresca[]` — ogni `cursore` e
  ogni `interruttore` vi registra la propria funzione di riscrittura — e al cambio di
  lingua li riesegue tutti. **Chi aggiunge un comando non deve fare nulla**: il
  cablaggio è già lì.
- Gli **interruttori** ricevono due *chiavi*, non due parole, e si riscrivono da sé.
  I nomi degli **strumenti** e dei **tratti dell'arco** stanno solo nel dizionario:
  `STRUMENTI` porta una `chiave`, `REGIONI` solo i confini.
- Il **giapponese** ha un `letter-spacing` ridotto (`html[lang="ja"] .tecnico`): la
  spaziatura larga, giusta per un maiuscoletto latino, sfalda una riga di kanji.

### I testi: `guida.md`

**`guida.md` è il tavolo di lavoro, non la sorgente.** Contiene tutte le parole
italiane della guida, divise in blocchi con àncore fra parentesi quadre
(`[intro]`, `[cielo 1]`, `[arco · i dieci tratti]`…). Valerio corregge lì; poi il
testo va riportato a mano nel dizionario dentro `guida.html`, **e nelle altre tre
lingue**, che sono traduzioni dell'italiano. Se i due file divergono, la pagina
non se ne accorge: è l'unico prezzo di questo modo di lavorare, ed è lo stesso
di Rada2 (`testi-guida.md`).

Due cose da ricordare quando si riporta un testo:

- le voci segnate «anche nell'interfaccia» — nomi dei comandi, dei dieci tratti,
  dei quattro strumenti, la firma — vivono **anche in `index.html`**: vanno
  cambiate in tutt'e due i dizionari, o il pannello e la guida si contraddicono;
- il risalto: i paragrafi di prosa della guida usano `data-i18n-html`, quindi
  `**grassetto**` diventa `<strong>` e `*corsivo*` diventa `<em>`. Le etichette
  brevi restano `data-i18n` (testo semplice). In giapponese il corsivo non si
  applica: i titoli d'opera prendono le 《》, e infatti *In C* è in corsivo in
  italiano, francese e inglese ma sta fra 《》 in giapponese.

### La guida (`guida.html`)

Pagina a sé, stessa testata e stesso linguaggio visivo dello strumento. Sei sezioni:
cos'è, il cielo, il suono, l'arco (con i dieci tratti e una glossa ciascuno), gli
strumenti, i comandi (tutti e diciassette, con una riga di spiegazione), i crediti.
Gli elenchi sono costruiti in JS dai dizionari, così un comando nuovo si aggiunge in un
posto solo. Il maiuscoletto tecnico sta sul termine (`dt`), **mai sulla glossa** (`dd`):
una spiegazione in maiuscoletto spaziato non si legge.

## Come sviluppare / verificare

- Aprire `index.html` in un browser moderno (nessun server necessario). La guida è
  `guida.html`, e i due collegamenti si passano la lingua nell'indirizzo.
- Per verifiche automatiche dei fotogrammi si è usato Playwright headless con lo
  Chromium di sistema (screenshot a tempi diversi, click sugli swatch, set dei valori
  degli slider via `dispatchEvent('input')`).

## Stato attuale — Modulo 2: il suono (prima versione funzionante)

Sulla scia di **In C** di Terry Riley: un archivio di frasi brevi in Do che più voci
leggono ciascuna per conto proprio, sopra un polso condiviso.

- `FRASI` — **archivio originale di 53 frasi in Do**, `[semitoni da Do, durata in
  battiti]`, `null` = silenzio. **Non sono le cellule di Riley** (opera del 1964 sotto
  diritto d'autore): è materiale nuovo che ne adotta il principio.

### L'arco e le cerniere (rifatto — leggere prima di toccare le frasi)

Più voci suonano insieme frasi diverse e vicine. Se due regioni confinanti contengono lo
stesso grado in due forme — **Fa/Fa#, Mi/Mib, Si/Sib, La/Sib, Re/Mib** — quelle forme
finiscono per sovrapporsi e l'insieme suona stonato. Era il difetto della prima stesura:
misurato, il primo scontro cadeva nella finestra 17-21 (Fa contro Fa#), poi di nuovo dalla
33 in avanti. Ora fra una regione e l'altra c'è una **cerniera di quattro frasi** costruita
sui soli suoni comuni, dove il grado vecchio si ritira prima che entri il nuovo:

|  |  |  |  |
|---|---|---|---|
| 1-6 | Do puro | *Sereno* | Do Mi Sol |
| 7-13 | pentatonica | *Cirri* | + Re La |
| 14-18 | il Fa | *Velo* | Do Mi Fa Sol La |
| **19-22** | **cerniera** | *Radura* | il Fa si ritira |
| 23-29 | Fa# lidio | *Controluce* | Do Re Mi Fa# Sol La |
| 30-34 | dominante | *Corrente* | entra il Si |
| **35-38** | **cerniera** | *Vuoto d'aria* | la quinta vuota: solo Do e Sol |
| 39-45 | l'ombra | *Nembo* | Do Mib Fa Sol Sib |
| **46-49** | **cerniera** | *Schiarita* | l'ombra si ritira: Do Fa Sol |
| 50-53 | rientro | *Zenit* | tornano Mi e Si; la 53 chiude su un Do lungo |

I nomi in corsivo sono quelli mostrati nel quadrante (`REGIONI`): dicono il cielo e non
l'armonia, perché chi ascolta non ha bisogno di sapere che è entrato il Fa#, ha bisogno
di sapere che la luce è cambiata. La corrispondenza con i tratti armonici è annotata
riga per riga nel codice.

Il fronte torna poi alla 1: l'arco si richiude dove è cominciato.

**Garanzia verificata**: nessuno scontro cromatico in alcuna finestra di **5 frasi**
consecutive, giro di boa 53→1 compreso. Si considerano ammessi i tre semitoni idiomatici
Si-Do (sensibile), Mi-Fa (diatonici) e Fa#-Sol (lidio); ogni altro semitono è uno scontro.
Oltre le 5 frasi l'archivio torna a sporcarsi — per questo la corsa di *Dispersione* si
ferma a 4. **Se si cambia anche una sola frase, ri-verificare** l'intero archivio a
finestra scorrevole prima di considerare il lavoro finito.
- `Suono` — motore Web Audio, nessuna libreria, nessun file esterno (anche il riverbero
  è una risposta all'impulso generata a runtime).
- `STRUMENTI` — **quattro timbri**, ognuno costruisce i propri nodi e li attacca a
  `v.uscita` (da lì panorama e riverbero sono già a posto). `Suono.nota` calcola solo
  altezza, durata e ampiezza, poi passa la mano allo strumento della voce.
  - **Onda** — il timbro d'origine: onda semplice + ottava sopra, attacco morbido, coda
    lunga. È il fondo su cui stanno gli altri tre.
  - **Vetro** — glockenspiel, sulla ricetta della «goccia» di Rada (`rada2/js/audio.js`):
    FM con portante sinusoidale e modulante a rapporto 3, più un parziale a 2.01×
    scordato dell'1% che dà un battimento lento. Il metallo sta nell'**indice di
    modulazione che decade**: 1.2 al colpo, poi si schiarisce in 0,22 s in una sinusoide
    che continua a suonare. Suona un'ottava sopra, come lo strumento vero — la classe
    d'altezza non cambia, la garanzia dell'archivio resta intatta.
  - **Legno** — battente su barra di marimba: fondamentale sinusoidale a spegnimento
    rapido, primo parziale a 4× (due ottave sopra: è così che si accordano le barre) che
    se ne va ancora prima, e un colpo di rumore scuro di 30 ms per il contatto del
    battente. Sostituisce il pizzicato *Corda* della prima stesura, che non convinceva:
    stessa famiglia percussiva del Vetro, colore opposto.
  - **Soffio** — soffio: rumore bianco in un passa-banda stretto (Q 13) sulla nota, più
    una sinusoide che le dà l'intonazione; attacco lento, vibrato appena accennato.
  La differenza fra i quattro sta quasi tutta **nella forma dell'inviluppo**, non nella
  forma d'onda: è l'attacco a dire che strumento è.
- **Taratura misurata** in `OfflineAudioContext` sulla stessa nota. I picchi sono
  allineati a 0,131–0,139 (Onda 0.137 · Vetro 0.139 · Legno 0.138 · Soffio 0.131): i
  fattori di ampiezza nel codice vengono da lì, non a occhio, e se si tocca un inviluppo
  vanno **ri-misurati**. Le altre due misure dicono il carattere, e vanno lasciate
  diverse:
  - *coda* (fino a −60 dB): Legno 0,56 s · Vetro 1,13 · Soffio 1,23 · Onda 1,42;
  - *brillantezza* (energia sopra i 2 kHz nei primi 170 ms): Vetro 8,8% · Legno 0,3% ·
    Onda e Soffio 0%. È la misura con cui è stato scelto l'indice FM del Vetro: 0.3 dava
    1,5% (sordo), 1.8 dava 21% (tagliente con sei voci), 1.2 dà 8,8%.
- **La fila del suono**: sotto la rubrica M2, l'interruttore d'ascolto e i quattro
  quadretti degli strumenti stanno **tutti sulla stessa linea** (`.fila`), l'ascolto a
  sinistra e gli strumenti **giustificati a destra** (`space-between`, più
  `justify-content: flex-end` dentro `.scelta` perché restino a destra anche andando a
  capo). I due poli agli estremi ripetono la struttura di ogni altra riga del pannello —
  nome a sinistra, valore a destra — e bastano a dire che il primo quadretto comanda
  un'altra cosa: il filetto verticale che li separava, con questa disposizione, finiva
  appiccicato al gruppo di destra e sembrava appartenergli, quindi è stato tolto.
  Non c'è etichetta né contatore: i quadretti pieni o vuoti dicono già tutto, e i nomi
  dei due gruppi restano in `aria-label` per chi non vede.

### Lo strumento lo sceglie la nuvola

Non è un sorteggio: è lo **spessore** della nuvola sulla banda a decidere il timbro.
`ORDINE_SPESSORE` dispone i quattro lungo un asse — **Vetro · Legno · Onda · Soffio**,
dal velo sottile alla nuvola piena — e `Suono.spessore(v)` riporta la densità media
della banda a 0..1; il tratto in cui cade sceglie lo strumento. Gli strumenti spenti
escono dall'asse: se ne è acceso uno solo, tutto l'insieme suona con quello; se ne sono
accesi due, la nuvola sceglie fra quei due. L'ultimo acceso non si può spegnere.

- **Estremi 0.05 e 0.85, misurati.** Al risveglio la densità è ben distribuita, perché
  una voce si sveglia solo quando la nuvola è già arrivata: su 79 risvegli ai valori di
  partenza, p05 0.145 · p25 0.234 · p50 0.418 · p75 0.643 · p90 0.852 · max 0.98. Gli
  estremi vengono da quei quartili, perché i quattro tratti risultino ugualmente
  frequentati. **Una prima taratura a 0.10-0.95**, fatta su un solo campione più
  nuvoloso, lasciava Onda e Soffio quasi sempre fuori: il cielo cambia molto nell'arco
  dei minuti, e un campione solo non basta. Se si tocca il cielo, ri-misurare.
- **Uno scarto casuale di ±0.06** sul valore normalizzato: il confine fra due tratti non
  dev'essere una lama, due nuvole quasi identiche non devono dare sempre lo stesso.
- **Quando si ridecide** (in `sveglia`): dopo un silenzio di almeno quattro battiti
  (`v.attesa`), se lo strumento in uso è stato spento dal pannello, oppure se lo spessore
  è cambiato di più di 0.28 rispetto a quello della scelta in corso (`v.spessoreScelta`).
  Le prime due condizioni evitano i cambi «a caldo» — misurato senza: 3 cambi in 26 s con
  la voce che ripartiva dopo 0,7 s, e il timbro saltava a metà del discorso; dopo: zero.
  La terza serve al caso opposto: una nuvola che staziona sulla banda non lascia mai il
  silenzio per ripensarci, e senza di essa il timbro restava quello del primo arrivo
  anche a cielo ormai chiuso (misurato: densità mediana 0.78 e ancora i timbri del velo,
  cioè i timbri del velo).
- **Verifica della corrispondenza**, fatta dove la scelta avviene davvero e non al
  risveglio (dove può essere ereditata): Vetro spessore 0.07-0.24 · Legno 0.34-0.51 ·
  Onda 0.55-0.72 · Soffio 0.75-0.87 — ciascuno dentro il proprio tratto.
- Il **righello delle bande** mostra l'iniziale dello strumento accanto al numero della
  frase (`08 F`), così la corrispondenza nuvola→timbro si legge a occhio.
- **Le nuvole scelgono.** Ogni voce presidia una banda verticale della finestra; quando
  una nuvola vi entra la voce si sveglia, sceglie **a caso** una frase nell'intorno del
  fronte e la ripete; quando la nuvola esce, finisce la lettura e tace. Le bande sono
  attraversate in momenti diversi, quindi le sovrapposizioni non sono scritte da nessuna
  parte.
- **Le regole trattenute da In C**: polso condiviso (le frasi partono su un battito
  ma hanno lunghezze diverse, e quindi sfasano); archivio percorso in avanti senza salti
  (il `fronte` avanza di una frase per volta); libertà di ciascuna voce dentro un intorno
  ristretto del fronte (`AUDIO.finestra = 3`), così l'insieme resta in una stessa regione
  armonica senza mai ripetere la stessa combinazione.
- **Nessuno resta indietro** (`Suono.ritardo`, e i due controlli in `avanzaFronte` e in
  `avanza`). È la disciplina che in *In C* è affidata ai musicisti, e qui è anche ciò che
  rende valida la garanzia dell'archivio: il fronte **aspetta** finché ogni voce che sta
  suonando è al massimo una frase dietro la nuova posizione, e una voce lasciata indietro
  chiude la lettura in corso e ne sceglie una aggiornata. Senza questa regola una voce
  può trascinare una frase di sei posizioni più indietro, e allora nessuna cerniera basta:
  misurato prima di introdurla, 39 scontri su 43.726 coppie simultanee (Fa/Fa# fra le
  frasi 18 e 24, Si/Sib fra la 32 e la 39). Dopo: **zero scontri su 22.480 coppie**, con
  la campata massima fra frasi simultanee pari a 5, cioè esattamente il limite garantito.
  La prova è stata fatta forzando il caso peggiore (8 voci, dispersione 4, fronte ogni
  0,7 s, cielo coperto); ai valori di partenza la campata osservata è 3.
- **Comandi**: vedi la sezione «Pannello» qui sotto. Il contesto audio nasce al primo
  clic sull'interruttore d'ascolto: lo esigono i browser.
- **Il polso udibile è stato rimosso** (agosto 2026), dall'interfaccia e dal codice:
  `AUDIO.polso`, `Suono.avanzaPolso`, `Suono.battuta` e `tPolso` non esistono più. Resta
  il polso *condiviso* — la griglia di battiti su cui tutte le frasi partono — che è
  un'altra cosa e regge l'intero impianto ritmico.

## Il pannello — linguaggio visivo

Rifatto sulle reference visuali fornite da Valerio (cartella `~/Downloads/ioreferences`,
esterna al repo: poster topografici, quadranti HUD, tavole di grafica tecnica, cursori a
pallino su filetto). Il registro è **svizzero-tecnico su carta chiara**:

- tutta la parte tecnica è **monospaziata**, maiuscoletta, 10px, `letter-spacing .16em`
  (classe `.tecnico`); il marchio resta in grottesco spaziato;
- **tutto in bianco sul cielo**, con la gerarchia affidata all'opacità: valori e cifre
  a 1, etichette 0.75, filetti 0.38, separatori interni 0.22. Il contrasto del bianco su
  `#5e9bc9` è ~3:1 — sotto la soglia WCAG per il testo minuto: è una scelta espressiva,
  se servisse più leggibilità basta scurire il celeste (e con esso `PARAMS.celeste`);
- **filetti** da 1px al posto di riquadri e ombre: testata, rubriche di
  sezione con codice a destra (`M1`, `M2`), separatori del quadrante;
- **due strumenti diversi, in due file distinte per sezione**:
  - **quadranti ad arco** (`Pannello.arco`) per i sei comandi principali — *Cielo sereno*
    e *Vento* nel Cielo, *Volume*, *Riverbero*, *Voci* e *Sensibilità* nel Suono: arco di
    tacche, pallino pieno che corre dentro l'arco, e sotto la targa con nome minuto e
    valore grande. Geometria: centro (70,70), arco da 195° a −15°, tacche fra r=58 e
    r=66, pallino su r=46, `viewBox 0 0 140 92`. Se la corsa è breve (≤12 scatti) c'è
    **una tacca per scatto** — la *Voci* ne ha dieci, e si legge a colpo d'occhio;
    altrimenti ventiquattro intervalli.
  - **cursori a filetto** per i comandi secondari: traccia da 1px con tacche ogni 10%
    e pallino pieno bianco da 9px; nessun riempimento della parte percorsa.
    **La linea e le tacche sono sfondi dell'`input` stesso** (due gradienti nella
    proprietà `background`), come in Rada e Rada2 — non pseudo-elementi disegnati
    sopra. È una scelta di funzionamento, non di stile: `::after` in `position:
    absolute` sul contenitore viene dipinto *dopo* il contenuto e copre la metà
    inferiore del comando, pallino compreso, intercettando il puntatore. Con quella
    stesura `elementFromPoint` non trovava più l'input da metà altezza in giù, e il
    cursore rispondeva solo se colpito negli 8 px superiori (era il difetto segnalato
    da Valerio: «se tocco il pallino non prende bene il comando»). **Non disegnare mai
    nulla sopra un input di comando.**
- **interruttori**: quadretto 9px vuoto/pieno + stato a parole (`SILENZIO`/`ASCOLTO`,
  `VISIBILI`/`NASCOSTE`). Nessuno di loro porta più una parola di contorno: la parola di
  stato **è** il valore, e una seconda dicitura accanto direbbe due volte la stessa cosa
  (sono cadute così «fermo/attivo» sull'ascolto e «righello» sulle bande).
  Quello d'ascolto è **senza etichetta**: solo il quadretto e la parola di stato, perché
  è il comando che non ha bisogno di essere nominato. Il nome resta però in
  `aria-label` (`data-i18n-aria="c.ascolto"`), che con `aria-pressed` è la forma giusta
  per un interruttore: il nome dice che cos'è, lo stato lo dice l'attributo;
- **quadrante dei dati**: cifre grandi tabellari con didascalia minuta sotto — frase
  dell'insieme, voci in ascolto, regione dell'arco;
- **firma in fondo**, copiata da Rada (`.firma` in `rada2/css/style.css`): un filetto,
  il credito in grottesco — non in monospaziato, perché non fa parte dello strumento e
  si deve vedere — e sotto i recapiti separati da un filetto verticale, che sparisce
  sotto i 480px lasciandoli impilati. **L'indirizzo di posta non è un collegamento**, e
  per la stessa ragione di Rada: un `mailto:` che contenga «[at]» aprirebbe una bozza
  verso un destinatario inesistente. Va ricomposto a mano, ed è il prezzo di non darlo
  in pasto ai raccoglitori di indirizzi. Il testo del credito è la stringa `foot.credits`
  di Rada, nelle stesse quattro lingue. **La stessa firma chiude anche la guida**; là il
  paragrafo dei crediti è stato alleggerito della paternità («Nuvole è un progetto di
  Valerio Belloni») e tenuto ai soli fatti tecnici — licenza, nessuna libreria, nessun
  campione — perché a dire di chi è il progetto ora ci pensa la firma, e dirlo due volte
  a tre righe di distanza si notava.
- **righello delle bande** sotto la finestra: una casella per voce, il numero della frase
  che sta leggendo, e un filetto nero che si accende quando la nuvola è sulla sua banda.
  È il riscontro visivo del legame nuvola→voce (era fra i «prossimi passi»).

## Comandi del pannello

Ognuno scrive in `PARAMS` (cielo) o in `AUDIO` (suono); `Pannello` non conosce né il
rendering né lo scheduler. Le tre funzioni `Pannello.cursore(id, applica)`,
`Pannello.interruttore(id, acceso, etichette, applica)` e `Pannello.arco(id)` fanno tutto
il cablaggio: l'etichetta del valore è cercata per convenzione in `val<Id>`, il disco
dell'arco in `disco<Id>`.

**Come funziona l'arco.** Sotto il disegno resta un `input[type=range]` nativo, celato
(1px, opacità 0) ma **non rimosso**: è lui a tenere il valore e a portare tastiera e
accessibilità, e `cursore()` non sa nemmeno che esista un arco sopra di sé. L'SVG traduce
il puntatore in angolo e l'angolo in valore, poi scrive nell'input ed emette `input`;
l'input, a sua volta, ridisegna il pallino. Chi aggiunge un arco a un comando esistente
deve solo: dare all'input la classe `celato`, mettergli accanto un `<div class="disco"
id="disco<Id>">`, e aggiungere l'id all'elenco in `Pannello.init`. Due dettagli non
ovvi: sotto l'arco c'è un **settore morto di 150°** e il puntatore che ci finisce va al
capo più vicino; e il valore si applica **prima** di `setPointerCapture`, che su certi
puntatori può fallire — se fallisse dopo, il clic andrebbe perso.

| Comando | Parametro | Corsa | Nota |
|---|---|---|---|
| Cielo sereno | `PARAMS.soglia` | 0.10–0.21 | è anche il comando del silenzio |
| Vento | `PARAMS.ventoX` | 0–2.5 | `ventoY = ventoX * 0.18` |
| Grana | `PARAMS.passo` | 5–20 px | chiama `Cielo.resize()`; `fattoreGriglia()` tiene ferme le nuvole |
| Ampiezza nuvole | `PARAMS.scalaForma` | 0.115–0.035 | `scalaMassa` segue (×0.267) |
| Muta | `PARAMS.morphMassa` | 0–0.030 | quanto in fretta muta la copertura |
| Bande | — | — | mostra/nasconde il righello; sta tutto su una riga (`.controllo.linea`), nome a sinistra e interruttore a destra |
| Ascolto | `Suono.avvia/ferma` | — | il solo quadretto con `SILENZIO`/`ASCOLTO`; dissolvenza di 1.2–1.5 s |
| Strumenti | `AUDIO.strumenti` | 4 quadretti | uno solo, o più d'uno e allora si sorteggia |
| Volume | `AUDIO.volume` | 0–1 | |
| Riverbero | `AUDIO.riverbero` | 0–1 | mandata al convolutore |
| Respiro | `AUDIO.respiro` | 0.4–2.6 | moltiplica attacchi e code di tutti gli strumenti; corsa esponenziale, a metà vale 1 |
| Voci | `AUDIO.voci` | 1–10 | `Suono.impostaVoci()` ricostruisce bande e righello |
| Sensibilità | `AUDIO.entra` | 0.28–0.03 | `esce = entra * 0.4` |
| Dispersione | `AUDIO.finestra` | 1–4 frasi | quanto le voci possono allontanarsi dal fronte; **non allargare** oltre 4 senza rifare le cerniere |
| Avanzamento | `AUDIO.attesaFronte` | 60–3.6 s | corsa esponenziale, `60·0.06^v` |
| Registro | `AUDIO.registro` | ±12 st | trasporto d'insieme |

**Il tempo non è più un comando**: `AUDIO.bpm` è **fisso a 44** (battito di 1,36 s).
Il quadrante che lo regolava è stato dato al *Riverbero*, che era un cursore a filetto;
il posto lasciato libero da quel cursore è ancora vuoto. Il punto che respira accanto al
marchio dura quattro battiti, cioè 5,45 s: è ora scritto in chiaro nel CSS, non più
calcolato dal pannello.

Due avvertenze emerse provando:

- **Non allargare la corsa di *Ampiezza nuvole***. Oltre `scalaForma ≈ 0.035` la nuvola
  diventa più grande della finestra: il campo resta uniforme, il cielo non si copre mai
  e l'insieme ammutolisce. La corsa attuale si ferma lì apposta.
- **Grana a 5px su schermo largo** fa ~23.000 puntini: misurati 8,9 ms per fotogramma
  (contro 2,1 ms alla grana di partenza). Sta dentro i 60 fps ma è il limite; se serve
  altro margine, il costo è tutto in `Cielo.render`.

### Taratura del legame cielo→suono (misurata, non a occhio)

`Suono.aggiornaDensita` ricava due misure per banda: **copertura** (frazione di punti con
`densita > 0.5`) e **densita** media. La *copertura* è il segnale di attacco/congedo; la
*media* governa dinamica e apertura del filtro. Perché la copertura: la media di una banda
alta e stretta resta sempre bassa (misurata: p50 0.04–0.20, max 0.38), e il massimo satura
a 1 appena un punto entra in una nuvola. La copertura invece si distribuisce bene
(p50 0–0.19, picchi 0.47). Soglie: `entra 0.12`, `esce 0.05`.

**Conseguenza voluta**: *Cielo sereno* è anche il comando del silenzio. Cielo limpido =
poche voci o nessuna; cielo coperto = insieme fitto. Il valore di partenza dello slider è
stato portato da 45% a 30% perché a 45% il cielo resta a lungo vuoto e l'app tace.
Misurato a 30%: in 35 s tutte e sei le voci hanno suonato, cinque frasi diverse, fino a
sei note simultanee, ~5 note al secondo, 60 fps stabili.

## Prossimi passi possibili (da discutere con Valerio)

### Comandi proposti, in attesa (agosto 2026)

Quattro possibilità nate quando il cursore del *Riverbero* è passato a quadrante e ha
lasciato un posto libero. **Il primo è stato fatto** (*Respiro*); gli altri tre restano
qui, scelti e non scartati:

- **Apertura** — l'ampiezza dei registri fra le voci. Oggi sono fissi
  (`[-12, 0, 12, 0, -12, 12]`, ciclati): il comando andrebbe da tutte le voci nella
  stessa ottava — insieme stretto, quasi un coro — fino a quattro ottave, con i gravi
  sotto e gli acuti in cima. Stretto si sentono gli attriti, largo si sente lo spazio.
- **Insistenza** — quante volte una voce ripete la frase prima di lasciarla
  (`AUDIO.lettureMin/Max`, oggi 2–5). Da «una o due volte», insieme inquieto, a
  «sei-dieci», con l'armonia che si deposita. È il comando più vicino allo spirito di
  *In C*, dove quanto restare su una cellula è la sola vera decisione dell'esecutore.
- **Scordatura** — un lievissimo disaccordo fra le voci, da zero a pochi centesimi di
  semitono: non stona, produce battimenti lenti fra note uguali suonate da voci diverse
  (l'effetto che in Rada fa il parziale a 2,01×). A cielo coperto sarebbe il più
  suggestivo dei tre, ma su una nota sola non si sente.

Altre due, viste e messe da parte: **larghezza stereo** (da mono al panorama pieno) e
**colore** (apertura globale del passa-basso).

## Prossimi passi possibili (da discutere con Valerio)

- **Timbro**: i quattro strumenti sono a posto, ma non c'è alcun comando che li plasmi
  oltre a *Respiro*.
- **Memoria dei comandi**: nessuna persistenza. Un `localStorage` conserverebbe la
  regolazione fra una visita e l'altra.
- **Ricarica e stato degli slider**: il browser ripristina i valori dei cursori al
  ricaricamento, che possono non corrispondere ai valori scritti in `PARAMS`/`AUDIO`.
  In pagina non è un problema (il pannello applica ciò che legge all'avvio), ma in prova
  conviene ricordarlo.

> Nota: registro linguistico di Valerio = italiano, ambito artistico/curatoriale;
> cura la qualità della scrittura anche nei testi di progetto (README compreso).
