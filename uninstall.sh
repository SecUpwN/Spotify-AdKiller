#!/bin/bash

set -euo pipefail

INSTALLDIR="$HOME/bin"
CONFIGDIR="${XDG_CONFIG_HOME:-$HOME/.config}/Spotify-AdKiller"
APPDIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"

echo "This script completely removes Spotify-AdKiller, including its configuration"

rm -rfv "$INSTALLDIR/spotify-adkiller.sh" \
        "$INSTALLDIR/spotify-wrapper.sh" \
        "$CONFIGDIR/Spotify-AdKiller.cfg" \
        "$APPDIR/Spotify (AdKiller).desktop"

rmdir --ignore-fail-on-non-empty "$INSTALLDIR" "$CONFIGDIR"
