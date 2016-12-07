
module soc (
	clk_clk,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	reset_reset_n,
	rfsend_conduit_en_in,
	rfsend_conduit_rftxdata,
	rfsend_conduit_rftxen,
	rfsend_conduit_rftxiqsel,
	rfsend_txclk_clk,
	sendcontrol_conduit_send_en);	

	input		clk_clk;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[31:0]	memory_mem_dq;
	inout	[3:0]	memory_mem_dqs;
	inout	[3:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[3:0]	memory_mem_dm;
	input		memory_oct_rzqin;
	input		reset_reset_n;
	input		rfsend_conduit_en_in;
	output	[11:0]	rfsend_conduit_rftxdata;
	output		rfsend_conduit_rftxen;
	output		rfsend_conduit_rftxiqsel;
	input		rfsend_txclk_clk;
	output		sendcontrol_conduit_send_en;
endmodule
