
Function build_single_side()
  Call make_core_component()
  Call make_single_side_windings(make_winding())
  Call make_single_side_coils()
  'Call print(ids_o.get_core_components())
End Function

Function orient_A()
  Call select_core_components()
  Call orient_core()
  Call move_core_to_midtrack()
  Call insert_core_airgap()
  Call ids_o.update_names("A")
  Call print(ids_o.get_coil_paths())
  Call print(ids_o.get_winding_paths())
End Function

Function build_motor()
  build_single_side()
  orient_A()
  If NOT (BUILD_WITH_SYMMETRY) Then
    Call make_core_component()
    Call make_single_side_windings(make_winding())
    Call make_single_side_coils()
    'Call select_core_components()
    'Call orient_core()
    'Call move_core_to_midtrack()
    'Call insert_core_airgap()
    'Call mirror_components()
  End If
  'Call ids_o.update_names()
  'Call make_coils()
End Function
