Class ids
  Private num_coils
  Private core_matches

  'Constructor
  Public Default Function init(nc)
    num_coils = nc
    core_matches = Array("Core","Coil")
    Set init = Me
  End Function

  Public Function find_all_components_with_match(find)
    ReDim matches(-1)
    For i=0 to UBound(component_names)
      For z=0 to UBound(find)
        If InStr(component_names(i),find(z)) Then
          ReDim Preserve matches(UBound(matches) + 1) : matches(UBound(matches)) = component_names(i)
        End if
      Next
    Next
    find_all_components_with_match = matches
  End Function

  Public Property Get get_components()
    get_components = getDocument().getAllComponentPaths()
  End Property

End Class
