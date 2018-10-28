###############################################################################
##
## Copyright (c) 2008 Xilinx, Inc. All Rights Reserved.
##
## xps_tft_v2_1_0.tcl
##
###############################################################################


## @BEGIN_CHANGELOG EDK_K_SP3
##
## Added core level constraints
##
## @END_CHANGELOG


#***--------------------------------***-----------------------------------***
#
#                CORE_LEVEL_CONSTRAINTS
#
#***--------------------------------***-----------------------------------***



proc generate_corelevel_ucf {mhsinst} {


    set filepath [pwd]
    
    set  instname     [xget_hw_parameter_value $mhsinst "INSTANCE"]
    set  include_plb  [xget_hw_parameter_value $mhsinst "C_DCR_SPLB_SLAVE_IF"]
    set  include_dvi  [xget_hw_parameter_value $mhsinst "C_TFT_INTERFACE"]

    set  filePath [xget_ncf_dir $mhsinst]

    file mkdir    $filePath

    # specify file name
    set    instname [xget_hw_parameter_value $mhsinst "INSTANCE"]
    set    fileName [string tolower  $instname]
    append fileName "_wrapper.ucf"
    append filePath $fileName


    # Open a file for writing
    set    outputFile       [open $filePath "w"]



    puts   $outputFile "INST \"*TFT_CTRL_I/FD_PLB_RST6*\" TNM = \"TNM_MPLB_RST_$instname\";"
    puts   $outputFile "INST \"*TFT_CTRL_I/tft_rst_*\" TNM = \"TNM_TFT_RST_$instname\";"

    puts   $outputFile "INST \"*TFT_CTRL_I/SLAVE_REG_U6/TFT_on_reg*\" TNM = \"TNM_SLAVE_ONREG_$instname\";"
    puts   $outputFile "INST \"*tft_on_reg_bram_d2*\" TNM = \"TNM_MPLB_ONREG_$instname\";"

    puts   $outputFile "TIMESPEC \"TS_SPLB2MPLB_$instname\" = FROM \"TNM_SLAVE_ONREG_$instname\" TO \"TNM_MPLB_ONREG_$instname\" TIG;"
    puts   $outputFile "TIMESPEC \"TS_MPLB2TFT_$instname\" = FROM \"TNM_MPLB_RST_$instname\" TO \"TNM_TFT_RST_$instname\" TIG;"
    
    puts   $outputFile "INST \"*/VSYNC_U3/V_bp_cnt_tc*\" TNM = \"TNM_TFT_CLOCK_$instname\";"
    puts   $outputFile "INST \"*/VSYNC_U3/V_p_cnt_tc*\" TNM = \"TNM_TFT_CLOCK_$instname\";"
    puts   $outputFile "INST \"*/TFT_CTRL_I/get_line_start_d1*\" TNM = \"TNM_TFT_CLOCK_$instname\";"

    puts   $outputFile "INST \"*/TFT_CTRL_I/v_bp_cnt_tc_d1*\" TNM = \"TNM_MPLB_CLOCK_$instname\";"
    puts   $outputFile "INST \"*/TFT_CTRL_I/v_p_cnt_tc_d1*\" TNM = \"TNM_MPLB_CLOCK_$instname\";"
    puts   $outputFile "INST \"*/TFT_CTRL_I/get_line_start_d2*\" TNM = \"TNM_MPLB_CLOCK_$instname\";"

    puts   $outputFile "TIMESPEC \"TS_TFT_MPLB_CLOCK_$instname\" = FROM \"TNM_TFT_CLOCK_$instname\" TO \"TNM_MPLB_CLOCK_$instname\" TIG;"

    if { $include_dvi == 1 } {
        puts   $outputFile "INST \"*TFT_CTRL_I/TFT_IF_U5/gen_dvi_if.iic_init/Done*\" TNM = \"TNM_I2C_DONE_$instname\";"
        puts   $outputFile "TIMESPEC \"TS_MPLB2TFT1_$instname\" = FROM \"TNM_I2C_DONE_$instname\" TO \"TNM_TFT_RST_$instname\" TIG;"
      }

    # Close the file
    close  $outputFile

    puts   [xget_ncf_loc_info $mhsinst]

}


