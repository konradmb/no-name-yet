import gintro/[gtk]
import os

const gettextPackage* = "my_app"
const appId* = "com.konradmb.my_app"
const iconFilename* = "my_app-icon.svg"
const appPrettyName* = "My App"

let appdir* = os.getAppDir() / "/"

let builder*: Builder = newBuilder()
var mainWindow*: ApplicationWindow

var resultLabel*: Label