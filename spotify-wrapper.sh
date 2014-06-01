#!/bin/bash

# Spotify-Adkiller Respository: https://github.com/SecUpwN/Spotify-AdKiller/
# Feel free to contribute improvements and suggestions to this funky script!

# Wrapper-Script to automatically start Spotify-AdKiller when Spotify starts

# IMPORTANT REMINDER! CAREFULLY READ AND UNDERSTAND THIS PART. THANK YOU.
# -----------------------------------------------------------------------
# Spotify is a fantastic service and worth every penny.
# This script is *NOT* meant to circumvent buying premium.
# Please do consider switching to premium to support Spotify!
# -----------------------------------------------------------------------

$HOME/bin/*spotify "" > /dev/null 2>&1 &
sleep 20
if [[ -z "" ]]
  then
$HOME/bin/spotify-adkiller.sh > /dev/null 2>&1 &
fi
