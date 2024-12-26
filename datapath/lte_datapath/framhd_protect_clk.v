//--------------------------------------------------------------
//Module Name:              framhd_gen.v
//Department:               Beijing R&D Center FPGA Design Dept
//Function Description:     TD&LTE Ir&CPRI
//--------------------------------------------------------------
//Version       Design       Coding         Simulate          Review          Reldata
//V1.0          zhulisen
//-----------------------------------------------------------------
//Version               Modified History           
//V1.0                  draft
//--------------------------------Key words--------------------------  


module framhd_protect_clk # 
(
	parameter NUM_DECIMAL_FRAM = 8'd149,
	parameter NUM_INTEGER_FRAM = 15'd16383
)
(
	input	wire         			asy_rst,
	input	wire             			clk,//clk
	//--------------------input timing info--------------------
	input	wire	    				i_ext_hd,//frame head from epld or receiver module
	input	wire		[23:0]		i_fram_max,//frame cnt max
	output	reg					o_int_hd//frame head gen
);

//localparam NUM_DECIMAL_FRAM = 8'd149;
//localparam NUM_INTEGER_FRAM = 14'd16383;

reg		[ 1:0]		sync_idx;
reg		[22:0]		exthd_pos;
reg		[22:0]		inthd_pos;
reg		[14:0]		cnt_integer_fram;	
reg		[ 7:0]		cnt_decimal_fram;   
reg		[14:0]		cnt_integer_fram_dly1clk ;	
reg		[ 7:0]		cnt_decimal_fram_dly1clk ; 
reg		[14:0]		cnt_integer_fram_dly2clk ;	
reg		[ 7:0]		cnt_decimal_fram_dly2clk ;  
reg		[14:0]		cnt_integer_fram_dly3clk ;	
reg		[ 7:0]		cnt_decimal_fram_dly3clk ;  
reg					ext_hd_ok;	
reg					ext_hd_d1;
reg					ext_hd_d2;
reg		[ 3:0]		compare_decimal_result;
reg		[ 2:0]		compare_integer_result;

reg		[14:0]		cnt_integer_fram_add_one;
reg		[14:0]		cnt_integer_fram_sub_one;
reg		[14:0]		cnt_integer_fram_add_max;
reg		[14:0]		cnt_integer_fram_sub_max;

/***********************************************************************************/
//cnt_fram
//cnt in fram 
/***********************************************************************************/
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			cnt_decimal_fram <= 8'd0;
		else if (cnt_decimal_fram == NUM_DECIMAL_FRAM)
			cnt_decimal_fram <= 8'd0;
		else
		    cnt_decimal_fram <= cnt_decimal_fram + 8'd1;
	end
	
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			cnt_integer_fram <= 15'd0;
		else 
			if (cnt_decimal_fram == NUM_DECIMAL_FRAM)
				if (cnt_integer_fram == NUM_INTEGER_FRAM)
					cnt_integer_fram <= 15'd0;
				else
				    cnt_integer_fram <= cnt_integer_fram + 15'd1;
			else
				cnt_integer_fram <= cnt_integer_fram;
	end
	
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			begin
				cnt_integer_fram_dly1clk <= NUM_INTEGER_FRAM;
				cnt_decimal_fram_dly1clk <= NUM_DECIMAL_FRAM;
			end
		else 
			begin
				cnt_integer_fram_dly1clk <= cnt_integer_fram;
				cnt_decimal_fram_dly1clk <= cnt_decimal_fram;
			end
	end	
	
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			begin
				cnt_integer_fram_dly2clk <= NUM_INTEGER_FRAM;
				cnt_decimal_fram_dly2clk <= NUM_DECIMAL_FRAM;
			end
		else 
			begin
				cnt_integer_fram_dly2clk <= cnt_integer_fram_dly1clk;
				cnt_decimal_fram_dly2clk <= cnt_decimal_fram_dly1clk;
			end
	end	
	
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			begin
				cnt_integer_fram_dly3clk <= NUM_INTEGER_FRAM;
				cnt_decimal_fram_dly3clk <= NUM_DECIMAL_FRAM;
			end
		else 
			begin
				cnt_integer_fram_dly3clk <= cnt_integer_fram_dly2clk;
				cnt_decimal_fram_dly3clk <= cnt_decimal_fram_dly2clk;
			end
	end	
	
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			begin
				cnt_integer_fram_add_one <= 15'b0;
				cnt_integer_fram_sub_one <= 15'b0;
			end
		else 
			begin
				cnt_integer_fram_add_one <= cnt_integer_fram + 15'd1;
				cnt_integer_fram_sub_one <= cnt_integer_fram - 15'd1;
			end
	end	
	
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			begin
				cnt_integer_fram_add_max <= 15'b0;
				cnt_integer_fram_sub_max <= 15'b0;
			end
		else 
			begin
				cnt_integer_fram_add_max <= cnt_integer_fram + NUM_INTEGER_FRAM;
				cnt_integer_fram_sub_max <= cnt_integer_fram - NUM_INTEGER_FRAM;
			end
	end	

