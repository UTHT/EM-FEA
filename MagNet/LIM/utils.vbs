
Function format_material(material)
  format_material = "Name="+material
End Function

Function clear_construction_lines()
  Set view = getDocument().getView()
  Call view.selectAll(infoSetSelection, Array(infoSliceLine, infoSliceArc))
  Call view.deleteSelection()
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

Function generate_two_sided_component(component_name,material,selection_x,selection_y,neg_val,pos_val)
  Call view.selectAt(selection_x, selection_y, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(neg_val, Array(component_name+"p1"),format_material(material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call view.selectAt(selection_x, selection_y, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(pos_val, Array(component_name+"p2"),format_material(material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call union_and_rename(component_name+"p1",component_name+"p2",component_name)
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
  'Call getDocument().rotateComponent(core_components, 0, 0, 0, 0, 0, 1, 90, 1)
  Call getDocument().endUndoGroup()
End Function

Function move_core_to_midtrack()
  Call getDocument().beginUndoGroup("Transform Component")
  core_components = ids_o.get_core_components()
  Call getDocument().shiftComponent(core_components, 0, rail_height/2, 0, 1)
  Call getDocument().endUndoGroup()
End Function

Function insert_core_airgap()
  Call select_core_components()
  Call getDocument().beginUndoGroup("Translate Core Component")
  core_components = ids_o.get_core_components()
  Call getDocument().shiftComponent(core_components, -air_gap/2, 0, 0, 1)
  Call getDocument().endUndoGroup()
End Function

Function select_core_components()
  components = ids_o.get_core_components()
  select_components(components)
End Function

Function select_components(arr)
  Call getDocument().getView().selectObject(arr(0),infoSetSelection)
  For i=0 to UBound(arr)-1
    Call getDocument().getView().selectObject(arr(i),infoAddToSelection)
  Next
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

Function mirror_components()
  Call getDocument().beginUndoGroup("Mirror Component")
  components = ids_o.get_core_components()
  Call getDocument().copyComponent(components, 1)
  Call getDocument().mirrorComponent(components, 0, 0, 0, 1, 0, 0, 1)
  Call ids_o.rename_mirror()

  Call getDocument().endUndoGroup()
End Function

Function reset_local()
  'This doesn't work
  unit_z_vec = Array(0,0,1)
  CALL getDocument().getView().getSlice().moveToAPlane(0, 0, 0, 0, 0, 1, 0, 0, -1)
End Function
