class router_env extends uvm_env;

	`uvm_component_utils(router_env)//factory registration

	source_agent_top src_agt_top;
	dest_agent_top dest_agt_top;
	router_scoreboard sb;
	router_virtual_sequencer v_seqr;

//	source_agent src_agt[];
//	dest_agent dest_agt[];

	router_env_config env_cfg;
	
 	function new(string name="router_env", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(router_env_config)::get(this,"*","router_env_config",env_cfg))
			`uvm_fatal("env config","cannot get env_config from uvm_config")
		super.build_phase(phase);
		if(env_cfg.has_source_agent_top==1)
			src_agt_top = source_agent_top::type_id::create("src_agt_top",this);
		if(env_cfg.has_dest_agent_top==1)
			dest_agt_top = dest_agent_top::type_id::create("dest_agt_top",this);
		if(env_cfg.has_scoreboard==1)
			sb = router_scoreboard::type_id::create("sb",this);
		if(env_cfg.has_virtual_sequencer==1)
			v_seqr = router_virtual_sequencer::type_id::create("v_seqr",this);
		
	//	src_agt = new[env_cfg.no_of_source_agents];
	//	dest_agt = new[env_cfg.no_of_dest_agents];

	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		for(int i=0;i<env_cfg.no_of_source_agents;i++)
			v_seqr.src_seqr[i] = src_agt_top.src_agt[i].sqrh;
		for(int i=0;i<env_cfg.no_of_dest_agents;i++)
			v_seqr.dest_seqr[i] = dest_agt_top.dest_agt[i].sqrh;
			
		for(int i=0;i<env_cfg.no_of_source_agents;i++)
		src_agt_top.src_agt[i].monh.src_monitor_port.connect(sb.src_fifo[i].analysis_export);
	
		for(int i=0;i<env_cfg.no_of_dest_agents;i++)
			dest_agt_top.dest_agt[i].monh.dest_monitor_port.connect(sb.dest_fifo[i].analysis_export);
	//	dest_agt_top.dest_agt[1].monh.dest_monitor_port.connect(sb.dest_fifo[1]);
	//	dest_agt_top.dest_agt[2].monh.dest_monitor_port.connect(sb.dest_fifo[2]);
		
	endfunction
endclass
