#!/bin/bash

# Official Spotify-AdKiller Repository: https://github.com/SecUpwN/Spotify-AdKiller/
# CHANGELOG: https://github.com/SecUpwN/Spotify-AdKiller/blob/master/CHANGELOG.md
# Feel free to contribute improvements and suggestions to this funky script!

# Spotify AdKiller main script

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

## VARIABLES

# !! PLEASE DO NOT MODIFY THIS SECTION. USE THE CONFIG_FILE INSTEAD !!
# !!     DEFAULT CONFIG PATH: "$HOME/.config/Spotify-AdKiller"     !!

# config

CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/Spotify-AdKiller"
CONFIG_FILE="$CONFIG_PATH/Spotify-AdKiller.cfg"

# settings

BINARY="spotify"

# initialization

INITIALRUN=1
ADMUTE=0
PAUSED=0
LOCPLAY=0
PAUSESIGNAL=0
ADFINISHED=0

## CLI MESSAGES

ERRORMSG1="ERROR: No supported audio player detected. Please install one of the supported \
players or define a custom player by setting CUSTOM_PLAYER.
Switching to simple automute (no local playback)"
ERRORMSG2="ERROR: Default music folder not found. Please set a custom location.
Switching to simple automute (no local playback)"
ERRORMSG3="ERROR: No music found in the specified location. Please check the settings. \
Switching to simple automute (no local playback)"

## FUNCTIONS

debuginfo(){
    if [[ "$DEBUG" = "1" ]]
      then
          echo "$1"
    fi
}

notify_send(){
    notify-send -i spotify-client "Spotify-AdKiller" "$1"
}

print_horiz_line(){
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

read_config(){
    [[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"
}

# Makes sure a string ends with a slash. This can be necessary when trying to find files in a directory via find.
append_missing_slash() {
    echo "${@%/}/"
}

set_musicdir(){
    if [[ "$automute" == "automute_simple" ]]; then
        return
    fi

    if [[ -z "$CUSTOM_MUSIC" ]]; then
        # get XDG default directories
        test -f "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs" \
        && source "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs"
        LOCAL_MUSIC="$(append_missing_slash "${XDG_MUSIC_DIR}")"

        if [[ -z "$LOCAL_MUSIC" ]]; then
            echo "$ERRORMSG2"
            notify_send "$ERRORMSG2"
            CUSTOM_MODE="simple"
        fi
    else
        LOCAL_MUSIC="$(append_missing_slash "${CUSTOM_MUSIC}")"
    fi

    echo "## Music path: $LOCAL_MUSIC ##"

    if [[ -z "$(find "$LOCAL_MUSIC" -iname "*.mp3" 2> /dev/null )" ]]; then
        echo "$ERRORMSG3"
        notify_send "$ERRORMSG3"
        CUSTOM_MODE="simple"
    fi
}

set_player(){
    if [[ -n "$CUSTOM_PLAYER" ]]; then
      PLAYER="$CUSTOM_PLAYER"
      LOOPOPT="$CUSTOM_LOOPOPT"
    elif type cvlc > /dev/null 2>&1; then
      # vlc volume ranges from 0..256
      PLAYER="cvlc --play-and-exit --volume=$((256*VOLUME/100))"
      LOOPOPT="--repeat"
    elif type mplayer > /dev/null 2>&1; then
      PLAYER="mplayer -vo null --volume=$VOLUME"
      LOOPOPT="-loop"
    elif type mpv > /dev/null 2>&1; then
      PLAYER="mpv --vo null --volume=$VOLUME"
      LOOPOPT="--loop=inf"
    elif type mpg321 > /dev/null 2>&1; then
      PLAYER="mpg321 -g $VOLUME"
      LOOPOPT="--loop 0"
    elif type avplay > /dev/null 2>&1; then
      # custom volume not supported
      PLAYER="avplay -nodisp -autoexit"
      LOOPOPT="-loop 0"
    elif type ffplay > /dev/null 2>&1; then
      # custom volume not supported
      PLAYER="ffplay -nodisp -autoexit"
      LOOPOPT="-loop 0"
    else
      if [[ "$CUSTOM_MODE" != "simple" ]]; then
        echo "$ERRORMSG1"
        notify_send "$ERRORMSG1"
        CUSTOM_MODE="simple"
      fi
    fi
    [[ -n "$PLAYER" ]] && echo "## Using $(echo "$PLAYER" | cut -d' ' -f1) for local playback ##"
}

set_volume(){
    if [[ -z "$CUSTOM_VOLUME" ]]
      then
          VOLUME="100"
      else
          VOLUME="$CUSTOM_VOLUME"
    fi
}

set_mode(){
    case "$CUSTOM_MODE" in
      continuous)     automute="automute_continuous"
                      ;;
      interstitial)   automute="automute_interstitial"
                      ;;
      simple)         automute="automute_simple"
                      ;;
      "")             automute="automute_continuous"
                      ;;
      \?)             echo "$ERRORMSG4"
                      exit 1
                      ;;
    esac

    echo "## Ad block mode: $automute ##"
}

