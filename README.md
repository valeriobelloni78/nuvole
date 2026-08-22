# Nuvole

*Nuvole* è una web-app di musica generativa che gira interamente nel browser, nella scia di **Rada** ma con un motore audio, un'interfaccia e un insieme di funzioni nuovi.

Questo repository contiene il **primo modulo — il cielo**: una matrice rettangolare di puntini celesti che riempie lo schermo come la trama di una finestra. Attraverso questa matrice si formano e derivano lentamente delle nuvole, rese dal passaggio cromatico dei puntini dall'azzurro al bianco. Il motore sonoro verrà innestato su questo stesso campo in una fase successiva: la densità delle nuvole che attraversano la finestra è pensata per diventare la sorgente degli eventi generativi.

## Come funziona

Il cielo non è una sequenza di nuvole pre-disegnate ma un **campo continuo di rumore** (`fBm`, moto browniano frazionario) campionato in ogni punto della matrice. Un termine di deriva sposta il campo nel tempo — il *vento* — mentre una seconda scala, più lenta, decide dove il cielo si addensa e dove resta sereno. Le nuvole così non si ripetono mai: nascono, attraversano e si sciolgono ai bordi.

Ogni puntino interpola il proprio colore fra il celeste del sereno e il bianco della nuvola in funzione della densità locale; nei nuclei più densi il puntino cresce e si accende di un lieve alone.

## Parametri

Tutti i parametri di resa e di comportamento sono raccolti nell'oggetto `PARAMS` in cima allo script, così da poter regolare in un solo punto la grana della matrice, la palette, la velocità del vento e la copertura del cielo.

## Uso

Nessuna dipendenza, nessun build. Basta aprire `index.html` in un browser moderno, oppure pubblicarlo su GitHub Pages.

## Licenza

MIT — vedi il file [LICENSE](LICENSE).
