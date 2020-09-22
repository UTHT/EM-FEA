Class ids
  Private core_matches
  Private remove_strings
  Public copy_replace_strings

  Private a_postfix
  Private b_postfix

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
    matches = find_all_components_with_match_replace(copy_replace_strings)
    For i=0 to UBound(matches)
      new_name = replace_substrings(matches(i),b_postfix)
      Call rename_components(matches(i),replace_substrings(matches(i),b_postfix))
    Next
    matches = get_core_components()
    For i=0 to UBound(matches)
      If InStr(matches(i),b_postfix)=0 Then
        Call rename_components(matches(i),append_substrings(matches(i)," "+a_postfix))
      End If
    Next
  End Function

  Public Function remove_substrings(str)
    For i=0 to UBound(remove_strings)
      str = Replace(str,remove_strings(i),"")
    Next
    remove_substrings = str
  End Function

  Public Function replace_substrings(str,repl)
    temp = str
    For i=0 to UBound(copy_replace_strings)
      If InStr(str,copy_replace_strings(i)) Then
        temp = Replace(temp,copy_replace_strings(i),repl)
      End If
    Next
    replace_substrings = temp
  End Function

  Private Function append_substrings(str,app)
    append_substrings = str+app
  End Function

  Public Property Get get_core_components()
    get_core_components = find_all_components_with_match_replace(core_matches)
  End Property

End Class
