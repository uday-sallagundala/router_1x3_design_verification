class source_xtn extends uvm_sequence_item;
	`uvm_object_utils(source_xtn)

	rand bit [7:0] header, payload[];
	   bit [7:0] parity;
	bit error;

	constraint valid_addr { header[1:0] != 2'b11;}
	constraint valid_len { header[7:2] != 0;}
	constraint valid_size { payload.size == header[7:2]; }

	function new(string name = "source_xtn");
		super.new(name);
	endfunction

	function void post_randomize();
		parity = header;
		foreach(payload[i])
			begin
				parity = payload[i] ^ parity;
			end
	endfunction

	function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field("header",this.header,8,UVM_DEC);
		foreach(payload[i])
			printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);
		printer.print_field("parity",this.parity,8,UVM_DEC);
		printer.print_field("error",this.error,1,UVM_DEC);

	endfunction
endclass

class bad_source_xtn extends source_xtn;
	`uvm_object_utils(bad_source_xtn)

	function new(string name = "bad_source_xtn");
		super.new(name);
	endfunction

	function void post_randomize();
		parity = header;
		foreach(payload[i])
			begin
				parity = payload[i] && parity;
			end
	endfunction

	function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field("parity",this.parity,8,UVM_DEC);
	endfunction
endclass
