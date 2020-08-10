Function make_track(SHOW_FORBIDDEN_AIR,SHOW_FULL_GEOMETRY,BUILD_WITH_SYMMETRY)
  If SHOW_FORBIDDEN_AIR Then
  	Call view.newLine(-railWidth/2.0 - plateGap, 0, -railWidth/2.0 - plateGap, bottomForbiddenHeight)
  	Call view.newLine(-railWidth/2.0 - plateGap, bottomForbiddenHeight, railWidth/2.0 + plateGap, bottomForbiddenHeight)
  	Call view.newLine(railWidth/2.0 + plateGap, bottomForbiddenHeight, railWidth/2.0 + plateGap, 0)
  	Call view.newLine(railWidth/2.0 + plateGap, 0, -railWidth/2.0 - plateGap, 0)

  	Call view.newLine(-topForbiddenWidth/2.0, railHeight - flangeThickness - topForbiddenHeight, -topForbiddenWidth/2.0, railHeight - flangeThickness)
  	Call view.newLine(-topForbiddenWidth/2.0, railHeight - flangeThickness, topForbiddenWidth/2.0, railHeight - flangeThickness)
  	Call view.newLine(topForbiddenWidth/2.0, railHeight - flangeThickness, topForbiddenWidth/2.0, railHeight - flangeThickness - topForbiddenHeight)
  	Call view.newLine(topForbiddenWidth/2.0, railHeight - flangeThickness - topForbiddenHeight, -topForbiddenWidth/2.0, railHeight - flangeThickness - topForbiddenHeight)

  	Call view.getSlice().moveInALine(-airZ)

  	Call view.selectAt(-1, bottomForbiddenHeight/2.0, infoSetSelection, Array(infoSliceSurface))
  	Call view.makeComponentInALine(2.0*airZ, Array("Forbidden Air 1"), "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  	Call getDocument().setMaxElementSize("Forbidden Air 1", airResolution)
  	Call getDocument().setComponentColor("Forbidden Air 1", RGB(255, 0, 0), 50)

  	Call view.selectAt(-1, railHeight - flangeThickness - topForbiddenHeight/2.0, infoSetSelection, Array(infoSliceSurface))
  	Call view.makeComponentInALine(2.0*airZ, Array("Forbidden Air 2"), "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  	Call getDocument().setMaxElementSize("Forbidden Air 2", airResolution)
  	Call getDocument().setComponentColor("Forbidden Air 2", RGB(255, 0, 0), 50)

  	Call view.getSlice().moveInALine(airZ)
  	Call view.selectAll(infoSetSelection, Array(infoSliceLine))
  	Call view.deleteSelection()
  End If

  If BUILD_WITH_SYMMETRY Then
  	If SHOW_FULL_GEOMETRY Then
  		Call view.newLine(-railWidth/2.0, 0, 0, 0)
  		Call view.newLine(0, 0, 0, railHeight)
  		Call view.newLine(0, railHeight, -railWidth/2.0, railHeight)
  		Call view.newLine(-railWidth/2.0, railHeight, -railWidth/2.0, railHeight - flangeThickness)
  		Call view.newLine(-railWidth/2.0, railHeight - flangeThickness, -webThickness/2.0, railHeight - flangeThickness)
  		Call view.newLine(-webThickness/2.0, railHeight - flangeThickness, -webThickness/2.0, flangeThickness)
  		Call view.newLine(-webThickness/2.0, flangeThickness, -railWidth/2.0, flangeThickness)
  		Call view.newLine(-railWidth/2.0, flangeThickness, -railWidth/2.0, 0)
  	Else
  		Call view.newLine(-webThickness/2.0, plateThickness, 0, plateThickness)
  		Call view.newLine(0, plateThickness, 0, railHeight - flangeThickness)
  		Call view.newLine(0, railHeight - flangeThickness, -webThickness/2.0, railHeight - flangeThickness)
  		Call view.newLine(-webThickness/2.0, railHeight - flangeThickness, -webThickness/2.0, plateThickness)
  	End If
  Else
  	If SHOW_FULL_GEOMETRY Then
  		Call view.newLine(-railWidth/2.0, 0, railWidth/2.0, 0)
  		Call view.newLine(railWidth/2.0, 0, railWidth/2.0, flangeThickness)
  		Call view.newLine(railWidth/2.0, flangeThickness, webThickness/2.0, flangeThickness)
  		Call view.newLine(webThickness/2.0, flangeThickness, webThickness/2.0, railHeight - flangeThickness)
  		Call view.newLine(webThickness/2.0, railHeight - flangeThickness, railWidth/2.0, railHeight - flangeThickness)
  		Call view.newLine(railWidth/2.0, railHeight - flangeThickness, railWidth/2.0, railHeight)
  		Call view.newLine(railWidth/2.0, railHeight, -railWidth/2.0, railHeight)
  		Call view.newLine(-railWidth/2.0, railHeight, -railWidth/2.0, railHeight - flangeThickness)
  		Call view.newLine(-railWidth/2.0, railHeight - flangeThickness, -webThickness/2.0, railHeight - flangeThickness)
  		Call view.newLine(-webThickness/2.0, railHeight - flangeThickness, -webThickness/2.0, flangeThickness)
  		Call view.newLine(-webThickness/2.0, flangeThickness, -railWidth/2.0, flangeThickness)
  		Call view.newLine(-railWidth/2.0, flangeThickness, -railWidth/2.0, 0)
  	Else
  		Call view.newLine(-webThickness/2.0, plateThickness, webThickness/2.0, plateThickness)
  		Call view.newLine(webThickness/2.0, plateThickness, webThickness/2.0, railHeight - flangeThickness)
  		Call view.newLine(webThickness/2.0, railHeight - flangeThickness, -webThickness/2.0, railHeight - flangeThickness)
  		Call view.newLine(-webThickness/2.0, railHeight - flangeThickness, -webThickness/2.0, plateThickness)
  	End If
  End If

  Call view.newLine(-airX, 0, -railWidth/2.0 - plateGap, 0)
  Call view.newLine(-railWidth/2.0 - plateGap, 0, -railWidth/2.0 - plateGap, plateThickness)
  Call view.newLine(-railWidth/2.0 - plateGap, plateThickness, -airX, plateThickness)
  Call view.newLine(-airX, plateThickness, -airX, 0)

  If NOT(BUILD_WITH_SYMMETRY) Then
  	Call view.newLine(airX, 0, railWidth/2.0 + plateGap, 0)
  	Call view.newLine(railWidth/2.0 + plateGap, 0, railWidth/2.0 + plateGap, plateThickness)
  	Call view.newLine(railWidth/2.0 + plateGap, plateThickness, airX, plateThickness)
  	Call view.newLine(airX, plateThickness, airX, 0)
  End If

  Call view.getSlice().moveInALine(-airZ - motionLength/2.0)

  Call view.selectAt(-1, railHeight/2.0, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(airZ*2 + motionLength, Array("Rail"), "Name=Aluminum: 3.8e7 Siemens/meter", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call getDocument().setMaxElementSize("Rail", aluminiumResolution)

  Call view.selectAt(-railWidth-plateGap-10, plateThickness/2.0, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(airZ*2 + motionLength, Array("Plate1"), "Name=Aluminum: 3.8e7 Siemens/meter", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call getDocument().setMaxElementSize("Plate1", aluminiumResolution)

  If NOT(BUILD_WITH_SYMMETRY) Then
  	Call view.selectAt(railWidth+plateGap+10, plateThickness/2.0, infoSetSelection, Array(infoSliceSurface))
  	Call view.makeComponentInALine(airZ*2 + motionLength, Array("Plate2"), "Name=Aluminum: 3.8e7 Siemens/meter", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  	Call getDocument().setMaxElementSize("Plate2", aluminiumResolution)
  End If

  Call view.getSlice().moveInALine(airZ + motionLength/2.0)
  Call view.selectAll(infoSetSelection, Array(infoSliceLine))
  Call view.deleteSelection()
End Function
