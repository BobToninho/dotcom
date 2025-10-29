Scaling the screen of my 2015 Macbook pro running Linux

Tale of a back and forth with Linux configs and Claude AI

Months ago I bought a 2015 Macbook Pro from my company despite knowing that it would have come without any OS installed. I installed MX Linux and ever since things went surprisingly well, except for one: text, pictures and icons were too small and I had to scale the whole OS 2x. It's good enough, but being only a Linux beginner I'm sure that you can do better than this. (Or I was just bothered that some apps didn't render some elements correctly!!)

An evening after a bunch of sick days I start reading the arch wiki page on [HiDPI and X Server](https://wiki.archlinux.org/title/HiDPI#X_Server) and after some paragraph I already think I am on the right path: my laptop is set with the wrong number of <abbr>DPI</abbr> (Dots Per Inch). HiDPI (or Retina) displays need 192 DPI. I get to know that my screen is set to 96 DPI because the command `xdpyinfo | grep -B 2 resolution` returns:

```txt
screen #0:
  dimensions:    1920x1200 pixels (508x317 millimeters)
  resolution:    96x96 dots per inch
```

I run the command `xrandr --dpi 192` to change the DPI, but in return I get a screen flashi and nothing more. I guess DPI are not the issue.

Intrigued by the `xrandr` command, I run it without any flags and the result surprised me: it outputs all the possible resolutions of my screen (I have to admit that any output would have surprised me given that I didn't know what to expect). I have an epiphany: maybe the resolution is my problem? (Post-mortem this seems a silly question, but at the time it wasn't.)

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
_Truncated output of `xrandr`_

I remember already trying to change the screen resolution, but for some reason I didn't get to a working solution. It might have been 23:00 in the night and I could have had hallucinations: let's try again.

Running `xrandr --output eDP-1 --mode <risoluzione>` and playing around with different resolutions, I got to a satisfying resolution: 1920x1200. (Thanks to [`tldr`](https://tldr.sh/) I immediately found the right command.)

But now I would like this command to be ran autoatically at each boot. I ask Claude and it tells me to add the command in `~/.xinitrc`, which according to it runs everytime the OS launches X. I try and reboot the system, but the resolution is still the wrong one. Then Claude tells me to check my desktop manager LightDM because it all depends on how X is launched. Quickly reading online on LightDM I understand that I have to create and make executable the `~/.xprofile` file because LightDM does not run `~/.xinitrc`. I try and nothing new happens. I go back to my trustworthy Claude and it tells me to create a file in `.config/autostart/` and to add the command in the file. I know that directory and I am confident that it's the right solution. I try, but nothing works. I insult Claude and its hallucinations for a while, I take a nervous walk in my appartment and then come back to the laptop. It's not over yet.

I read Claude's answer one more time and decide to try the second solution: adding a file in `/etc/X11/xorg.conf.d` containing:

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

I reboot the laptop for the fourth time and it works. I stop for some minutes to enjoy the feeling of solving a problem. I notice that also the login screen, which so far was rendered with a small font, has a decent resolution. _These are the side effects that I like_, I think.

Reflecting on this, I didn't really learn how X, LightDM and company work. Claude gave me many solutions, but I don't know why one of them works and the others do not; I didn't understand why the `~/.xinitrc` and `~/.xprofile` files are not ran at boot; I didn't understand how LightDM launches X. I am left a bit disappointed.

Curious, the next day I read some discussions on random forums and I see that many people suggest to write commands that need to be ran on system boot in the `~/.xinitrc` or `~/.xprofile` files. Also X's manpage recommends to do so: so Claude was not hallucinating, after all! _Maybe, if Claude would have had access to my whole file system it could have immediately given me the correct solution. Even if I could run an instance of the biggest Claude model offline and feed it my OS, I wouldn't want it to solve the problem for me. I would prefer wasting days on forums reading other people's problems or reading countless manpages instead of having a fast solution but that doesn't give me any learning, that doesn't give me anything more than the solution itself_, I think.

I am left confused and ignorant, but I finally decide that not all the problems need to be faced and to keep going with my life.
