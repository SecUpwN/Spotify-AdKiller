#!/bin/bash

# Official Spotify-AdKiller Repository: https://github.com/SecUpwN/Spotify-AdKiller/
# CHANGELOG: https://github.com/SecUpwN/Spotify-AdKiller/blob/master/CHANGELOG.md
# Feel free to contribute improvements and suggestions to this funky script!

# Spotify-AdKiller-Mode: Automute-Continuous
# Automatically mutes Spotify when ad comes on and plays random local file
# Automatically continues Spotify playback afterwards

# DEPENDENCIES (Ubuntu): spotify, x11-utils, pulseaudio-utils
#
# Additonally you will need one of the following audio players:
#  - mpv
#  - vlc
#  - mplayer
#  - mpg321
#  - avplay
#  - ffplay                

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

## SYS

# get XDG default directories
test -f ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs \
&& source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs

## Settings

# volume of local playback
VOLUME=100
# local music directory to choose tracks from
# defaults to $HOME/Music (or equivalent on your system)
LOCALMUSIC="${XDG_MUSIC_DIR}"
# alert when switching to local playback
# might not play if using mpg321 (sketchy ogg support)
ALERT="/usr/share/sounds/freedesktop/stereo/complete.oga"
# override automatic music player detection
CUSTOMPLAYER=""

## VAR

WMTITLE="Spotify - Linux Preview"
ADMUTE=0
PAUSED=0
INITIALRUN=1

BINARY="spotify"

## TXT

ERRORMSG1="ERROR: No audio player detected. Please install mpv, cvlc, mpg321 \
or define a custom player by setting CUSTOMPLAYER in the script."

## FCT

choose_player(){
    if [[ -n "$CUSTOMPLAYER" ]]; then
      PLAYER="$CUSTOMPLAYER"
      echo "## Using $CUSTOMPLAYER for playback ##"
      return
    fi
    if type mpv > /dev/null 2>&1; then
      PLAYER="mpv --vo null --volume=$VOLUME"
      echo "## Using mpv for local playback ##"
    elif type mplayer > /dev/null 2>&1; then
      PLAYER="mplayer -vo null --volume=$VOLUME"
      echo "## Using mplayer for local playback ##"
    elif type cvlc > /dev/null 2>&1; then
      # vlc volume ranges from 0..256
      PLAYER="cvlc --play-and-exit --volume=$((256*VOLUME/100))"
      echo "## Using cvlc for local playback ##"
    elif type mpg321 > /dev/null 2>&1; then
      PLAYER="mpg321 -g $VOLUME"
      echo "## Using mpg321 for local playback ##"
    elif type avplay > /dev/null 2>&1; then
      # custom volume not supported
      PLAYER="avplay -nodisp -autoexit"
      echo "## Using avplay for local playback ##"
    elif type ffplay > /dev/null 2>&1; then
      # custom volume not supported
      PLAYER="ffplay -nodisp -autoexit"
      echo "## Using ffpla for local playback ##"
    else
      echo "$ERRORMSG1"
      exit 1
    fi
}

restore_settings(){
    # I would love to restore the pactl settings here
    # but unfortunately it's impossible; pactl can only control
    # active sinks, i.e. if Spotify isn't running we can't control its
    # mute state. So instead we have to unmute Spotify on every initial run
    # of this script (INITIALRUN=1)
    echo "##Restoring settings##"
    # terminate PLAYER if still running
    PLAYERPID="$(cat "$PIDFILE")"
    kill -0 "$PLAYERPID" 2> /dev/null && kill -s TERM "$PLAYERPID"
    [[ -f "$PIDFILE" ]] && rm "$PIDFILE"
}


