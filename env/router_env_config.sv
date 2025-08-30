class router_env_config extends uvm_object;

	`uvm_object_utils(router_env_config)

	bit has_scoreboard = 1;
	bit has_virtual_sequencer = 1;

	bit has_source_agent_top = 1;
	bit has_dest_agent_top = 1;
							
	int no_of_source_agents = 1;
	int no_of_dest_agents = 3;

	router_source_agent_config src_agt_cfg[];
	router_dest_agent_config dest_agt_cfg[];


extern function new(string name = "router_env_config");

endclass: router_env_config
//-----------------  constructor new method  -------------------//

function router_env_config::new(string name = "router_env_config");
  	super.new(name);
endfunction