set_version(){
  if dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify / \
    org.freedesktop.MediaPlayer2.GetMetadata > /dev/null 2>&1; then
    SPOTIFY_VERSION="legacy"
    xpropcommand=(xprop -spy -name "Spotify Free - Linux Preview"  WM_ICON_NAME)
    getstate="get_state_legacy"
  else
    SPOTIFY_VERSION="beta"
    xpropcommand=(xprop -spy -id "$WINDOWID" _NET_WM_NAME)
    getstate="get_state_beta"
  fi
  echo "## Detected Spotify version: $SPOTIFY_VERSION ##"
}

set_windowid(){
  WINDOWID=$(xdotool search --classname "$BINARY" | tail -1)
  if [[ -z "$WINDOWID" ]]; then
    echo "Spotify not active. Exiting."
    exit 1
  fi
}

setup_vars(){
    set_windowid
    set_version
    set_mode
    set_musicdir
    set_volume
    set_player
}

get_track_info_beta(){
  DBUSOUTPUT=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 \
   org.freedesktop.DBus.Properties.Get  string:'org.mpris.MediaPlayer2.Player' string:'Metadata')

  DBUS_TRACK=$(echo "$DBUSOUTPUT" | grep xesam:trackNumber -A 1 | grep variant | awk '{ printf $3; }')
}

get_pactl_info_beta(){
  pacmd list-sink-inputs | grep -B 25 "application.process.binary = \"$BINARY\""
}

get_state_beta(){
  get_track_info_beta

  # check if track paused
  debuginfo "$(get_pactl_info_beta)"
  if get_pactl_info_beta | grep 'state: CORKED' > /dev/null 2>&1; then
    # wait and recheck
    sleep 0.75
    if get_pactl_info_beta | grep 'state: CORKED' > /dev/null 2>&1; then
      echo "PAUSED:   Yes"
      PAUSED="1"
    fi
    get_track_info_beta
  else
    echo "PAUSED:   No"
    PAUSED="0"
  fi

  if [[ "$DBUS_TRACK" == "0" ]]; then
    echo "AD:       Yes"
    AD="1"
  else
    echo "AD:       No"
    AD="0"
  fi

  # check if local player running
  if ps -p "$ALTPID" > /dev/null 2>&1
    then
        echo "LOCAL:    Yes"
        LOCPLAY="1"
    else
        echo "LOCAL:    No"
        LOCPLAY="0"
  fi

  debuginfo "admute: $ADMUTE; pausesignal: $PAUSESIGNAL; adfinished: $ADFINISHED"
}

