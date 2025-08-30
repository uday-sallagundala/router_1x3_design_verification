package router_test_pkg;

	import uvm_pkg::*;

	`include "uvm_macros.svh"
	
	`include "source_xtn.sv"
	`include "router_source_agent_config.sv"
	`include "router_dest_agent_config.sv"
	`include "router_env_config.sv"
	`include "source_driver.sv"
	`include "source_monitor.sv"
	`include "source_sequencer.sv"
	`include "source_agent.sv"
	`include "source_agent_top.sv"
	`include "source_sequence.sv"

	`include "dest_xtn.sv"
	`include "dest_driver.sv"
	`include "dest_monitor.sv"
	`include "dest_sequencer.sv"
	`include "dest_agent.sv"
	`include "dest_agent_top.sv"
	`include "dest_sequence.sv"

	`include "router_virtual_sequencer.sv"
	`include "router_virtual_sequence.sv"
	`include "router_scoreboard.sv"

	`include "router_env.sv"

	`include "router_test.sv"
endpackage
