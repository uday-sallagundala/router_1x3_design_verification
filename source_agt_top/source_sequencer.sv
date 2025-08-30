class source_sequencer extends uvm_sequencer #(source_xtn);
	
	`uvm_component_utils(source_sequencer)
	
//router_source_driver	router_source_agent_config src_cfg;
	
	extern function new(string name="source_sequencer",uvm_component parent);
endclass: source_sequencer
//---------------------------------------------------------------------------------//

function source_sequencer::new(string name="source_sequencer",uvm_component parent);
		super.new(name,parent);
endfunction: new
