class router_test extends uvm_test;
	`uvm_component_utils(router_test)

	router_env env_h;
	router_env_config tb_cfg;
	router_source_agent_config src_agt_cfg[];
	router_dest_agent_config dest_agt_cfg[];
	
	virtual router_if vif;
	
	int no_of_source_agents = 1;
	int no_of_dest_agents = 3;

	function new(string name="router_test", uvm_component parent);
		super.new(name,parent);
	endfunction: new		
	
	function void build_phase(uvm_phase phase);

		tb_cfg=router_env_config::type_id::create("tb_cfg");
		uvm_config_db #(router_env_config)::set(this,"*","router_env_config",tb_cfg);

		src_agt_cfg = new[no_of_source_agents];
		foreach(src_agt_cfg[i]) begin
			src_agt_cfg[i]=router_source_agent_config::type_id::create($sformatf("src_agt_cfg[%0d]",i));
			src_agt_cfg[i].is_active = UVM_ACTIVE;
			uvm_config_db #(router_source_agent_config)::set(this,$sformatf("env_h.src_agt_top.src_agt[%0d]*",i),"router_source_agent_config",src_agt_cfg[i]);
				uvm_config_db #(virtual router_if)::get(this,"",$sformatf("src_if%0d",i),src_agt_cfg[i].vif);
			end

		dest_agt_cfg = new[no_of_dest_agents];
		foreach(dest_agt_cfg[i]) begin
			dest_agt_cfg[i]=router_dest_agent_config::type_id::create($sformatf("dest_agt_cfg[%0d]",i));
			dest_agt_cfg[i].is_active = UVM_ACTIVE;								
			uvm_config_db #(router_dest_agent_config)::set(this,$sformatf("env_h.dest_agt_top.dest_agt[%0d]*",i),"router_dest_agent_config",dest_agt_cfg[i]);
			//setting the configuration of each of the respective agents one by one and giving visibility to respective agents only to avoid overriding
			if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("dest_if%0d",i),dest_agt_cfg[i].vif))
				`uvm_fatal("router_test","could not get virtual interface")
				//getting the virtual interface to respective agents one by one
			end
				
		tb_cfg.no_of_source_agents = no_of_source_agents;
		tb_cfg.no_of_dest_agents = no_of_dest_agents;
		tb_cfg.src_agt_cfg = src_agt_cfg;
		tb_cfg.dest_agt_cfg = dest_agt_cfg;
				
		super.build_phase(phase);
		env_h = router_env::type_id::create("env_h",this);

	endfunction: build_phase
	
function void end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction: end_of_elaboration_phase

endclass

 
class small_test extends router_test;	
	`uvm_component_utils(small_test)
	
	bit[1:0] addr;
//	small_sequence seqh;
//	normal_sequence mseqh;
	small_vseq1 sml_vseq1;
	small_vseq2 sml_vseq2;

	function new(string name="small_test", uvm_component parent);
		super.new(name,parent);
	endfunction: new	
	    
	function void build_phase(uvm_phase phase);
            super.build_phase(phase);
		//seqh = small_sequence::type_id::create("seqh");
		//mseqh = normal_sequence::type_id::create("mseqh");
		sml_vseq1 = small_vseq1::type_id::create("sml_vseq1");
		sml_vseq2 = small_vseq2::type_id::create("sml_vseq2");		
	endfunction
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		addr=2'b00;//$urandom%3;
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
	//	fork
			//seqh.start(env_h.src_agt_top.src_agt[0].sqrh);
			//mseqh.start(env_h.dest_agt_top.dest_agt[addr].sqrh);
			//seqh.start(env_h.v_seqr);
			//mseqh.start(env_h.v_seqr);
			
			sml_vseq1.start(env_h.v_seqr);
			//sml_vseq2.start(env_h.v_seqr);
			
			
	//	join
		#100;
		phase.drop_objection(this);
	endtask
endclass


class medium_test extends router_test;	
	`uvm_component_utils(medium_test)
	
	bit[1:0] addr;
	//medium_sequence seqh;
	medium_vseq1 mdm_vseq1;
	medium_vseq2 mdm_vseq2;

	function new(string name="medium_test", uvm_component parent);
		super.new(name,parent);
	endfunction: new	
	    
	function void build_phase(uvm_phase phase);
            super.build_phase(phase);
		//seqh = medium_sequence::type_id::create("seqh");
		mdm_vseq1 = medium_vseq1::type_id::create("mdm_vseq1");
		mdm_vseq2 = medium_vseq2::type_id::create("mdm_vseq2");
		
	endfunction
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		addr = 2'b01; //$urandom%3; //2'b01;// 2'b01, 2'b10;
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
		//for(int i=0; i<no_of_source_agents; i++)
			//seqh.start(env_h.src_agt_top.src_agt[i].sqrh);
	//	mdm_vseq1.start(env_h.v_seqr);
		mdm_vseq2.start(env_h.v_seqr);	
		#100;	
		phase.drop_objection(this);
	endtask
endclass



class large_test extends router_test;	
	`uvm_component_utils(large_test)
	
	bit[1:0] addr;
	//large_sequence seqh;
	large_vseq1 lrg_vseq1;
	large_vseq2 lrg_vseq2;

	function new(string name="large_test", uvm_component parent);
		super.new(name,parent);
	endfunction: new	
	    
	function void build_phase(uvm_phase phase);
            	super.build_phase(phase);
		//seqh = large_sequence::type_id::create("seqh");
		lrg_vseq1 = large_vseq1::type_id::create("lrg_vseq1");
		lrg_vseq2 = large_vseq2::type_id::create("lrg_vseq2");
		
	endfunction
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		addr = 2'b10;// 2'b01, 2'b10;
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
		//for(int i=0; i<no_of_source_agents; i++)
		//	seqh.start(env_h.src_agt_top.src_agt[i].sqrh);
		lrg_vseq1.start(env_h.v_seqr);
	//	lrg_vseq2.start(env_h.v_seqr);
	//	#100;
		phase.drop_objection(this);
	endtask
endclass


class bad_test extends router_test;	
	`uvm_component_utils(bad_test)
	
	bit[1:0] addr;
	//large_sequence seqh;
	bad_vseq b_vseq;

	function new(string name="bad_test", uvm_component parent);
		super.new(name,parent);
	endfunction: new	
	    
	function void build_phase(uvm_phase phase);
            	super.build_phase(phase);
		b_vseq = bad_vseq::type_id::create("b_vseq");
		
	endfunction
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		addr = 2'b10;// 2'b01, 2'b10;
		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
		//for(int i=0; i<no_of_source_agents; i++)
		//	seqh.start(env_h.src_agt_top.src_agt[i].sqrh);
		b_vseq.start(env_h.v_seqr);
	//	lrg_vseq2.start(env_h.v_seqr);
	//	#100;
		phase.drop_objection(this);
	endtask
endclass
