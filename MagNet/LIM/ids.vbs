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

  Public Function generate_core(name)
    Call getDocument().getApplication().MsgBox(UBound(component_names))
    ReDim Preserve component_names(UBound(component_names) + 1)
    component_names(UBound(component_names)) = name
    Call getDocument().getApplication().MsgBox(UBound(component_names))
  End Function

  Public Property Get a_component_names()
    a_component_names = component_names_a
  End Property

  Public Property Get b_component_names()
    b_component_names = component_names_b
  End Property

End Class