print_horiz_line(){
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

spotify_playpause(){
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 \
    org.mpris.MediaPlayer2.Player.PlayPause > /dev/null 2>&1
}

get_pactl_nr(){
    LC_ALL=C pacmd list-sink-inputs | awk -v binary="$BINARY" '
            $1 == "index:" {idx = $2} 
            $1 == "application.process.binary" && $3 == "\"" binary "\"" {print idx; exit}
        '
    # awk script by Glenn Jackmann (http://askubuntu.com/users/10127/)
    # first posted on http://askubuntu.com/a/180661
}

player(){
    RANDOMTRACK="$(find "$LOCALMUSIC" -name "*.mp3" | sort --random-sort | head -1)"
    notify-send -i spotify "Spotify-AdKiller" "Playing ${RANDOMTRACK##*/}"
    $PLAYER "$ALERT" > /dev/null 2>&1 &         # alert user of switch to local playback
    $PLAYER "$RANDOMTRACK" > /dev/null 2>&1 &   # play random track
    PLAYERPID="$!"                              # get PLAYER PID
    echo "$PLAYERPID" > "$PIDFILE"              # store player PID
    wait "$PLAYERPID"                           # wait for player to exit before continuing
    
    spotify_playpause # continue Spotify playback. This triggers the xprop spy and
                      # subsequent actions like unmuting Spotify
}

## PREP

# create PIDFILE for inter-process-communication
PIDFILE="$(mktemp)"

# make sure to restore settings upon exit
trap restore_settings EXIT

# choose player
choose_player

## MAIN

while read -r XPROPOUTPUT; do
    XPROP_TRACKDATA="$(echo "$XPROPOUTPUT" | cut -d \" -f 2 )"
    DBUS_TRACKDATA="$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify / \
    org.freedesktop.MediaPlayer2.GetMetadata | grep xesam:title -A 1 | grep variant | cut -d \" -f 2)"
    
    echo "XPROP:    $XPROP_TRACKDATA"
    echo "DBUS:     $DBUS_TRACKDATA"
    
    if [[ "$XPROP_TRACKDATA" = "Spotify" ]]
      then
          echo "PAUSED:      Yes"
          PAUSED="1"
      else
          PAUSED="0"
          echo "PAUSED:      No"
          if [[ "$INITIALRUN" = 1 ]]  # unmute on initial run (to revert possible mute
            then                      # from last run)
                for PACTLNR in $(get_pactl_nr); do
                  pactl set-sink-input-mute "$PACTLNR" no > /dev/null 2>&1 ## unmute
                  echo "## INITIAL: Unmuting sink $PACTLNR ##"
                done
                INITIALRUN="0"
                print_horiz_line
                continue
          fi
    fi
    
    if [[ "$PAUSED" = "1" || "$XPROP_TRACKDATA" =~ $DBUS_TRACKDATA ]]
      then
          echo "AD:          No"
          if [[ "$ADMUTE" = "1" ]]
            then
                if ps -p $ALTPID > /dev/null 2>&1       # if alternative player still running
                  then
                      if [[ "$PAUSED" != "1" ]]         ## and if track not yet paused
                        then
                            spotify_playpause           ### then pause
                            echo "## Pausing Spotify until local playback finished ##"
                      fi
                      print_horiz_line
                      continue                          ## reset loop
                  else
                      for PACTLNR in $(get_pactl_nr); do
                          pactl set-sink-input-mute "$PACTLNR" no > /dev/null 2>&1 ## unmute
                          echo "## Unmuting sink $PACTLNR ##"
                          echo "## Switching back to Spotify ##"
                      done
                fi
          fi
          ADMUTE=0
      else
          echo "AD:          Yes"
          if [[ "$ADMUTE" != "1" ]]
            then
                for PACTLNR in $(get_pactl_nr); do
                    pactl set-sink-input-mute "$PACTLNR" yes > /dev/null 2>&1
                    echo "## Muting sink $PACTLNR ##"
                done
                if ! ps -p $ALTPID > /dev/null 2>&1
                  then
                      echo "## Switching to local playback ##"
                      player > /dev/null 2>&1 &
                      ALTPID="$!"
                fi
          fi
          ADMUTE=1
    fi
    print_horiz_line

done < <(xprop -spy -name "$WMTITLE" WM_ICON_NAME)
# use process substitution instead of piping to preserve variables

echo "Spotify not active. Exiting."

exit 0
