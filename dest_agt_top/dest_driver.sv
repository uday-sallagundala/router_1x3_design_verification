class dest_driver extends uvm_driver #(dest_xtn);
	
	`uvm_component_utils(dest_driver)
	
	router_dest_agent_config dest_cfg;
	virtual router_if.DEST_DRV_MP vif;
	
	function new(string name="dest_driver",uvm_component parent);
		super.new(name,parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(router_dest_agent_config)::get(this,"","router_dest_agent_config",dest_cfg))
			`uvm_fatal("src_drv","cannot get() src_cfg from uvm_config_db. Have you set() it?") 
        endfunction

	function void connect_phase(uvm_phase phase);
          vif = dest_cfg.vif;
        endfunction

	
	task run_phase(uvm_phase phase);
		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask

	task send_to_dut(dest_xtn req);
		while(vif.dest_drv.vld_out!==1)
			@(vif.dest_drv);
			//$display("dest_driver1111111111111111111111111111111111111111111111");

		repeat(req.no_of_cycles)
			@(vif.dest_drv);
			//$display("dest_driver222222222222222222222222222222222222222222222222");

		vif.dest_drv.read_enb<=1'b1;
		@(vif.dest_drv);
		//$display("dest_driver33333333333333333333333333333333333333333333333333");

		while(vif.dest_drv.vld_out!==0)
			@(vif.dest_drv);
			//$display("dest_driver444444444444444444444444444444444444444444444");

		//repeat(req.no_of_cycles)
		//@(vif.dest_drv);
		//$display("dest_driver555555555555555555555555555555555555555555555");

		vif.dest_drv.read_enb<=1'b0;
         	`uvm_info("DEST_DRIVER",$sformatf("printing from dest_driver \n %s", req.sprint()),UVM_LOW) 
	endtask


endclass
