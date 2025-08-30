class dest_agent extends uvm_agent;
	`uvm_component_utils(dest_agent)

	router_dest_agent_config dest_cfg;

	dest_driver drvh;
	dest_monitor monh;
	dest_sequencer sqrh;
	
	function new(string name="dest_agent",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
    //get the config object using uvm_config_db 
    if(!uvm_config_db #(router_dest_agent_config)::get(this,"","router_dest_agent_config",dest_cfg))
			`uvm_fatal("CONFIG","cannot get() dest_cfg from uvm_config_db. Have you set() it?") 
	  monh=dest_monitor::type_id::create("monh",this);	
		if(dest_cfg.is_active==UVM_ACTIVE)
			begin
				drvh=dest_driver::type_id::create("drvh",this);
				sqrh=dest_sequencer::type_id::create("sqrh",this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(dest_cfg.is_active == UVM_ACTIVE)begin
			drvh.seq_item_port.connect(sqrh.seq_item_export);
		end	
	endfunction
endclass
