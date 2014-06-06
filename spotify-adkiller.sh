#!/bin/bash

# Official Spotify-AdKiller Repository: https://github.com/SecUpwN/Spotify-AdKiller/
# CHANGELOG: https://github.com/SecUpwN/Spotify-AdKiller/blob/master/CHANGELOG.md
# Feel free to contribute improvements and suggestions to this funky script!

# Spotify-AdKiller-Mode: Automute-Continuous
# Automatically mutes Spotify when ad comes on and plays random local file
# Automatically continues Spotify playback afterwards

# DEPENDENCIES:   - Ubuntu:     x11-utils pulseaudio-utils libnotify-bin
#                 - openSUSE:   binutils pulseaudio-utils libnotify-tools

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


## SETTINGS

CUSTOM_PLAYER=""
# local music player to use
# - will be chosen automatically if not set
CUSTOM_VOLUME=""
# volume of local playback
# - will be set to 100 if empty
CUSTOM_MUSIC=""
# local music directory to choose tracks from
# - will use XDG standard music directory if not set
# - please make sure that the tracks in your music directory
#   are at least as long as the average Spotify ad (30-60 secs)
ALERT="/usr/share/sounds/freedesktop/stereo/complete.oga"
# alert when switching to local playback
# - might not play if using mpg321 (sketchy ogg support)


## VARIABLES

WMTITLE="Spotify - Linux Preview"
BINARY="spotify"
ADMUTE=0
PAUSED=0
INITIALRUN=1


## CLI MESSAGES

ERRORMSG1="ERROR: No audio player detected. Please install cvlc, mplayer, mpv, \
mpg321, avplay, ffplay, or define a custom player by setting CUSTOMPLAYER."


## FUNCTIONS

set_musicdir(){
    if [[ -z "$CUSTOM_MUSIC" ]]
      then
          # get XDG default directories
          test -f "${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs" \
          && source "${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs"
          LOCAL_MUSIC="${XDG_MUSIC_DIR}"
      else
          LOCAL_MUSIC="$CUSTOM_MUSIC"
    fi
}

set_player(){
    if [[ -n "$CUSTOM_PLAYER" ]]; then
      PLAYER="$CUSTOM_PLAYER"
    elif type cvlc > /dev/null 2>&1; then
      # vlc volume ranges from 0..256
      PLAYER="cvlc --play-and-exit --volume=$((256*VOLUME/100))"
    elif type mplayer > /dev/null 2>&1; then
      PLAYER="mplayer -vo null --volume=$VOLUME"
    elif type mpv > /dev/null 2>&1; then
      PLAYER="mpv --vo null --volume=$VOLUME"
    elif type mpg321 > /dev/null 2>&1; then
      PLAYER="mpg321 -g $VOLUME"
    elif type avplay > /dev/null 2>&1; then
      # custom volume not supported
      PLAYER="avplay -nodisp -autoexit"
    elif type ffplay > /dev/null 2>&1; then
      # custom volume not supported
      PLAYER="ffplay -nodisp -autoexit"    
    else
      echo "$ERRORMSG1"
      exit 1
    fi
    echo "## Using $(echo "$PLAYER" | cut -d' ' -f1) for local playback ##"
}

set_volume(){
    if [[ -z "$CUSTOM_VOLUME" ]]
      then
          VOLUME="100"
      else
          VOLUME="$CUSTOM_VOLUME"
    fi
}

setup_vars(){
    set_musicdir
    set_player
    set_volume
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
    RANDOM_TRACK="$(find "$LOCAL_MUSIC" -name "*.mp3" | sort --random-sort | head -1)"
    notify-send -i spotify "Spotify-AdKiller" "Playing ${RANDOM_TRACK##*/}"
    [[ -n "$ALERT" ]] && $PLAYER "$ALERT" > /dev/null 2>&1 &  # Alert user
    $PLAYER "$RANDOM_TRACK" > /dev/null 2>&1 &                # Play random track
    PLAYER_PID="$!"                                           # Get PLAYER PID
    echo "$PLAYER_PID" > "$PIDFILE"                           # Store player PID
    wait "$PLAYER_PID"                                        # Wait for player to 
                                                              # exit before continuing
                                                              
    spotify_playpause                                         # Continue Spotify playback. 
                                                              # This triggers the xprop spy and
                                                              # subsequent actions like unmuting
}

restore_settings(){
    echo "## Restoring settings ##"
    # terminate PLAYER if still running
    [[ -f "$PIDFILE" ]] && PLAYER_PID="$(cat "$PIDFILE")"
    kill -0 "$PLAYER_PID" 2> /dev/null && kill -s TERM "$PLAYER_PID"
    [[ -f "$PIDFILE" ]] && rm "$PIDFILE"
    # I would love to restore the mute state here but unfortunately it's impossible. 
    # `pactl` can only control active sinks, i.e. if Spotify isn't running we can't 
    # control its mute state. So we have to resort to unmuting Spotify on every initial 
    # run of this script (INITIALRUN=1)
}


## PREPARATION

# create PIDFILE for inter-process-communication
PIDFILE="$(mktemp -u "${0##*/}".XXXXXXXX)"

# make sure to restore settings upon exit
trap restore_settings EXIT

# setup player, music directory, and volume
setup_vars


## MAIN

while read -r XPROPOUTPUT; do

    # get track data from xprop and the DBUS interface
    XPROP_TRACKDATA="$(echo "$XPROPOUTPUT" | cut -d\" -f 2- | rev | cut -d\" -f 2- | rev)"
    DBUS_TRACKDATA="$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify / \
    org.freedesktop.MediaPlayer2.GetMetadata | grep xesam:title -A 1 | grep variant | \
    cut -d\" -f 2- | rev | cut -d\" -f 2- | rev)"

    # `cut | rev | cut | rev` gets string between first and last double-quotes
    # TODO: find a more elegant way to do this

    echo "XPROP:    $XPROP_TRACKDATA"
    echo "DBUS:     $DBUS_TRACKDATA"
    
   
    # Check if Spotify is paused and/or has just been launched
    if [[ "$XPROP_TRACKDATA" = "Spotify" ]]
      then
          echo "PAUSED:   Yes"
          PAUSED="1"
      else
          PAUSED="0"
          echo "PAUSED:   No"
          if [[ "$INITIALRUN" = 1 ]]                    # unmute on initial run
            then
                for PACTLNR in $(get_pactl_nr); do
                  pactl set-sink-input-mute "$PACTLNR" no > /dev/null 2>&1
                  echo "## INITIAL: Unmuting sink $PACTLNR ##"
                done
                INITIALRUN="0"
                print_horiz_line
                continue
          fi
    fi

    
    # Check if current track is an ad and take appropriate action
    if [[ "$PAUSED" = "1" || "$XPROP_TRACKDATA" == *$DBUS_TRACKDATA* ]]
      then
          echo "AD:       No"
          if [[ "$ADMUTE" = "1" ]]
            then
                if ps -p "$ALTPID" > /dev/null 2>&1     # if alternative player still running
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
          echo "AD:       Yes"
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
 
    
    # print horizontal line
    print_horiz_line

done < <(xprop -spy -name "$WMTITLE" WM_ICON_NAME)  # we use process substitution instead of piping
                                                    # to avoid executing the loop in a subshell
                                                    
echo "Spotify not active. Exiting."

exit 0
