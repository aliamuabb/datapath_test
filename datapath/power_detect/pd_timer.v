//wangshuyi@2018-04-26

module	pd_timer
#(
 parameter	FRAM_NUM 		= 	75
,parameter	SF_TIME			=	245760
,parameter	SF_NUM			=	20
,parameter	SF_ADDR_NUM		=	20
,parameter	ANT_NUM			=	4
,parameter	MODE			=	"SIM"
,parameter	ANW			   =	2
,parameter	SNW			   =	5
,parameter	SANW			=	5
)
(
 input				clk
,input				reset
,input				i_hd
,input				trig

,output	reg			start_clr
,output	reg			get_end_wr
,output	reg	[SANW+ANW-1:0]	get_end_addr
);

   (* ASYNC_REG="true" *)reg	[2:0]	trig_reg = 0;
   
reg	[ 8:0]	fram_cnt	= 0;
reg[18:0]	sf_data_cnt = 0;
reg	[SNW-1:0]	sf_cnt		= 0;
reg	[SANW-1:0]	sf_addr_cnt = 0;
reg		    sf_cnt_end = 0;
reg			fram_cnt_end = 0;
reg			get_end_wr_start;
reg			get_end_wr_end;
reg			start_clr_start = 0;
reg			start_clr_end = 0;
reg			trig_once = 0;
reg			trig_mode = 0;
reg			trig_en = 0;


always	@	(posedge clk)
begin
	if	(i_hd)
	begin
		if	(fram_cnt == FRAM_NUM - 1)
			fram_cnt <= 0;
		else
			fram_cnt <= fram_cnt + 1;
	end
	else
		fram_cnt <= fram_cnt;
end

always  @   (posedge clk)
begin
    if  (i_hd)
        sf_data_cnt <= 0;
    else
    begin
        if  (sf_data_cnt == SF_TIME-1)
            sf_data_cnt <= 0;
        else
            sf_data_cnt <= sf_data_cnt + 1;
    end
end

always	@	(posedge clk)
begin
	sf_cnt_end <= (sf_data_cnt == SF_TIME - 2);
//	fram_cnt_end <= (sf_cnt == SF_NUM - 1);
end

always	@	(posedge clk)
begin
//	if	(sf_data_cnt == SF_TIME - 1)
    if  (i_hd)
        sf_cnt <= 0;
    else
    begin
        if	(sf_cnt_end)
        begin
            if	(sf_cnt == SF_NUM - 1)
                sf_cnt <= 0;
            else
                sf_cnt <= sf_cnt + 1;
        end
        else
            sf_cnt <= sf_cnt;
    end
end

always	@	(posedge clk)
begin
//	if	(sf_data_cnt == SF_TIME - 1)
    if  (i_hd)
 	      sf_addr_cnt <= 0;
 	else
 	begin   
        if	(sf_cnt_end)
        begin
            if	(sf_addr_cnt == SF_ADDR_NUM - 1)
                sf_addr_cnt <= 0;
            else
                sf_addr_cnt <= sf_addr_cnt + 1;
        end
        else
            sf_addr_cnt <= sf_addr_cnt;
    end
end

always	@	(posedge clk)
begin
	get_end_addr <= {sf_addr_cnt,sf_data_cnt[ANW-1:0]};
end

always	@	(posedge clk)
begin
	get_end_wr_start <= (sf_data_cnt == SF_TIME - 2 - ANT_NUM);
	get_end_wr_end <= (sf_data_cnt == SF_TIME - 2);
end

always	@	(posedge clk)
begin
	if	((fram_cnt == FRAM_NUM - 1)& (sf_cnt >= SF_NUM-SF_ADDR_NUM))
	begin
		if	(get_end_wr_end)
			get_end_wr <= 0;
		else
		begin
			if	(get_end_wr_start & trig_en)
				get_end_wr <= 1;
			else
				get_end_wr <= get_end_wr;
		end
	end
	else
		get_end_wr <= 0;
end

//为了判断方便，延后一个时钟，后面clr使用时间点比较宽松
always	@	(posedge clk)
begin
//	start_clr_start <= (sf_data_cnt == SF_TIME - 1);
	start_clr_start <= i_hd | sf_cnt_end;
	start_clr_end <= (sf_data_cnt == ANT_NUM-1);
end

always	@	(posedge clk)
begin
	if	((fram_cnt == 0) & (sf_cnt < SF_ADDR_NUM))
	begin
		if	(start_clr_end)
			start_clr <= 0;
		else
		begin
			if	(start_clr_start)
				start_clr <= 1;
			else
				start_clr <= start_clr;
		end
	end
	else
		start_clr <= 0;
end

always	@	(posedge clk)
begin
	trig_reg <= {trig_reg[1:0],trig};
	trig_once <= (trig_reg[2:1] == 2'b01);
end

always	@	(posedge clk)
begin
	if	(trig_en & i_hd)
		trig_mode <= 0;
	else
	begin
		if	(trig_once)
			trig_mode <= 1;
		else
			trig_mode <= trig_mode;
	end
end

always	@	(posedge clk)
begin
	if	(trig_mode & i_hd)
		trig_en <= (fram_cnt == FRAM_NUM - 2);
	else
		trig_en <= trig_en;
end

endmodule