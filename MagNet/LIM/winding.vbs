Call Include("utils")

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

  Call view.newLine(lx1,by1,rx1,by1)
  Call view.newLine(lx1,ty1,rx1,ty1)
  Call view.newLine(lx1,by1,lx1,ty1)
  Call view.newLine(rx1,by1,rx1,ty1)

  Call view.newLine(lx2,by2,rx2,by2)
  Call view.newLine(lx2,ty2,rx2,ty2)
  Call view.newLine(lx2,by2,lx2,ty2)
  Call view.newLine(rx2,by2,rx2,ty2)

  Set coilbuild = new build.init(ids_o.get_winding_keyword(),ids_o.get_winding_keyword()+"#1")

  Call view.getSlice().moveInALine(length_core/2)

  'coil_p1_name = ids_o.get_winding_keyword()+"#1p1"
  'coil_p2_name = ids_o.get_winding_keyword()+"#1p2"
  'coil_name = ids_o.get_winding_keyword()+"#1"
  'copy_keyword = " Copy#"
  'union_keyword = " Union#"

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

  line_frame_7 = Array("Line",Array((lx2+rx2)/2-(lx1+rx1)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_core_separation_x))
  line_frame_8 = Array("Line",Array(((lx2+rx2)/2-(lx1+rx1)/2)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_core_separation_x+end_ext))
  line_frame_9 = Array("Line",Array(((lx2+rx2)/2-(lx1+rx1)/2)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_core_separation_x+end_ext+coil_width))
  multi_sweep_params = Array(frame_params,start_frame,line_frame_7,blend_frame,line_frame_8,blend_frame,line_frame_9)

  unselect()
  Call view.selectAt((lx2+rx2)/2,(ty2+by2)/2, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInAMultiSweep(multi_sweep_params,Array(coilbuild.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)

  'Merge Coil Parts (Forms one side of single winding)'
  Call coilbuild.union_all()
  Call coilbuild.mirror(Array(0,0,1))

  line_frame_1 = Array("Line",Array(0,0,length_core/2+coil_core_separation_x))
  line_frame_2 = Array("Line",Array(((lx2+rx2)/2-(lx1+rx1)/2)/2,0,length_core/2+coil_core_separation_x+end_ext))
  line_frame_3 = Array("Line",Array(((lx2+rx2)/2-(lx1+rx1)/2)/2,0,length_core/2+coil_core_separation_x+end_ext+coil_width))
  multi_sweep_params = Array(frame_params,start_frame,line_frame_1,blend_frame,line_frame_2,blend_frame,line_frame_3)

  Call view.selectAt((lx1+rx1)/2,(ty1+by1)/2, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInAMultiSweep(multi_sweep_params,Array(coilbuild.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)

  line_frame_7 = Array("Line",Array((lx2+rx2)/2-(lx1+rx1)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_core_separation_x))
  line_frame_8 = Array("Line",Array(((lx2+rx2)/2-(lx1+rx1)/2)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_core_separation_x+end_ext))
  line_frame_9 = Array("Line",Array(((lx2+rx2)/2-(lx1+rx1)/2)/2,(ty2+by2)/2-(ty1+by1)/2,length_core/2+coil_core_separation_x+end_ext+coil_width))
  multi_sweep_params = Array(frame_params,start_frame,line_frame_7,blend_frame,line_frame_8,blend_frame,line_frame_9)

  Call view.selectAt((lx2+rx2)/2,(ty2+by2)/2, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInAMultiSweep(multi_sweep_params,Array(coilbuild.component_name()),format_material(coil_material),infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)


  'Mirror Single-sided Coil (Forms full single winding in two separate components)'
  'component_name = (ids_o.get_union_components())(0)
  Call getDocument().beginUndoGroup("Mirror Component")
  'Call getDocument().mirrorComponent(getDocument().copyComponent(Array(component_name), 1), 0, 0, 0, 0, 0, 1, 1)
  Call getDocument().endUndoGroup()

  'Union both coil sides (Form full single winding)'
  'Call union_components(component_name,component_name+copy_keyword+"1")

  'Rename Component'
  final_component_name = component_name+"+"+component_name+copy_keyword+"1"+union_keyword+"1"
  Call rename_components(final_component_name,coil_name)
  make_winding = coil_name

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

Sub Include(file)
  Dim fso, f
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set f = fso.OpenTextFile(file & ".vbs", 1)
  ExecuteGlobal f.ReadAll
  f.Close
End Sub
