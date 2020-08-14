
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

Function generate_two_sided_component(component_name,selection_x,selection_y,neg_val,pos_val)
  Call view.selectAt(selection_x, selection_y, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(z_min, Array(component_name+"p1"),format_material(air_material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call view.selectAt(selection_x, selection_y, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(z_max, Array(component_name+"p2"),format_material(air_material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call union_and_rename(component_name+"p1",component_name+"p2",component_name)
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

Function reset_local()
  'This doesn't work
  unit_z_vec = Array(0,0,1)
  call getDocument().getView().getSlice().moveToAPlane(0,0,0,0,0,1,1,0,0)
End Function
