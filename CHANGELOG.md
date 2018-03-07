# CHANGELOG of 'Spotify-AdKiller'
---------------------------------

#### 07.03.2018

* Changed: Use DNS blocking instead of muting

#### 03.04.2016

* Changed: Now showing full path in local-track notification for more information
* Fixed: Set default mode to `continuous` in code as specified in dafault config
* Fixed: Set Volume of local playback before generating the `PLAYER` command

---

#### 24.03.2016

* Changed: Now waiting a bit before determining playback status on Spotify 1.x
* Added: Debugging output for `pulseaudio` added to ` spotify-adkiller.sh`

---

#### 19.03.2016

* Fixed: Correctly list missing dependencies

---

#### 05.02.2016

* Updated: Clarified intention of this project in our project `README`

---

#### 04.01.2016

* Updated: Arch linux installation instructions received refreshed `AUR Package`

---

#### 03.01.2016

* Removed: Purged unmaintained projects from `Similar Projects` in our `README`
* Updated: Ad detection method got another try to catch one more ad corner case
* Updated: Playback status is now being determined based on `pulseaudio`
* Added: New checkdep function to check the existence of needed dependencies
* Fixed: Our script would sometimes fall into a loop of pausing/unpausing playback

---

#### 02.01.2016

* Changed: Several small improvements of our `README` for better readability

---

#### 31.12.2015

* Changed: Restored compatibility with Spotify 0.9.x while retaining compatibility with Spotify 1.0.x and future releases
* Changed: Set default automute mode to `automute_simple`, now using more robust string manipulation
* Removed: Purged dependencies `gawk`and `wmctrl`, added `xdotool` dependency to our `README` instead

---

#### 03.12.2015

* Added: `wmctrl` dependency has been added to our `README` to fix `Spotify not active. Exiting.`

---

#### 24.11.2015

* Removed: `exit 0` has been purged since bash will `exit 0`, if nothing exits with 1 before

---

#### 12.11.2015

* Added: Compatibility with Spotify 1.0.14 without deps on python, now parsing dbus output with `awk`

#### 16.09.2015

* Removed: Purged `CUSTOM_ALERT` because it was causing issues with VLC (on top of being annoying)

#### 28.08.2015

* Fixed: `install.sh` is now using the right folder to check for existing config files

#### 19.07.2015

* Added: Linked project `spotify-blacklist-mute` in our `README`

#### 17.03.2015

* Added: Integrated correct muting of multiple ads when in simple operation mode

---

#### 06.03.2015

* Changed: Reverted changes related to ad detection based on empty `DBUS` output
* Added: New section in `README`on compatibility with past and future Spotify releases

---

#### 04.03.2015

* Fixed: Resolved false positives due to empty `DBUS` output at startup

---

#### 28.02.2015

* Changed: Use more elegant text processing, as suggested by @quietoparado
* Fixed: Resolved rare instances where `DBUS` output has been empty

---

#### 25.02.2015

* Added: Arch Linux Installation Instruction including a `PKGBUILD` by @Timidger
* Fixed: `Spotify-AdKiller` now handles unknown conditions more graciously
* Fixed: Resolved rare startup condition where the xprop output was empty

---

#### 09.02.2015

* Changed: Window title changed to newer "Spotify Free - Linux Preview"
* Removed: Many trailing spaces removed and code cleaned a little more
* Fixed: "Error: Spotify not found" has been fixed with new title detection

---

#### 31.12.2014

* Updated: Small updates of `README` with re-added header artwork
* Updated: Several style updates throughout our whole `CHANGELOG.md`
* Changed: Launcher comment now matches wording of our respository
* Added: `.gitignore` has been added to avoid upload of garbage

---

#### 15.08.2014

* Added: `CUSTOM_LOOPOPT` to support your own custom loop options
* Improved: fall back to simple mode if no supported player found

---

#### 08.08.2014

* Improved: Feltzer changed some formatting and phrasing here and there
* Added: Section on related projects to make people contribute there, too

---

#### 01.07.2014

* Fixed: Feltzer nuked a few Issues with the Installer and updated the `README`

---

#### 09.06.2014

* Changed: Moved config file setup from AdKiller to `spotify-wrapper`
* Improved: `DEBUG` setting now enables log file
* Improved: Added `DEBUG` setting to configuration file
* Improved: Check if installation directory is part of system `PATH`
* Added: Spacing between Installer outputs and colors for Warnings
* Fixed: Set `XDG` paths in a more safe and generic manner
* Fixed: Corrected `CONFIGDIR` to be correctly detected by openSUSE

---

#### 08.06.2014

* Added: `XPROP/DBUS` debug output to fix Issues more easily

---

#### 07.06.2014

* Improved: Completely rewrote script logic to fix most false positives/negatives in ad detection
* Improved: Added ability to skip local track in continuous mode
* Improved: Added two new ad blocking modes (simple and interstitial)
* Improved: Added configuration file
* Imprvoed: Added desktop launcher
* Improved: Added installation script
* Improved: Added debug switch
* Improved: Various other small things
* Fixed: Automatically switch to 'simple' mode if no audio files found

