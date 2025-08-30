class router_virtual_sequence extends uvm_sequence #(uvm_sequence_item);
	`uvm_object_utils(router_virtual_sequence)
	router_virtual_sequencer v_seqr;
	source_sequencer src_seqr[];
	dest_sequencer dest_seqr[];
	router_env_config m_cfg;

	function new(string name = "router_virtual_sequence");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(router_env_config)::get(null,get_full_name(),"router_env_config",m_cfg))
			`uvm_fatal("vir_seqr","could not env config")

		src_seqr = new[m_cfg.no_of_source_agents];
		dest_seqr = new[m_cfg.no_of_dest_agents];

		if(!($cast(v_seqr,m_sequencer)))
    			`uvm_error("BODY", "Error in $cast of virtual sequencer")

  		foreach(src_seqr[i])
			src_seqr[i] = v_seqr.src_seqr[i];
		foreach(dest_seqr[i])
			dest_seqr[i] = v_seqr.dest_seqr[i];
	endtask
endclass

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class small_vseq1 extends router_virtual_sequence;
	`uvm_object_utils(small_vseq1)
	small_sequence s_seq;
	normal_sequence n_seq;
	bit[1:0] addr;
	
	function new(string name = "small_vseq1");
		super.new(name);
	endfunction
	
	task body();	
		super.body;
		s_seq = small_sequence::type_id::create("s_seq");
		n_seq = normal_sequence::type_id::create("n_seq");
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal("v_seq_small_vseq1","cannot get() addr")

		fork
			foreach(src_seqr[i]) begin
				s_seq.start(src_seqr[i]);
			end
			n_seq.start(dest_seqr[addr]);
		join
	endtask
endclass


class small_vseq2 extends router_virtual_sequence;
	`uvm_object_utils(small_vseq2)
	small_sequence s_seq;
	abnormal_sequence abn_seq;
	bit[1:0] addr;
	
	function new(string name = "small_vseq2");
		super.new(name);
	endfunction
	
	task body();	
		super.body;
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal("v_seq_small_vseq2","cannot get() addr")

		s_seq = small_sequence::type_id::create("s_seq");
		abn_seq = abnormal_sequence::type_id::create("abn_seq");
		fork
			foreach(src_seqr[i])
				s_seq.start(src_seqr[i]);
			abn_seq.start(dest_seqr[addr]);
		join
	endtask
endclass

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

class medium_vseq1 extends router_virtual_sequence;
	`uvm_object_utils(medium_vseq1)
	medium_sequence m_seq;
	normal_sequence n_seq;
	bit[1:0] addr;
	
	function new(string name = "medium_vseq1");
		super.new(name);
	endfunction
	
	task body();	
		super.body;
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal("v_seq_medium_vseq1","cannot get() addr")

		m_seq = medium_sequence::type_id::create("m_seq");
		n_seq = normal_sequence::type_id::create("n_seq");
		fork
			foreach(src_seqr[i])
				m_seq.start(src_seqr[i]); //starting mediumseq on to the source seq
			n_seq.start(dest_seqr[addr]);//starting norma seq on to dest seq
		join
	endtask
endclass


class medium_vseq2 extends router_virtual_sequence;
	`uvm_object_utils(medium_vseq2)
	medium_sequence m_seq;
	abnormal_sequence abn_seq;
	bit[1:0] addr;
	
	function new(string name = "medium_vseq2");
		super.new(name);
	endfunction
	
	task body();	
		super.body;
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal("v_seq_medium_vseq2","cannot get() addr")

		m_seq = medium_sequence::type_id::create("m_seq");
		abn_seq = abnormal_sequence::type_id::create("abn_seq");
		fork
			foreach(src_seqr[i])
				m_seq.start(src_seqr[i]); //starting mediumseq on to the source seq
			abn_seq.start(dest_seqr[addr]);//starting abnorma seq on to dest seq
		join
	endtask
endclass

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class large_vseq1 extends router_virtual_sequence;
	`uvm_object_utils(large_vseq1)
	large_sequence m_seq;
	normal_sequence n_seq;
	bit[1:0] addr;
	
	function new(string name = "large_vseq1");
		super.new(name);
	endfunction
	
	task body();	
		super.body;
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal("v_seq_medium_vseq1","cannot get() addr")

		m_seq = large_sequence::type_id::create("m_seq");
		n_seq = normal_sequence::type_id::create("n_seq");
		fork
			foreach(src_seqr[i])
				m_seq.start(src_seqr[i]); //starting largeseq on to the source seq
			n_seq.start(dest_seqr[addr]);//starting norma seq on to dest seq
		join
	endtask
endclass

class large_vseq2 extends router_virtual_sequence;
	`uvm_object_utils(large_vseq2)
	large_sequence m_seq;
	abnormal_sequence abn_seq;
	bit[1:0] addr;
	
	function new(string name = "large_vseq2");
		super.new(name);
	endfunction
	
	task body();	
		super.body;
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal("v_seq_medium_vseq1","cannot get() addr")

		m_seq = large_sequence::type_id::create("m_seq");
		abn_seq = abnormal_sequence::type_id::create("abn_seq");
		fork
			foreach(src_seqr[i])
				m_seq.start(src_seqr[i]); //starting largeseq on to the source seq
			abn_seq.start(dest_seqr[addr]);//starting abnorma seq on to dest seq
		join
	endtask
endclass

////////////////////////////////////////////////////////////////////////////////////////////////////

class bad_vseq extends router_virtual_sequence;
	`uvm_object_utils(bad_vseq)
	bad_sequence bad_seq;
	//normal_sequence abn_seq;
	bit[1:0] addr;
	
	function new(string name = "bad_vseq");
		super.new(name);
	endfunction
	
	task body();	
		super.body;
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal("v_seq_medium_vseq1","cannot get() addr")

		bad_seq = bad_sequence::type_id::create("bad_seq");
		//abn_seq = abnormal_sequence::type_id::create("abn_seq");
		fork
			foreach(src_seqr[i])
				bad_seq.start(src_seqr[i]); //starting largeseq on to the source seq
			//abn_seq.start(dest_seqr[addr]);//starting abnorma seq on to dest seq
		join
	endtask
endclass
