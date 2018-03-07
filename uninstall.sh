#!/bin/bash

set -euo pipefail

INSTALLDIR="$HOME/bin"
CONFIGDIR="${XDG_CONFIG_HOME:-$HOME/.config}/Spotify-AdKiller"
APPDIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"

echo "This script completely removes Spotify-AdKiller"

rm -rfv "$INSTALLDIR/dns-block.so" \
        "$INSTALLDIR/spotify-wrapper.sh" \
        "$CONFIGDIR/Spotify-AdKiller.cfg" \
        "$APPDIR/Spotify (AdKiller).desktop"

rmdir --ignore-fail-on-non-empty "$INSTALLDIR" "$CONFIGDIR"
