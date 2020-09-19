
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

Function rename_all_with_substr(components,substr,newsubstr)
temp = components
  For i=0 to num_coils-1
    temp(i) = Replace(components(i),substr,newsubstr)
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

Function orient_core(num_coils)
  Call select_core_components(num_coils)
  Call getDocument().beginUndoGroup("Rotate Core Component")
  core_components = get_core_components(num_coils)
  'Call getDocument().getApplication().MsgBox(print_arr(core_components))
  Call getDocument().rotateComponent(core_components, 0, 0, 0, 0, 1, 0, 90, 1)
  Call getDocument().rotateComponent(core_components, 0, 0, 0, 0, 0, 1, 90, 1)
  Call getDocument().endUndoGroup()
End Function

Function move_core_to_midtrack(num_coils)
  Call getDocument().beginUndoGroup("Transform Component")
  core_components = get_core_components(num_coils)
  Call getDocument().shiftComponent(core_components, 0, rail_height/2, 0, 1)
  Call getDocument().endUndoGroup()
End Function

Function insert_core_airgap(num_coils)
  Call select_core_components(num_coils)
  Call getDocument().beginUndoGroup("Translate Core Component")
  core_components = get_core_components(num_coils)
  Call getDocument().shiftComponent(core_components, -air_gap/2, 0, 0, 1)
  Call getDocument().endUndoGroup()
End Function

Function get_core_components(num_coils)
  ReDim components(-1)
  ReDim Preserve components(UBound(components)+1) : components(UBound(components)) = "Core 1"
  For i=0 to num_coils-1
    ReDim Preserve components(UBound(components)+1) : components(UBound(components)) = "Coil#"&(i+1)
  Next
  get_core_components=components
End Function

Function select_core_components(num_coils)
  components = get_core_components(num_coils)
  Call getDocument().getView().selectObject(components(0),infoSetSelection)
  For i=0 to num_coils-1
    Call getDocument().getView().selectObject(components(i),infoAddToSelection)
  Next
End Function

Function print_arr(input_arr)
  Dim output_str
  output_str = output_str&"["
  For each x in input_arr
    output_str = output_str&x&" "
  Next
  print_arr = output_str&"]"
End Function

Function print(input)
  Set app = getDocument().getApplication()
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
  Dim global_points(3)
  Call view.getSlice().convertLocalToGlobal(local_x,local_y,global_points(0),global_points(1),global_points(2))
  get_global = global_points
End Function

Function get_local(global_x,global_y)
  Set view = getDocument().getView()
  Dim local_points(2)
  Call view.getSlice().convertGlobalToLocal(global_x,global_y,local_points(0),local_points(1))
  get_local = local_points
End Function

Function get_origin_from_local()
  get_origin_from_local = get_global(0,0)
End Function

Function mirror_components()
  Call getDocument().beginUndoGroup("Mirror Component")
  components = get_core_components(num_coils)
  Call getDocument().mirrorComponent(getDocument().copyComponent(components, 1), 0, 0, 0, 1, 0, 0, 1)
  Call rename_all_with_substr(components,"Coil","Haha")
  Call getDocument().endUndoGroup()
End Function

Function reset_local()
  'This doesn't work
  unit_z_vec = Array(0,0,1)
  CALL getDocument().getView().getSlice().moveToAPlane(0, 0, 0, 0, 0, 1, 0, 0, -1)
End Function
