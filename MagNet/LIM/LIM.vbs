Dim width_core 'core width (motion direction)
Dim thick_core 'core thickness (away from track)
Dim length_core 'core length (into the page)
Dim core_endlengths 'core end width

Dim slots 'number of slots'
Dim slot_pitch 'slot pitch'
Dim slot_gap 'slot gap width'
Dim teeth_width 'teeth width'
Dim slot_height 'slot height'

width_core = 370
thick_core = 60
length_core = 50
core_endlengths = 30
slots = 11
slot_pitch = 40
slot_gap = 20
slot_height = 40

core_endlengths = core_endlengths + slot_gap
teeth_width = slot_pitch-slot_gap

Dim core_material
Dim air_material

core_material = "M330-35A"
air_material = "AIR"

'Document Setup'
Call newDocument()
Call SetLocale("en-us")
Call getDocument().setDefaultLengthUnit("Millimeters")
Set view = getDocument().getView()


Function format_material(material)
  format_material = "Name="+material
End Function


Function draw_core_geometry()
  Dim slot_teeth_width
  slot_teeth_width = (slots-1)*slot_pitch+slot_gap
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
End Function


Function make_core_component()
  Call draw_core_geometry()
  Call view.selectAt(0,(thick_core+slot_height)/2,infoSetSelection,Array(infoSliceSurface))

  REDIM ArrayOfValues(0)
  ArrayOfValues(0) = "Core 1"
  Call view.makeComponentInALine(length_core,ArrayOfValues,format_material(core_material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
End Function


'main()'
Call make_core_component()
