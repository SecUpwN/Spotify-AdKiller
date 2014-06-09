#!/bin/bash

# Official Spotify-AdKiller Repository: https://github.com/SecUpwN/Spotify-AdKiller/
# CHANGELOG: https://github.com/SecUpwN/Spotify-AdKiller/blob/master/CHANGELOG.md
# Feel free to contribute improvements and suggestions to this funky script!

# Installation script for Spotify-AdKiller

# Please make sure to consult the attached README file before using this script

# IMPORTANT REMINDER! CAREFULLY READ AND UNDERSTAND THIS PART. THANK YOU.
# -----------------------------------------------------------------------
# Spotify is a fantastic service and worth every penny.
# This script is *NOT* meant to circumvent buying premium.
# Please do consider switching to premium to support Spotify!
# -----------------------------------------------------------------------
# This product is not endorsed, certified or otherwise approved in any way
# by Spotify. Spotify is the registered trade mark of the Spotify Group.
# -----------------------------------------------------------------------
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# -----------------------------------------------------------------------

# WARNING: This installation script has only been tested on Ubuntu and openSUSE

# VAR

INSTALLDIR="$HOME/bin"
CONFIGDIR="${XDG_CONFIG_HOME:-$HOME/.config}/Spotify-AdKiller"  # try to follow XDG specs
APPDIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"      # try to follow XDG specs

SCRIPT="spotify-adkiller.sh"
WRAPPER="spotify-wrapper.sh"
CONFIGFILE="Spotify-AdKiller.cfg"
DESKTOPFILE="Spotify (AdKiller).desktop"

ERRORMSG1="\e[1;31mERROR: $INSTALLDIR is not part of your PATH.\e[0m Current PATH:
$PATH
\e[1;93mPlease change 'INSTALLDIR' in this installer script and try again.\e[0m"
ERRORMSG2="\e[1;31mERROR: One or more files not found. Please make sure to \
execute this script in the right working directory.\e[0m"


# MAIN

if [[ ! "$PATH" == ?(*:)"$INSTALLDIR"?(:*) ]]; then             # check if INSTALLDIR part of
  echo -e "$ERRORMSG1"                                          # PATH
  exit 1
fi

if [[ ! -f "$SCRIPT" || ! -f "$WRAPPER" || ! -f "$CONFIGFILE" ]]; then
  echo -e "$ERRORMSG2"
  exit 1
fi

echo

echo "## Changing permissions ##"
chmod -v +x "$SCRIPT"
chmod -v +x "$WRAPPER"

echo

echo "## Creating installation directories ##"
mkdir -vp "$INSTALLDIR"
mkdir -vp "$CONFIGDIR"

echo

echo "## Installing files ##"
cp -v "$SCRIPT" "$INSTALLDIR/"
cp -v "$WRAPPER" "$INSTALLDIR/"
cp -v "$CONFIGFILE" "$CONFIGDIR/"
cp -v "$DESKTOPFILE" "$APPDIR/"

echo

echo "## Done. ##"
