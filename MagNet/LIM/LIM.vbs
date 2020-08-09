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

  Call view.newLine(lx1,by1,rx1,by1)
  Call view.newLine(lx1,ty1,rx1,ty1)
  Call view.newLine(lx1,by1,lx1,ty1)
  Call view.newLine(rx1,by1,rx1,ty1)

  lx2 = lx1+distribute_distance*slot_pitch
  rx2 = rx1+distribute_distance*slot_pitch
  by2 = slot_height-ty1
  ty2 = slot_height-by1

  Call view.newLine(lx2,by2,rx2,by2)
  Call view.newLine(lx2,ty2,rx2,ty2)
  Call view.newLine(lx2,by2,lx2,ty2)
  Call view.newLine(rx2,by2,rx2,ty2)

  Call getDocument().getView().selectAt((lx1+rx1)/2,(ty1+by1)/2, infoSetSelection, Array(infoSliceSurface))
  'Call getDocument().getView().selectAt((lx2+rx2)/2,(ty2+by2)/2, infoAddToSelection, Array(infoSliceSurface))

  REDIM component_name(0)
  component_name(0)= "Coil#1"




  init_coords=Array((lx1+rx1)/2,(by1+ty1)/2,-length_core/2)'TODO: change to construction surface'
  unit_x_vec=Array(1,0,0)
  unit_y_vec=Array(0,1,0)
  unit_z_vec=Array(0,0,1)

  frame_params=Array("Frame","Cartesian",init_coords,unit_x_vec,unit_y_vec,unit_z_vec)

  REDIM multi_sweep_params(10)
  multi_sweep_params(0)=frame_params

  REDIM start_frame(0)
  start_frame(0)= "Start"

  multi_sweep_params(1)= start_frame

  REDIM line_frame_1(1)
  line_frame_1(0)= "Line"

  REDIM line_frame_1_coords(2)
  line_frame_1_coords(0)= 0
  line_frame_1_coords(1)= 0
  line_frame_1_coords(2)= length_core+coil_width/2+coil_core_separation_x
  line_frame_1(1)= line_frame_1_coords

  multi_sweep_params(2)= line_frame_1

  REDIM blend_frame_1(1)
  blend_frame_1(0)= "Blend"
  blend_frame_1(1)= "Automatic"

  multi_sweep_params(3)= blend_frame_1

  REDIM line_frame_2(1)
  line_frame_2(0)= "Line"

  REDIM line_frame_2_coords(2)
  line_frame_2_coords(0)= (lx2+rx2)/2-(lx1+rx1)/2
  line_frame_2_coords(1)= (ty2+by2)/2-(ty1+by1)/2
  line_frame_2_coords(2)= length_core+coil_width/2+coil_core_separation_x
  line_frame_2(1)= line_frame_2_coords

  multi_sweep_params(4)= line_frame_2


  REDIM blend_frame_2(1)
  blend_frame_2(0)= "Blend"
  blend_frame_2(1)= "Automatic"

  multi_sweep_params(5)= blend_frame_1

  REDIM line_frame_3(1)
  line_frame_3(0)= "Line"

  REDIM line_frame_3_coords(2)
  line_frame_3_coords(0)= (lx2+rx2)/2-(lx1+rx1)/2
  line_frame_3_coords(1)= (ty2+by2)/2-(ty1+by1)/2
  line_frame_3_coords(2)= -(coil_width/2+coil_core_separation_x)
  line_frame_3(1)= line_frame_3_coords

  multi_sweep_params(6)= line_frame_3

  REDIM blend_frame_3(1)
  blend_frame_3(0)= "Blend"
  blend_frame_3(1)= "Automatic"

  multi_sweep_params(7)= blend_frame_3

  REDIM line_frame_4(1)
  line_frame_4(0)= "Line"

  REDIM line_frame_4_coords(2)
  line_frame_4_coords(0)= 0
  line_frame_4_coords(1)= 0
  line_frame_4_coords(2)= -(coil_width/2+coil_core_separation_x)
  line_frame_4(1)= line_frame_4_coords

  multi_sweep_params(8)= line_frame_4

  REDIM blend_frame_4(1)
  blend_frame_4(0)= "Blend"
  blend_frame_4(1)= "Automatic"

  multi_sweep_params(9)= blend_frame_4

  REDIM line_frame_5(1)
  line_frame_5(0)= "Line"

  REDIM line_frame_5_coords(2)
  line_frame_5_coords(0)= 0
  line_frame_5_coords(1)= 0
  line_frame_5_coords(2)= length_core
  line_frame_5(1)= line_frame_5_coords

  multi_sweep_params(10)= line_frame_5



Call getDocument().getView().makeComponentInAMultiSweep(multi_sweep_params, component_name, "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)




  'REDIM ArrayOfValues(1)
  'ArrayOfValues(0)= "Component#1"
  'ArrayOfValues(1)= "Component#2"
  'Call view.makeComponentInALine(length_core,ArrayOfValues,format_material(coil_material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)

  'Call view.newLine(lx2-coil_core_separation_x,0,lx2-coil_core_separation_x,slot_height)
  'Call view.newLine(rx1+coil_core_separation_x,0,rx1+coil_core_separation_x,slot_height)

  'Call getDocument().getView().makeComponentInAnArc(lx2-coil_core_separation_x,0,0,1,90,ArrayOfValues,"Name=Copper: 5.77e7 Siemens/meter", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
End Function
