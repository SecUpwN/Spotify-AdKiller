# Spotify-AdKiller (for LINUX)

Your Party with Spotify - but without Ads!

We all love Spotify, but sometimes people (like me) want to throw a party without interrupting Ads before having bought premium. This is for testing purposes ONLY! Spotify is a fantastic service and worth every penny. This script is **NOT** meant to circumvent buying premium! Please do consider switching to premium to support Spotify - especially if you're going to use it on the move. If the script does not work for you, help us improve it!

### Dependencies

Utilities used in the script:

  - xprop
  - pacmd
  - notify-send

You will also need to have one of the following audio/media players installed:

  - mpv
  - vlc
  - mplayer
  - mpg321
  - avplay
  - ffplay
  
Please consult the Settings section below for information on setting a custom audio player.

Install all utilities + vlc on Ubuntu with:

    sudo apt-get install x11-utils pulseaudio-utils libnotify-bin vlc


### Installation of the script

Move the Spotify-AdKiller `spotify-adkiller.sh` as well as the Wrapper `spotify-wrapper.sh` to your PATH (e.g. `$HOME/bin` on openSUSE and Ubuntu) and make both of them executable with `chmod +x spotify-adkiller.sh` and `chmod +x spotify-wrapper.sh`.

Finally, just call the Wrapper `spotify-wrapper.sh` to start the AdKiller and Spotify. On openSUSE I simply placed the following line into the Spotify-Launcher on my Desktop:

    Exec=/bin/bash /$HOME/bin/spotify-wrapper.sh %U

Alternatively, if you placed the script in your PATH you can simply use the following Exec line:

    Exec=spotify-wrapper.sh %U

You don't have to worry about terminating it when Spotify exits because that happens automatically.

### Settings

Notable parameters you might want to change in `spotify-adkiller.sh`:

 - `LOCALMUSIC` - directory to use for local playback; set to default XDG music directory
 - `CUSTOMPLAYER` - music player to use for local playback; overrides automatic detection
 - `ALERT` - alert when switching to local playback; unset if you don't want an audio alert

### Important notes

Please make sure to always use the Wrapper when running Spotify. Under some circumstances Spotify might remain muted when exiting the application. This is a technical limitation with PulseAudio. Spotify AdKiller automatically unmutes Spotify when initially run.

If for some reason Spotify does remain muted you can use the following command to unmute it manually while it's running:

```bash
for i in $(pactl list | grep -E '(^Sink Input)|(media.name = \"Spotify\"$)' | cut -d \# -f2 | grep -v Spotify); do pactl set-sink-input-mute "$i" no; done
```

### License of the Project

Many people have contributed to make our script become what it is today (huge shout-out to the initial creator pcworld). If you are like me and think that it is very sad when projects die, please accept that all code here is fully licensed under GPL v3+. Feel free to read our complete [License](https://github.com/SecUpwN/Spotify-AdKiller/blob/master/LICENSE).
