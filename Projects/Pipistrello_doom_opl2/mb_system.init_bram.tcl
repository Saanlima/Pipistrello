cd D:/Documents/Projects/Pipistrello_v2.0/Pipistrello_dvi565_doom_opl2_new/mb_system
if { [ catch { xload xmp mb_system.xmp } result ] } {
  exit 10
}

if { [catch {run init_bram} result] } {
  exit -1
}

exit 0
