//--------------------------------------------------------------
//Module Name:              seq_insert
//Department:               Beijing R&D Center FPGA Design Dept
//Function Description:     ac
//-----------------------------------------------------------------
//Version       Design       Coding         Simulate          Review          Reldata
//V1.0                      2016-09-30
//author                    linbiying
//-----------------------------------------------------------------
//Version               Modified History           
//V1.0                  draft






module seq_insert

( 
input   	wire            asy_rst,					//reset    
input   	wire            clk_245p76,                    	
input		wire	[3:0]	reg_cal_ant_en,           //一组的校准天线使能
input   wire  [31:0]   dl_wdata,

input   wire  [2:0]    rx_ant_cnt,           //rx ac 用
input   wire  [2:0]    tx_ant_cnt,           //tx ac 用
input   wire           tx_ac_valid,
input   wire  [3:0]    group_index,          //指示第几组天线
input   wire   rx_seq_valid,
input   wire   tx_seq_valid,
input wire [31:0] amp_seq0,
input wire [31:0] amp_seq1,
input wire [31:0] amp_seq2,
input wire [31:0] amp_seq3,
input wire [31:0] amp_seq4,
input wire [31:0] amp_seq5,
input wire [31:0] amp_seq6,
input wire [31:0] amp_seq7,

input wire        i_seq_insert_en,
input wire [6:0]  i_seq_cnt, 

output  reg  [31:0]   dl_wdata_out,

input wire sw_testdata,     
input wire [31:0] testdata0,
input wire [31:0] testdata1, 
input wire [31:0] testdata2,
input wire [31:0] testdata3, 
input wire [31:0] testdata4,
input wire [31:0] testdata5,
input wire [31:0] testdata6,
input wire [31:0] testdata7
//input wire i_cell_en
//input wire i_board_sel


);

reg [31:0] tx_dl_wdata_out;
reg [31:0] rx_dl_wdata_out;
reg [31:0] dl_wdata_dl1;
reg [31:0] dl_wdata_dl2;
reg [31:0] dl_wdata_dl3;
reg [31:0] dl_wdata_dl4;
reg [31:0] dl_wdata_dl5;
reg [31:0] dl_wdata_dl6;
reg [31:0] dl_wdata_dl7;
reg [31:0] dl_wdata_dl8;
reg [31:0] dl_wdata_dl9;
reg [31:0] dl_wdata_dl10;
reg [31:0] dl_wdata_dl11;



reg tx_seq_valid_dl1;
reg tx_seq_valid_dl2;
reg tx_seq_valid_dl3;
reg tx_seq_valid_dl4;
reg tx_seq_valid_dl5;
reg tx_seq_valid_dl6;
reg tx_seq_valid_dl7;


reg rx_seq_valid_dl1;
reg rx_seq_valid_dl2;
reg rx_seq_valid_dl3;
reg rx_seq_valid_dl4;
reg rx_seq_valid_dl5;
reg rx_seq_valid_dl6;
reg rx_seq_valid_dl7;

reg [31:0] amp_seq;
/*
wire [31:0] ins_data0;
wire [31:0] ins_data1;
wire [31:0] ins_data2;
wire [31:0] ins_data3;
wire [31:0] ins_data4;
wire [31:0] ins_data5;
wire [31:0] ins_data6;
wire [31:0] ins_data7;
*/
reg [31:0] ins_data0;
reg [31:0] ins_data1;
reg [31:0] ins_data2;
reg [31:0] ins_data3;
reg [31:0] ins_data4;
reg [31:0] ins_data5;
reg [31:0] ins_data6;
reg [31:0] ins_data7;

reg  [2:0]    tx_ant_cnt_dl1;
reg  [2:0]    tx_ant_cnt_dl2;
reg  [2:0]    rx_ant_cnt_dl1;
reg  [2:0]    rx_ant_cnt_dl2;
reg  [31:0]   amp_seq0_dl1;
reg  [6:0]    seq_cnt_dl1;

reg		tx_ac_valid_dly;

always @ (posedge clk_245p76 )
begin

           dl_wdata_dl1 <= dl_wdata;
           dl_wdata_dl2 <= dl_wdata_dl1;
           dl_wdata_dl3 <= dl_wdata_dl2;
           dl_wdata_dl4 <= dl_wdata_dl3; 
           dl_wdata_dl5 <= dl_wdata_dl4;
           dl_wdata_dl6 <= dl_wdata_dl5;
           dl_wdata_dl7 <= dl_wdata_dl6;
           dl_wdata_dl8 <= dl_wdata_dl7;
           dl_wdata_dl9 <= dl_wdata_dl8;
           dl_wdata_dl10 <= dl_wdata_dl9;
           dl_wdata_dl11 <= dl_wdata_dl10;
end 

always @ (posedge clk_245p76 )
begin
 
           tx_seq_valid_dl1<= tx_seq_valid;
           tx_seq_valid_dl2<= tx_seq_valid_dl1;
           tx_seq_valid_dl3<= tx_seq_valid_dl2;
           tx_seq_valid_dl4<= tx_seq_valid_dl3;
           tx_seq_valid_dl5<= tx_seq_valid_dl4;
           tx_seq_valid_dl6<= tx_seq_valid_dl5;
           tx_seq_valid_dl7<= tx_seq_valid_dl6;
       
