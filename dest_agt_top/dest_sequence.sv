class dest_sequence extends uvm_sequence #(dest_xtn);
	`uvm_object_utils(dest_sequence)
	function new(string name = "dest_sequence");
		super.new(name);
	endfunction
endclass

class normal_sequence extends dest_sequence;
	 `uvm_object_utils(normal_sequence)

	function new(string name = "normal_sequence");
		super.new(name);
	endfunction

	task body();
   	   	req=dest_xtn::type_id::create("req");		
		start_item(req);
		assert(req.randomize() with {no_of_cycles inside {[1:28]};} )
		finish_item(req);
		req.print();
	endtask
endclass

class abnormal_sequence extends dest_sequence;
	 `uvm_object_utils(abnormal_sequence)

	function new(string name = "abnormal_sequence");
		super.new(name);
	endfunction

	task body();
   	   	req=dest_xtn::type_id::create("req");		
		start_item(req);
		assert(req.randomize() with {no_of_cycles inside {[29:60]};} )
		finish_item(req);
		req.print();
	endtask
endclass
