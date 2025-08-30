class router_scoreboard extends uvm_scoreboard;
	
	`uvm_component_utils(router_scoreboard)

	router_env_config m_cfg;
	router_source_agent_config src_cfg;

	uvm_tlm_analysis_fifo #(source_xtn) src_fifo[];
	uvm_tlm_analysis_fifo #(dest_xtn) dest_fifo[];

	source_xtn source_data;
	dest_xtn dest_data;
	
	function new(string name="router_scoreboard",uvm_component parent);
		super.new(name,parent);
		router_source = new();
		//router_dest = new();
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
			`uvm_fatal("router_scoreboard","cannot get router env config")
		src_fifo = new[m_cfg.no_of_source_agents];
		dest_fifo = new[m_cfg.no_of_dest_agents];
		foreach(src_fifo[i])
			src_fifo[i] = new($sformatf("src_fifo[%0d]",i),this);
		foreach(dest_fifo[i])
			dest_fifo[i] = new($sformatf("dest_fifo[%0d]",i),this);
		source_data = source_xtn::type_id::create("source_data");
		dest_data = dest_xtn::type_id::create("dest_data");

	endfunction

	covergroup router_source;
		option.per_instance=1;
		SOURCE_ADDR: coverpoint source_data.header[1:0] {
			bins addr0 = {0};
			bins addr1 = {1};
			bins addr2 = {2};
			}
		PAYLOAD: coverpoint source_data.header[7:2] {
			bins small_packet = {[1:15]};
			bins medium_packet = {[16:30]};
			bins large_packet = {[31:63]};
			}
		ERROR: coverpoint source_data.error {
			bins normal = {0};
			bins error = {1};
			}
	endgroup

	
	task run_phase(uvm_phase phase);
	forever
		begin
			fork 
				begin: A
					#400;
					src_fifo[0].get(source_data);
					//source_data.print();
         				`uvm_info("sb_src_fifo0",$sformatf("printing from sb_src_fifo0 \n %s", source_data.sprint()),UVM_LOW) 

				end:A
				begin: B
					fork
						begin: C
							dest_fifo[0].get(dest_data);
						//	dest_data.print();
         						`uvm_info("sb_dest_fifo0",$sformatf("printing from sb_dest_fifo0 \n %s", dest_data.sprint()),UVM_LOW) 
							compare(source_data,dest_data);
						end: C	
						begin: D
							dest_fifo[1].get(dest_data);
						//	dest_data.print();
         						`uvm_info("sb_dest_fifo1",$sformatf("printing from sb_dest_fifo1 \n %s", dest_data.sprint()),UVM_LOW) 

							compare(source_data,dest_data);
						end: D
						begin: 	E
							dest_fifo[2].get(dest_data);
						//	dest_data.print();
         						`uvm_info("sb_dest_fifo2",$sformatf("printing from sb_dest_fifo2 \n %s", dest_data.sprint()),UVM_LOW) 
							compare(source_data,dest_data);
						end:E	
					join_any
					disable fork;
				end: B
			join
		end
	endtask

	task compare(source_xtn source_data, dest_xtn dest_data);
		if(source_data.header == dest_data.header)
			$display("===================HEADER COMPARISION SUCCESSFULL================================");
		else
			$display("===================HEADER COMPARISION FAILED================================");
	
		if(source_data.payload == dest_data.payload)
			$display("===================PAYLOAD COMPARISION SUCCESFULL================================");
		else
			$display("===================PAYLOAD COMPARISION FAILED================================");

		if(source_data.parity == dest_data.parity)
			$display("===================PARITY COMPARISION SUCCESFULL================================");
		else
			$display("===================PARITY COMPARISION FAILED================================");
		
		router_source.sample();
		//router_dest.sample();
	endtask


endclass