---

#### 06.06.2014

* Improved: Several smaller code improvements and more comments on the code
* Fixed: Changed music directory autodetection and substring matching, added a few checks

---

#### 05.06.2014

* Improved: Aligned variables of `XPROPOUTPUT` (yes, I admit it: I'm a perfectionist!)
* Improved: Updated installation command for required utilities on openSUSE
* Fixed: AdKiller would return false positives if song title contained double-quotes
* Fixed: Empty `XPROP_TRACKDATA` when playback paused + made `DBUS` parsing more safe

---

#### 04.06.2014

* Improved: Added Links to our new `CHANGELOG.md` and beautified some very tiny code snippets
* Changed: `DBUS/XPROP` comparison method (old one was failing on certain special characters)
* Changed: Reordered `choose_player()` by player popularity/availability
* Fixed: Removed a debug call to `player()` causing the script to keep on switching to local playback
* Fixed: Quoted `LOCALMUSIC` properly, enabling local playback if the user set a custom music path with spaces

---

#### 03.06.2014

* Added: Really **AWESOME FIRST PULL REQUEST** by Feltzer with huge re-write and improvements!
* Added: Spotify-AdKiller automatically chooses music player (mpv, vlc, mplayer, mpg321, avplay or ffplay)
* Added: Music player can be overridden with a custom music player setting
* Added: Music player volume can now be chosen
* Added: Spotify-AdKiller automatically chooses default Music folder based on `XDG` specifications
* Improved: Changed `ALERT` to freedesktop standard, added a lot more comments and fixed typos
* Improved: The `README` of Spotify-AdKiller now contains a section on dependencies
* Improved: Expanded `README` section on installation and made it more generic
* Improved: Added `README` section on settings and added important notes as well as trademark statement
* Fixed: Spotify stopping when Ad plays
* Fixed: Exiting the script kills all running instances of mpv
* Fixed: Exiting script while local playback is active leaves Spotify muted
* Fixed: Script will launch multiple times when opening Spotify URIs through a browser
* Fixed: Spotify-AdKiller does not start if Spotify takes to long too launch (race condition)
* Fixed: Script will mute unrelated applications under some circumstances
* Fixed: Removed literal quotation of `$DBUS_TRACKDATA` as recommended by jetchisel

---

#### 02.06.2014

* Added: Support for international naming of the local music folder which contains the MP3's

---

#### 01.06.2014 - Birthday of Spotify-AdKiller!

* I woke up in the middle of the night and could not sleep any longer always thinking about the script
* My mission was to adopt this awesome script and give it a real home: Spotify-Adkiller was born! ;-)
* Added: Attempt to call generic Spotify name (the binary is named differently on my openSUSE)

---

#### 30.05.3014

Fixed: Locale Issue where muting and unmuting didn't work anymore resolved by hairyheron

---

#### 23.05.2014

* I discovered the original Gist while planning my own Party and listening to creepy Spotify-Ads
* The script worked great, but GitHub-Gist was a bad place to report Issues or mention Users
* The same night, I fell in love with the original script and continously thought about it

---

#### 22.05.2014

* Huge re-write by Feltzer to automatically mute Spotify when an ad comes on and loop an audio file
* Instructions on how to install and use his script where also added by Feltzer in the old Gist

---

#### 12.04.2014

* Another re-write by AmpGod to detect DBus information and support icecast audio streamer

---

#### 25.03.2014

* Added: Code by bigeebeans to support playing a radiostream via VLC

---

#### 19.03.2014

* Spanish users did profit from further recommendations by fernandolguevara

---

#### 17.03.2014

* Fixed: "You have to specify a sink input index and a mute boolean" erased by AmpGod

---

#### 04.03.2014

* Updated: Script now supports icecast with song information thanks to AmpGod

---

#### 16.08.2013

* Improved: Code now supports language-independent locale thanks to jakicoll

---

#### 25.07.2013

* Smaller modifications to enhance the code have been done by anupdhml
* Discussion of the current codebase to improve playback went on for numerous days

---

#### 05.07.2013

* Re-write of the script to support the latest version of Spotify by OlegSmelov
* People extensively tested the very elegant method created by him - wokring awesome!

---

#### 16.10.2012

* Useful code change for muting and unmuting Ads by sbenkk
* Smaller improvements and chit-chat on GitHub Gist followed thereafter

---

#### 08.10.2012

* Recommendation with code for playing internet radio instead of Ads by EDawg878

---

#### 30.09.2012

* First recommendation with code for improvements to mute just Spotify by bim9262

---

#### 29.07.2012

* GitHub-User pcworld launched the initial version of his script on GitHub Gist. THANK YOU!
* (If you're curious, have a glance into the past on https://gist.github.com/pcworld/3198763)
