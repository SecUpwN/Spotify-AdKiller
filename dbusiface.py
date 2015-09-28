#!/usr/bin/env python3
import dbus
import re
import json

def get_metadata():
    session_bus = dbus.SessionBus()
    proxy = session_bus.get_object("org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2")
    properties = dbus.Interface(proxy, "org.freedesktop.DBus.Properties")
    player = dbus.Interface(proxy, "org.mpris.MediaPlayer2.Player")
    d = properties.Get("org.mpris.MediaPlayer2.Player", "Metadata")
    return d

if __name__=="__main__":
    data = json.loads(json.dumps(get_metadata()))
    print(", ".join(data["xesam:artist"]) + " - " + data["xesam:title"])
