opt_design -directive Explore -verbose
place_design -directive Explore -verbose
phys_opt_design -directive Explore -verbose
report_timing_summary -file output/post_place_timing_summary.rpt
route_design -directive Explore -verbose
report_timing_summary -file output/post_route_timing_summary.rpt
report_timing -sort_by group -max_paths 100 -path_type summary -file output/post_route_timing.rpt
report_clock_utilization -file output/clock_util.rpt
report_utilization -file output/post_route_util.rpt
report_power -file output/post_route_power.rpt
report_drc -file output/post_imp_drc.rpt
write_checkpoint -force output/implemented_design.dcp

