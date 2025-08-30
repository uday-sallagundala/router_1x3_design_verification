class dest_sequencer extends uvm_sequencer #(dest_xtn);
	
	`uvm_component_utils(dest_sequencer)
	
//router_source_driver	router_source_agent_config src_cfg;
	
	extern function new(string name="dest_sequencer",uvm_component parent);
endclass: dest_sequencer
//---------------------------------------------------------------------------------//

function dest_sequencer::new(string name="dest_sequencer",uvm_component parent);
		super.new(name,parent);
endfunction: new
