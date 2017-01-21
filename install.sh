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

# DEPENDENCIES
dep=(xprop pacmd notify-send xdotool)

# TEXT COLOURS
readonly RED="\033[01;31m"
readonly GREEN="\033[01;32m"
readonly BLUE="\033[01;34m"
readonly YELLOW="\033[00;33m"
readonly BOLD="\033[01m"
readonly END="\033[0m"

# VAR

INSTALLDIR="$HOME/bin"
CONFIGDIR="${XDG_CONFIG_HOME:-$HOME/.config}/Spotify-AdKiller"  # try to follow XDG specs
APPDIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"      # try to follow XDG specs

SCRIPT="spotify-adkiller.sh"
WRAPPER="spotify-wrapper.sh"
CONFIGFILE="Spotify-AdKiller.cfg"
DESKTOPFILE="Spotify (AdKiller).desktop"

INFOMSG1="\e[1;93mWARNING: $INSTALLDIR is not part of your PATH. Your current PATH:

\e[0m$PATH

\e[1;93mIf you are on Ubuntu you might have to relog to complete the installation.
This will update your PATH and make the script available to your system.

\e[0mIf the launcher doesn't work after relogging you will have to manually add
$INSTALLDIR to your PATH variable. 

Alternatively you could abort this installation and follow the instructions in the
README to manually install Spotify AdKiller.

\e[1;93mDo you want to proceed with the installation? \e[0m(y/n)"

ERRORMSG1="\e[1;31mERROR: One or more files not found. Please make sure to \
execute this script in the right working directory.\e[0m"

ERRORMSG2="ERROR: Please install these missing dependencies before running the script"

# FCT

checkdep(){
  for i in "${dep[@]}"; do
    if  ( ! type "$i" &>/dev/null ); then
      miss=("${miss[@]}" "and" "$i")
      missing="1"
    fi
  done
}


# MAIN

## check for missing dependencies
checkdep
if [[ $missing -eq 1 ]]; then
  misslist=$(echo ${miss[@]} | cut -c 4-)
  echo -e "$RED$misslist not found$END"
  echo -e "$ERRORMSG2"
  exit 1
fi

## check if INSTALLDIR is part of PATH
## prompt user for action
if [[ ! "$PATH" == ?(*:)"$INSTALLDIR"?(:*) ]]; then
  echo -e "$INFOMSG1"
  read INSTALLCHOICE
  if [[ "$INSTALLCHOICE" != "y" ]]; then
    echo "Aborting installation."
    exit 1
  else
    echo "Proceeding with installation."
  fi
fi

## check if all files present
if [[ ! -f "$SCRIPT" || ! -f "$WRAPPER" || ! -f "$CONFIGFILE" ]]; then
  echo -e "$ERRORMSG1"
  exit 1
fi

## if $APPDIR is missing then create it
if [[ ! -d "$APPDIR" ]]; then
 mkdir -vp "$APPDIR"
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
[[ ! -f "$CONFIGDIR/$CONFIGFILE" ]] && cp -v "$CONFIGFILE" "$CONFIGDIR/"
cp -v "$DESKTOPFILE" "$APPDIR/"

echo

echo "## Done. ##"
