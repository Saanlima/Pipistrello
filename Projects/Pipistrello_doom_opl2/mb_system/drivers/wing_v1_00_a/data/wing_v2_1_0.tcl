##############################################################################
## Filename:          J:\Documents\Projects\Pipistrello_v2.0\MBduino\mb_system/drivers/wing_v1_00_a/data/wing_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Sun Mar 03 08:39:22 2013 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "wing" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
