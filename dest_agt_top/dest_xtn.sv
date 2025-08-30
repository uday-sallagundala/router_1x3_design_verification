class dest_xtn extends uvm_sequence_item;

	`uvm_object_utils(dest_xtn)

	bit [7:0] header,payload[];
	bit parity;
	bit vld_out;
	bit read_enb;
	rand bit [5:0] no_of_cycles;

	constraint c1{no_of_cycles inside {[1:60]};}

	function new(string name = "dest_xtn");
		super.new(name);
	endfunction



	function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field("header",this.header,8,UVM_DEC);
		foreach(payload[i])
			printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);
		printer.print_field("parity",this.parity,8,UVM_DEC);

		printer.print_field("vld_out",this.vld_out,1,UVM_DEC);
		printer.print_field("read_enb",this.read_enb,1,UVM_DEC);
		printer.print_field("no_of_cycles",this.no_of_cycles,6,UVM_DEC);


	endfunction
endclass
