Call Include("utils")

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

  REDIM component_name(0)
  component_name(0) = "Core 1"
  Call view.makeComponentInALine(length_core,component_name,format_material(core_material), infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call clear_construction_lines()
  Call view.getSlice().moveInALine(length_core/2)
End Function


Sub Include(file)
  Dim fso, f
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set f = fso.OpenTextFile(file & ".vbs", 1)
  ExecuteGlobal f.ReadAll
  f.Close
End Sub