/***********************************************************************************/
//inthd_pos
/***********************************************************************************/
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			inthd_pos <= 23'h0;
		else if (({cnt_integer_fram,cnt_decimal_fram} == inthd_pos) && (sync_idx == 2'd2))
			inthd_pos <= exthd_pos;
		else;
	end	

/***********************************************************************************/
//ext_hd_ok
/***********************************************************************************/	
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			begin
				compare_decimal_result <= 4'b0;
				compare_integer_result <= 3'b0;
			end
		else 
    		begin
    		    if(i_ext_hd)
        		    begin
            		    compare_decimal_result[0] <= (exthd_pos[7:0] - cnt_decimal_fram_dly1clk <= 2);
            		    compare_decimal_result[1] <= (cnt_decimal_fram_dly1clk - exthd_pos[7:0] <= 2);
            		    compare_decimal_result[2] <= (exthd_pos[7:0] + NUM_DECIMAL_FRAM- cnt_decimal_fram_dly1clk <= 2);
            		    compare_decimal_result[3] <= (cnt_decimal_fram_dly1clk + NUM_DECIMAL_FRAM- exthd_pos[7:0] <= 2);
            		end
        		else
        		    compare_decimal_result <= 4'b0;
        		    
        		if(i_ext_hd)
        		    begin
            		    compare_integer_result[0] <= ((exthd_pos[22:8] == cnt_integer_fram_add_one) | (cnt_integer_fram_sub_max == exthd_pos[22:8]));
            		    compare_integer_result[1] <= ((exthd_pos[22:8] == cnt_integer_fram_sub_one) | (cnt_integer_fram_add_max == exthd_pos[22:8]));
            		    compare_integer_result[2] <= (exthd_pos[22:8] == cnt_integer_fram_dly1clk);
            		end
        		else
        		    compare_integer_result <= 3'b0;
    		end
	end

always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			ext_hd_ok <= 1'b0;
		else if (ext_hd_d1)
		    if (((|compare_decimal_result[1:0]) & compare_integer_result[2]) | (compare_decimal_result[2] & compare_integer_result[0]) | (compare_decimal_result[3] & compare_integer_result[1]))
			    ext_hd_ok <= 1'b1;
			else
			    ext_hd_ok <= 1'b0;
		else;
	end

always @ (posedge asy_rst or posedge clk)
    begin
    	if (asy_rst)
    		ext_hd_d1 <= 1'b0;
    	else 
    	    ext_hd_d1 <= i_ext_hd;
    end
    
always @ (posedge asy_rst or posedge clk)
    begin
    	if (asy_rst)
    		ext_hd_d2 <= 1'b0;
    	else 
    	    ext_hd_d2 <= ext_hd_d1;
    end
/***********************************************************************************/
//exthd_pos
/***********************************************************************************/
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			exthd_pos <= 23'd0;
		else if (ext_hd_d2)
		    if (ext_hd_ok & (~ sync_idx[0]))
			    exthd_pos <= exthd_pos;
			else
			    exthd_pos <= {cnt_integer_fram_dly3clk,cnt_decimal_fram_dly3clk};
		else;
	end	

/***********************************************************************************/
//sync_idx
/***********************************************************************************/
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			sync_idx <= 2'b1;
		else if (sync_idx == 2'd2)
		    if ({cnt_integer_fram,cnt_decimal_fram} == inthd_pos)
			    sync_idx <= 2'b0;
			else;
		else if (sync_idx == 2'd0)
		    if (ext_hd_ok)
		        sync_idx <= 2'd0;	  
			else if(ext_hd_d2) 
				sync_idx <= 2'd1;	
		    else;
		else //(sync_idx == 2'd1)
		    if (ext_hd_ok)
		        sync_idx <= 2'd2;
		    else;		    
	end	
	
/***********************************************************************************/
//o_int_hd
/***********************************************************************************/
always @ (posedge asy_rst or posedge clk)
	begin
		if (asy_rst)
			o_int_hd <= 1'b0;
		else if(sync_idx != 2'd0)
		    o_int_hd <= 1'b0;
		else if({cnt_integer_fram,cnt_decimal_fram} == inthd_pos)
		    o_int_hd <= 1'b1;
		else
		    o_int_hd <= 1'b0;
	end	
	
endmodule