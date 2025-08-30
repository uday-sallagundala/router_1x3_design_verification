class source_agent extends uvm_agent;
	`uvm_component_utils(source_agent)

	router_source_agent_config src_cfg;

	source_driver drvh;
	source_monitor monh;
	source_sequencer sqrh;
	
	
function new(string name="source_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
		super.build_phase(phase);
                // get the config object using uvm_config_db 
	  	if(!uvm_config_db #(router_source_agent_config)::get(this,"","router_source_agent_config",src_cfg))
			`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
	        monh=source_monitor::type_id::create("monh",this);	
		if(src_cfg.is_active==UVM_ACTIVE)
			begin
				drvh=source_driver::type_id::create("drvh",this);
				sqrh=source_sequencer::type_id::create("sqrh",this);
			end
endfunction

function void connect_phase(uvm_phase phase);
	if(src_cfg.is_active == UVM_ACTIVE)begin
		drvh.seq_item_port.connect(sqrh.seq_item_export);
	end
endfunction

endclass
