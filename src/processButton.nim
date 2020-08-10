import gintro/[gtk]
import virtualKeyboard
import x11/keysym
import commonVars, numLockButton

let pressKeyProc = pressKeyXTest

proc numpadButtonClicked*(button: Button) =
  echo button.name
  case button.name:
    of "buttonNumLock":
      pressKeyProc(XK_Num_Lock)
      checkNumLockIndicator()
    of "button1":
      pressKeyProc(XK_KP_1)
    of "button2":
      pressKeyProc(XK_KP_2)
    of "button3":
      pressKeyProc(XK_KP_3)
    of "button4":
      pressKeyProc(XK_KP_4)
    of "button5":
      pressKeyProc(XK_KP_5)
    of "button6":
      pressKeyProc(XK_KP_6)
    of "button7":
      pressKeyProc(XK_KP_7)
    of "button8":
      pressKeyProc(XK_KP_8)
    of "button9":
      pressKeyProc(XK_KP_9)
    of "button0":
      pressKeyProc(XK_KP_0)
    of "buttonDot":
      pressKeyProc(XK_KP_Separator)
    of "buttonDivide":
      pressKeyProc(XK_KP_Divide)
    of "buttonMultiply":
      pressKeyProc(XK_KP_Multiply)
    of "buttonSubtract":
      pressKeyProc(XK_KP_Subtract)
    of "buttonAdd":
      pressKeyProc(XK_KP_Add)
    of "buttonEnter":
      pressKeyProc(XK_KP_Enter)
    of "buttonBackspace":
      pressKeyProc(XK_BackSpace)
    else:
      echo "Unknown button!"
  GC_fullCollect()