get_state_legacy(){
  DBUSOUTPUT=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify / \
  org.freedesktop.MediaPlayer2.GetMetadata)

  XPROP_TRACKDATA="$(echo "$XPROPOUTPUT" | cut -d\" -f 2- | sed 's/"$//g')"

  debuginfo "XPROP_DEBUG: $XPROPOUTPUT"
  debuginfo "DBUS_DEBUG:  $DBUSOUTPUT"
  echo "XPROP:    $XPROP_TRACKDATA"

  # check if track paused
  if [[ "$XPROP_TRACKDATA" = "Spotify" || "$XPROP_TRACKDATA" = "_NET_WM_NAME:  not found." ]]
    then
        echo "PAUSED:   Yes"
        PAUSED="1"
    else
        echo "PAUSED:   No"
        PAUSED="0"
  fi

  if [[ "$DBUS_TRACK" == "0" ]]; then
    echo "AD:       Yes"
    AD="1"
  else
    echo "AD:       No"
    AD="0"
  fi

  # check if local player running
  if ps -p "$ALTPID" > /dev/null 2>&1
    then
        echo "LOCAL:    Yes"
        LOCPLAY="1"
    else
        echo "LOCAL:    No"
        LOCPLAY="0"
  fi

  debuginfo "admute: $ADMUTE; pausesignal: $PAUSESIGNAL; adfinished: $ADFINISHED"

}

get_pactl_nr(){
    LC_ALL=C pacmd list-sink-inputs | awk -v binary="$BINARY" '
            $1 == "index:" {idx = $2}
            $1 == "application.process.binary" && $3 == "\"" binary "\"" {print idx; exit}
        '
    # awk script by Glenn Jackmann (http://askubuntu.com/users/10127/)
    # first posted on http://askubuntu.com/a/180661
}

mute(){
    debuginfo "pactl: mute"
    for PACTLNR in $(get_pactl_nr); do
      pactl set-sink-input-mute "$PACTLNR" yes > /dev/null 2>&1
      echo "## Muting sink $PACTLNR ##"
    done
    ADMUTE=1
}

unmute(){
    debuginfo "pactl: unmute"
    for PACTLNR in $(get_pactl_nr); do
        pactl set-sink-input-mute "$PACTLNR" no > /dev/null 2>&1 ## unmute
        echo "## Unmuting sink $PACTLNR ##"
    done
    ADMUTE=0
}

stop_localplayback(){
    kill -s TERM "$ALTPID" 2> /dev/null
    [[ -f "$PIDFILE" ]] && PLAYER_PID="$(cat "$PIDFILE")"
    kill -s TERM "$PLAYER_PID" 2> /dev/null
}

spotify_dbus(){
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 \
    org.mpris.MediaPlayer2.Player."$1" > /dev/null 2>&1
    debuginfo "dbus: $1"
}

player(){
    RANDOM_TRACK="$(find "$LOCAL_MUSIC" -iname "*.mp3" | sort --random-sort | head -1)"
    notify_send "Playing ${RANDOM_TRACK##$LOCAL_MUSIC/}"
    ${PLAYER} $2 "$RANDOM_TRACK" > /dev/null 2>&1 &           # Play random track
    PLAYER_PID="$!"                                           # Get PLAYER PID
    echo "$PLAYER_PID" > "$PIDFILE"                           # Store player PID
    wait "$PLAYER_PID"                                        # Wait for player to
                                                              # exit before continuing

    spotify_dbus $1                                           # Continue Spotify playback.
                                                              # This triggers the xprop spy and
                                                              # subsequent actions like unmuting
}

