import oldgtk3/[gtk, glib]

proc first*(glist: ptr pointer): pointer =
  cast[GList](glist).first().data
proc nth*(glist: ptr pointer, i: int): pointer =
  cast[GList](glist).nth(i.cuint).data

iterator items(glist: GList): pointer =
  for i in 0 ..< glist.length():
    yield glist.nth(i).data

proc toSeq*(glist: ptr pointer): seq[pointer] =
  var glist = cast[GList](glist)
  for item in glist.items():
    result.add(item)

proc name*(widget: pointer): string =
  $widget.widget().getName()