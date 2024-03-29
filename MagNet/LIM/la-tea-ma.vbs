'Geometry Parameters Setup'
width_core = 370      'core width (motion direction)
thick_core = 60       'core thickness (away from track)
length_core = 50      'core length (into the page)
core_endlengths = 30  'core end width
slots = 11            'number of slots
slot_pitch = 40       'slot pitch
slot_gap = 20         'slot gap width (teeth_width is generated with slot_pitch and slot_gap)
slot_height = 40      'slot height
end_ext = 15          'one sided winding extension value (TODO: replace with dynamic sizing)
air_gap = 14          'distance between DLIM cores

'Problem Variables'
slip = 0.01         'Per unit slip'
v_r = 25            'Relative speed of pod'
motion_length = 1   'track_length (in meters)'
phase = 3           'Number of phases'
speed = 1           'Speed of pod'

'Build Flags'
const SHOW_FORBIDDEN_AIR = True	  	' Show forbidden zones for design purposes (as red air regions)
const SHOW_FULL_GEOMETRY = True	   	' Build with flanges of track
const BUILD_WITH_SYMMETRY = False   	' Build only half of the track and one wheel, with symmetry conditions
const BUILD_WITH_CIRCUIT = False      ' Build simulation with drive circuitry (useful to turn off for debugging)'
const BUILD_STATIC = TRUE             ' Build simulation with no motion components, 
const AUTO_RUN = False                ' Run simulation as soon as problam definition is complete

'Winding Setup'
coil_core_separation_x = 4  'minimum separation between core and coil (one-sided, x-direction)'
coil_core_separation_y = 4  'minimum separation between core and coil (one-sided, y-direction)'
distribute_distance = 2     'distributed winding distance, in # of slots'
v_max = 120                 'input voltage'
freq = 15                   'source frequency'

'Material Setup'
core_material = "M330-35A"
coil_material = "Copper: 5.77e7 Siemens/meter"
track_material = "Aluminum: 3.8e7 Siemens/meter"
air_material = "AIR"

'Mesh Resolution Setup'
air_rail_boundary = 1
air_resolution = 6
aluminium_resolution = 5
core_resolution = 3
winding_resolution = 4
rail_surface_resolution = 2
plate_surface_resolution = 3
use_H_adaption = False
use_P_adaption = False

'Track Constants'
const rail_height = 127
const rail_width = 127
const web_thickness = 10.4902
const flange_thickness = 10.4648
const plate_thickness = 12.7
const plate_gap = 12.7
const bottom_forbidden_height = 29.6672
const top_forbidden_height = 19.05
const top_forbidden_width = 46.0502

'Internal Variables'
core_endlengths = core_endlengths + slot_gap
teeth_width = slot_pitch-slot_gap
slot_teeth_width = (slots-1)*slot_pitch+slot_gap
core_track_gap = (air_gap-web_thickness)/2
num_coils = slots-distribute_distance
coil_width = slot_gap-2*coil_core_separation_x
coil_height = (slot_height-3*coil_core_separation_y)/2
v_s = v_r/(1-slip)
slip_speed = v_s-v_r
motion_length = motion_length*1000
remesh_padding = 0.25
airbox_padding = 1

'Problem Bounds'
x_min = 0
y_min = -20
z_min = -width_core*0.75
x_max = (length_core+air_gap)*2
y_max = rail_height+20
z_max = -z_min

'Document Setup'
Call newDocument()
Call SetLocale("en-us")
Call getDocument().setDefaultLengthUnit("Millimeters")
Set view = getDocument().getView()
Set app = getDocument().getApplication()

'Ids Class Setup
Set ids_o = new ids.init()

'Main Code'
Call make_track(SHOW_FORBIDDEN_AIR,SHOW_FULL_GEOMETRY,BUILD_WITH_SYMMETRY)
'Call reset_local()
'Call print(ids_o.subtract_strings("Coil#1 Copy#1","Coil#1"))
Call build_motor()
'components = get_core_components(num_coils)
'Call getDocument().getApplication().MsgBox(components(0))
Call make_airbox(BUILD_WITH_SYMMETRY)
If(BUILD_WITH_CIRCUIT) Then
  Set drive = new power.init()
End If

If NOT(BUILD_STATIC) Then
  Call setup_motion()
End If

'Call getDocument().save("D:\Repos\EM-FEA\MagNet\LIM\temp.mn")
Call setup_sim()

If(AUTO_RUN) Then
  Call getDocument().solveTransient3DWithMotion()
End If

'end main'

Function build_single_side_core()
  Call make_core_component()
  Call make_single_side_windings(make_winding())
  Call make_single_side_coils()
  'Call print(ids_o.get_core_components())
End Function

Function orient_A()
  Call ids_o.update_names("A")
  components = ids_o.get_a_components()
  Call select_a_components()
  Call orient_core_a()
  Call move_core_to_midtrack(components)
  Call insert_core_airgap(components,1)
  Call getDocument().getView().unselectAll()
End Function

Function orient_B()
  Call ids_o.update_names("B")
  components = ids_o.get_b_components()
  Call select_b_components()
  Call orient_core_b()
  Call move_core_to_midtrack(components)
  Call insert_core_airgap(components,-1)
  Call getDocument().getView().unselectAll()
  For i = 1 to num_coils
    component_coil = "Coil#"&(i+num_coils)
    Call view.selectObject(component_coil, infoSetSelection)
    Call getDocument().reverseCoilDirection(component_coil)
  Next
End Function

