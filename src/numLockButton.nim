import gintro/[gtk]
import commonVars, virtualKeyboard

proc setNumLockIndicator(state: bool) =
  builder.getRevealer("buttonNumLockRevealer").revealChild = state

proc checkNumLockIndicator*() =
  if getModifierState(Indicator.numLock):
    setNumLockIndicator(true)
  else:
    setNumLockIndicator(false)