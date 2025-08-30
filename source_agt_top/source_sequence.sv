class source_sequence extends uvm_sequence #(source_xtn);
	`uvm_object_utils(source_sequence)
	function new(string name = "source_sequence");
		super.new(name);
	endfunction
endclass

class small_sequence extends source_sequence;
	 `uvm_object_utils(small_sequence)
		bit[1:0] addr;

	function new(string name = "small_sequence");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal("src_seq","cannot get() addr")
   	   	req=source_xtn::type_id::create("req");	
		repeat(10) begin	
			start_item(req);
			assert(req.randomize() with {header[7:2] < 15 && header[1:0] == addr;} )//to control which dest the packet is driven addr is given
			finish_item(req);
		end
	endtask
endclass

class medium_sequence extends source_sequence;
	 `uvm_object_utils(medium_sequence)
		bit[1:0] addr;

	function new(string name = "medium_sequence");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal("src_seq","cannot get() addr")
   	   	req=source_xtn::type_id::create("req");		
		repeat(10) begin
			start_item(req);
			assert(req.randomize() with {header[7:2] > 15; header[7:2] < 30; header[1:0] == addr;})//to control which dest the pkt is driven addr is given
			finish_item(req);
		end
	endtask
endclass


class large_sequence extends source_sequence;
	 `uvm_object_utils(large_sequence)
		bit[1:0] addr;

	function new(string name = "large_sequence");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal("src_seq","cannot get() addr")
   	   	req=source_xtn::type_id::create("req");		
		repeat(10) begin
			start_item(req);
			assert(req.randomize() with {header[7:2] > 30; header[7:2] < 64; header[1:0] == addr;} )//to control which dest the pkt is driven addr is given
			finish_item(req);
		end
	endtask
endclass

class bad_sequence extends source_sequence;// #(bad_source_xtn);
	 `uvm_object_utils(bad_sequence)
		bit[1:0] addr;
	bad_source_xtn res;
	function new(string name = "bad_sequence");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal("src_seq","cannot get() addr")
   	   	res=bad_source_xtn::type_id::create("req");		
		repeat(10) begin
			start_item(res);
			assert(res.randomize() with {header[7:2] < 64 ;} )//to control which dest the pkt is driven addr is given
			finish_item(res);
		end
	endtask
endclass
