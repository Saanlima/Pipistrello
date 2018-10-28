##############################################################################
## Filename:          J:\Documents\Projects\Pipistrello_v2.0\MBduino\mb_system/drivers/timebase_v1_00_a/data/timebase_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Sun Mar 03 18:31:42 2013 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "timebase" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
