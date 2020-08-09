'Geometry Parameters Setup'

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
Dim slot_teeth_width 'internal variable'
slot_teeth_width = (slots-1)*slot_pitch+slot_gap


'Winding Setup'
Dim coil_core_separation_x 'minimum separation between core and coil (one-sided, x-direction)'
Dim coil_core_separation_y 'minimum separation between core and coil (one-sided, y-direction)'
Dim distribute_distance 'distributed winding distance, in # of slots'

Dim coil_width 'coil x length value'
Dim coil_height 'coil y length value'


coil_core_separation_x = 1
coil_core_separation_y = 1
distribute_distance = 2


coil_width = slot_gap-2*coil_core_separation_x
coil_height = (slot_height-3*coil_core_separation_y)/2

'Material Setup'
Dim core_material
Dim air_material

core_material = "M330-35A"
coil_material = "Copper: 5.77e7 Siemens/meter"
air_material = "AIR"


'Document Setup'
Call newDocument()
Call SetLocale("en-us")
Call getDocument().setDefaultLengthUnit("Millimeters")
Set view = getDocument().getView()


'main()'
Call view.getSlice().moveInALine(-length_core/2)
Call make_core_component()
Call clear_construction_lines()
Call make_winding()
'end main'



Function format_material(material)
  format_material = "Name="+material
End Function


Function draw_core_geometry()
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

  REDIM component_name(0)
  component_name(0) = "Core 1"
  Call view.makeComponentInALine(length_core,component_name,format_material(core_material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
End Function


Function clear_construction_lines()
  Call view.selectAll(infoSetSelection, Array(infoSliceLine, infoSliceArc))
  Call view.deleteSelection()
End Function


Function make_winding()
  lx1 = -slot_teeth_width/2+coil_core_separation_x
  rx1 = -slot_teeth_width/2+coil_core_separation_x+coil_width
  by1 = coil_core_separation_y
  ty1 = coil_core_separation_y+coil_height
  lx2 = lx1+distribute_distance*slot_pitch
  rx2 = rx1+distribute_distance*slot_pitch
  by2 = slot_height-ty1
  ty2 = slot_height-by1

  Call view.newLine(lx1,by1,rx1,by1)
  Call view.newLine(lx1,ty1,rx1,ty1)
  Call view.newLine(lx1,by1,lx1,ty1)
  Call view.newLine(rx1,by1,rx1,ty1)

  Call view.getSlice().moveInALine(length_core/2)
  Call view.selectAt((lx1+rx1)/2,(ty1+by1)/2, infoSetSelection, Array(infoSliceSurface))

  Dim component_name_val
  component_name_val = "Coil#1"
  component_name = Array(component_name_val)

  init_coords = Array((lx1+rx1)/2,(by1+ty1)/2,0)
  unit_x_vec = Array(1,0,0)
  unit_y_vec = Array(0,1,0)
  unit_z_vec = Array(0,0,1)

  frame_params = Array("Frame","Cartesian",init_coords,unit_x_vec,unit_y_vec,unit_z_vec)
  start_frame = Array("Start")
  blend_frame = Array("Blend","Automatic")

  line_frame_1 = Array("Line",Array(0,0,length_core/2+coil_width/2+coil_core_separation_x))
  line_frame_2 = Array("Line",Array((lx2+rx2)/2-(lx1+rx1)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_width/2+coil_core_separation_x))
  line_frame_3 = Array("Line",Array((lx2+rx2)/2-(lx1+rx1)/2,(ty2+by2)/2-(ty1+by1)/2,0))

  multi_sweep_params = Array(frame_params,start_frame,line_frame_1,blend_frame,line_frame_2,blend_frame,line_frame_3)

  Call view.makeComponentInAMultiSweep(multi_sweep_params,component_name,format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)

  Call getDocument().beginUndoGroup("Mirror Component")
  Call getDocument().mirrorComponent(getDocument().copyComponent(component_name, 1), 0, 0, 0, 0, 0, 1, 1)
  Call getDocument().endUndoGroup()

  copy_keyword = " Copy#1"
  union_keyword = " Union#1"
  components = Array(component_name_val,component_name_val+copy_keyword)

  Call getDocument().beginUndoGroup("Union Components")
  If (getDocument().unionComponents(components,2,ErrorMessages) <> "") Then
    Call getDocument().getView().selectObject(component_name_val, infoSetSelection)
    Call getDocument().getView().selectObject(component_name_val+copy_keyword, infoAddToSelection)
    Call getDocument().getView().deleteSelection()
  Else
    Call getDocument().getView().unselectAll()
    Call getApplication().MsgBox("An error occurred doing the union operation:" & vbLf & ErrorMessages, vbOKOnly)
  End If
  Call getDocument().endUndoGroup()

  Call getDocument().beginUndoGroup("Set Coil Properties", true)
  Call getDocument().renameObject(component_name_val+"+"+component_name_val+copy_keyword+union_keyword,component_name_val)
  Call getDocument().endUndoGroup()

End Function
