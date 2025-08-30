class source_driver extends uvm_driver #(source_xtn);
	
	`uvm_component_utils(source_driver)

	virtual router_if.SRC_DRV_MP vif;
	
	router_source_agent_config src_cfg;
	
	function new(string name="source_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(router_source_agent_config)::get(this,"","router_source_agent_config",src_cfg))
			`uvm_fatal("src_drv","cannot get() src_cfg from uvm_config_db. Have you set() it?") 
        endfunction

	function void connect_phase(uvm_phase phase);
          vif = src_cfg.vif;
        endfunction

	task run_phase(uvm_phase phase);
		@(vif.src_drv);
		vif.src_drv.resetn<=1'b0;
		@(vif.src_drv);
		vif.src_drv.resetn<=1'b1;
		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask

	task send_to_dut(source_xtn req);
	//	@(vif.src_drv);
	//	vif.src_drv.resetn<=1'b0;
	//	@(vif.src_drv);
	//	vif.src_drv.resetn<=1'b1;
		@(vif.src_drv);
		while(vif.src_drv.busy!==0)
		@(vif.src_drv);
		vif.src_drv.pkt_valid<=1'b1;
		vif.src_drv.data_in<=req.header;
		@(vif.src_drv);
		foreach(req.payload[i])
			begin
				while(vif.src_drv.busy!==0)
				@(vif.src_drv);
   				vif.src_drv.data_in<=req.payload[i];
				@(vif.src_drv);
			end		
		vif.src_drv.pkt_valid<=1'b0;
		vif.src_drv.data_in<=req.parity;
		`uvm_info("SRC_DRIVER",$sformatf("printing from src_driver \n %s", req.sprint()),UVM_LOW) 

	endtask
		
endclass		
		
		
