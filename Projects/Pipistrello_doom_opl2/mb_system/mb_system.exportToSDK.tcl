proc exportToSDK {} {
  cd D:/Documents/Projects/Pipistrello_v2.0/Pipistrello_dvi565_doom_opl2_new/mb_system
  if { [ catch { xload xmp mb_system.xmp } result ] } {
    exit 10
  }
  if { [run exporttosdk] != 0 } {
    return -1
  }
  return 0
}

if { [catch {exportToSDK} result] } {
  exit -1
}

set sExportDir [ xget sdk_export_dir ]
set sExportDir [ file join "D:/Documents/Projects/Pipistrello_v2.0/Pipistrello_dvi565_doom_opl2_new/mb_system" "$sExportDir" "hw" ] 
if { [ file exists D:/Documents/Projects/Pipistrello_v2.0/Pipistrello_dvi565_doom_opl2_new/edkBmmFile_bd.bmm ] } {
   puts "Copying placed bmm file D:/Documents/Projects/Pipistrello_v2.0/Pipistrello_dvi565_doom_opl2_new/edkBmmFile_bd.bmm to $sExportDir" 
   file copy -force "D:/Documents/Projects/Pipistrello_v2.0/Pipistrello_dvi565_doom_opl2_new/edkBmmFile_bd.bmm" $sExportDir
}
if { [ file exists D:/Documents/Projects/Pipistrello_v2.0/Pipistrello_dvi565_doom_opl2_new/mb_system_top.bit ] } {
   puts "Copying bit file D:/Documents/Projects/Pipistrello_v2.0/Pipistrello_dvi565_doom_opl2_new/mb_system_top.bit to $sExportDir" 
   file copy -force "D:/Documents/Projects/Pipistrello_v2.0/Pipistrello_dvi565_doom_opl2_new/mb_system_top.bit" $sExportDir
}
exit $result
