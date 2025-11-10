Problems with scaling

Tale of a back and forth with Linux configs and Claude

Months ago I bought a 2015 Macbook Pro without the OS. I installed [MX Linux](https://mxlinux.org/) and ever since things went surprisingly well except one: text, pictures and icons were too small. I scaled the whole OS 2x and found the result OK. The feeling didn't last much 'cause some apps didn't render icons correctly, tickling the often-dormient area of my brain responsible for OCD.

An evening after a bunch of sick-leave-days I start reading the arch wiki page on [HiDPI and X Server](https://wiki.archlinux.org/title/HiDPI#X_Server) and I, after reading three not so long paragraphs, think: _that must be the issue! It's the DPI (Dots Per Inch)!_. HiDPI displays need 192 DPI to function properly; mine is set to 96 DPI at least according to the command `xdpyinfo | grep -B 2 resolution` which returns:

```txt
screen #0:
  dimensions:    1920x1200 pixels (508x317 millimeters)
  resolution:    96x96 dots per inch
```

I run the command `xrandr --dpi 192` to change the DPI, but the screen laughs at me as it remains the same as the moment before I ran the command.

There is always something good in the bad, and now I am intrigued by the `xrandr` command. I run it with no flags and the result catches me off guard: it outputs all the possible resolutions of my screen (although any output would have caught me off guard (I didn't know what to expect)). I find this situation somewhat rewarding: my own intuition brought me down this hill and to be honest it's so comfortable down here I might like it. I have an epiphany: maybe the resolution is the problem?

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

I remember already trying to change the screen resolution but not getting to a working solution. Could have been a 2300h hallucination as it happens with the screen addiction affecting the generation I am part of. Let's try again.

Running `xrandr --output eDP-1 --mode <resolution>` (thank you [`tldr`](https://tldr.sh/)) and playing around with different resolutions produces the correct result: the 1920x1200 resolution. Sheer trial and error seems to be, in the year twentytwentyfive past summer and before autumn, still the way.

But now I would like this command to be ran automatically at each system boot. 

Claude, the AI friend no one is talking about and that is the smartest-of-them-all™ (at least as of the day of today), tells me to add the command inside an `~/.xinitrc` file, which supposedly runs every time the OS launches [X](https://www.x.org/wiki/). I follow what the [robot](link to clanker) tells me to do and reboot the system, but the resolution is still the wrong one. 

_I probably did something wrong. Claude can't be wrong_, I think. So I ask Claude and it answers me assuming it was wrong and tells me to check my desktop manager LightDM because it all supposedly depends on how X is launched and supposedly LightDM launches X. Quickly reading online about LightDM I understand that I have to create the `~/.xprofile` file and make it executable and I also understand that LightDM does not run `~/.xinitrc`. I try and nothing happens. 

I go back to Claude, it tells me to create a file in `~/.config/autostart/` and to add the command in that file. I know that directory; I am confident that this is the right solution. I try and nothing happens. _Clanker!_. 

I take a nervous walk in my apartment and then come back to the laptop. It's not over yet.

Because I stopped at the first of the four solutions Claude gave me, I decide to try the second one: adding a file in `/etc/X11/xorg.conf.d` containing:

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

I reboot the laptop for the fourth time and the resolution is correct. _So I am the clanker?_, I think. I stop for some minutes to enjoy the unique feeling of solving a problem that I created myself. I notice that also the login screen, which so far was using a small font, has an OK resolution.

---

I didn't really learn how X and LightDM work, the clanker gave me solutions. I didn't understand why the `~/.xinitrc` and `~/.xprofile` files are not ran at system boot and I didn't understand how LightDM launches X. What's left to me?
