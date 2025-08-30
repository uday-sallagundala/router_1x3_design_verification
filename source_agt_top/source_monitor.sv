class source_monitor extends uvm_monitor;
	
	`uvm_component_utils(source_monitor)

	virtual router_if.SRC_MON_MP vif;
  	uvm_analysis_port #(source_xtn) src_monitor_port;
	router_source_agent_config src_cfg;

	source_xtn item;

	function new(string name="source_monitor",uvm_component parent);
		super.new(name,parent);
		src_monitor_port = new("src_monitor_port",this);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(router_source_agent_config)::get(this,"","router_source_agent_config",src_cfg))
			`uvm_fatal("src_mon","cannot get() src_cfg from uvm_config_db. Have you set() it?") 
		item = source_xtn::type_id::create("item");

        endfunction

	function void connect_phase(uvm_phase phase);
          vif = src_cfg.vif;
        endfunction
	
	task run_phase(uvm_phase phase);
		forever
			begin
				collect_data();	
			end
	endtask

	task collect_data();
		while(vif.src_mon.busy!==0)
		@(vif.src_mon);
		while(vif.src_mon.pkt_valid!==1)
		@(vif.src_mon);
		item.header = vif.src_mon.data_in;
		@(vif.src_mon);
		item.payload = new[item.header[7:2]];
		foreach(item.payload[i]) begin
			while(vif.src_mon.busy!==0)
			@(vif.src_mon);
			item.payload[i] = vif.src_mon.data_in;
			@(vif.src_mon);
		end

	//	while(vif.src_mon.busy!==0)
	//	@(vif.src_mon);
	//	while(vif.src_mon.pkt_valid!==0)
	//	@(vif.src_mon);
		item.parity = vif.src_mon.data_in;
	//	@(vif.src_mon);
	//	@(vif.src_mon);
		
		item.error =  vif.src_mon.err;
		src_monitor_port.write(item);
         	`uvm_info("SRC_MONITOR",$sformatf("printing from src_monitor \n %s", item.sprint()),UVM_LOW) 

	endtask
	
endclass
		
