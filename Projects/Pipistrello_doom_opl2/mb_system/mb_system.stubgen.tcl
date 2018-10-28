cd J:/Documents/Projects/Pipistrello_v2.0/MBduino/mb_system/
if { [ catch { xload xmp mb_system.xmp } result ] } {
  exit 10
}
xset hdl verilog
run stubgen
exit 0
