Class ids
  Private num_coils
  Private mirror

  Private component_names
  Private component_names_a
  Private component_names_b

  'Constructor
  Public Default Function init(nc)
    num_coils = nc
    component_names = Array()
    component_names_a = Array()
    component_names_b = Array()

    Set init = Me
  End Function

  Public Function add_component(name)
    If(UBound(component_names)>=0) Then
      ReDim Preserve component_names(UBound(component_names) + 1)
      component_names(UBound(component_names)) = name
    Else
      component_names = Array(name)
    End if
  End Function

  'Public Function modify_component(name)

  'End Function

  Public Function find_all_components_with_match(find)
    ReDim matches(-1)
    For i=0 to UBound(component_names)
      If component_names(i).Contains(find) Then
        ReDim Preserve matches (UBound(matches) + 1) : matches(UBound(matches)) = component_names(i)
      End if
    Next
    find_all_components_with_match = matches
  End Function

  Public Property Get get_component_names()
    get_component_names = component_names
  End Property

  Public Property Get a_component_names()
    a_component_names = component_names_a
  End Property

  Public Property Get b_component_names()
    b_component_names = component_names_b
  End Property

End Class
