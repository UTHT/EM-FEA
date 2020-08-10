Sub Include(file)

  Dim fso, f
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set f = fso.OpenTextFile(file & ".vbs", 1)
  ExecuteGlobal f.ReadAll
  f.Close
  'ExecuteGlobal str
End Sub


Function format_material(material)
  format_material = "Name="+material
End Function


Function clear_construction_lines()
  Set view = getDocument().getView()
  Call view.selectAll(infoSetSelection, Array(infoSliceLine, infoSliceArc))
  Call view.deleteSelection()
End Function
