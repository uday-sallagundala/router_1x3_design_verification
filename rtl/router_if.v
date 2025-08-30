interface router_if (input bit clock);
	bit [7:0] data_in;
	bit pkt_valid;
	bit err;
	bit busy;
	bit resetn;
	bit [7:0] data_out;
	bit read_enb;
	bit vld_out;
	
	clocking src_drv @(posedge clock);
	    	default input #1 output #1;
    		output pkt_valid;
		output data_in; 
		output resetn;
    		input busy;
	endclocking

	clocking src_mon @(posedge clock);
    		default input #1 output #1;
    		input pkt_valid;
		input data_in;
		input resetn;
		input err; 
		input busy;
	endclocking

	clocking dest_drv @(posedge clock);
    		default input #1 output #1;
		input vld_out;
		output read_enb;
	endclocking

	clocking dest_mon @ (posedge clock);
    		default input #1 output #1;
    		input data_out;
		input vld_out; 
		input read_enb;
	endclocking

	//source Driver MP
  	modport SRC_DRV_MP (clocking src_drv);
  	//source Monitor MP
  	modport SRC_MON_MP (clocking src_mon);
  	//dest driver MP
  	modport DEST_DRV_MP (clocking dest_drv);
  	//dest Monitor MP
  	modport DEST_MON_MP (clocking dest_mon);

endinterface
