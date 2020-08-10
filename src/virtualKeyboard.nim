# import libevdev/libevdev
import extra/libevdev_uinput, extra/linux/input
import X11/x, X11/xlib, X11/xtst, X11/keysym, X11/xkblib
import os

var numLockEnabledOnStart = false

proc pressKeyEvdev*(key: cuint) = 
  var err: cint
  var dev: ptr libevdev
  var uidev: ptr libevdev_uinput
  dev = libevdev_new()
  libevdev_set_name(dev, "fake keyboard device")
  echo libevdev_enable_event_type(dev, EV_KEY)
  echo libevdev_enable_event_code(dev, EV_KEY, key, nil)
  err = libevdev_uinput_create_from_device(dev, LIBEVDEV_UINPUT_OPEN_MANAGED.cint,
      addr(uidev))
  if err != 0:
    echo err
  sleep(500)
  echo libevdev_uinput_write_event(uidev, EV_KEY, key, 1)
  echo libevdev_uinput_write_event(uidev, EV_SYN, SYN_REPORT, 0)
  echo libevdev_uinput_write_event(uidev, EV_KEY, key, 0)
  echo libevdev_uinput_write_event(uidev, EV_SYN, SYN_REPORT, 0)

  sleep(10000)

  libevdev_uinput_destroy(uidev)
  echo "Complete\n"

proc createX11KeyEvent*(display: PDisplay; win: var Window; winRoot: var Window;
                    press: bool; keycode: KeySym; modifiers: cint): XKeyEvent =
  var event: XKeyEvent
  event.display = display
  event.window = win
  event.root = winRoot
  event.subwindow = None
  event.time = CurrentTime
  event.x = 1
  event.y = 1
  event.x_root = 1
  event.y_root = 1
  event.same_screen = true.XBool
  event.keycode = XKeysymToKeycode(display, keycode).cuint
  event.state = modifiers.cuint
  if press:
    event.theType = KeyPress
  else:
    event.theType = KeyRelease
  return event

proc pressKeyX11*(keycode: KeySym) =
  ##  Obtain the X11 display.
  var display: PDisplay = XOpenDisplay(nil)
  if display == nil:
    echo "error"
  var winRoot: Window = XDefaultRootWindow(display)
  ##  Find the window which has the current keyboard focus.
  var winFocus: Window
  var revert: cint
  echo XGetInputFocus(display, addr(winFocus), addr(revert))
  ##  Send a fake key press event to the window.
  var event: XKeyEvent = createX11KeyEvent(display, winFocus, winRoot, true, keycode, 0)
  echo XSendEvent(event.display, event.window, true.XBool, KeyPressMask,
             cast[ptr XEvent](addr(event)))
  ##  Send a fake key release event to the window.
  event = createX11KeyEvent(display, winFocus, winRoot, false, keycode, 0)
  echo XSendEvent(event.display, event.window, true.XBool, KeyPressMask,
             cast[ptr XEvent](addr(event)))
  ##  Done.
  echo XCloseDisplay(display)

proc pressKeyXTest*(keysym: KeySym) =
  var display: PDisplay = XOpenDisplay(nil)
  if display == nil:
    echo "error"
  echo XTestGrabControl(display, true.XBool);
  # if (modsym != 0) {
  #   modcode = XKeysymToKeycode(disp, modsym);
  #   XTestFakeKeyEvent (disp, modcode, True, 0);
  # }
  # /* Generate regular key press and release */
  let keycode = XKeysymToKeycode(display, keysym).cuint
  echo XTestFakeKeyEvent(display, keycode, true.XBool, 0);
  echo XTestFakeKeyEvent(display, keycode, false.XBool, 0); 
  
  # /* Generate modkey release */
  # if (modsym != 0)
  #   XTestFakeKeyEvent (disp, modcode, False, 0);
  
  echo XSync(display, false.XBool);
  echo XTestGrabControl(display, false.XBool);
  echo XCloseDisplay(display)

type Indicator* {.pure.} = enum
  capsLock = "Caps Lock",
  numLock = "Num Lock"

proc getModifierState*(indicator: Indicator): bool =
  var display: PDisplay = XOpenDisplay(nil)
  if display == nil:
    echo "error"
  # var state: uint
  # echo XkbGetIndicatorState(display, XkbUseCoreKbd, cast[PWord](state.addr))
  let atom = XInternAtom(display, $indicator, false.XBool)
  echo xkblib.XkbGetNamedIndicator(display, atom, nil, result.addr, nil, nil)
  echo XCloseDisplay(display)

proc initNumlock*() =
  if not getModifierState(Indicator.numLock):
    pressKeyXTest(XK_Num_Lock)
    numLockEnabledOnStart = true

proc cleanNumLock*() =
  if numLockEnabledOnStart and getModifierState(Indicator.numLock):
    pressKeyXTest(XK_Num_Lock)