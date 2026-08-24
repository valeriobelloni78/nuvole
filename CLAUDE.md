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
  riquadro della pagina; il marchio *Nuvole* è allineato a sinistra sopra il vetro
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
- **Vento a fase accumulata**: la deriva usa `phaseX/phaseY` accumulate per frame
  (`+= vento * dt`), non il tempo assoluto. Così cambiare la velocità muta il *ritmo*
  e non fa **saltare** le nuvole di posizione. Il `dt` è clampato per la tab in background.
- **Slider "Cielo sereno"** mappa su `PARAMS.soglia` (range ~0.10–0.21); **"Vento"** su
  `PARAMS.ventoX` (0–2.5) con `ventoY = ventoX * 0.18`.

## Come sviluppare / verificare

- Aprire `index.html` in un browser moderno (nessun server necessario).
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

|  |  |  |
|---|---|---|
| 1-6 | Do puro | Do Mi Sol |
| 7-13 | pentatonica | + Re La |
| 14-18 | il Fa | Do Mi Fa Sol La |
| **19-22** | **cerniera** | il Fa si ritira |
| 23-29 | Fa# lidio | Do Re Mi Fa# Sol La |
| 30-34 | dominante | entra il Si |
| **35-38** | **cerniera** | la quinta vuota: solo Do e Sol |
| 39-45 | l'ombra | Do Mib Fa Sol Sib |
| **46-49** | **cerniera** | l'ombra si ritira: Do Fa Sol |
| 50-53 | rientro | tornano Mi e Si; la 53 chiude su un Do lungo |

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
  - **Vetro** — campana: parziali inarmoniche 1 : 2.76 : 5.40 (proporzioni delle campane
    tubolari), attacco istantaneo, nessuna tenuta, code di durata diversa per parziale.
  - **Corda** — pizzicato: dente di sega con il filtro che si chiude in 0,32 s; è la
    chiusura del filtro, più della coda, a dare il colpo dell'unghia.
  - **Fiato** — soffio: rumore bianco in un passa-banda stretto (Q 13) sulla nota, più
    una sinusoide che le dà l'intonazione; attacco lento, vibrato appena accennato.
  La differenza fra i quattro sta quasi tutta **nella forma dell'inviluppo**, non nella
  forma d'onda: è l'attacco a dire che strumento è.
- **Taratura delle ampiezze, misurata** in `OfflineAudioContext` sulla stessa nota:
  i picchi sono allineati a 0,130–0,141 (Onda 0.137 · Vetro 0.141 · Corda 0.136 ·
  Fiato 0.130). L'energia sul primo secondo resta invece diversa a coppie — sostenuti
  0,085 e 0,073, percussivi 0,025 e 0,017 — ed è giusto così: è la loro natura.
  Se si tocca un inviluppo, **ri-misurare**: i fattori nel codice (0.72 · 0.85 · 1.90)
  vengono da lì, non a occhio.
### Lo strumento lo sceglie la nuvola

Non è un sorteggio: è lo **spessore** della nuvola sulla banda a decidere il timbro.
`ORDINE_SPESSORE` dispone i quattro lungo un asse — **Vetro · Corda · Onda · Fiato**,
dal velo sottile alla nuvola piena — e `Suono.spessore(v)` riporta la densità media
della banda a 0..1; il tratto in cui cade sceglie lo strumento. Gli strumenti spenti
escono dall'asse: se ne è acceso uno solo, tutto l'insieme suona con quello; se ne sono
accesi due, la nuvola sceglie fra quei due. L'ultimo acceso non si può spegnere.

- **Estremi 0.05 e 0.85, misurati.** Al risveglio la densità è ben distribuita, perché
  una voce si sveglia solo quando la nuvola è già arrivata: su 79 risvegli ai valori di
  partenza, p05 0.145 · p25 0.234 · p50 0.418 · p75 0.643 · p90 0.852 · max 0.98. Gli
  estremi vengono da quei quartili, perché i quattro tratti risultino ugualmente
  frequentati. **Una prima taratura a 0.10-0.95**, fatta su un solo campione più
  nuvoloso, lasciava Onda e Fiato quasi sempre fuori: il cielo cambia molto nell'arco
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
  anche a cielo ormai chiuso (misurato: densità mediana 0.78 e ancora Vetro e Corda,
  cioè i timbri del velo).
- **Verifica della corrispondenza**, fatta dove la scelta avviene davvero e non al
  risveglio (dove può essere ereditata): Vetro spessore 0.12-0.24 · Corda 0.45 ·
  Onda 0.57-0.69 · Fiato 0.85-0.92 — ciascuno dentro il proprio tratto.
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
    e *Vento* nel Cielo, *Volume*, *Tempo*, *Voci* e *Sensibilità* nel Suono: arco di
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
- **interruttori**: quadretto 9px vuoto/pieno + stato a parole (`SILENZIO`/`IN ASCOLTO`);
- **quadrante dei dati**: cifre grandi tabellari con didascalia minuta sotto — frase
  dell'insieme, voci in ascolto, regione dell'arco;
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
| Bande | — | — | mostra/nasconde il righello |
| Ascolto | `Suono.avvia/ferma` | — | dissolvenza di 1.2–1.5 s |
| Polso udibile | `AUDIO.polso` | — | il Do acuto sulla griglia comune |
| Strumenti | `AUDIO.strumenti` | 4 quadretti | uno solo, o più d'uno e allora si sorteggia |
| Volume | `AUDIO.volume` | 0–1 | |
| Tempo | `AUDIO.bpm` | 44–132 | |
| Voci | `AUDIO.voci` | 1–10 | `Suono.impostaVoci()` ricostruisce bande e righello |
| Sensibilità | `AUDIO.entra` | 0.28–0.03 | `esce = entra * 0.4` |
| Dispersione | `AUDIO.finestra` | 1–4 frasi | quanto le voci possono allontanarsi dal fronte; **non allargare** oltre 4 senza rifare le cerniere |
| Avanzamento | `AUDIO.attesaFronte` | 60–3.6 s | corsa esponenziale, `60·0.06^v` |
| Riverbero | `AUDIO.riverbero` | 0–1 | mandata al convolutore |
| Registro | `AUDIO.registro` | ±12 st | trasporto d'insieme |

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

- **Timbro**: è il punto più debole. Oggi: oscillatore (seno/triangolo) + ottava sopra
  appena percettibile, passa-basso, riverbero a convoluzione. Non c'è alcun comando di
  timbro nel pannello ed è probabilmente il prossimo da inventare.
- **Registri delle voci**: oggi fissi (`[-12, 0, 12, 0, -12, 12]`, ciclati). Si potrebbe
  legarli alla banda (grave a sinistra, acuto a destra) o renderli mobili.
- **Memoria dei comandi**: nessuna persistenza. Un `localStorage` conserverebbe la
  regolazione fra una visita e l'altra.
- **Ricarica e stato degli slider**: il browser ripristina i valori dei cursori al
  ricaricamento, che possono non corrispondere ai valori scritti in `PARAMS`/`AUDIO`.
  In pagina non è un problema (il pannello applica ciò che legge all'avvio), ma in prova
  conviene ricordarlo.

> Nota: registro linguistico di Valerio = italiano, ambito artistico/curatoriale;
> cura la qualità della scrittura anche nei testi di progetto (README compreso).
