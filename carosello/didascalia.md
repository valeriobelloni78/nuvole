# Carosello Instagram — Nuvole

Quattro tavole 1080×1350 (4:5, il formato che occupa più schermo nel feed).
Le immagini sono `nuvole-1.png` … `nuvole-4.png`, da caricare **in quest'ordine**.

Due soli registri, e nessuna mescolanza fra i due: la **prima tavola è
un'immagine sola** — un rettangolo di nuvole in 4:5, cioè esattamente la
proporzione della tavola — e le **altre tre sono testo solo**, bianco, centrato
nel cielo. Niente marchio, niente numerazione, niente piede: la prima tavola
guarda, le altre parlano.

---

## Come il testo è diviso

| tavola | contenuto |
|---|---|
| 1 | la finestra: solo nuvole (cielo con seme 487) |
| 2 | il *Cloudspotting* · guardare le nuvole · il nimbologo di Fosco Maraini |
| 3 | l'esperto della distrazione · la finestra-spartito · che cos'è *Nuvole* |
| 4 | il contrappunto delle nuvole · la chiusa |

Le tre tavole di testo sono equilibrate a occhio e a conteggio — 563, 477 e 418
battute — e il corpo cresce man mano che il testo si accorcia (34, 35, 36 px),
così l'ultima pagina, che porta la chiusa, è anche la più larga di respiro.
L'ultima frase è la stessa che si legge sulla soglia dell'app: il carosello
finisce dove il sito comincia.

---

## Didascalia del post

Da incollare così com'è (è il testo intero, per chi legge senza sfogliare).

> Ho sviluppato questo sistema sonoro partendo da una pratica molto nota ai
> distratti e a tutti quelli che vivono «con la testa tra le nuvole»: la pratica
> del Cloudspotting.
>
> Guardare le nuvole, indugiare con lo sguardo in alto, verso elevazioni meno
> moderate dei soliti pensieri, in cerca di compagnia tra le soffici distese di
> vapori.
>
> Il nimbologo (come lo chiamava Fosco Maraini) è il nomade di spirito che adora
> perdersi tra le cremose correnti dell'arco celeste, in cerca di nulla se non
> lasciare che i moti dell'animo vengano accarezzati da lontani arcipelaghi
> bianchi.
>
> Ritenendomi esperto (se non altro per il conteggio dei pomeriggi passati ad
> affinare questa antica arte della distrazione) ho deciso di associare delle
> frasi musicali a questo lento gioco di vapori. Ho immaginato lo sguardo al
> cielo delimitato dalla cornice di una finestra e ho associato il movimento
> delle nuvole allo scorrere di uno spartito, e da questa idea è nata «Nuvole».
>
> «Nuvole» è uno spartito che evolve e cambia sempre, proprio come il cielo
> fuori dalla nostra finestra preferita.
>
> Le nuvole creano percorsi sempre diversi e anche i nostri stati d'animo
> cambiano con il loro scorrere, come isole di un mare calmo ci trasmettono un
> contrappunto lento e sontuoso fatto di modulazioni sentimentali profonde e
> armoniche, il loro divenire è una progressione continua ma impercettibile.
>
> Per quanto osservandole cerchiamo di coglierne la forma, loro sfuggono fluide
> e un istante dopo sono già qualcos'altro.

---

## I quattro ritocchi fatti al testo

Minimi, e tutti reversibili in `genera.html` (array `TAVOLE`) e qui sopra.

1. `…vivono "con la testa tra le nuvole" la pratica del Cloudspotting` → **due punti**
   dopo la virgolettatura. Senza, la frase inciampa.
2. `…lasciare che  moti dell'animo` → `…lasciare che **i** moti dell'animo`. Nel
   testo c'erano due spazi al posto dell'articolo.
3. Virgolette all'italiana **« »** al posto delle dritte, e apostrofo tipografico **’**
   al posto di quello dritto.
4. `…allo scorrere di uno spartito e da questa idea è nata` → **virgola** prima di
   «e da questa idea», che chiude il periodo lungo.

Il resto è parola per parola come l'hai scritto.

---

## La tavola della finestra

Il vetro è **1000×1250**: 4:5 al pixel come la tavola che lo contiene. I margini
perciò non sono uniformi — 40 px di fianco, 50 sopra e sotto — proprio perché la
proporzione sia quella e non le somigli soltanto. Resta il contorno bianco
finissimo dell'app: senza, non sarebbe più una finestra ma una fotografia.

Il **seme 487** non è scelto a occhio. Su 600 semi sono stati misurati, alla
geometria di questa tavola, copertura e distribuzione in nove settori: tengono
solo quelli con copertura fra il 26 e il 38 per cento — sotto esce un cielo quasi
vuoto, sopra un muro bianco — e con nuvola presente in **tutti e nove** i
settori, perché su un'immagine grande così un cielo tutto da una parte si legge
come un errore. Ne sono rimasti quattro: 487, 52, 135, 512. Guardati tutti, è il
487 ad avere masse distinte e cielo aperto fra l'una e l'altra; gli altri
riempiono troppo, e da nuvole diventano retinatura.

È lo stesso numero di `?cielo=` nell'app: quel cielo si rivede aprendo
`index.html?cielo=487`.

---

## Rifare le immagini

```
./scatta.sh
```

Serve Google Chrome. Per provare un altro cielo senza toccare il file basta
aprire `genera.html?n=1&seme=135` nel browser; quando uno convince, si scrive il
numero in `TAVOLE[0]`.

**Il campo-nuvole in `genera.html` è copiato di peso da `index.html`**: se si
tocca il campo nell'app, questo file va riallineato, altrimenti l'immagine
mostra un cielo che non esiste più.