end 

always @ (posedge clk_245p76 )
begin

           rx_seq_valid_dl1<= rx_seq_valid;
           rx_seq_valid_dl2<= rx_seq_valid_dl1;
           rx_seq_valid_dl3<= rx_seq_valid_dl2;
           rx_seq_valid_dl4<= rx_seq_valid_dl3;
           rx_seq_valid_dl5<= rx_seq_valid_dl4;
           rx_seq_valid_dl6<= rx_seq_valid_dl5;
           rx_seq_valid_dl7<= rx_seq_valid_dl6;
      
end 


/*
assign ins_data0 = (sw_testdata)?testdata0:amp_seq0;
assign ins_data1 = (sw_testdata)?testdata1:amp_seq1;
assign ins_data2 = (sw_testdata)?testdata2:amp_seq2;
assign ins_data3 = (sw_testdata)?testdata3:amp_seq3;
assign ins_data4 = (sw_testdata)?testdata4:amp_seq4;
assign ins_data5 = (sw_testdata)?testdata5:amp_seq5;
assign ins_data6 = (sw_testdata)?testdata6:amp_seq6;
assign ins_data7 = (sw_testdata)?testdata7:amp_seq7;
*/
//20180423
always @ (*)
begin

     ins_data0 <= amp_seq0;//(sw_testdata)?testdata0:amp_seq0
     ins_data1 <= amp_seq1;//(sw_testdata)?testdata1:amp_seq1
     ins_data2 <= amp_seq2;//(sw_testdata)?testdata2:amp_seq2
     ins_data3 <= amp_seq3;//(sw_testdata)?testdata3:amp_seq3
     ins_data4 <= amp_seq4;//(sw_testdata)?testdata4:amp_seq4
     ins_data5 <= amp_seq5;//(sw_testdata)?testdata5:amp_seq5
     ins_data6 <= amp_seq6;//(sw_testdata)?testdata6:amp_seq6
     ins_data7 <= amp_seq7;//(sw_testdata)?testdata7:amp_seq7
     
 end  

always @ (posedge clk_245p76 )
begin
 	
			seq_cnt_dl1 <= 	i_seq_cnt;
	end	

always @ (posedge clk_245p76 )
begin

         case (seq_cnt_dl1)
     				3'd0: begin
     							amp_seq <= ins_data0;// amp_seq0;	
                  end	
           	 3'd1: begin
     							amp_seq <= ins_data1;// amp_seq1;	
                  end	
             3'd2: begin
     							amp_seq <= ins_data2;// amp_seq2;	
                  end	
             3'd3: begin
     							amp_seq <= ins_data3;// amp_seq3;	
                  end	
             3'd4: begin
     							amp_seq <= ins_data4;// amp_seq4;	
                  end	
             3'd5: begin
     							amp_seq <= ins_data5;// amp_seq5;	
                  end	
             3'd6: begin
     							amp_seq <= ins_data6;// amp_seq6;	
                  end	
             3'd7: begin
     							amp_seq <= ins_data7;// amp_seq7;	
                  end	   
         endcase 	
end

always @ (posedge clk_245p76 )
begin
 
		 		tx_ant_cnt_dl1 <= tx_ant_cnt;
		 		tx_ant_cnt_dl2 <= tx_ant_cnt_dl1;
		 
end		 		

always @ (posedge clk_245p76 )
begin
	if (tx_seq_valid_dl7 && i_seq_insert_en)
 				begin
//          if (reg_cal_ant_en[tx_ant_cnt_dl1])
          if (reg_cal_ant_en[tx_ant_cnt_dl2])
     		    tx_dl_wdata_out <= amp_seq;	
          else
          	tx_dl_wdata_out <= dl_wdata_dl11; 
         end
     else
        tx_dl_wdata_out <= dl_wdata_dl11; 
end 

always @ (posedge clk_245p76 )
begin

		 		rx_ant_cnt_dl1 <= rx_ant_cnt;
		 		rx_ant_cnt_dl2 <= rx_ant_cnt_dl1;
		 	
end	

always @ (posedge clk_245p76 )
begin

		 		amp_seq0_dl1 <= ins_data0; //amp_seq0;
end	                

always @ (posedge clk_245p76 )
begin
	if (rx_seq_valid_dl7)
//     	case (rx_ant_cnt_dl1)   // rx ac 序列固定从a33 发
     		case (rx_ant_cnt_dl2)   // rx ac 序列固定从a33 发 
 
                   
             3'd0: begin
     			  			if (group_index==4'd8)
     								rx_dl_wdata_out <= amp_seq0_dl1;   //amp_seq0;	
                  else
                    rx_dl_wdata_out <= dl_wdata_dl11; 
                  end
             default:  rx_dl_wdata_out <= dl_wdata_dl11;     
           	 
      endcase
       else
       	rx_dl_wdata_out <= dl_wdata_dl11;  
end
     				
     				
     			

//assign dl_wdata_out = (tx_ac_valid)?tx_dl_wdata_out:rx_dl_wdata_out;  

always @ (posedge clk_245p76 )
begin
	tx_ac_valid_dly <= tx_ac_valid;
     if (tx_ac_valid_dly)
     	dl_wdata_out <= tx_dl_wdata_out;
     else
     	dl_wdata_out <= rx_dl_wdata_out;		
end

endmodule         