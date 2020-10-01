
Function build_single_side()
  Call make_core_component()
  Call make_single_side_windings(make_winding())
  Call make_single_side_coils()
  'Call print(ids_o.get_core_components())
End Function

Function orient_A()
  Call ids_o.update_names("A")
  components = ids_o.get_a_components()
  Call select_a_components()
  Call orient_core_a()
  Call move_core_to_midtrack(components)
  Call insert_core_airgap(components,1)
  Call getDocument().getView().unselectAll()
End Function

Function orient_B()
  Call ids_o.update_names("B")
  components = ids_o.get_b_components()
  Call select_b_components()
  Call orient_core_b()
  Call move_core_to_midtrack(components)
  Call insert_core_airgap(components,-1)
  Call getDocument().getView().unselectAll()
End Function


Function build_motor()
  build_single_side()
  orient_A()
  If NOT (BUILD_WITH_SYMMETRY) Then
    build_single_side()
    orient_B()
    For i = 1 to num_coils
      component_coil = "Coil#"&(i+num_coils)
      print(component_coil)
      Call view.selectObject(component_coil, infoSetSelection)
      Call getDocument().reverseCoilDirection(component_coil)
    Next
  End If
End Function
