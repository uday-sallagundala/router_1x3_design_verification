module top;
   	
	// import ram_test_pkg
    	import router_test_pkg::*;

	`include "uvm_macros.svh"
   
	// import uvm_pkg.sv
	import uvm_pkg::*;
	
	bit clock;
	always #5 clock=~clock;
		
		router_if src_if0(clock);
		router_if dest_if0(clock);
		router_if dest_if1(clock);
		router_if dest_if2(clock);
		
		router_top_level DUV(.router_clock(clock),
				.resetn(src_if0.resetn),
				.pkt_valid(src_if0.pkt_valid),
				.busy(src_if0.busy),
				.err(src_if0.err),
				.data_in(src_if0.data_in),
				.data_out_0(dest_if0.data_out),
				.data_out_1(dest_if1.data_out),
				.data_out_2(dest_if2.data_out),
				.read_enb_0(dest_if0.read_enb),
				.read_enb_1(dest_if1.read_enb),
				.read_enb_2(dest_if2.read_enb),
				.vld_out_0(dest_if0.vld_out),
				.vld_out_1(dest_if1.vld_out),
				.vld_out_2(dest_if2.vld_out));  

		initial
			begin
	
				`ifdef VCS
         			$fsdbDumpvars(0, top);
        			`endif
			

   				uvm_config_db #(virtual router_if)::set(null,"*","src_if0",src_if0);
   				uvm_config_db #(virtual router_if)::set(null,"*","dest_if0",dest_if0);
   				uvm_config_db #(virtual router_if)::set(null,"*","dest_if1",dest_if1);
 				uvm_config_db #(virtual router_if)::set(null,"*","dest_if2",dest_if2);

   				// Call run_test
				run_test();
			end

		property p1();
			@(posedge clock) DUV.pkt_valid |=> DUV.busy;
		endproperty
				
		property p2();
			@(posedge clock) DUV.vld_out_0 |=> DUV.read_enb_0;
		endproperty

		property p3();
			@(posedge clock) !(DUV.vld_out_0) |=> !(DUV.read_enb_0);
		endproperty

		property p4();
			@(posedge clock) DUV.vld_out_0 |-> $stable(DUV.busy);
		endproperty


		A_C: assert property(p1)
			$display("assertion passed");
		else
			$display("assertion failed");

		A_d: assert property(p2)
			$display("assertion passed");
		else
			$display("assertion failed");

		A_C3: assert property(p3)
			$display("assertion passed");
		else
			$display("assertion failed");

		A_C4: assert property(p4)
			$display("assertion passed");
		else
			$display("assertion failed");


endmodule


  
   
  
