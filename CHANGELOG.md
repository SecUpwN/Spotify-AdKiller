# CHANGELOG of 'Spotify-AdKiller'
--------------------------------

# 09.06.2014

* Changed: Moved config file setup from AdKiller to Wrapper
* Improved: DEBUG setting now enables log file
* Improved: Added DEBUG setting to configuration file
* Fix: Set XDG paths in a more safe and generic manner
* Improved: Check if installation directory is part of system PATH
* Added: Spacing between Installer outputs and colors for Warnings
* Fix: Corrected CONFIGDIR to be correctly detected by openSUSE

# 08.06.2014

* Added: XPROP/DBUS debug output to fix Issues more easily

# 07.06.2014

* Improved: Completely rewrote script logic. This should fix most of the issues with false positives/negatives in ad detection
* Improved: Added ability to skip local track in continuous mode
* Improved: Added two new ad blocking modes (simple and interstitial)
* Improved: Added configuration file
* Imprvoed: Added desktop launcher
* Improved: Added installation script
* Improved: Added debug switch
* Improved: Various other small things
* Fix: Automatically switch to 'simple' mode if no audio files found

# 06.06.2014

* Improved: Several smaller code improvements and more comments on the code
* Fix: Changed music directory autodetection and substring matching, added a few checks

# 05.06.2014

* Fix: AdKiller would return false positives if song title contained double-quotes
* Improved: Aligned variables of XPROPOUTPUT (yes, I admit it: I'm a perfectionist!)
* Improved: Updated installation command for required utilities on openSUSE
* Fix: Empty XPROP_TRACKDATA when playback paused + made DBUS parsing more safe

# 04.06.2014

* Fix: Removed a debug call to player(), which caused the script to keep on switching to local playback
* Fix: Quoted LOCALMUSIC properly, which enables local playback if the user set a custom music path with spaces
* Improved: Added Links to our new CHANGELOG and beautified some very tiny code snippets
* Changed: DBUS/XPROP comparison method (old one was failing on certain special characters)
* Changed: Reordered choose_player() by player popularity/availability

# 03.06.2014

* Fix: Removed literal quotation of $DBUS_TRACKDATA as recommended by jetchisel
* Really **AWESOME FIRST PULL REQUEST** by Feltzer with huge re-write and improvements:
* Fix: Spotify stopping when Ad plays
* Fix: Exiting the script kills all running instances of mpv
* Fix: Exiting script while local playback is active leaves Spotify muted
* Fix: Script will launch multiple times when opening Spotify URIs through a browser
* Fix: AdKiller does not start if Spotify takes to long too launch (race condition)
* Fix: Script will mute unrelated applications under some circumstances
* Added: Spotify-AdKiller automatically chooses music player (mpv, vlc, mplayer, mpg321, avplay or ffplay)
* Added: Music player can be overridden with a custom music player setting
* Added: Music player volume can now be chosen
* Added: Spotify-AdKiller automatically chooses default Music folder based on XDG specifications
* Improved: Changed ALERT to freedesktop standard, added a lot more comments and fixed typos
* Improved: The README of Spotify-AdKiller now contains a section on dependencies
* Improved: Expanded README section on installation and made it more generic
* Improved: Added README section on settings and added important notes as well as trademark statement

# 02.06.2014

* Added support for international naming of the local music folder which contains the MP3's

# 01.06.2014

* I woke up in the middle of the night and could not sleep any longer always thinking about the script
* My mission was to adopt this awesome script and give it a real home: Spotify-Adkiller was born! ;-)
* Added: Attempt to call generic Spotify name (the binary is named differently on my openSUSE)

# 30.05.3014

Fix: Locale Issue where muting and unmuting didn't work anymore resolved by hairyheron

# 23.05.2014

* I discovered the original Gist while planning my own Party and listening to creepy Spotify-Ads
* The script worked great, but GitHub-Gist was a bad place to report Issues or mention Users
* The same night, I fell in love with the original script and continously thought about it

# 22.05.2014

* Huge re-write by Feltzer to automatically mute Spotify when an ad comes on and loop an audio file
* Instructions on how to install and use his script where also added by Feltzer in the old Gist

# 12.04.2014

* Another re-write by AmpGod to detect DBus information and support icecast audio streamer

# 25.03.2014

* Added: Code by bigeebeans to support playing a radiostream via VLC

# 19.03.2014

* Spanish users did profit from further recommendations by fernandolguevara

# 17.03.2014

* Fix for "You have to specify a sink input index and a mute boolean" by AmpGod

# 04.03.2014

* Great update to support updates to icecast with song information by AmpGod

# 16.08.2013

* Improvements to the code for support of language-independent locale by jakicoll

# 25.07.2013

* Smaller modifications to enhance the code have been done by anupdhml
* Discussion of the current codebase to improve playback went on for numerous days

# 05.07.2013

* Re-write of the script to support the latest version of Spotify by OlegSmelov
* People extensively tested the very elegant method created by him - wokring awesome!

# 16.10.2012

* Useful code change for muting and unmuting Ads by sbenkk
* Smaller improvements and chit-chat on GitHub Gist followed thereafter

# 08.10.2012

* Recommendation with code for playing internet radio instead of Ads by EDawg878

# 30.09.2012

* First recommendation with code for improvements to mute just Spotify by bim9262

# 29.07.2012

* GitHub-User pcworld launched the initial version of his script on GitHub Gist. THANK YOU!
* (If you're curious, have a glance into the past on https://gist.github.com/pcworld/3198763)
