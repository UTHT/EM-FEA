Dim width_core
Dim thick_core
Dim core_endlengths

Dim slots
Dim slot_pitch
Dim slot_gap
Dim slot_height
Dim slot_teeth_width

Dim teeth_width

width_core = 370
thick_core = 60
core_endlengths = 30
slots = 11
slot_pitch = 40
slot_gap = 20
slot_teeth_width = (slots-1)*slot_pitch+slot_gap
slot_height = 40

core_endlengths = core_endlengths + slot_gap
teeth_width = slot_pitch-slot_gap

Call newDocument()
Call SetLocale("en-us")
Call getDocument().setDefaultLengthUnit("Millimeters")
Set view = getDocument().getView()

Call view.newLine(-width_core/2-core_endlengths,thick_core,width_core/2+core_endlengths,thick_core)
Call view.newLine(width_core/2+core_endlengths,0,width_core/2+core_endlengths,thick_core)
Call view.newLine(-width_core/2-core_endlengths,0,-width_core/2-core_endlengths,thick_core)
' Call view.newLine()

For i=0 to slots-1
  delta = slot_pitch*i
  Call view.newLine(-slot_teeth_width/2+delta,0,-slot_teeth_width/2+delta,slot_height)
  Call view.newLine(-slot_teeth_width/2+slot_gap+delta,0,-slot_teeth_width/2+slot_gap+delta,slot_height)
  Call view.newLine(-slot_teeth_width/2+delta,slot_height,-slot_teeth_width/2+slot_gap+delta,slot_height)
  If(i < slots-1) Then
    Call view.newLine(-slot_teeth_width/2+slot_gap+delta,0,-slot_teeth_width/2+slot_gap+delta+teeth_width,0)
  End If
Next

Call view.newLine(-width_core/2-core_endlengths,0,-slot_teeth_width/2,0)
Call view.newLine(slot_teeth_width/2,0,width_core/2+core_endlengths,0)
