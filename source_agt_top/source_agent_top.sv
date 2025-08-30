class source_agent_top extends uvm_env;
	`uvm_component_utils(source_agent_top)

	int num;
	source_agent src_agt[];
	router_env_config m_cfg;
	router_source_agent_config agt_cfg;

	extern function new(string name = "source_agent_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	//extern task run_phase(uvm_phase phase);

endclass: source_agent_top
//------------------------------------------------------------------------------------//
		
function source_agent_top::new(string name="source_agent_top", uvm_component parent);
	super.new(name,parent);
endfunction: new
			
function void source_agent_top::build_phase(uvm_phase phase);
	//agt_cfg = router_source_agent_config::type_id::create("router_source_agent_config",this);	
	//uvm_config_db #(router_source_agent_config)::set(this,"*","router_source_agent_config",agt_cfg);
	
	if(!uvm_config_db#(router_env_config)::get(this,"*","router_env_config",m_cfg))
		`uvm_fatal("src_top config","cannot get config from uvm_config")
	num = m_cfg.no_of_source_agents;
	src_agt = new[num];
	foreach(src_agt[i])
		src_agt[i] = source_agent::type_id::create($sformatf("src_agt[%0d]",i),this);

endfunction: build_phase
			
//function void source_agent_top::end_of_elaboration_phase(uvm_phase phase);
//	uvm_top.print_topology();
//endfunction: end_of_elaboration_phase
