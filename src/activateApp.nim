import gintro/[gtk, gdk, glib, gobject, gio]
import os, strformat, sequtils

import commonVars, loadCss, glist, processButton, virtualKeyboard, numLockButton

proc destroyMainWindow(window: ApplicationWindow) =
  cleanNumLock()

proc moveToLowerRightCorner(window: gtk.Window) =
  var workarea = Rectangle()
  getDefaultDisplay().getPrimaryMonitor().getWorkarea(workarea)
  window.gravity = Gravity.southEast
  window.move(workarea.width, workarea.height)

proc unsetChildrenBackdrop(widget: Container) =
  for widgetPtr in widget.getChildren().toSeq():
    let tmpWidget = Widget()
    echo fmt"widgetPtr: {widgetPtr.repr}, tmpWidget: {tmpWidget.repr}"
    tmpWidget.impl = cast[ptr Widget00](widgetPtr)
    tmpWidget.unsetStateFlags({StateFlag.backdrop})
    echo tmpWidget.name

proc unsetBackdrop(a: bool): bool =
  builder.getGrid("buttonGrid").unsetStateFlags({StateFlag.backdrop})
  # mainWindow.unsetChildrenBackdrop()
  false
  

# proc ev(widget: ApplicationWindow|Button|Grid, sf: StateFlags) =
#   echo fmt"widget: {widget.repr}, sf: {sf}"
#   if widget == nil:
#     return
#   widget.unsetStateFlags({StateFlag.backdrop})
#   widget.unsetChildrenBackdrop()
# proc ev(widget: ApplicationWindow|Grid) =
#   ev(widget, {StateFlag.backdrop})
# proc ev(widget: ApplicationWindow|Grid, s: StateType) =
#   ev(widget, {StateFlag.backdrop})

proc appStartupWithBuilder*(app: Application) = 
  getDefaultIconTheme().prependSearchPath(appdir /../ "data" / "icons")
  getDefaultIconTheme().addResourcePath(appdir /../ "data" / "icons")

  discard builder.addFromFile(appdir /../ "data" / "main.glade")
  mainWindow = builder.getApplicationWindow("mainWindow")
  mainWindow.setApplication(app)
  mainWindow.title = appPrettyName
  if existsFile(appdir / fmt"../data/icons/{iconFilename}"):
    discard mainWindow.setIconFromFile(appdir / fmt"../data/icons/{iconFilename}")

  mainWindow.connect("destroy", destroyMainWindow)
  # mainWindow.connect("composited-changed", ev)
  # builder.getGrid("buttonGrid").connect("composited-changed", ev)
  
  # mainWindow.defaultSize = (413,514)
  mainWindow.moveToLowerRightCorner()
  mainWindow.keepAbove = true
  mainWindow.acceptFocus = false
  # mainWindow.grabFocus()


  # let buttonList = builder.getGrid("buttonGrid").getChildren().toSeq().mapIt(it.name)
  # echo buttonList
  const buttonList = ["button9", "button8", "button7", "button6", "button5", 
    "button4", "buttonEnter", "buttonAdd", "buttonSubtract", "buttonMultiply", 
    "buttonDivide", "buttonNumLock", "buttonDot", "button3", "button2", 
    "button1", "button0", "buttonBackspace"]
  for buttonName in buttonList:
    let button = builder.getButton(buttonName)
    GC_ref(button)
    button.connect("clicked", numpadButtonClicked)
    button.setSizeRequest(width = 100, height = 100)
    button.hexpand=true
    button.vexpand=true

  initNumlock()
  checkNumLockIndicator()

  loadCss()

  showAll(mainWindow)

proc appActivate*(app: Application) =
  mainWindow.present()
  doAssert 0 < timeoutAdd(500, unsetBackdrop, true)
  doAssert 0 < timeoutAdd(1500, unsetBackdrop, true)
  # mainWindow.unsetStateFlags({StateFlag.backdrop})
  # mainWindow.unsetChildrenBackdrop()
  var w,h:int
  mainWindow.getSize(w,h)
  echo w," ", h






