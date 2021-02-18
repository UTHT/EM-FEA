'Save Flags'
'Note: Save flags match result tabs in Simcenter MagNet (open the results window and look at top bar)'
const SAVE_ENERGY = True             ' Save the Magnetic Energy/Coenergy'
const SAVE_BODY_FORCE = True          ' Save body force results'
const SAVE_COMPONENT_FORCE = True    ' Save component force results'
const SAVE_FLUX_LINKAGE = True        ' Save flux linkage results'
const SAVE_OHMIC_LOSS = True          ' Save ohmic loss (winding loss) results'
const SAVE_IRON_LOSS = True           ' Save iron loss (core loss) results'
const SAVE_CURRENT = True             ' Save current results'
const SAVE_VOLTAGE = True             ' Save voltage results'
const SAVE_TEMPERATURE = True        ' Save temperature results'
const SAVE_MOTION = True              ' Save motion results'


Function export_data(num)
  'Create file system object directory'
  Set fso = CreateObject("Scripting.FileSystemObject")


  cur_location = fso.GetAbsolutePathName(".")
  cur_time = get_current_timestamp()

  save_path = cur_location+"\"+cur_time+"\"

  save_postfix = "_"+num+".csv"

  'Create a new folder with timestamp as name if does not exist'
  If Not fso.FolderExists(save_path) Then
    fso.CreateFolder(save_path)
  End If

  'Save data'
  If(SAVE_ENERGY) Then
    Call getGlobalResultsView().exportData(infoDataEnergy,save_path+"energy"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_BODY_FORCE) Then
    Call getGlobalResultsView().exportData(infoDataForce,save_path+"force"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_COMPONENT_FORCE) Then
    Call getGlobalResultsView().exportData(infoDataComponentForce,save_path+"component_force"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_FLUX_LINKAGE) Then
    Call getGlobalResultsView().exportData(infoDataFluxLinkage,save_path+"flux_linkage"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_OHMIC_LOSS) Then
    Call getGlobalResultsView().exportData(infoDataOhmicLoss,save_path+"ohmic_loss"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_IRON_LOSS) Then
    Call getGlobalResultsView().exportData(infoDataIronLoss,save_path+"iron_loss"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_CURRENT) Then
    Call getGlobalResultsView().exportData(infoDataCurrent,save_path+"current"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_VOLTAGE) Then
    Call getGlobalResultsView().exportData(infoDataVoltage,save_path+"voltage"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_TEMPERATURE) Then
    Call getGlobalResultsView().exportData(infoDataTemperature,save_path+"temperature"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

  If(SAVE_MOTION) Then
    Call getGlobalResultsView().exportData(infoDataMotion,save_path+"motion"+save_postfix,infoDataFormatLocaleListSeparatorDelimitedLocaleDecimal)
  End If

End Function