automute_continuous(){
    # no ad, first track
    if [[ "$AD" = "0" && "$PAUSED" = "0" && "$ADMUTE" = "0" &&  \
     "$INITIALRUN" = "1" ]]
      then
          echo "## Initial run ##"
          unmute
          INITIALRUN="0"

    # no ad, regular track
    elif [[ "$AD" = "0" && "$PAUSED" = "0" && "$ADMUTE" = "0" &&  \
     "$INITIALRUN" = "0" ]]
      then
          echo "## Regular track ##"

    # no ad, regular pause
    elif [[ "$AD" = "0" && "$PAUSED" = "1" && "$ADMUTE" = "0" &&  \
     "$INITIALRUN" = "0" ]]
      then
          echo "## Paused by User ##"

    # ad finished
    elif [[ "$AD" = "0" && "$PAUSED" = "0"  && "$ADMUTE" = "1" &&  \
      "$LOCPLAY" = "1" && "$PAUSESIGNAL" = "0" && "$ADFINISHED" = "0" ]]
      then
          echo "## Pausing Spotify until local playback finished / user interrupt ##"
          ADFINISHED=1
          spotify_dbus Pause

    # ad finished, next track paused
    elif [[ "$AD" = "0" && "$PAUSED" = "1"  && "$ADMUTE" = "1" &&  \
      "$LOCPLAY" = "1" && "$PAUSESIGNAL" = "0" && "$ADFINISHED" = "1" ]]
      then
          echo "## Paused by AdKiller ##"
          PAUSESIGNAL=1
          spotify_dbus Pause

    # ad, manual pause
    elif [[ "$AD" = "0" && "$PAUSED" = "1"  && "$ADMUTE" = "1" &&  \
      "$LOCPLAY" = "1" && "$PAUSESIGNAL" = "0" && "$ADFINISHED" = "0" ]]
      then
          echo "## Paused during ad by User ##"
          notify_send "Ad is still on. Please wait for a moment."
          spotify_dbus Play

    # ad, manual pause
    elif [[ "$AD" = "1" && "$PAUSED" = "1"  && "$ADMUTE" = "1" &&  \
      "$LOCPLAY" = "1" && "$PAUSESIGNAL" = "0" && "$ADFINISHED" = "0" ]]
      then
          echo "## Paused during ad by User ##"
          notify_send "Ad is still on. Please wait for a moment."
          spotify_dbus Play

    # ad finished, user unpaused/switched track
    elif [[ "$AD" = "0" && "$PAUSED" = "0"  && "$ADMUTE" = "1" &&  \
      "$LOCPLAY" = "1" && "$PAUSESIGNAL" = "1" && "$ADFINISHED" = "1" ]]
      then
          echo "## Interrupting local playback ##"
          notify_send "Local playback interrupted"
          stop_localplayback
          unmute
          PAUSESIGNAL=0
          ADFINISHED=0

    # ad finished, local playback finished
    elif [[ "$AD" = "0" && "$PAUSED" = "0"  && "$ADMUTE" = "1" &&  \
      "$LOCPLAY" = "0" && "$PAUSESIGNAL" = "1" && "$ADFINISHED" = "1" ]]
      then
          echo "## Switching back to Spotify ##"
          unmute
          PAUSESIGNAL=0
          ADFINISHED=0

    # ad still on, local playback finished
    elif [[ "$AD" = "1" && "$PAUSED" = "0"  && "$ADMUTE" = "1" &&  \
      "$LOCPLAY" = "0" && "$PAUSESIGNAL" = "0" && "$ADFINISHED" = "0" ]]
      then
          echo "## Playing next local track ##"
          mute
          player Play > /dev/null 2>&1 &
          ALTPID="$!"

    # ad started
    elif [[ "$AD" = "1" && "$PAUSED" = "0"  && "$ADMUTE" = "0" &&  \
      "$LOCPLAY" = "0" && "$PAUSESIGNAL" = "0" && "$ADFINISHED" = "0" ]]
      then
          echo "## Switching to local playback ##"
          mute
          player Play > /dev/null 2>&1 &
          ALTPID="$!"

    # second ad / manual unpause while ad is on
    elif [[ "$AD" = "1" && "$PAUSED" = "0"  && "$ADMUTE" = "1" &&  \
      "$LOCPLAY" = "1" && "$PAUSESIGNAL" = "0" && "$ADFINISHED" = "0" ]]
      then
          echo "## Keep local playback running ##"

    # any other unknown condition -> restore state
    else
      echo "## Restoring state ##"
      unmute
      ADMUTE=0
      PAUSED=0
      LOCPLAY=0
      PAUSESIGNAL=0
      ADFINISHED=0

    fi
}

