
Set exc_o = new export_data.init()

Class export_data

  Private excel_obj
  Private excel_workbook_obj
  Private save_location
  Private save_location_postfix
  Private excel_file_postfix

  Public Default Function init()
    'Create excel object, set to be visible'
    Set excel_obj = CreateObject("Excel.Application")
    excel_obj.Application.Visible = True

    'Get current directory of script => location of saved output files'
    Set fso = CreateObject("Scripting.FileSystemObject")
    save_location = FSO.GetAbsolutePathName(".")

    'If you want your data to be saved into another subfolder, add the subfolder name here'
    'Don't add the \, just write the name of the folder'
    'Make sure the directory you are trying to save to exists!'
    save_location_postfix = ""

    excel_file_postfix = ".xlsx"

    Print(get_save_path())

    Set excel_workbook_obj = excel_obj.Workbooks.Add()

    excel_obj.Cells(1,1).Value = "Hello"

    'excel_workbook_obj.SaveAs "D:\Repos\EM-FEA\MagNet\Excel\test.xlsx"
    save_file("test")

    'close()
    Set init = me
  End Function

  'Get path for output files to be saved to'
  Public Function get_save_path()
    If(save_location_postfix="") Then
      get_save_path = save_location+"\"
    Else
      get_save_path = save_location+"\"+save_location_postfix+"\"
    End if
  End Function

  'Save excel file with given file name'
  Public Function save_file(file_name)
    full_file_name = get_save_path()+file_name+excel_file_postfix
    Print(full_file_name)
    excel_workbook_obj.SaveAs full_file_name
  End Function

  Public Function close()
    'Close workbook and quit excel'
    excel_workbook_obj.Close
    excel_obj.Quit

    'Free variables'
    excel_workbook_obj = Nothing
    excel_obj = Nothing
  End Function


End Class


Function print_arr(input_arr)
  Dim output_str
  output_str = output_str&"["
  For each x in input_arr
    output_str = output_str&x&","
  Next
  print_arr = output_str&"]"
End Function

'Prints a given variable'
'Supports integer, string, and array'
'params:'
'(Array, int, string)' variable to be printed
Function print(input)
  If(IsArray(input)) Then
    Call app.MsgBox(print_arr(input))
  ElseIf(IsNumeric(input)) Then
    Call app.MsgBox(Cstr(input))
  Else
    Call app.MsgBox(input)
  End If
End Function
