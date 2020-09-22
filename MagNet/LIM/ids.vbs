Class ids
  Private num_coils
  Private core_matches

  'Constructor
  Public Default Function init(nc)
    num_coils = nc
    core_matches = Array("Core","Coil")
    'remove_strings = Array(",","Body#1")
    Set init = Me
  End Function

  Public Function find_all_components_with_match(find)
    ReDim matches(-1)
    components = getDocument().getAllComponentPaths()
    For i=0 to UBound(components)
      For z=0 to UBound(find)
        'print(components(i))
        'print(find(z))
        If InStr(components(i),find(z)) Then
          'print("Here")
          ReDim Preserve matches(UBound(matches) + 1)
          matches(UBound(matches)) = components(i)
        End if
      Next
    Next
    find_all_components_with_match = matches
  End Function


  Public Property Get get_core_components()
    get_core_components = find_all_components_with_match(core_matches)
  End Property

End Class