automute_simple(){
    # no ad, first track
    if [[ "$AD" = "0" && "$PAUSED" = "0" && "$ADMUTE" = "0" &&  \
     "$INITIALRUN" = "1" ]]
      then
          echo "## Initial run ##"
          unmute
          INITIALRUN="0"

    # no ad, regular track
    elif [[ "$AD" = "0" && "$PAUSED" = "0" && "$ADMUTE" = "0" &&  \
     "$INITIALRUN" = "0" ]]
      then
          echo "## Regular track ##"

    # no ad, regular pause
    elif [[ "$AD" = "0" && "$PAUSED" = "1" && "$ADMUTE" = "0" &&  \
     "$INITIALRUN" = "0" ]]
      then
          echo "## Paused by User ##"

    # ad finished
    elif [[ "$AD" = "0" && "$PAUSED" = "0"  && "$ADMUTE" = "1" ]]
      then
          unmute

    # ad started
    elif [[ "$AD" = "1" && "$PAUSED" = "0"  && "$ADMUTE" = "0" ]]
      then
          mute

    # another ad
    elif [[ "$AD" = "1" && "$PAUSED" = "0"  && "$ADMUTE" = "1" ]]
      then
          mute

    # any other unknown condition -> restore state
    else
      echo "## Restoring state ##"
      unmute
      ADMUTE=0
      PAUSED=0
      ADFINISHED=0

    fi
}

automute_interstitial(){
    # no ad, first track
    if [[ "$AD" = "0" && "$PAUSED" = "0" && "$ADMUTE" = "0" &&  \
     "$INITIALRUN" = "1" ]]
      then
          echo "## Initial run ##"
          unmute
          INITIALRUN="0"

    # no ad, regular track
    elif [[ "$AD" = "0" && "$PAUSED" = "0" && "$ADMUTE" = "0" &&  \
     "$INITIALRUN" = "0" ]]
      then
          echo "## Regular track ##"

    # no ad, regular pause
    elif [[ "$AD" = "0" && "$PAUSED" = "1" && "$ADMUTE" = "0" &&  \
     "$INITIALRUN" = "0" ]]
      then
          echo "## Paused by User ##"

    # ad finished
    elif [[ "$AD" = "0" && "$PAUSED" = "0"  && "$ADMUTE" = "1" &&  \
      "$LOCPLAY" = "1" ]]
      then
          echo "## Interrupting local playback ##"
          stop_localplayback
          unmute

    # ad, manual pause
    elif [[ "$AD" = "0" && "$PAUSED" = "1"  && "$ADMUTE" = "1" &&  \
      "$LOCPLAY" = "1" ]]
      then
          echo "## Paused by User during ad  ##"
          notify_send "Ad is still on. Please wait for a moment."
          spotify_dbus Play

    # ad started
    elif [[ "$AD" = "1" && "$PAUSED" = "0"  && "$ADMUTE" = "0" &&  \
      "$LOCPLAY" = "0" ]]
      then
          echo "## Switching to local playback ##"
          mute
          player Play "$LOOPOPT" > /dev/null 2>&1 &
          ALTPID="$!"

    # second ad / manual unpause while ad is on
    elif [[ "$AD" = "1" && "$PAUSED" = "0"  && "$ADMUTE" = "1" &&  \
      "$LOCPLAY" = "1" ]]
      then
          echo "## Keep local playback running ##"

    # any other unknown condition -> restore state
    else
      echo "## Restoring state ##"
      unmute
      ADMUTE=0
      PAUSED=0
      LOCPLAY=0
      PAUSESIGNAL=0
      ADFINISHED=0

    fi
}

restore_settings(){
    echo "## Restoring settings ##"
    # terminate PLAYER if still running
    stop_localplayback
    [[ -f "$PIDFILE" ]] && rm "$PIDFILE"
    # I would love to restore the mute state here but unfortunately it's impossible.
    # `pactl` can only control active sinks, i.e. if Spotify isn't running we can't
    # control its mute state. So we have to resort to unmuting Spotify on every initial
    # run of this script (INITIALRUN=1)
    # However, we can always unmute the Spotify sink if it is running.
    if pgrep spotify &>/dev/null; then unmute; fi
}

## PREPARATION

# read configuration file
read_config

# create PIDFILE for inter-process-communication
PIDFILE="$(mktemp -u --tmpdir "${0##*/}.XXXXXXXX")"

# make sure to restore settings upon exit
trap restore_settings EXIT

# setup player, music directory, and volume
setup_vars

## MAIN

while read XPROPOUTPUT; do

    $getstate

    $automute

    print_horiz_line

done < <("${xpropcommand[@]}")   # we use process substitution instead of piping
                                 # to avoid executing the loop in a subshell

echo "Spotify not active. Exiting."
