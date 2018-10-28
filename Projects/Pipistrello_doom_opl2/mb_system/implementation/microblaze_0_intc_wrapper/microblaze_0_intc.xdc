set_false_path -to [get_cells -filter {IS_SEQUENTIAL} INTC_CORE_I/*intr_sync*]
set_false_path -from [get_cells -filter {IS_SEQUENTIAL} INTC_CORE_I/*intr_sync*] -to [get_cells -filter {IS_SEQUENTIAL} INTC_CORE_I/*intr_p1*]
### No false path constraints for paths crossing between AXI clock and processor clock domains
