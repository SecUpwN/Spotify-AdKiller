# CHANGELOG of 'Spotify-AdKiller'
--------------------------------

# 04.06.2014

* Fix: Removed a debug call to player(), which caused the script to keep on switching to local playback
* Fix: Quoted LOCALMUSIC properly, which enables local playback if the user set a custom music path with spaces
* Improved: Added Links to our new CHANGELOG and beautified some very tiny code snippets

# 03.06.2014

* Fix: Removed litteral quotation of $DBUS_TRACKDATA as recommended by jetchisel
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

# 2012

* GitHub-User pcworld launched the initial version of his script on GitHub Gist. THANK YOU!
* (If you're curious, have a glance into the past on https://gist.github.com/pcworld/3198763)
