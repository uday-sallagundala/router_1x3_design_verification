class dest_monitor extends uvm_monitor;
	
	`uvm_component_utils(dest_monitor)
	
	router_dest_agent_config dest_cfg;
	virtual router_if.DEST_MON_MP vif;
  	uvm_analysis_port #(dest_xtn) dest_monitor_port;

	dest_xtn item;
	
	
	function new(string name="dest_monitor",uvm_component parent);
		super.new(name,parent);
		dest_monitor_port = new("dest_monitor_port",this);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(router_dest_agent_config)::get(this,"","router_dest_agent_config",dest_cfg))
			`uvm_fatal("src_mon","cannot get() src_cfg from uvm_config_db. Have you set() it?") 
		item = dest_xtn::type_id::create("item");

        endfunction

	function void connect_phase(uvm_phase phase);
          vif = dest_cfg.vif;
        endfunction
	
	task run_phase(uvm_phase phase);
		forever
			begin
				collect_data();	
			end
	endtask


	task collect_data();
		//@(vif.dest_mon);
		while(vif.dest_mon.vld_out!==1)
			@(vif.dest_mon);
		//	$display("dest_monitor1111111111111111111111111111111");

		while(vif.dest_mon.read_enb!==1)
			@(vif.dest_mon);
			//$display("dest_monitor2222222222222222222222222222222222");

		item.header = vif.dest_mon.data_out;
		@(vif.dest_mon);
	//	$display("dest_monitor3333333333333333333333333333333333333");

		item.payload = new[item.header[7:2]];

		foreach(item.payload[i]) begin
			item.payload[i] = vif.dest_mon.data_out;
			@(vif.dest_mon);
	//	$display("dest_monitor4444444444444444444444444444444444444");

		end
		item.parity = vif.dest_mon.data_out;
		dest_monitor_port.write(item);

         	`uvm_info("DEST_MONITOR",$sformatf("printing from dest_monitor \n %s", item.sprint()),UVM_LOW) 
	endtask

endclass
				
