Function make_airbox(BUILD_WITH_SYMMETRY)
  airbox = "AirBox"
  If BUILD_WITH_SYMMETRY Then
    Call draw_square(x_min,-x_max,y_min,y_max)
  Else
    Call draw_square(-x_max,x_max,y_min,y_max)
  End If
  Call generate_two_sided_component(airbox,air_material,-x_max+1,y_max-1,z_min,z_max+motion_length)
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

Function temp_unused()
  If FALSE Then
    Call view.newLine(x_min, y_min, -airX, airCutY)
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
