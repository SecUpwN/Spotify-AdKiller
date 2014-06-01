# Spotify-AdKiller (for LINUX)

Your Party with Spotify - but without Ads!

We all love Spotify, but sometimes people (like me) want to throw a party without interrupting Ads before having bought premium. This is for testing purposes ONLY! Spotify is a fantastic service and worth every penny. This script is **NOT** meant to circumvent buying premium! Please do consider switching to premium to support Spotify - especially if you're going to use it on the move. If the script does not work for you, help us improve it!

### Installation of the script

Move the script `spotify-adkiller.sh` to your PATH containing the Spotify-Binary (e.g. $HOME/bin on openSUSE and Ubuntu) and make it executable with `chmod +x spotify-adkiller.sh`. Then use the wrapper script `spotify-wrapper.sh` to start the AdKiller automatically when Spotify gets started.

On openSUSE I simply placed the following line into the Spotify-Launcher on my Desktop: `Exec=/bin/bash /$HOME/bin/spotify-wrapper.sh %U`. You don't have to worry about terminating it when Spotify exits because that happens automatically.

### License of the Project

Many people have contributed to make our script become what it is today (huge shout-out to the initial creator pcworld). If you are like me and think that it is very sad when projects die, please accept that all code here is fully licensed under GPL v3+.
