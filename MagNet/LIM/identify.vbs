Class ids
  Public copy_replace_strings

  Private core_matches
  Private remove_strings
  Private a_postfix
  Private b_postfix
  Private copper_keyword
  Private cores

  'Constructor
  Public Default Function init()
    copper_keyword = "CoilGeometry"
    core_matches = Array("Core",copper_keyword)
    remove_strings = Array(",","Body#1")
    copy_replace_strings = Array("Copy#1","Copy#9")

    a_postfix = "A"
    b_postfix = "B"
    cores = Array(a_postfix,b_postfix)
    Set init = Me
  End Function

  Public Function find_all_components_with_match(find)
    components = getDocument().getAllComponentPaths()
    find_all_components_with_match = find_with_match(components,find)
  End Function

  Public Function find_all_components_with_match_replace(find)
    components = getDocument().getAllComponentPaths()
    find_all_components_with_match_replace = find_with_match_replace(components,find)
  End Function

  Public Function find_with_match(arr,find)
    ReDim matches(-1)
    For i=0 to UBound(arr)
      For z=0 to UBound(find)
        If InStr(arr(i),find(z)) Then
          ReDim Preserve matches(UBound(matches) + 1)
          matches(UBound(matches)) = (arr(i))
        End if
      Next
    Next
    find_with_match = matches
  End Function

  Public Function find_with_match_replace(arr,find)
    ReDim matches(-1)
    For i=0 to UBound(arr)
      For z=0 to UBound(find)
        If InStr(arr(i),find(z)) Then
          ReDim Preserve matches(UBound(matches) + 1)
          matches(UBound(matches)) = remove_substrings(arr(i))
        End if
      Next
    Next
    find_with_match_replace = matches
  End Function

  Public Function find_with_not_match(arr,find)
    ReDim matches(-1)
    For i=0 to UBound(arr)
      For z=0 to UBound(find)
        If InStr(arr(i),find(z)) Then
          d=0
        Else
          ReDim Preserve matches(UBound(matches) + 1)
          matches(UBound(matches)) = (arr(i))
        End if
      Next
    Next
    find_with_not_match = matches
  End Function

  'Update core components to have postfix'
  'Called only when BUILD_WITH_SYMMETRY true'
  Public Function rename_mirror()
    matches = find_all_components_with_match_replace(copy_replace_strings)
    For i=0 to UBound(matches)
      new_name = replace_substrings(matches(i),b_postfix)
      Call rename_components(matches(i),replace_substrings(matches(i),b_postfix))
    Next
  End Function

  'Update core components to have postfix'
  'Need to call regardless of BUILD_WITH_SYMMETRY'
  Public Function update_names(append)
    matches = get_core_components()
    For i=0 to UBound(cores)
      If cores(i)<>append Then
        Call print(matches)
        matches = find_with_not_match(matches,Array(cores(i)))
      End If
    Next
    Call print(matches)
    For i=0 to UBound(matches)
      If InStr(matches(i),b_postfix)=0 Then
        Call rename_components(matches(i),append_substrings(matches(i)," "+append))
      End If
    Next
  End Function

  'Gets component names for A side'
  Public Function get_a_components()
    get_a_components = find_all_components_with_match_replace(Array(a_postfix))
  End Function

  'Gets component names for B side'
  Public Function get_b_components()
    get_b_components = find_all_components_with_match_replace(Array(a_postfix))
  End Function

  'Gets component names for all coil elements'
  Public Function get_coil_components()
    get_coil_components = find_all_components_with_match_replace(Array("Coil"))
  End Function

  Public Function get_coil_paths()
    get_coil_paths = find_all_components_with_match(Array("Coil"))
  End Function

  Public Function get_winding_components()
    get_winding_components = find_all_components_with_match_replace(Array(copper_keyword))
  End Function

  Public Function get_winding_paths()
    get_winding_paths = find_all_components_with_match(Array(copper_keyword))
  End Function

  Public Property Get get_core_components()
    get_core_components = find_all_components_with_match_replace(core_matches)
  End Property

  Public Property Get get_union_components()
    get_union_components = find_all_components_with_match_replace(Array("Union"))
  End Property

  Public Property Get get_copy_components()
    get_copy_components = find_all_components_with_match_replace(Array("Copy"))
  End Property

  'Removes predetermined substrings from (param) string '
  Public Function remove_substrings(str)
    For i=0 to UBound(remove_strings)
      str = Replace(str,remove_strings(i),"")
    Next
    remove_substrings = str
  End Function

  Public Function subtract_strings(str1,str2)
    diff = ""
    If (len(str1)>len(str2)) Then
      diff = Replace(str1,str2,"")
    Else
      diff = Replace(str2,str1,"")
    End If
    subtract_strings = diff
  End Function

  'Replaces (param) substring in (param) string'
  Public Function replace_substrings(str,repl)
    temp = str
    For i=0 to UBound(copy_replace_strings)
      If InStr(str,copy_replace_strings(i)) Then
        temp = Replace(temp,copy_replace_strings(i),repl)
      End If
    Next
    replace_substrings = temp
  End Function

  'Appends (param) substring to (param) string'
  Public Function append_substrings(str,app)
    append_substrings = str+app
  End Function

  Public Property Get get_winding_keyword()
    get_winding_keyword = copper_keyword
  End Property

End Class
