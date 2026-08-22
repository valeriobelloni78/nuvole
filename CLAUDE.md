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


- **Finestra** senza cornice, in una stanza dal fondo grigio chiarissimo (`#f2f2f0`),
  con il marchio *Nuvole* allineato a sinistra sopra il vetro; la superficie della
  finestra è una matrice fitta di puntini celesti (canvas 2D, responsive: la finestra
  segue la larghezza del contenitore `.stanza`, max 960px).
- **Nessun fondo**: il canvas è trasparente, i puntini stanno direttamente sulla
  stanza chiara. Niente palette: un solo cielo.
- **Campo-nuvole** a deriva animata: le nuvole si formano, attraversano e si sciolgono.
  I puntini interpolano il colore da celeste (sereno) a bianco (nuvola) in base alla
  densità locale e insieme **si assottigliano** (`raggioBase` 1.25 → `raggioNuvola` 0.7):
  senza fondo, sul grigio chiaro della stanza, la nuvola è una **dissolvenza** — la
  matrice si dirada e svanisce dove la nuvola passa. Scelta voluta da Valerio, contro
  l'alternativa (nuvola come addensarsi in blu profondo). L'alone (`glow`) è spento:
  un bagliore bianco su fondo chiaro non aggiunge nulla.
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
  diritto d'autore): è materiale nuovo che ne adotta il principio. Arco in sette
  regioni: Do puro (1-6), pentatonica (7-13), Fa (14-20), Fa# lidio (21-28), dominante
  (29-36), ombra di Mib/Sib (37-44), rientro Si→Do (45-53). La 53 chiude su un Do lungo
  e il fronte torna alla 1: l'arco si richiude dove è cominciato.
- `Suono` — motore Web Audio, nessuna libreria, nessun file esterno (anche il riverbero
  è una risposta all'impulso generata a runtime).
- **Le nuvole scelgono.** Ogni voce presidia una banda verticale della finestra; quando
  una nuvola vi entra la voce si sveglia, sceglie **a caso** una frase nell'intorno del
  fronte e la ripete; quando la nuvola esce, finisce la lettura e tace. Le bande sono
  attraversate in momenti diversi, quindi le sovrapposizioni non sono scritte da nessuna
  parte.
- **Le tre regole trattenute da In C**: polso condiviso (le frasi partono su un battito
  ma hanno lunghezze diverse, e quindi sfasano); archivio percorso in avanti senza salti
  (il `fronte` avanza di una frase per volta); libertà di ciascuna voce dentro un intorno
  ristretto del fronte (`AUDIO.finestra = 3`), così l'insieme resta in una stessa regione
  armonica senza mai ripetere la stessa combinazione.
- **Comandi aggiunti**: *Suono* (interruttore d'ascolto — il contesto audio nasce al
  primo clic, lo esigono i browser; l'etichetta mostra il fronte, «frase n/53») e
  *Volume*.

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

- Timbro: al momento è un oscillatore (seno/triangolo) + un'ottava sopra appena
  percettibile, filtro passa-basso, riverbero a convoluzione. C'è molto da guadagnare qui.
- Riscontro visivo: far vedere quale banda sta suonando (per ora la corrispondenza
  nuvola→voce si intuisce solo dal panorama stereo, che segue la banda).
- Tempo (`AUDIO.bpm`, ora 88) e numero di voci (`AUDIO.voci`, ora 6) non sono esposti
  nel pannello: valutare se meritano un comando.

> Nota: registro linguistico di Valerio = italiano, ambito artistico/curatoriale;
> cura la qualità della scrittura anche nei testi di progetto (README compreso).
