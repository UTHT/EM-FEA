Function make_airbox(BUILD_WITH_SYMMETRY)
  If BUILD_WITH_SYMMETRY Then
    Call view.newLine(-airX, airYmin, -airX, airCutY)
    Call view.newLine(-airX, airCutY, -railWidth/2.0, airYmax)
    Call view.newLine(-railWidth/2.0, airYmax, 0, airYMax)
    Call view.newLine(0, airYmax, 0, airYmin)
    Call view.newLine(0, airYmin, -airX, airYmin)
  Else
    Call view.newLine(-airX, airYmin, -airX, airCutY)
    Call view.newLine(-airX, airCutY, -railWidth/2.0, airYmax)
    Call view.newLine(-railWidth/2.0, airYmax, railWidth/2.0, airYMax)
    Call view.newLine(airX, airYmin, airX, airCutY)
    Call view.newLine(airX, airCutY, railWidth/2.0, airYmax)
    Call view.newLine(-airX, airYmin, airX, airYmin)
  End If

  Call view.getSlice().moveInALine(-airZ - motionLength - airRailBoundary)
  Call view.selectAt(-1, 1, infoSetSelection, Array(infoSliceSurface))
  Call view.makeComponentInALine(airZ*2 + motionLength*2 + airRailBoundary*2, Array("Outer Air"), "Name=AIR", infoMakeComponentUnionSurfaces Or infoMakeComponentRemoveVertices)
  Call getDocument().setMaxElementSize("Outer Air", airResolution)
  Call view.getSlice().moveInALine(airZ + motionLength + airRailBoundary)
  Call getDocument().getView().setObjectVisible("Outer Air", False)

  Call view.selectAll(infoSetSelection, Array(infoSliceLine))
  Call view.deleteSelection()

  If BUILD_WITH_SYMMETRY Then
    Call getDocument().createBoundaryCondition(Array("Outer Air,Face#4"), "BoundaryCondition#1")
    Call getDocument().setMagneticFieldNormal("BoundaryCondition#1")
  End If




End Function
