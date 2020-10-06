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
