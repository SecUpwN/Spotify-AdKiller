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

WMTITLE="Spotify - Linux Preview"
COUNTER="0"
ERRORMSG1="Error: Spotify not found."

notify_send(){
    notify-send -i spotify-client "Spotify-AdKiller" "$1"
}



# no need to supply full path to executable if
# spotify is in PATH
spotify "$@" > /dev/null 2>&1 &

# wait for spotify to launch
# if spotify not launched after 50 seconds
# exit script
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

# only launch script if it isn't active already
if [[ -z "$(pgrep spotify-adkill)" ]]
  then
      # no need to supply full path to executable if
      # spotify_adkiller.sh is in PATH
      spotify-adkiller.sh > /dev/null 2>&1 &
fi
