
Function make_track(SHOW_FORBIDDEN_AIR,SHOW_FULL_GEOMETRY,BUILD_WITH_SYMMETRY)
  If SHOW_FORBIDDEN_AIR Then
  	Call view.newLine(-rail_width/2.0 - plate_gap, 0, -rail_width/2.0 - plate_gap, bottom_forbidden_height)
  	Call view.newLine(-rail_width/2.0 - plate_gap, bottom_forbidden_height, rail_width/2.0 + plate_gap, bottom_forbidden_height)
  	Call view.newLine(rail_width/2.0 + plate_gap, bottom_forbidden_height, rail_width/2.0 + plate_gap, 0)
  	Call view.newLine(rail_width/2.0 + plate_gap, 0, -rail_width/2.0 - plate_gap, 0)

  	Call view.newLine(-top_forbidden_width/2.0, rail_height - flange_thickness - top_forbidden_height, -top_forbidden_width/2.0, rail_height - flange_thickness)
  	Call view.newLine(-top_forbidden_width/2.0, rail_height - flange_thickness, top_forbidden_width/2.0, rail_height - flange_thickness)
  	Call view.newLine(top_forbidden_width/2.0, rail_height - flange_thickness, top_forbidden_width/2.0, rail_height - flange_thickness - top_forbidden_height)
  	Call view.newLine(top_forbidden_width/2.0, rail_height - flange_thickness - top_forbidden_height, -top_forbidden_width/2.0, rail_height - flange_thickness - top_forbidden_height)

  	Call view.selectAt(-1, bottom_forbidden_height/2.0, infoSetSelection, Array(infoSliceSurface))
  	Call view.makeComponentInALine(z_min, Array("Forbidden Air 1"), "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
    Call view.makeComponentInALine(z_max, Array("Forbidden Air 1"), "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
    'Call getDocument().setMaxElementSize("Forbidden Air 1", airResolution)
  	Call getDocument().setComponentColor("Forbidden Air 1", RGB(255, 0, 0), 50)

  	Call view.selectAt(-1, rail_height - flange_thickness - top_forbidden_height/2.0, infoSetSelection, Array(infoSliceSurface))
  	Call view.makeComponentInALine(abs(z_min)+z_max, Array("Forbidden Air 2"), "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  	'Call getDocument().setMaxElementSize("Forbidden Air 2", airResolution)
  	Call getDocument().setComponentColor("Forbidden Air 2", RGB(255, 0, 0), 50)

  	'Call view.getSlice().moveInALine(abs(z_min))
  	Call view.selectAll(infoSetSelection, Array(infoSliceLine))
  	Call view.deleteSelection()
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

  Call view.newLine(-x_max, 0, -rail_width/2.0 - plate_gap, 0)
  Call view.newLine(-rail_width/2.0 - plate_gap, 0, -rail_width/2.0 - plate_gap, plate_thickness)
  Call view.newLine(-rail_width/2.0 - plate_gap, plate_thickness, -x_max, plate_thickness)
  Call view.newLine(-x_max, plate_thickness, -x_max, 0)

  If NOT(BUILD_WITH_SYMMETRY) Then
  	Call view.newLine(x_max, 0, rail_width/2.0 + plate_gap, 0)
  	Call view.newLine(rail_width/2.0 + plate_gap, 0, rail_width/2.0 + plate_gap, plate_thickness)
  	Call view.newLine(rail_width/2.0 + plate_gap, plate_thickness, x_max, plate_thickness)
  	Call view.newLine(x_max, plate_thickness, x_max, 0)
  End If

  Call view.getSlice().moveInALine(-airZ - motion_length/2.0)

  Call view.selectAt(-1, rail_height/2.0, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(airZ*2 + motion_length, Array("Rail"), "Name=Aluminum: 3.8e7 Siemens/meter", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call getDocument().setMaxElementSize("Rail", aluminiumResolution)

  Call view.selectAt(-rail_width-plate_gap-10, plate_thickness/2.0, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(airZ*2 + motion_length, Array("Plate1"), "Name=Aluminum: 3.8e7 Siemens/meter", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call getDocument().setMaxElementSize("Plate1", aluminiumResolution)

  If NOT(BUILD_WITH_SYMMETRY) Then
  	Call view.selectAt(rail_width+plate_gap+10, plate_thickness/2.0, infoSetSelection, Array(infoSliceSurface))
  	Call view.makeComponentInALine(airZ*2 + motion_length, Array("Plate2"), "Name=Aluminum: 3.8e7 Siemens/meter", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  	Call getDocument().setMaxElementSize("Plate2", aluminiumResolution)
  End If

  Call view.getSlice().moveInALine(airZ + motion_length/2.0)
  Call view.selectAll(infoSetSelection, Array(infoSliceLine))
  Call view.deleteSelection()
End Function
