#!/bin/bash

# Official Spotify-AdKiller Repository: https://github.com/SecUpwN/Spotify-AdKiller/
# CHANGELOG: https://github.com/SecUpwN/Spotify-AdKiller/blob/master/CHANGELOG.md
# Feel free to contribute improvements and suggestions to this funky script!

# Wrapper script to automatically start Spotify-AdKiller when Spotify starts

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

# WARNING: If you use this wrapper please make sure to ALWAYS use it
#          If you start Spotify without it, there's a chance that Spotify will
#          stay muted and will have to be manually be unmuted through pactl

## VARIABLES

# settings

ADKILLER="spotify-adkiller.sh"
WMTITLE="Spotify - Linux Preview"
LOGFILE="$HOME/.Spotify-AdKiller.log"

# DNS-BLOCK

# experimental support for blocking ad banners
# Instructions: 
# 1. download and compile dns-block.c from the experimental branch
#    (https://github.com/SecUpwN/Spotify-AdKiller/tree/dns-block/experimental)
# 2. create a dns-block directory in your Spotify AdKiller installation path
# 3. Move the compiled dns-block.so library there   
SCRIPTEXEC="$(readlink -f "$0")"
SCRIPTDIR="${SCRIPTEXEC%/*}"
PRELOAD_LIB="$SCRIPTDIR/dns-block/dns-block.so"
[[ ! -f "$PRELOAD_LIB" ]] && PRELOAD_LIB=""

# initialization

COUNTER="0"

# config

CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/Spotify-AdKiller"
CONFIG_FILE="$CONFIG_PATH/Spotify-AdKiller.cfg"
CONFIG_DEFAULT=\
'##                                                      ##
## Configuration file for Spotify-AdKiller              ##
## Please make sure to double-quote all custom values   ##
##                                                      ##

CUSTOM_MODE=""
# ad block mode. possible values:
# - simple        — mute Spotify, unmute when ad is over
# - interstitial  — mute Spotify, play random local track, stop and unmute when ad is over
# - continuous    — mute Spotify, play random local track, stop and unmute when track is over
# -> set to continuous by default

CUSTOM_PLAYER=""
CUSTOM_LOOPOPT=""
# local music player to use
# you can define a loop option (if available) in case you want
# to use a music track shorter than the average ad duration (only applicable to interstitial mode)
# -> chosen automatically by default

CUSTOM_VOLUME=""
# volume of local playback
# -> set to 100 by default

CUSTOM_MUSIC=""
# local music directory / track
# -> set to XDG standard music directory by default

CUSTOM_ALERT=""
# alert when switching to local playback
# - might not play if using mpg321 (sketchy ogg support)
# -> set to XDG standard alert by default

DEBUG="0"
# control debug mode
# - "1" to enable
# - "0" to disable
# -> Will make the CLI output more verbose and write a logfile
#    to "$HOME/.Spotify-AdKiller.log"'

## CLI MESSAGES

ERRORMSG1="Error: Spotify not found."
INFOMSG1="DEBUG mode active"

## FUNCTIONS

notify_send(){
    notify-send -i spotify-client "Spotify-AdKiller" "$1"
}

read_write_config(){
    mkdir -p "$CONFIG_PATH"
    if [[ ! -f "$CONFIG_FILE" ]]; then
      echo "$CONFIG_DEFAULT" > "$CONFIG_FILE"
    fi
    source "$CONFIG_FILE" 
}

spotify_launch(){
    LD_PRELOAD="$PRELOAD_LIB" spotify "$@" > /dev/null 2>&1 &
    # wait for spotify to launch
    # if spotify not launched after 50 seconds exit script
    while true; do
      if [[ "$COUNTER" = "10" ]]
        then
            notify_send "$ERRORMSG1"
            echo "$ERRORMSG1"
            exit 1
      fi
      echo "## Waiting for Spotify ##"
      xprop -name "$WMTITLE" WM_ICON_NAME > /dev/null 2>&1
      if [[ "$?" == "0" ]]; then
        break
      fi
      COUNTER=$(( COUNTER + 1 ))
      sleep 5
    done
}

adkiller_launch(){
    # only launch script if it isn't active already
    # we need to truncate script name to make pgrep work
    if [[ -z "$(pgrep "${ADKILLER:0:14}")" ]]; then
      if [[ "$DEBUG" = "1" ]]; then
        echo "$INFOMSG1"
        notify_send "$INFOMSG1"
        $ADKILLER > "$LOGFILE" 2> /dev/null &
      else
        $ADKILLER > /dev/null 2>&1 &
      fi
    fi
}

## MAIN

read_write_config
spotify_launch
adkiller_launch
