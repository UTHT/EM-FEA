Class ids
  Private core_matches
  Private remove_strings
  Private copy_replace_strings

  Private a_prefix
  Private b_prefix

  'Constructor
  Public Default Function init()
    core_matches = Array("Core","Coil")
    remove_strings = Array(",","Body#1")
    copy_replace_strings = Array("Copy#1","Copy#9")

    a_postfix = "A1"
    b_postfix = "B2"
    Set init = Me
  End Function

  Public Function find_all_components_with_match(find)
    ReDim matches(-1)
    components = getDocument().getAllComponentPaths()
    For i=0 to UBound(components)
      For z=0 to UBound(find)
        If InStr(components(i),find(z)) Then
          ReDim Preserve matches(UBound(matches) + 1)
          matches(UBound(matches)) = (components(i))
        End if
      Next
    Next
    find_all_components_with_match = matches
  End Function

  Public Function find_all_components_with_match_replace(find)
    ReDim matches(-1)
    components = getDocument().getAllComponentPaths()
    For i=0 to UBound(components)
      For z=0 to UBound(find)
        If InStr(components(i),find(z)) Then
          ReDim Preserve matches(UBound(matches) + 1)
          matches(UBound(matches)) = remove_substrings(components(i))
        End if
      Next
    Next
    find_all_components_with_match_replace = matches
  End Function

  Public Function rename_mirror()
    matches = find_all_components_with_match(copy_replace_strings)
    For i=0 to UBound(matches)
      'Call print(matches)
      Call rename_components(matches(i),replace_substrings(matches(i),b_prefix))
    Next
    find_all_components_with_match = matches
  End Function

  Public Function remove_substrings(str)
    For i=0 to UBound(remove_strings)
      str = Replace(str,remove_strings(i),"")
    Next
    remove_substrings = str
  End Function

  Public Function replace_substrings(str,repl)
    For i=0 to UBound(copy_replace_strings)
      str = Replace(str,copy_replace_strings(i),repl)
    Next
    replace_substrings = str
  End Function

  Public Property Get get_core_components()
    get_core_components = find_all_components_with_match_replace(core_matches)
  End Property

End Class
