# Package

version       = "0.1.0"
author        = "yourname"
description   = "Example Nim GTK+ app"
license       = "GPL-3.0"
srcDir        = "src"
binDir        = "src"
bin           = @["my_app"]
skipExt       = @["nim"]


# Dependencies

requires "nim >= 1.2.0"
requires "gintro  >= 0.7.3"
requires "oldgtk3"
requires "https://github.com/konradmb/nim_gtk_build >= 0.1.0"
requires "libevdev >= 0.1.0"
requires "x11 >= 1.1"

let packageName = "my_app"
let prettyName = "My App"

include nim_gtk_build




