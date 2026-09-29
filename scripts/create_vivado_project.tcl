# Recreate the Vivado project for this repo. Sources are referenced in place (not copied),
# so edits made in Vivado land directly in rtl/ and tb/ and are tracked by git.
# Usage:  vivado -mode batch -source scripts/create_vivado_project.tcl [-tclargs <top_tb>]
set repo     [file normalize [file join [file dirname [info script]] ..]]
set proj_dir "C:/fpga/vivado/riscv_cpu"
set top_tb   [expr {[llength $argv] > 0 ? [lindex $argv 0] : "regfile_tb"}]

create_project riscv_cpu $proj_dir -part xc7a35tcpg236-1 -force
add_files -norecurse [glob $repo/rtl/*.v]
add_files -fileset sim_1 -norecurse [glob $repo/tb/*.v]
set_property top $top_tb [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
close_project
