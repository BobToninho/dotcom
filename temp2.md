obiettivo: scalare il monitor del mio macbookpro 2015

prima soluzione con MX linux era usare scaling, ma: alcune app non scalano bene e in generale "sento" quando un desktop è scalato. Sono sicuro si possa fare di più

provato a leggere la pagina arch wiki sui HiDPI e mi sono reso conto che il numero sbagliato di DPI potrebbe essere il problema

mentre leggevo, menzionano il comando xrandr e non capisco cosa sia. Lo runno e quando vedo l'output mi si accende la scintilla: non è che forse è la risoluzione il problema, e non i DPI? (mentre lo scrivo sembra stupido, ma prima per me non lo era)

ricordo che avevo già provato a cambiare la risoluzione ma i risultati non mi soddisfacevano (TODO provare ad andare di nuovo alle impostazioni e vedere come veniva la risoluzione)

ho quindi usato xrandr per cambiare la risoluzione con il comando 

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
