read_file -format verilog "Top.v"
current_design Top
create_clock -name "clk" -period 10 -waveform { 0 5  }  { clk  }
set_fix_hold [ find clock clk ]
set_dont_touch_network [ find clock clk ]
set_operating_conditions -min_library fast -min fast -max_library slow -max slow
set_driving_cell -library slow -lib_cell DFFX2 -dont_scale -no_design_rule [all_inputs]
set_load [load_of "slow/DFFX2/D"] [all_outputs]
set_input_delay -clock clk -max 1 [remove_from_collection [all_inputs] [get_ports clk]]
set_input_delay -clock clk -min 0.2 [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay -max 1 -clock clk [all_outputs]
set_output_delay -min 0.1 -clock clk [all_outputs]
set auto_wire_load_selection false
set_wire_load_model -name tsmc18_wl10 -library slow
set_wire_load_mode top 
set_max_area 10000
check_design
compile -map_effort medium -area_effort medium
report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group
report_timing -path full -delay min -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group
report_area -nosplit
report_power
write -hierarchy -format verilog -output Top_syn.v
write_sdf -version 1.0 -context verilog Top_syn.sdf


