class dest_agent_top extends uvm_env;
	`uvm_component_utils(dest_agent_top)

	int num;
	dest_agent dest_agt[];
	router_env_config m_cfg;
	router_dest_agent_config agt_cfg[];

	extern function new(string name = "dest_agent_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass: dest_agent_top
//------------------------------------------------------------------------------------//
		
function dest_agent_top::new(string name="dest_agent_top", uvm_component parent);
	super.new(name,parent);
endfunction: new
			
function void dest_agent_top::build_phase(uvm_phase phase);	
	if(!uvm_config_db#(router_env_config)::get(this,"*","router_env_config",m_cfg))
		`uvm_fatal("src_top config","cannot get config from uvm_config")
	num = m_cfg.no_of_dest_agents;
	dest_agt = new[num];
	foreach(dest_agt[i])
		dest_agt[i] = dest_agent::type_id::create($sformatf("dest_agt[%0d]",i),this);			
endfunction: build_phase
			
