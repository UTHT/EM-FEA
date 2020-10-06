
Function make_track(SHOW_FORBIDDEN_AIR,SHOW_FULL_GEOMETRY,BUILD_WITH_SYMMETRY)
  If SHOW_FORBIDDEN_AIR Then
  	Call generate_forbidden_zones()
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

  rail = "Track"
  p1 = "Plate 1"
  p2 = "Plate 2"

  Call generate_two_sided_component(rail,track_material,0,rail_height/2.0,z_min,z_max+motion_length)
  'Call getDocument().setMaxElementSize(rail, aluminiumResolution)

  Call view.newLine(-x_max, 0, -rail_width/2.0 - plate_gap, 0)
  Call view.newLine(-rail_width/2.0 - plate_gap, 0, -rail_width/2.0 - plate_gap, plate_thickness)
  Call view.newLine(-rail_width/2.0 - plate_gap, plate_thickness, -x_max, plate_thickness)
  Call view.newLine(-x_max, plate_thickness, -x_max, 0)

  Call generate_two_sided_component(p1,track_material,-rail_width/2.0-plate_gap-10,plate_thickness/2.0,z_min,z_max+motion_length)
  'Call getDocument().setMaxElementSize(p1, aluminiumResolution)

  If NOT(BUILD_WITH_SYMMETRY) Then
  	Call view.newLine(x_max, 0, rail_width/2.0 + plate_gap, 0)
  	Call view.newLine(rail_width/2.0 + plate_gap, 0, rail_width/2.0 + plate_gap, plate_thickness)
  	Call view.newLine(rail_width/2.0 + plate_gap, plate_thickness, x_max, plate_thickness)
  	Call view.newLine(x_max, plate_thickness, x_max, 0)

    Call generate_two_sided_component(p2,track_material,rail_width/2.0+plate_gap+10,plate_thickness/2.0,z_min,z_max+motion_length)
  	'Call getDocument().setMaxElementSize(p2, aluminiumResolution)
  End If

  Call clear_construction_lines()
End Function

Function generate_forbidden_zones()
  Call view.newLine(-rail_width/2.0 - plate_gap, 0, -rail_width/2.0 - plate_gap, bottom_forbidden_height)
  Call view.newLine(-rail_width/2.0 - plate_gap, bottom_forbidden_height, rail_width/2.0 + plate_gap, bottom_forbidden_height)
  Call view.newLine(rail_width/2.0 + plate_gap, bottom_forbidden_height, rail_width/2.0 + plate_gap, 0)
  Call view.newLine(rail_width/2.0 + plate_gap, 0, -rail_width/2.0 - plate_gap, 0)

  Call view.newLine(-top_forbidden_width/2.0, rail_height - flange_thickness - top_forbidden_height, -top_forbidden_width/2.0, rail_height - flange_thickness)
  Call view.newLine(-top_forbidden_width/2.0, rail_height - flange_thickness, top_forbidden_width/2.0, rail_height - flange_thickness)
  Call view.newLine(top_forbidden_width/2.0, rail_height - flange_thickness, top_forbidden_width/2.0, rail_height - flange_thickness - top_forbidden_height)
  Call view.newLine(top_forbidden_width/2.0, rail_height - flange_thickness - top_forbidden_height, -top_forbidden_width/2.0, rail_height - flange_thickness - top_forbidden_height)

  fa_name_1 = "Forbidden Air 1"
  fa_name_2 = "Forbidden Air 2"

  Call generate_two_sided_component(fa_name_1,air_material,0,bottom_forbidden_height/2.0,z_min,z_max)
  'Call getDocument().setMaxElementSize(fa_name_1, airResolution)
  Call getDocument().setComponentColor(fa_name_1, RGB(255, 0, 0), 50)

  Call generate_two_sided_component(fa_name_2,air_material,0,rail_height-flange_thickness-top_forbidden_height/2.0,z_min,z_max)
  'Call getDocument().setMaxElementSize("Forbidden Air 2", airResolution)
  Call getDocument().setComponentColor(fa_name_2, RGB(255, 0, 0), 50)

  Call clear_construction_lines()
End Function
