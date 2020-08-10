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
Dim end_ext

width_core = 370
thick_core = 60
length_core = 50
core_endlengths = 30
slots = 11
slot_pitch = 40
slot_gap = 20
slot_height = 40
end_ext = 15

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


coil_core_separation_x = 4
coil_core_separation_y = 4
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
Call make_windings(make_winding())
'Call make_winding()
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

  Call view.newLine(lx2,by2,rx2,by2)
  Call view.newLine(lx2,ty2,rx2,ty2)
  Call view.newLine(lx2,by2,lx2,ty2)
  Call view.newLine(rx2,by2,rx2,ty2)

  Call view.getSlice().moveInALine(length_core/2)

  Dim coil_p1_name
  Dim coil_p2_name
  Dim coil_name

  coil_p1_name = "Coil#1p1"
  coil_p2_name = "Coil#1p2"
  coil_name = "Coil#1"
  copy_keyword = " Copy#"
  union_keyword = " Union#"

  init_coords = Array((lx1+rx1)/2,(by1+ty1)/2,0)
  unit_x_vec = Array(1,0,0)
  unit_y_vec = Array(0,1,0)
  unit_z_vec = Array(0,0,1)

  frame_params = Array("Frame","Cartesian",init_coords,unit_x_vec,unit_y_vec,unit_z_vec)
  start_frame = Array("Start")
  blend_frame = Array("Blend","Automatic")

  line_frame_1 = Array("Line",Array(0,0,length_core/2+coil_core_separation_x))
  line_frame_2 = Array("Line",Array(((lx2+rx2)/2-(lx1+rx1)/2)/2,0,length_core/2+coil_core_separation_x+end_ext))
  line_frame_3 = Array("Line",Array(((lx2+rx2)/2-(lx1+rx1)/2)/2,0,length_core/2+coil_core_separation_x+end_ext+coil_width))
  arc_frame_4 = Array("Arc",180,Array(((lx2+rx2)/2-(lx1+rx1)/2)/2,(ty2+by2)/4-(ty1+by1)/4,length_core/2+coil_core_separation_x+end_ext+coil_width),Array(-1,0,0))
  line_frame_5 = Array("Line",Array(((lx2+rx2)/2-(lx1+rx1)/2)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_core_separation_x))
  line_frame_6 = Array("Line",Array((lx2+rx2)/2-(lx1+rx1)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_core_separation_x))

  multi_sweep_params = Array(frame_params,start_frame,line_frame_1,blend_frame,line_frame_2,blend_frame,line_frame_3,blend_frame,arc_frame_4)'',blend_frame,line_frame_5)'',blend_frame,line_frame_6)'',blend_frame,line_frame_7)

  Call view.selectAt((lx1+rx1)/2,(ty1+by1)/2, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInAMultiSweep(multi_sweep_params,Array(coil_p1_name),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)

  line_frame_7 = Array("Line",Array((lx2+rx2)/2-(lx1+rx1)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_core_separation_x))
  line_frame_8 = Array("Line",Array(((lx2+rx2)/2-(lx1+rx1)/2)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_core_separation_x+end_ext))
  line_frame_9 = Array("Line",Array(((lx2+rx2)/2-(lx1+rx1)/2)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_core_separation_x+end_ext+coil_width))

  multi_sweep_params = Array(frame_params,start_frame,line_frame_7,blend_frame,line_frame_8,blend_frame,line_frame_9)

  Call view.selectAt((lx2+rx2)/2,(ty2+by2)/2, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInAMultiSweep(multi_sweep_params,Array(coil_p2_name),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)

  'Merge Coil Parts (Forms one side of single winding)'
  coil_parts = Array(coil_p1_name,coil_p2_name)
  Call getDocument().beginUndoGroup("Union Coil Parts")
  If (getDocument().unionComponents(coil_parts,2,ErrorMessages) <> "") Then
    Call getDocument().getView().selectObject(coil_p1_name, infoSetSelection)
    Call getDocument().getView().selectObject(coil_p2_name, infoAddToSelection)
    Call getDocument().getView().deleteSelection()
  Else
    Call getDocument().getView().unselectAll()
    Call getApplication().MsgBox("An error occurred doing the union operation:" & vbLf & ErrorMessages, vbOKOnly)
  End If
  Call getDocument().endUndoGroup()

  'Mirror Single-sided Coil (Forms full single winding in two separate components)'
  component_name = coil_p1_name+"+"+coil_p2_name+union_keyword+"1"
  Call getDocument().beginUndoGroup("Mirror Component")
  Call getDocument().mirrorComponent(getDocument().copyComponent(Array(component_name), 1), 0, 0, 0, 0, 0, 1, 1)
  Call getDocument().endUndoGroup()

  'Union both coil sides (Form full single winding)'
  coil_halves = Array(component_name,component_name+copy_keyword+"1")
  Call getDocument().beginUndoGroup("Union Components")
  If (getDocument().unionComponents(coil_halves,2,ErrorMessages) <> "") Then
    Call getDocument().getView().selectObject(component_name, infoSetSelection)
    Call getDocument().getView().selectObject(component_name+copy_keyword+"1", infoAddToSelection)
    Call getDocument().getView().deleteSelection()
  Else
    Call getDocument().getView().unselectAll()
    Call getApplication().MsgBox("An error occurred doing the union operation:" & vbLf & ErrorMessages, vbOKOnly)
  End If
  Call getDocument().endUndoGroup()

  'Rename Component'
  Dim final_name
  final_component_name = component_name+"+"+component_name+copy_keyword+"1"+union_keyword+"1"
  Call getDocument().beginUndoGroup("Set Coil Properties", true)
  Call getDocument().renameObject(final_component_name,coil_name)
  Call getDocument().endUndoGroup()
  make_winding = coil_name

End Function


Function make_windings(winding_name)
  Call getDocument().beginUndoGroup("Transform Component")

  Dim component_name
  copy_keyword = " Copy#1"

  For i=1 to slots-1-distribute_distance
    Call getDocument().shiftComponent(getDocument().copyComponent(Array(winding_name),1),slot_pitch*i, 0, 0, 1)
    component_name = Replace(winding_name,"1",i+1)
    Call getDocument().renameObject(winding_name+Replace(copy_keyword,"1",i),component_name)
  Next
  Call getDocument().endUndoGroup()
End Function
