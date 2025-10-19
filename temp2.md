obiettivo: scalare il monitor del mio macbookpro 2015

Ho dovuto adattare lo schermo del mio MacBook Pro 2015 con installato MX Linux perché aveva una risoluzione troppo bassa. La prima soluzione è stata scalare 2x tramite le impostazioni che shippano con MX Linux. Ha funzionato per buona parte, ma ero sicuro ci fosse di meglio (e alcune app non renderizzavano perfettamente certi elementi). Le app però erano visibilmente scalate e c'era meno spazio di manovra.

Ho provato a leggere la pagina arch wiki riguardo HiDPI e dopo qualche paragrafo pensavo di essere sulla giusta strada: il mio laptop ha settato il numero di DPI sbagliato, quindi correggere i DPI dovrebbe sistemare il mio problema. Di fretta, provo ad eseguire il comando `xrandr --dpi 192`, ma non succede nulla se non un piccolo flash. Dunque i DPI non sono un problema.

Continuando a leggere, viene menzionato il comando xrandr un po' a caso. Lo eseguo per capire cosa fa: manda in output tutte le possibili risoluzioni del mio schermo. Non è che forse è la risoluzione il problema? (Post-mortem sembra stupido, ma in quel momento non lo era).

Ricordo che avevo già provato una volta a cambiare la risoluzione, ma per qualche motivo non ero arrivato ad una soluzione. Potrebbero essere state le 11 di sera e potrei aver avuto qualche allucinazione.

Eseguendo `xrandr` nel seguente modo e provando qualche risoluzione (grazie a `tldr` ho subito trovato il comando adatto), sono arrivato ad una soluzione soddisfacente.

```sh
xrandr --output eDP-1 --mode 1920x1200
```

ora però vorrei che questa cosa succedesse ad ogni avvio. Chiedo a Claude e mi dice di runnare il comando in ~/.xinitrc. Non va. Allora claude mi dice di controllare il mio desktop manager. Ho lightdm. In quel caso, devo creare e rendere eseguibile il file ~/.xprofile. Provo e non va. Allora Claude mi dice di creare un file in .config/autostart e aggiungere del testo. Provo ma non funziona. La seconda soluzione è aggiungere un file in /etc/X11/xorg.conf.d e chiamarlo 10-monitor.conf (penso che il nome non abbia importanza)


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

questo è il contenuto, e funziona. Ora anche la schermata di login ha una risoluzione decente.

Ora, pero, non ho davvero imparato come funzionano queste cose. Claude mi ha dato una soluzione ma non so perche questa fuznioni e le altre no. Rimango un po' deluso da questo, ma felice di avere la risoluzione corretta nel mio laptop
