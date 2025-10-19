Scalare lo schermo del mio Macbook pro 2015 con Linux sopra

Racconto di un andirivieni con configurazioni di Linux e Claude AI

Qualche mese fa ho comprato dalla mia azienda un Macbook Pro del 2015 nonostante sapessi che sarebbe arrivato senza sistema operativo installato. Ci ho installato MX Linux e da allora le cose sono andate sorprendentemente bene, eccetto una: testo, immagini e icone erano troppo piccoli e ho quindi dovuto scalare tutto il sistema operativo di 2x. Funziona decentemente, ma essendo solo un novellino di Linux sono sicuro che si possa fare di meglio. (O forse mi da solo fastidio che certe applicazioni non renderizzino correttamente certi elementi!!)

Una sera dopo qualche giorno di malattia inizio a leggere la pagina arch wiki su [HiDPI e X Server](https://wiki.archlinux.org/title/HiDPI#X_Server) e dopo qualche paragrafo penso già di essere sulla strada giusta: il mio portatile è impostato con il numero di <abbr>DPI</abbr> (Dots Per Inch) sbagliato. I display HiDPI (o Retina) hanno bisogno di 192 DPI. Vengo a conoscenza del fatto che il mio schermo è impostato a 96 DPI dato che il comando `xdpyinfo | grep -B 2 resolution` mi restituisce:

```txt
screen #0:
  dimensions:    1920x1200 pixels (508x317 millimeters)
  resolution:    96x96 dots per inch
```

Eseguo il comando `xrandr --dpi 192` per cambiare i DPI, ma in cambio ricevo un flash dello schermo e niente più. Mi sa che i DPI non sono un problema.

Incuriosito dal comando `xrandr`, lo eseguo senza argomenti e il risultato mi coglie di sorpresa: manda in output tutte le possibili risoluzioni del mio schermo (c'è da dire che qualsiasi output mi avrebbe sorpreso dato che non sapevo cosa aspettarmi). Ho un' illuminazione: non è che forse è la risoluzione il problema? (Post-mortem sembra una domanda stupida, ma in quel momento non lo era).

```txt
Screen 0: minimum 320 x 200, current 1920 x 1200, maximum 16384 x 16384
eDP-1 connected primary 1920x1200+0+0 (normal left inverted right x axis y axis) 286mm x 179mm
   1920x1200     59.88*+  47.84    59.95
   2560x1600     59.97 +
   2560x1440     59.99    59.99    59.96    59.95
   2048x1536     60.00
   1920x1440     60.00
   1856x1392     60.01
   1792x1344     60.01
   2048x1152     59.99    59.98    59.90    59.91
   1920x1080     60.01    59.97    59.96    59.93
   1600x1200     60.00
   1680x1050     59.95    59.88
   1400x1050     59.98
   ...
   432x243       59.92    59.57
   320x240       60.05
   360x202       59.51    59.13
   320x180       59.84    59.32
DP-1 disconnected (normal left inverted right x axis y axis)
HDMI-1 disconnected (normal left inverted right x axis y axis)
DP-2 disconnected (normal left inverted right x axis y axis)
HDMI-2 disconnected (normal left inverted right x axis y axis)
```
_Esempio troncato di output di xrandr_

Ricordo che avevo già provato una volta a cambiare la risoluzione dello schermo, ma per qualche motivo non ero arrivato ad una soluzione. Potrebbero essere state le 11 di sera e potrei aver avuto qualche allucinazione: riproviamo.

Eseguendo `xrandr --output eDP-1 --mode <risoluzione>` e giostrando tra qualche risoluzione diversa, sono arrivato ad una soluzione soddisfacente: 1920x1200. (Grazie a [`tldr`](https://tldr.sh/) ho subito trovato il comando adatto.)

Ora però vorrei che questo comando venga eseguito automaticamente ad ogni avvio. Chiedo a Claude e mi dice di metter il comando in `~/.xinitrc`, che apparentemente viene eseguito ogni volta che il sistema operativo lancia X. Provo e riavvio il PC, ma la risoluzione è ancora quella sbagliata. Allora Claude mi dice di controllare il mio desktop manager LightDM perché dipende tutto da come X viene lanciato. Leggendo online qualcosa su LightDM capisco che devo creare e rendere eseguibile il file `~/.xprofile` perché LightDM non esegue `~/.xinitrc`. Provo e non succede nulla di nuovo. Ritorno dal mio fidato Claude e mi dice di creare un file in `.config/autostart/` e aggiungere _li_ il comando. Conosco quella cartella e sono fiducioso che sia la soluzione adatta. Provo,  ma non funziona ancora. Insulto Claude e le sue allucinazioni per un po', mi faccio una passeggiata nervosa nel mio appartamento e poi torno al PC. Rileggo la risposta di Claude e decido di provare la seconda soluzione, ovvero aggiungere un file in `/etc/X11/xorg.conf.d` contenente:

```
Section "Monitor"
    Identifier "eDP-1"
    Modeline "1920x1200" 154.00 1920 2048 2256 2592 1200 1201 1204 1242 -HSync +Vsync
EndSection

Section "Screen"
    Identifier "Screen0"
    Monitor "eDP-1"
    DefaultDepth 24
    Subsection "Display"
        Depth 24
        Modes "1920x1200"
    EndSubsection
EndSection
```

Riavvio il PC per la quarta volta e funziona. Mi prendo qualche minuto per godermi la sensazione di aver risolto un problema. Subito dopo noto che anche la schermata di login, che fino ad ora si vedeva molto in piccolo, ha una risoluzione decente. Questi sono gli effetti collaterali che mi piacciono.

Riflettendoci, non ho davvero imparato come funzionano X, LightDM e compagnia cantante. Claude mi ha dato una soluzione ma non so perché questa funzioni e le altre no. Non ho capito perché i file `~/.xinitrc` e `~/.xprofile` non vengano eseguiti. Rimango un po' deluso da tutto ciò, nonostante possa essere consolato dal mio MacBook Pro con Linux sopra. 


Incuriosito, il giorno seguente leggo qualche discussione su forum qua e la e vedo che in molti suggeriscono di scrivere vari comandi nel mio `.xinitrc` o `.xprofile`. Anche la manpage di X lo consiglia: allora Claude non allucinava! _Forse, se Claude avesse avuto accesso al mio intero file system mi avrebbe potuto dare la soluzione esatta immediatamente. Però questa non è una cosa che vedo possibile nel mio futuro. Anche se potessi eseguire un'istanza del più grande modello di Claude offline e dargli in pasto il mio sistema operativo, non vorrei che risolvesse il problema per me. Avrei preferito stare per giorni sui forum leggendo i problemi di altra gente o postando io una domanda sul mio problema invece che avere una soluzione veloce ma che non mi lascia un insegnamento_, penso. 

Rimango confuso e ignorante, ma infine decido che non tutti i problemi debbano essere affrontati e di proseguire con la mia vita.
