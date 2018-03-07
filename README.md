# Spotify-AdKiller (for Linux)

Your Party with [Spotify](https://www.spotify.com) - without ads!

[![Spotify-AdKiller](https://github.com/SecUpwN/Spotify-AdKiller/raw/master/Spotify-AdKiller.png)](https://github.com/SecUpwN/Spotify-AdKiller)

We all love Spotify, but sometimes people (like us) want to throw a party without having to listen to interrupting ads before having bought [Spotify Premium](https://www.spotify.com/premium/). Well, with this killer project, now you can!

**This is for testing purposes ONLY!** Spotify is a fantastic service and worth every penny. This script is **NOT** meant to circumvent buying premium! Please do consider switching to premium to support Spotify - especially if you're going to use it on mobile. If the script does not work for you, help us improve it!

### Dependencies

Utilities used in the script:

  - gcc
  - make

[![openSUSE](https://news.opensuse.org/wp-content/uploads/2014/11/468x60.png)](http://www.opensuse.org/)

Install all utilities + VLC on **[openSUSE](http://www.opensuse.org/)** with:

    sudo zypper in binutils pulseaudio-utils libnotify-tools xdotool vlc

[![Ubuntu](http://spreadubuntu.neomenlo.org/files/banner-468x60.png)](http://www.ubuntu.com/)

Install all utilities + VLC on **[Ubuntu](http://www.ubuntu.com/)** with:

    sudo apt-get install build-essential

[![Arch Linux](http://www.faderweb.de/img/archlinux.jpg)](http://www.archlinux.org/)

There is an [AUR Package](https://aur.archlinux.org/packages/spotify-adkiller-git/) for  **[Arch Linux](http://www.archlinux.org/)**. To install:

    git clone https://aur.archlinux.org/spotify-adkiller-git.git
    cd spotify-adkiller-git
    makepkg -si

### Installation

**Automated Installation**

Grab the latest release of `Spotify-AdKiller`:

    git clone https://github.com/SecUpwN/Spotify-AdKiller.git

Run the provided installer:

    cd Spotify-AdKiller
    make
    ./install.sh

**Troubleshooting**

- If you've installed Spotify from any source other than the official repository please make sure that the `spotify` executable is in your `PATH`.

    You can create a symbolic link, if necessary (e.g. linking `my-spotify` to `spotify` if you are using the user installation of [spotify-make](https://github.com/leamas/spotify-make)).

- The installer script will install `Spotify-AdKiller` to `$HOME/bin`, which should be recognized by Ubuntu and openSUSE.

- If `$HOME/bin` didn't exist before, a relog might be necessary to complete the installation.

    Technical explanation: Ubuntu automatically adds `$HOME/bin` to your `PATH` if it exists when you log in. Relogging reloads `$HOME/.profile` and updates your `PATH`.

    If the script doesn't work after relogging you can either [manually add](http://askubuntu.com/q/3744) `$HOME/bin` to your `PATH` or follow the installation instructions below. This also applies if you're using a distro that is configured differently than Ubuntu/OpenSUSE or if you want to install the script in a custom location.

- If GUI and text are too small, you can scale the application by editing the desktop file:

        cd /home/<your username>/.local/share/applications
        sudo gedit Spotify\ \(AdKiller\).desktop

    Add `--force-device-scale-factor=2` to scale it with factor 2:

        Exec=spotify-wrapper.sh --force-device-scale-factor=2 %U

**Manual Installation**

1. Run `make`

1. Copy `dns-block.so` and `spotify-wrapper.sh` to your `PATH` (e.g. `$HOME/bin` or `/usr/local/bin` on openSUSE and Ubuntu) and make both of them executable with `chmod +x dns-block.so` and `chmod +x spotify-wrapper.sh`.

2. Copy `Spotify (AdKiller).desktop` to `$HOME/.local/share/applications` or any other folder your distro reads `.desktop` launchers from (e.g. `/usr/share/applications`, `/usr/local/share/applications`).

The default configuration file will be written automatically on the first startup of the script.

### Usage

If you installed `Spotify-AdKiller` correctly, a new entry called `Spotify (AdKiller)` should appear in your menu. This launcher will start Spotify in ad-free mode. As mentioned before, **this is for testing purposes ONLY** so use this new entry only when your purposes are **testing**.

### Similar Projects

- [blockify](https://github.com/mikar/blockify) - automatic/blacklist-based ad-blocker written in Python
- [spotify_ad_blocker_linux.rb](https://github.com/superr4y/hacks/blob/master/spotify/spotify_ad_blocker_linux.rb) - automatic ad-blocker written in Ruby
- [spotify-blacklist-mute](https://github.com/ysangkok/spotify-blacklist-mute) - blacklist-based muting, written in Bash

### License

Many people have contributed to make our script become what it is today (huge shout-out to the initial creator [pcworld](https://github.com/pcworld)). If you are like us and think that it is very sad when projects die, please accept that all code here is fully licensed under GPL v3+. Have a look at the full [License](https://github.com/SecUpwN/Spotify-AdKiller/blob/master/LICENSE). Contribute pull requests!

**This product is not endorsed, certified or otherwise approved in any way by Spotify. Spotify is the registered trade mark of the Spotify Group. Use your brainz prior to formatting your HDD.**