Function build_motor()
  build_single_side_core()
  orient_A()
  If NOT (BUILD_WITH_SYMMETRY) Then
    build_single_side_core()
    orient_B()
  End If
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
  Call view.getSlice().moveInALine(-length_core/2)
  Call draw_core_geometry()
  Call view.selectAt(0,(thick_core+slot_height)/2,infoSetSelection,Array(infoSliceSurface))

  core_name = "Core 1"
  REDIM component_name(0)
  component_name(0) = core_name
  Call view.makeComponentInALine(length_core,component_name,format_material(core_material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call getDocument().setMaxElementSize(core_name,core_resolution)
  Call clear_construction_lines()
  Call view.getSlice().moveInALine(length_core/2)
End Function

Function get_coil_cross_section_coords(lx1,rx1,by1,ty1,lx2,rx2,by2,ty2)
  lx1 = -slot_teeth_width/2+coil_core_separation_x
  rx1 = -slot_teeth_width/2+coil_core_separation_x+coil_width
  by1 = coil_core_separation_y
  ty1 = coil_core_separation_y+coil_height
  lx2 = lx1+distribute_distance*slot_pitch
  rx2 = rx1+distribute_distance*slot_pitch
  by2 = slot_height-ty1
  ty2 = slot_height-by1
End Function

Function make_winding()
  Call view.getSlice().moveInALine(-length_core/2)

  Call get_coil_cross_section_coords(lx1,rx1,by1,ty1,lx2,rx2,by2,ty2)

  Call draw_square(lx1,rx1,by1,ty1)
  Call draw_square(lx2,rx2,by2,ty2)

  Set coilbuild = new build.init(ids_o.get_winding_keyword()+"#1")

  Call view.getSlice().moveInALine(length_core/2)

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
  multi_sweep_params = Array(frame_params,start_frame,line_frame_1,blend_frame,line_frame_2,blend_frame,line_frame_3,blend_frame,arc_frame_4)

  unselect()
  Call view.selectAt((lx1+rx1)/2,(ty1+by1)/2, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInAMultiSweep(multi_sweep_params,Array(coilbuild.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call getDocument().setMaxElementSize(coilbuild.component_name(),winding_resolution)
  Call coilbuild.increment_component_num()

  line_frame_7 = Array("Line",Array((lx2+rx2)/2-(lx1+rx1)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_core_separation_x))
  line_frame_8 = Array("Line",Array(((lx2+rx2)/2-(lx1+rx1)/2)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_core_separation_x+end_ext))
  line_frame_9 = Array("Line",Array(((lx2+rx2)/2-(lx1+rx1)/2)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_core_separation_x+end_ext+coil_width))
  multi_sweep_params = Array(frame_params,start_frame,line_frame_7,blend_frame,line_frame_8,blend_frame,line_frame_9)

  unselect()
  Call view.selectAt((lx2+rx2)/2,(ty2+by2)/2, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInAMultiSweep(multi_sweep_params,Array(coilbuild.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call getDocument().setMaxElementSize(coilbuild.component_name(),winding_resolution)
  Call coilbuild.increment_component_num()

  'Merge Coil Parts (Forms one side of single winding)'
  Call coilbuild.union_all()
  Call coilbuild.mirror_copy(Array(0,0,1))
  Call coilbuild.union_all()

  make_winding = coilbuild.end_component_build()

  Call view.getSlice().moveInALine(length_core/2)

End Function

Function make_single_side_windings(winding_name)
  Dim component_name
  copy_keyword = " Copy#1"

  Call getDocument().beginUndoGroup("Transform Component")
  Call view.getSlice().moveInALine(-length_core/2)

  For i=1 to num_coils-1
    Call getDocument().shiftComponent(getDocument().copyComponent(Array(winding_name),1),slot_pitch*i, 0, 0, 1)
    copy_component = ids_o.get_copy_components()(0)
    copy_keyword = ids_o.subtract_strings(ids_o.get_winding_keyword+"#1",copy_component)
    component_name = Replace(winding_name,"1",i+1)
    Call getDocument().renameObject(copy_component,component_name)
  Next
  Call getDocument().endUndoGroup()
  Call clear_construction_lines()
End Function

Function make_single_side_coils()
  Call getDocument.beginUndoGroup("Create Coils")
  match = ids_o.get_winding_paths()
  match = ids_o.find_with_not_match(match,Array("A"))
  Set re = new RegExp
  re.Pattern = "[^\d]"
  re.Global = True

  Call get_coil_cross_section_coords(lx1,rx1,by1,ty1,lx2,rx2,by2,ty2)

  For i=0 to UBound(match)
    coil_path = match(i)
    coil_name = ids_o.remove_substrings(match(i))
    coil_num = CInt(re.Replace(coil_name,""))
    coil_side = Right(coil_name,1)

    excitation_center = get_global((lx1+rx1)/2+slot_pitch*i,(by1+ty1)/2)
    excitaiton_normal = Array(0,0,1)
    excitation_volume = Array(coil_path)

    If(coil_num Mod 2=0) Then
      excitation_normal = Array(0,0,1)
    Else
      excitation_normal = Array(0,0,-1)
    End If
    Call getDocument().makeCurrentFlowSurfaceCoil(1,coil_path,excitation_center,excitation_normal,excitation_volume)
  Next
  Call getDocument.endUndoGroup()
End Function

Function make_track(SHOW_FORBIDDEN_AIR,SHOW_FULL_GEOMETRY,BUILD_WITH_SYMMETRY)
  If SHOW_FORBIDDEN_AIR Then
  	Call generate_forbidden_zones()
  End If

  If BUILD_WITH_SYMMETRY Then
  	If SHOW_FULL_GEOMETRY Then
  		Call view.newLine(-rail_width/2.0, 0, 0, 0)
  		Call view.newLine(0, 0, 0, rail_height)
  		Call view.newLine(0, rail_height, -rail_width/2.0, rail_height)
  		Call view.newLine(-rail_width/2.0, rail_height, -rail_width/2.0, rail_height - flange_thickness)
  		Call view.newLine(-rail_width/2.0, rail_height - flange_thickness, -web_thickness/2.0, rail_height - flange_thickness)
  		Call view.newLine(-web_thickness/2.0, rail_height - flange_thickness, -web_thickness/2.0, flange_thickness)
  		Call view.newLine(-web_thickness/2.0, flange_thickness, -rail_width/2.0, flange_thickness)
  		Call view.newLine(-rail_width/2.0, flange_thickness, -rail_width/2.0, 0)
  	Else
  		Call view.newLine(-web_thickness/2.0, plate_thickness, 0, plate_thickness)
  		Call view.newLine(0, plate_thickness, 0, rail_height - flange_thickness)
  		Call view.newLine(0, rail_height - flange_thickness, -web_thickness/2.0, rail_height - flange_thickness)
  		Call view.newLine(-web_thickness/2.0, rail_height - flange_thickness, -web_thickness/2.0, plate_thickness)
  	End If
  Else
  	If SHOW_FULL_GEOMETRY Then
  		Call view.newLine(-rail_width/2.0, 0, rail_width/2.0, 0)
  		Call view.newLine(rail_width/2.0, 0, rail_width/2.0, flange_thickness)
  		Call view.newLine(rail_width/2.0, flange_thickness, web_thickness/2.0, flange_thickness)
  		Call view.newLine(web_thickness/2.0, flange_thickness, web_thickness/2.0, rail_height - flange_thickness)
  		Call view.newLine(web_thickness/2.0, rail_height - flange_thickness, rail_width/2.0, rail_height - flange_thickness)
  		Call view.newLine(rail_width/2.0, rail_height - flange_thickness, rail_width/2.0, rail_height)
  		Call view.newLine(rail_width/2.0, rail_height, -rail_width/2.0, rail_height)
  		Call view.newLine(-rail_width/2.0, rail_height, -rail_width/2.0, rail_height - flange_thickness)
  		Call view.newLine(-rail_width/2.0, rail_height - flange_thickness, -web_thickness/2.0, rail_height - flange_thickness)
  		Call view.newLine(-web_thickness/2.0, rail_height - flange_thickness, -web_thickness/2.0, flange_thickness)
  		Call view.newLine(-web_thickness/2.0, flange_thickness, -rail_width/2.0, flange_thickness)
  		Call view.newLine(-rail_width/2.0, flange_thickness, -rail_width/2.0, 0)
  	Else
  		Call view.newLine(-web_thickness/2.0, plate_thickness, web_thickness/2.0, plate_thickness)
  		Call view.newLine(web_thickness/2.0, plate_thickness, web_thickness/2.0, rail_height - flange_thickness)
  		Call view.newLine(web_thickness/2.0, rail_height - flange_thickness, -web_thickness/2.0, rail_height - flange_thickness)
  		Call view.newLine(-web_thickness/2.0, rail_height - flange_thickness, -web_thickness/2.0, plate_thickness)
  	End If
  End If

  rail = "Track"
  p1 = "Plate 1"
  p2 = "Plate 2"

  rm1 = "Track Remesh"

 Call generate_two_sided_component(rail,track_material,0,rail_height/2.0,z_min,z_max+motion_length,aluminium_resolution)
 Call getDocument().setMaxElementSize(rail, aluminiumResolution)

  Call view.newLine(-x_max, 0, -rail_width/2.0 - plate_gap, 0)
  Call view.newLine(-rail_width/2.0 - plate_gap, 0, -rail_width/2.0 - plate_gap, plate_thickness)
  Call view.newLine(-rail_width/2.0 - plate_gap, plate_thickness, -x_max, plate_thickness)
  Call view.newLine(-x_max, plate_thickness, -x_max, 0)

  Call generate_two_sided_component(p1,track_material,-rail_width/2.0-plate_gap-10,plate_thickness/2.0,z_min,z_max+motion_length,aluminium_resolution)
  Call getDocument().setMaxElementSize(p1, aluminiumResolution)

  If NOT(BUILD_WITH_SYMMETRY) Then
  	Call view.newLine(x_max, 0, rail_width/2.0 + plate_gap, 0)
  	Call view.newLine(rail_width/2.0 + plate_gap, 0, rail_width/2.0 + plate_gap, plate_thickness)
  	Call view.newLine(rail_width/2.0 + plate_gap, plate_thickness, x_max, plate_thickness)
  	Call view.newLine(x_max, plate_thickness, x_max, 0)

    Call generate_two_sided_component(p2,track_material,rail_width/2.0+plate_gap+10,plate_thickness/2.0,z_min,z_max+motion_length,aluminium_resolution)
  	Call getDocument().setMaxElementSize(p2, aluminiumResolution)
  End If

  Call clear_construction_lines()

  If NOT(BUILD_STATIC) Then
    Call view.newLine(-web_thickness/2.0-remesh_padding, plate_thickness-remesh_padding, web_thickness/2.0+remesh_padding, plate_thickness-remesh_padding)
    Call view.newLine(web_thickness/2.0+remesh_padding, plate_thickness-remesh_padding, web_thickness/2.0+remesh_padding, rail_height - flange_thickness + remesh_padding)
    Call view.newLine(web_thickness/2.0+remesh_padding, rail_height - flange_thickness + remesh_padding, -web_thickness/2.0-remesh_padding, rail_height - flange_thickness + remesh_padding)
    Call view.newLine(-web_thickness/2.0-remesh_padding, rail_height - flange_thickness + remesh_padding, -web_thickness/2.0-remesh_padding, plate_thickness-remesh_padding)
    Call generate_two_sided_component(rm1,air_material,0,rail_height/2.0,z_min-motion_length,z_max+motion_length+airbox_padding/2,air_resolution)
    Call clear_construction_lines()
  End If
End Function

Function generate_forbidden_zones()
  Call view.newLine(-rail_width/2.0 - plate_gap, 0, -rail_width/2.0 - plate_gap, bottom_forbidden_height)
  Call view.newLine(-rail_width/2.0 - plate_gap, bottom_forbidden_height, rail_width/2.0 + plate_gap, bottom_forbidden_height)
  Call view.newLine(rail_width/2.0 + plate_gap, bottom_forbidden_height, rail_width/2.0 + plate_gap, 0)
  Call view.newLine(rail_width/2.0 + plate_gap, 0, -rail_width/2.0 - plate_gap, 0)

  Call view.newLine(-top_forbidden_width/2.0, rail_height - flange_thickness - top_forbidden_height, -top_forbidden_width/2.0, rail_height - flange_thickness)
  Call view.newLine(-top_forbidden_width/2.0, rail_height - flange_thickness, top_forbidden_width/2.0, rail_height - flange_thickness)
  Call view.newLine(top_forbidden_width/2.0, rail_height - flange_thickness, top_forbidden_width/2.0, rail_height - flange_thickness - top_forbidden_height)
  Call view.newLine(top_forbidden_width/2.0, rail_height - flange_thickness - top_forbidden_height, -top_forbidden_width/2.0, rail_height - flange_thickness - top_forbidden_height)

  fa_name_1 = "Forbidden Air 1"
  fa_name_2 = "Forbidden Air 2"

  Call generate_two_sided_component(fa_name_1,air_material,0,bottom_forbidden_height/2.0,z_min,z_max,air_resolution)
  'Call getDocument().setMaxElementSize(fa_name_1, airResolution)
  Call getDocument().setComponentColor(fa_name_1, RGB(255, 0, 0), 50)

  Call generate_two_sided_component(fa_name_2,air_material,0,rail_height-flange_thickness-top_forbidden_height/2.0,z_min,z_max,air_resolution)
  'Call getDocument().setMaxElementSize("Forbidden Air 2", airResolution)
  Call getDocument().setComponentColor(fa_name_2, RGB(255, 0, 0), 50)

  Call clear_construction_lines()
End Function

Function make_airbox(BUILD_WITH_SYMMETRY)
  airbox = "AirBox"
  If BUILD_WITH_SYMMETRY Then
    Call draw_square(x_min,-x_max-10,y_min,y_max)
  Else
    Call draw_square(-x_max-airbox_padding-10,x_max+airbox_padding+10,y_min-airbox_padding,y_max+airbox_padding)
  End If
  Call generate_two_sided_component(airbox,air_material,-x_max-1,y_max-1,zmin-motion_length-airbox_padding,z_max+motion_length+airbox_padding,air_resolution)
  Call getDocument().setMaxElementSize(airbox, air_resolution)
  Call getDocument().getView().setObjectVisible(airbox, False)

  Call view.selectAll(infoSetSelection, Array(infoSliceLine))
  Call view.deleteSelection()
  If BUILD_WITH_SYMMETRY Then
    airbox_comp = ids_o.get_spec_paths(Array(airbox))
    temp = Array(airbox_comp(0)+",Face#3")
    Call getDocument().createBoundaryCondition(temp, "BoundaryCondition#1")
    Call getDocument().setMagneticFieldNormal("BoundaryCondition#1")
  End If
End Function


Class ids
  Public copy_replace_strings

  Private core_matches
  Private remove_strings
  Private a_postfix
  Private b_postfix
  Private copper_keyword
  Private cores

  'Constructor
  Public Default Function init()
    copper_keyword = "CoilGeometry"
    core_matches = Array("Core",copper_keyword)
    remove_strings = Array(",","Body#1")
    copy_replace_strings = Array("Copy#1","Copy#9")

    a_postfix = "A"
    b_postfix = "B"
    cores = Array(a_postfix,b_postfix)
    Set init = Me
  End Function

  Public Function find_all_components_with_match(find)
    components = getDocument().getAllComponentPaths()
    find_all_components_with_match = find_with_match(components,find)
  End Function

  Public Function find_all_components_with_match_replace(find)
    components = getDocument().getAllComponentPaths()
    find_all_components_with_match_replace = find_with_match_replace(components,find)
  End Function

  Public Function find_with_match(arr,find)
    ReDim matches(-1)
    For i=0 to UBound(arr)
      For z=0 to UBound(find)
        If InStr(arr(i),find(z)) Then
          ReDim Preserve matches(UBound(matches) + 1)
          matches(UBound(matches)) = (arr(i))
        End if
      Next
    Next
    find_with_match = matches
  End Function

  Public Function find_with_match_replace(arr,find)
    ReDim matches(-1)
    For i=0 to UBound(arr)
      For z=0 to UBound(find)
        If InStr(remove_substrings(arr(i)),find(z)) Then
          ReDim Preserve matches(UBound(matches) + 1)
          matches(UBound(matches)) = remove_substrings(arr(i))
        End if
      Next
    Next
    find_with_match_replace = matches
  End Function

  Public Function find_with_not_match(arr,find)
    ReDim matches(-1)
    For i=0 to UBound(arr)
      For z=0 to UBound(find)
        If InStr(arr(i),find(z)) Then
          asdf=0
        Else
          ReDim Preserve matches(UBound(matches) + 1)
          matches(UBound(matches)) = (arr(i))
        End if
      Next
    Next
    find_with_not_match = matches
  End Function

  'Update core components to have postfix'
  'Called only when BUILD_WITH_SYMMETRY true'
  Public Function rename_mirror()
    matches = find_all_components_with_match_replace(copy_replace_strings)
    For i=0 to UBound(matches)
      new_name = replace_substrings(matches(i),b_postfix)
      Call rename_components(matches(i),replace_substrings(matches(i),b_postfix))
    Next
  End Function

  'Update core components to have postfix'
  'Need to call regardless of BUILD_WITH_SYMMETRY'
  Public Function update_names(append)
    matches = get_core_components()
    For i=0 to UBound(cores)
      If cores(i)<>append Then
        matches = find_with_not_match(matches,Array(cores(i)))
      End If
    Next
    For i=0 to UBound(matches)
      If InStr(matches(i),b_postfix)=0 Then
        Call rename_components(matches(i),append_substrings(matches(i)," "+append))
      End If
    Next
  End Function

  'Gets component names for A side'
  Public Function get_a_components()
    get_a_components = find_all_components_with_match_replace(Array(a_postfix))
  End Function

  'Gets component names for B side'
  Public Function get_b_components()
    get_b_components = find_all_components_with_match_replace(Array(b_postfix))
  End Function

  'Gets component names for all coil elements'
  Public Function get_coil_components()
    get_coil_components = find_all_components_with_match_replace(Array("Coil"))
  End Function

  Public Function get_coil_paths()
    get_coil_paths = find_all_components_with_match(Array("Coil"))
  End Function

  Public Function get_winding_components()
    get_winding_components = find_all_components_with_match_replace(Array(copper_keyword))
  End Function

  Public Function get_winding_paths()
    get_winding_paths = find_all_components_with_match(Array(copper_keyword))
  End Function

  Public Property Get get_core_components()
    get_core_components = find_all_components_with_match_replace(core_matches)
  End Property

  Public Property Get get_copy_components()
    get_copy_components = get_spec_components(Array("Copy"))
  End Property

  Public Property Get get_union_components()
    get_union_components = get_spec_components(Array("Union"))
  End Property

  Public Property Get get_spec_components(arr_comps)
    get_spec_components = find_all_components_with_match_replace(arr_comps)
  End Property

  Public Property Get get_spec_paths(arr_comps)
    get_spec_paths = find_all_components_with_match(arr_comps)
  End Property

  'Removes predetermined substrings from (param) string '
  Public Function remove_substrings(str)
    For i=0 to UBound(remove_strings)
      str = Replace(str,remove_strings(i),"")
    Next
    remove_substrings = str
  End Function

  Public Function subtract_strings(str1,str2)
    diff = ""
    If (len(str1)>len(str2)) Then
      diff = Replace(str1,str2,"")
    Else
      diff = Replace(str2,str1,"")
    End If
    subtract_strings = diff
  End Function

  'Replaces (param) substring in (param) string'
  Public Function replace_substrings(str,repl)
    temp = str
    For i=0 to UBound(copy_replace_strings)
      If InStr(str,copy_replace_strings(i)) Then
        temp = Replace(temp,copy_replace_strings(i),repl)
      End If
    Next
    replace_substrings = temp
  End Function

  'Appends (param) substring to (param) string'
  Public Function append_substrings(str,app)
    append_substrings = str+app
  End Function

  Public Property Get get_winding_keyword()
    get_winding_keyword = copper_keyword
  End Property

End Class


Class build

  Private name
  Private final_name
  Private build_step
  Private component_number

  Public Default Function init(target_name)
    Call start_component_build(target_name)
    Set init = Me
  End Function

  Public Function start_component_build(target_name)
    name = "comp"
    final_name = target_name
    component_number=0
    build_step=0
  End Function

  Public Function update()
    temp_comps = up_complist()
    Call print(temp_comps)
  End Function

  Public Function union_all()
    temp_comps = up_complist()
    temp = temp_comps(0)
    For i=1 to UBound(temp_comps)
      Call union_components(temp,temp_comps(i))
      union_comps = ids_o.get_spec_components(Array("Union"))
      temp = component_name()
      Call rename_components(union_comps(0),temp)
    Next
    temp_comps = up_complist()
    Call rename_components(temp_comps(0),component_name())
  End Function

  Public Function mirror(normal)
    temp_comps = up_complist()
    Call mirror_components(temp_comps,normal)
  End Function

  Public Function mirror_copy(normal)
    temp_comps = up_complist()
    Call mirror_components_copy(temp_comps,normal)
  End Function

  Public Function end_component_build()
    temp_comps = up_complist()
    Call rename_components(temp_comps(0),final_name)
    end_component_build = final_name
  End Function

  Public Function component_name()
    component_name = name&component_number
  End Function

  Public Function increment_component_num()
    component_number=component_number+1
  End Function

  Public Function set_build_step(val)
    build_step = val
  End Function

  Public Function increment_step()
    build_step = build_step+1
  End Function

  Public Function get_build_step()
    get_build_step = build_step
  End Function

  Private Function up_complist()
    up_complist = ids_o.find_all_components_with_match_replace(Array(name))
  End Function

End Class

'CONTROL/DRIVE CIRCUITRY'
Class power

  Private coil_comps
  Private num_coils
  Private start_x
  Private start_y
  Private offset_x
  Private offset_y
  Private connection_offset

  Public Default Function init()
    coil_comps = ids_o.get_coil_components()
    num_coils = CInt(UBound(coil_comps)+1)

    start_x = 100
    start_y = 100
    offset_y = 150
    offset_x = 100
    connection_offset = 25

    Call getDocument().newCircuitWindow()
    draw_circuit()

    Set init = Me
  End Function

  Public Function draw_circuit()
    For i=1 to num_coils

      Call draw_single_winding(i)
    Next
  End Function

  Public Function draw_single_winding(i)
    Set circ = getDocument().getCircuit()
    Call circ.insertCoil("Coil#"&i, start_x, start_y+i*offset_y)
    Call circ.insertCurrentSource(start_x+offset_x, start_y+i*offset_y)

    coil_name = "Coil#"&i
    source_name = "I"&i

    DIM ctx,cty,vstx,vsty
    Call circ.getPositionOfTerminal(coil_name&",T2",ctx,cty)
    Call circ.getPositionOfTerminal(source_name&",T1",vstx,vsty)
    xconn = Array(ctx,vstx)
    yconn = Array(cty,vsty)
    Call circ.insertConnection(xconn, yconn)

    Call circ.getPositionOfTerminal(coil_name&",T1",ctx,cty)
    Call circ.getPositionOfTerminal(source_name&",T2",vstx,vsty)
    xconn = Array(ctx,ctx,vstx,vstx)
    yconn = Array(cty,cty+connection_offset,vsty+connection_offset,vsty)
    Call circ.insertConnection(xconn, yconn)

    Call getDocument().beginUndoGroup("Set V Source Properties", true)
    phase_ang = 120*((i-1) mod phase)
    props = Array(0,v_max,freq,0,0,120*((i-1) mod phase))

    Call getDocument().setSourceWaveform(source_name,"SIN", props)
    Call getDocument().endUndoGroup()
  End Function

End Class


Function setup_motion()
  m1 = "Motion#1"
  m2 = "Motion#2"
  m3 = "Motion#3"
  Call getDocument().makeMotionComponent(Array("Track,Body#1"))
  Call getDocument().setMotionSourceType(m1, infoVelocityDriven)
  Call getDocument().setMotionType(m1, infoLinear)
  Call getDocument().setMotionLinearDirection(m1, Array(0, 0, -1))
  Call getDocument().setMotionPositionAtStartup(m1, 0)
  ' Call getDocument().setMotionSpeedAtStartup(m1, speed)
  Call getDocument().setMotionSpeedVsTime(m1, Array(0), Array(speed))

  If(False) Then
    Call getDocument().makeMotionComponent(Array("Plate 1,Body#1"))
    Call getDocument().setMotionSourceType(m2, infoVelocityDriven)
    Call getDocument().setMotionType(m2, infoLinear)
    Call getDocument().setMotionLinearDirection(m2, Array(0, 0, -1))
    Call getDocument().setMotionPositionAtStartup(m2, 0)
    ' Call getDocument().setMotionSpeedAtStartup(m2, speed)
    Call getDocument().setMotionSpeedVsTime(m2, Array(0), Array(speed))

    If NOT(BUILD_WITH_SYMMETRY) Then
      Call getDocument().makeMotionComponent(Array("Plate 2,Body#1"))
      Call getDocument().setMotionSourceType(m3, infoVelocityDriven)
      Call getDocument().setMotionType(m3, infoLinear)
      Call getDocument().setMotionLinearDirection(m3, Array(0, 0, -1))
      Call getDocument().setMotionPositionAtStartup(m3, 0)
      ' Call getDocument().setMotionSpeedAtStartup(m3, speed)
      Call getDocument().setMotionSpeedVsTime(m3, Array(0), Array(speed))
    End If
  End If
End Function

Function setup_sim()
  Call getDocument().beginUndoGroup("Set Transient Options", true)
  Call getDocument().setFixedIntervalTimeSteps(0, 100, 5)
  Call getDocument().deleteTimeStepMaximumDelta()
  Call getDocument().setParameter("", "TransientAveragePowerLossStartTime", "0%ms", infoNumberParameter)
  Call getDocument().setParameter("", "TransientAveragePowerLossStopTime", "100%ms", infoNumberParameter)
  Call getDocument().endUndoGroup()
End Function

'UTIL FUNCTIONS'


Function format_material(material)
  format_material = "Name="+material
End Function

Function clear_construction_lines()
  Set view = getDocument().getView()
  Call view.selectAll(infoSetSelection, Array(infoSliceLine, infoSliceArc))
  Call view.deleteSelection()
End Function

Function draw_square(x1,x2,y1,y2)
  tx1 = x1
  tx2 = x2
  ty1 = y1
  ty2 = y2
  If(tx1 > tx2) Then
    temp = tx1
    tx1 = tx2
    tx2 = temp
  End If
  If(ty1 > ty2) Then
    temp = ty1
    ty1 = ty2
    ty2 = temp
  End If
  Call view.newLine(tx1,ty1,tx2,ty1)
  Call view.newLine(tx1,ty2,tx2,ty2)
  Call view.newLine(tx1,ty1,tx1,ty2)
  Call view.newLine(tx2,ty1,tx2,ty2)
End Function

Function union_components(component_1,component_2)
  parts = Array(component_1,component_2)
  Call getDocument().beginUndoGroup("Union Components")
  If (getDocument().unionComponents(parts,2,ErrorMessages) <> "") Then
    Call getDocument().getView().selectObject(component_1, infoSetSelection)
    Call getDocument().getView().selectObject(component_2, infoAddToSelection)
    Call getDocument().getView().deleteSelection()
    union_components = 1
  Else
    Call getDocument().getView().unselectAll()
    Call getApplication().MsgBox("An error occurred doing the union operation:" & vbLf & ErrorMessages, vbOKOnly)
    union_components = 0
  End If
  Call getDocument().endUndoGroup()
End Function

Function rename_components(component,name)
  Call getDocument().beginUndoGroup("Rename Component", true)
  Call getDocument().renameObject(component,name)
  Call getDocument().endUndoGroup()
End Function

Function union_and_rename(component_1,component_2,name)
  Call union_components(component_1,component_2)
  union_name = component_1+"+"+component_2+" Union#1"
  Call rename_components(union_name,name)
End Function

Function rename_copies(components,substr,newsubstr)
  temp = components
  For i=0 to num_coils-1
    temp(i) = Replace(components(i),substr,newsubstr)
    'app.MsgBox(components(i))
    Call rename_components(components(i),temp(i))
  Next
End Function

Function mirror_components_copy(components,normal)
  Call getDocument().beginUndoGroup("Mirror Component")
  Call getDocument().copyComponent(components, 1)
  Call getDocument().mirrorComponent(components,0,0,0,normal(0),normal(1),normal(2),1)
  Call getDocument().endUndoGroup()
End Function

Function mirror_components(components,normal)
  Call getDocument().beginUndoGroup("Mirror Component")
  Call getDocument().mirrorComponent(components,0,0,0,normal(0),normal(1),normal(2),1)
  Call getDocument().endUndoGroup()
End Function

Function generate_two_sided_component(component_name,material,selection_x,selection_y,neg_val,pos_val,resolution)
  Call view.selectAt(selection_x, selection_y, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(neg_val, Array(component_name+"p1"),format_material(material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call view.selectAt(selection_x, selection_y, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(pos_val, Array(component_name+"p2"),format_material(material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call union_and_rename(component_name+"p1",component_name+"p2",component_name)
  Call getDocument().setMaxElementSize(component_name,resolution)
End Function

Function orient_core_a()
  Call select_a_components()
  Call getDocument().beginUndoGroup("Rotate Core Component")
  core_components = ids_o.get_a_components()
  Call getDocument().rotateComponent(core_components, 0, 0, 0, 0, 1, 0, 90, 1)
  Call getDocument().rotateComponent(core_components, 0, 0, 0, 0, 0, 1, 90, 1)
  Call getDocument().endUndoGroup()
End Function

Function orient_core_b()
  Call select_b_components()
  Call getDocument().beginUndoGroup("Rotate Core Component")
  core_components = ids_o.get_b_components()
  Call getDocument().rotateComponent(core_components, 0, 0, 0, 0, 1, 0, 90, 1)
  Call getDocument().rotateComponent(core_components, 0, 0, 0, 0, 0, 1, -90, 1)
  Call getDocument().endUndoGroup()
End Function

Function move_core_to_midtrack(core_components)
  Call getDocument().beginUndoGroup("Transform Component")
  Call getDocument().shiftComponent(core_components, 0, rail_height/2, 0, 1)
  Call getDocument().endUndoGroup()
End Function

Function insert_core_airgap(core_components,direction)
  Call getDocument().beginUndoGroup("Translate Core Component")
  Call getDocument().shiftComponent(core_components,direction*-air_gap/2, 0, 0, 1)
  Call getDocument().endUndoGroup()
End Function

Function select_core_components()
  components = ids_o.get_core_components()
  select_components(components)
End Function

Function select_components(arr)
  Call getDocument().getView().selectObject(arr(0),infoSetSelection)
  For i=0 to UBound(arr)
    Call getDocument().getView().selectObject(arr(i),infoAddToSelection)
  Next
End Function

Function unselect()
  Call getDocument().getView().unselectAll()
End Function

Function select_a_components()
  components = ids_o.get_a_components()
  Call select_components(components)
End Function

Function select_b_components()
  components = ids_o.get_b_components()
  Call select_components(components)
End Function

Function print_arr(input_arr)
  Dim output_str
  output_str = output_str&"["
  For each x in input_arr
    output_str = output_str&x&","
  Next
  print_arr = output_str&"]"
End Function

Function print(input)
  If(IsArray(input)) Then
    Call app.MsgBox(print_arr(input))
  ElseIf(IsNumeric(input)) Then
    Call app.MsgBox(Cstr(input))
  Else
    Call app.MsgBox(input)
  End If
End Function

Function get_global(local_x,local_y)
  Set view = getDocument().getView()
  Dim global_points(2)
  Call view.getSlice().convertLocalToGlobal(local_x,local_y,global_points(0),global_points(1),global_points(2))
  get_global = global_points
End Function

Function get_local(global_x,global_y)
  Set view = getDocument().getView()
  Dim local_points(1)
  Call view.getSlice().convertGlobalToLocal(global_x,global_y,local_points(0),local_points(1))
  get_local = local_points
End Function

Function get_origin_from_local()
  get_origin_from_local = get_global(0,0)
End Function

Function reset_local()
  'This doesn't work
  unit_z_vec = Array(0,0,1)
  CALL getDocument().getView().getSlice().moveToAPlane(0, 0, 0, 0, 0, 1, 0, 0, -1)
End Function

' edw 
' Magnets
const PI = 3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067

const DOUBLE_SIDED = False
'const BUILD_WITH_SYMMETRY = False	' If double sided, build only half the track with symmetry conditions for faster
const runSimulation = True

railMaterial = "Aluminium 6061-T6"
railConductivity = 24940400
magnetMaterial = "N50"

n = 32
r1 = 47.88
r2 = 70
ra = 45 * PI / 180.0
gap = 10
thickness = 50
rail_thickness = 10
rpm = 360
offsetX = 1.0						' Offset of both wheels laterally to test for guidance force (only works when simulating double-sided without symmetry)
start_angle = 0.0 * PI / 180.0

numWheels = 1
spaceBetweenWheels = 30.0

If BUILD_WITH_SYMMETRY Then
    offsetX = 0.0
End If

' Speeds in m/s
speed = 25.0						' Speed of pod
slipSpeed = 30.0					' Slip speed if numSpeedSteps = 1
minSlipSpeed = 10.0					' Starting test slip speed
maxSlipSpeed = 20.0 				' Ending test slip speed
numSpeedSteps = 3					' Number of tests, slip speed is linearly spaces from minSlipSpeed to maxSlipSpeed

solveStepsPerMagnet = 10.0	        ' Number of steps needed for wheel to rotate the angle of one magnet
numSteps = 10*10				    ' Number of simulation steps

If (numSpeedSteps = 1) Then
	minSlipSpeed = slipSpeed
End If

magneticCircumference = 1.04 * r2*PI*2.0 / 1000.0		' Magnetic circumference of wheel (important for accurate slip speeds)

wheelsLength = r2 * 2.0 * numWheels + spaceBetweenWheels * (numWheels - 1)
wheelOffsetY = r2 * 2.0 + spaceBetweenWheels
wheelOffsetAngle = wheelOffsetY / magneticCircumference * PI * 2.0

' Use min rps to calculate max solveStep for max rail length
rps = (speed + minSlipSpeed) / magneticCircumference
solveStep = 1000.0 / (rps * n * solveStepsPerMagnet)

motionLength = speed * (solveStep * numSteps)

' Air boundaries
airRailBoundary = 1.0
airX = r2 * 2.5
airXMin = -50.0
airZ = thickness * 3.0
airYClearance = 40.0
railY = 2*wheelsLength/2.0 + motionLength/2.0 + airYClearance
airY = railY + motionLength/2.0 + airRailBoundary


' Mesh resolutions
airResolution = 10
magnetResolution = 10
aluminiumResolution = 10
magnetFaceResolution = 3
railSurfaceResolution = 3

useHAdaption = False
usePAdaption = False

If NOT getUserMaterialDatabase().isMaterialInDatabase(railMaterial) Then
	Call getUserMaterialDatabase().newMaterial(railMaterial)
	Call getUserMaterialDatabase().setMaterialColor(railMaterial, 192, 192, 192, 255)
	Call getUserMaterialDatabase().setMaterialCategories(railMaterial, Array("Sleeve material", "Shaft material", "Housing material", "Conducting material", "Coil winding material", "Brush material", "Segment material"))
	REDIM ArrayOfValues(0, 2)
	ArrayOfValues(0, 0)= 20
	ArrayOfValues(0, 1)= 1
	ArrayOfValues(0, 2)= 0
	Call getUserMaterialDatabase().setMagneticPermeability(railMaterial, ArrayOfValues, infoLinearIsotropicReal)
	REDIM ArrayOfValues(0, 1)
	ArrayOfValues(0, 0)= 20
	ArrayOfValues(0, 1)= railConductivity
	Call getUserMaterialDatabase().setElectricConductivity(railMaterial, ArrayOfValues, infoLinearIsotropicReal)
	REDIM ArrayOfValues(0, 1)
	ArrayOfValues(0, 0)= 20
	ArrayOfValues(0, 1)= 1
	Call getUserMaterialDatabase().setElectricPermittivity(railMaterial, ArrayOfValues, infoLinearIsotropicReal)
	REDIM ArrayOfValues(0, 1)
	ArrayOfValues(0, 0)= 20
	ArrayOfValues(0, 1)= 204
	Call getUserMaterialDatabase().setThermalConductivity(railMaterial, ArrayOfValues)
	REDIM ArrayOfValues(0, 1)
	ArrayOfValues(0, 0)= 20
	ArrayOfValues(0, 1)= 896
	Call getUserMaterialDatabase().setThermalSpecificHeatCapacity(railMaterial, ArrayOfValues)
	REDIM ArrayOfValues(0, 1)
	ArrayOfValues(0, 0)= 20
	ArrayOfValues(0, 1)= 2707
	Call getUserMaterialDatabase().setMassDensity(railMaterial, ArrayOfValues)
End If

'Call newDocument()
'Call SetLocale("en-us")
'Call getDocument().setDefaultLengthUnit("Millimeters")
'Set view = getDocument().getView()

' Air

If BUILD_WITH_SYMMETRY Then
	Call view.newLine(0, -airY, airX, -airY)
	Call view.newLine(airX, -airY, airX, airY)
	Call view.newLine(airX, airY, 0, airY)
	Call view.newLine(0, airY, 0, -airY)
ElseIf NOT DOUBLE_SIDED Then
	Call view.newLine(airXMin, -airY, airX, -airY)
	Call view.newLine(airX, -airY, airX, airY)
	Call view.newLine(airX, airY, airXMin, airY)
	Call view.newLine(airXMin, airY, airXMin, -airY)
Else
	Call view.newLine(-airX, -airY, airX, -airY)
	Call view.newLine(airX, -airY, airX, airY)
	Call view.newLine(airX, airY, -airX, airY)
	Call view.newLine(-airX, airY, -airX, -airY)
End If

Call view.getSlice().moveInALine(-airZ/2.0)
Call view.selectAt(1, 0, infoSetSelection, Array(infoSliceSurface))
' Call view.makeComponentInALine(airZ, Array("Outer Air"), "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
' Call getDocument().setMaxElementSize("Outer Air", airResolution)
Call view.getSlice().moveInALine(airZ/2.0)
' Call getDocument().getView().setObjectVisible("Outer Air", False)

Call view.selectAll(infoSetSelection, Array(infoSliceLine))
Call view.deleteSelection()

'If BUILD_WITH_SYMMETRY Then
'	Call getDocument().createBoundaryCondition(Array("Outer Air,Face#6"), "BoundaryCondition#1")
'	Call getDocument().setMagneticFieldNormal("BoundaryCondition#1")
'End If

' Aluminium

If BUILD_WITH_SYMMETRY Then
	Call view.newLine(0, -railY, rail_thickness/2.0, -railY)
	Call view.newLine(rail_thickness/2.0, -railY, rail_thickness/2.0, railY)
	Call view.newLine(rail_thickness/2.0, railY, 0, railY)
	Call view.newLine(0, railY, 0, -railY)
Else
	Call view.newLine(-rail_thickness/2.0, -railY, rail_thickness/2.0, -railY)
	Call view.newLine(rail_thickness/2.0, -railY, rail_thickness/2.0, railY)
	Call view.newLine(rail_thickness/2.0, railY, -rail_thickness/2.0, railY)
	Call view.newLine(-rail_thickness/2.0, railY, -rail_thickness/2.0, -railY)
End If
' creates the aluminum block 
' moves the construction slice i.e. 'building' faces
' Call view.getSlice().moveInALine(-airZ/2.0)
' Call view.selectAt(1, 0, infoSetSelection, Array(infoSliceSurface))
' extrude that shape in a certain distance
' Call view.makeComponentInALine(airZ, Array("Aluminium"), "Name=" & railMaterial, infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
' Call getDocument().setMaxElementSize("Aluminium", aluminiumResolution)
' Call view.getSlice().moveInALine(airZ/2.0)

Call view.selectAll(infoSetSelection, Array(infoSliceLine))
Call view.deleteSelection()

' sets the resolution of the faces - controls the maximum edge length i.e. mesh surface 
' Call getDocument().setMaxElementSize("Aluminium,Face#4", railSurfaceResolution)

' If DOUBLE_SIDED AND NOT BUILD_WITH_SYMMETRY Then
' 	Call getDocument().setMaxElementSize("Aluminium,Face#6", railSurfaceResolution)
' End If

' Call getDocument().makeMotionComponent(Array("Aluminium"))
' Call getDocument().setMotionSourceType("Motion#1", infoVelocityDriven)
' Call getDocument().setMotionType("Motion#1", infoLinear)
' Call getDocument().setMotionLinearDirection("Motion#1", Array(0, 1, 0))
' Call getDocument().setMotionPositionAtStartup("Motion#1", -motionLength/2.0)
' Call getDocument().setMotionSpeedVsTime("Motion#1", Array(0), Array(speed))

' Magnets

Call view.getSlice().moveInALine(-thickness/2.0)

For wheel = 1 To numWheels
	wheel_y = wheelsLength/2.0 - r2 - (wheel - 1) * wheelOffsetY

	Call view.newCircle((r2 + rail_thickness/2.0 + gap), wheel_y, r1)
	Call view.newCircle((r2 + rail_thickness/2.0 + gap), wheel_y, r2)

	For i = 1 To n
		x_hat = Sin(PI * 2.0 * (i + 0.5) / n + wheelOffsetAngle*(wheel - 1))
		y_hat = Cos(PI * 2.0 * (i + 0.5) / n + wheelOffsetAngle*(wheel - 1))

		Call view.newLine((r2 + rail_thickness/2.0 + gap) + x_hat*r1, y_hat*r1 + wheel_y, (r2 + rail_thickness/2.0 + gap) + x_hat*r2, y_hat*r2 + wheel_y)
	Next

	ReDim Magnets(n - 1)

	For i = 1 To n
		x_hat = Sin(PI * 2.0 * i / n + wheelOffsetAngle*(wheel - 1))
		y_hat = Cos(PI * 2.0 * i / n + wheelOffsetAngle*(wheel - 1))
		mid_r = (r1 + r2) / 2.0

		Call view.selectAt((r2 + rail_thickness/2.0 + gap) + x_hat*mid_r, y_hat*mid_r + wheel_y, infoSetSelection, Array(infoSliceSurface))

		x_hat = Sin(PI * 2.0 * i / n + wheelOffsetAngle*(wheel - 1) - i * ra + PI/2.0)
		y_hat = Cos(PI * 2.0 * i / n + wheelOffsetAngle*(wheel - 1) - i * ra + PI/2.0)

		direction = "[" & x_hat & "," & y_hat & ",0]"
		name = "Magnet" & i & "#" & wheel

		Call view.makeComponentInALine(thickness, Array(name), "Name=N50;Type=Uniform;Direction=" & direction, True)

		Call getDocument().setMaxElementSize(name, magnetResolution)
		Call getDocument().setMaxElementSize(name & ",Face#1", magnetFaceResolution)
		Call getDocument().setMaxElementSize(name & ",Face#2", magnetFaceResolution)
		Call getDocument().setMaxElementSize(name & ",Face#3", magnetFaceResolution)
		Call getDocument().setMaxElementSize(name & ",Face#4", magnetFaceResolution)
		Call getDocument().setMaxElementSize(name & ",Face#5", magnetFaceResolution)
        Call getDocument().setMaxElementSize(name & ",Face#6", magnetFaceResolution)

		Magnets(i - 1) = name
	Next
                                              'x          'y 'z
	Call getDocument().shiftComponent(Magnets, offsetX + 50, 0, 0, 1)
                                    ' (path array, x, y, z, x axis, y axis, z axis, rotation angle, problem ID)
  Call getDocument().rotateComponent(Magnets, offsetX + 1000, 50, 0, 50, 0, 0, 90, 1)
  'shiftComponent (path array, x shift, y shift, z shift, problem ID)
  Call getDocument().shiftComponent(Magnets, offsetX-70 , 13, 370, 1)

	If DOUBLE_SIDED AND NOT BUILD_WITH_SYMMETRY Then
		Call view.newCircle(-(r2 + rail_thickness/2.0 + gap), wheel_y, r1)
		Call view.newCircle(-(r2 + rail_thickness/2.0 + gap), wheel_y, r2)

		For i = 1 To n
			x_hat = -Sin(PI * 2.0 * (i + 0.5) / n + wheelOffsetAngle*(wheel - 1))
			y_hat = Cos(PI * 2.0 * (i + 0.5) / n + wheelOffsetAngle*(wheel - 1))

			Call view.newLine(-(r2 + rail_thickness/2.0 + gap) + x_hat*r1, y_hat*r1 + wheel_y, -(r2 + rail_thickness/2.0 + gap) + x_hat*r2, y_hat*r2 + wheel_y)
		Next

		ReDim MagnetsB(n - 1)

		For i = 1 To n
			x_hat = -Sin(PI * 2.0 * i / n + wheelOffsetAngle*(wheel - 1))
			y_hat = Cos(PI * 2.0 * i / n + wheelOffsetAngle*(wheel - 1))
			mid_r = (r1 + r2) / 2.0

			Call view.selectAt(-(r2 + rail_thickness/2.0 + gap) + x_hat*mid_r, y_hat*mid_r + wheel_y, infoSetSelection, Array(infoSliceSurface))

			x_hat = -Sin(PI * 2.0 * i / n + wheelOffsetAngle*(wheel - 1) - i * ra - PI/2.0)
			y_hat = Cos(PI * 2.0 * i / n + wheelOffsetAngle*(wheel - 1) - i * ra - PI/2.0)

			direction = "[" & x_hat & "," & y_hat & ",0]"
			name = "MagnetB" & i & "#" & wheel

			Call view.makeComponentInALine(thickness, Array(name), "Name=N50;Type=Uniform;Direction=" & direction, True)

			Call getDocument().setMaxElementSize(name, magnetResolution)
			Call getDocument().setMaxElementSize(name & ",Face#1", magnetFaceResolution)
			Call getDocument().setMaxElementSize(name & ",Face#2", magnetFaceResolution)
			Call getDocument().setMaxElementSize(name & ",Face#3", magnetFaceResolution)
			Call getDocument().setMaxElementSize(name & ",Face#4", magnetFaceResolution)
			Call getDocument().setMaxElementSize(name & ",Face#5", magnetFaceResolution)
			Call getDocument().setMaxElementSize(name & ",Face#6", magnetFaceResolution)

			MagnetsB(i - 1) = name
		Next

		Call getDocument().shiftComponent(MagnetsB, offsetX, 0, 0, 1)
	End If

	Call view.selectAll(infoSetSelection, Array(infoSliceLine, infoSliceArc))
	Call view.deleteSelection()

	motionComponent = getDocument().makeMotionComponent(Magnets)
    Call getDocument().setMotionSourceType(motionComponent, infoVelocityDriven)
    Call getDocument().setMotionRotaryCenter(motionComponent, Array((r2 + rail_thickness/2.0 + gap) + offsetX, wheel_y, 0))
    Call getDocument().setMotionRotaryAxis(motionComponent, Array(0, 0, 1))
    Call getDocument().setMotionPositionAtStartup(motionComponent, start_angle)
	Call getDocument().setParameter(motionComponent, "SpeedVsTime", "[0%ms, -(%rotSpeed)]", infoArrayParameter)

	If DOUBLE_SIDED AND NOT BUILD_WITH_SYMMETRY Then
		Call getDocument().shiftComponent(MagnetsB, offsetX, 1000, 1000, 1)

		motionComponent = getDocument().makeMotionComponent(MagnetsB)
		Call getDocument().setMotionSourceType(motionComponent, infoVelocityDriven)
		Call getDocument().setMotionRotaryCenter(motionComponent, Array(-(r2 + rail_thickness/2.0 + gap) + offsetX, wheel_y, 0))
		Call getDocument().setMotionRotaryAxis(motionComponent, Array(0, 0, 1))
		Call getDocument().setMotionPositionAtStartup(motionComponent, -start_angle)
		Call getDocument().setParameter(motionComponent, "SpeedVsTime", "[0%ms, %rotSpeed]", infoArrayParameter)
	End If
Next

Call view.getSlice().moveInALine(thickness/2.0)

Call getDocument().setTimeStepMethod(infoFixedIntervalTimeStep)
' Call getDocument().setFixedIntervalTimeSteps(0, solveStep*numSteps, solveStep)
' Call getDocument().deleteTimeStepMaximumDelta()
' Call getDocument().setAdaptiveTimeSteps(0, solveStep*numSteps, solveStep, solveStep * 4)
' Call getDocument().setTimeAdaptionTolerance(0.03)

Call getDocument().useHAdaption(useHAdaption)
Call getDocument().usePAdaption(usePAdaption)

If numSpeedSteps = 1 Then
	rps = (speed + slipSpeed) / (magneticCircumference)
    text1 = text1 & rps*2.0*PI & "%rad"
Else
    For i = 1 to numSpeedSteps
        slipSpeed = (i - 1) * ((maxSlipSpeed - minSlipSpeed) / (numSpeedSteps - 1)) + minSlipSpeed
        rps = (speed + slipSpeed) / (magneticCircumference)
        text1 = text1 & rps*2.0*PI & "%rad"
        If i <> numSpeedSteps Then
            text1 = text1 & ", "
        End If
    Next
End If

Call getDocument().setParameter("", "rotSpeed", text1, infoNumberParameter)
Call getDocument().setParameter("", "TimeSteps", "[0%ms, (1000.0/((%rotSpeed/(2.0*%Pi))*" & n & "*" & solveStepsPerMagnet & "))%ms, " & "(1000.0/((%rotSpeed/(2.0*%Pi))*" & n & "*" & solveStepsPerMagnet & ")*" & numSteps & ")%ms]", infoArrayParameter)

' Scale view to fit

Call getDocument().getView().setScaledToFit(True)

if runSimulation Then
	Call getDocument().solveTransient2DWithMotion()
End If
