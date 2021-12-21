module tcam_32x28
(
  input logic clk_i,
  
  input logic csb_i,
  input logic web_i,
  input logic  [3:0]   wmask_i,
  input logic  [27:0]  addr_i,
  input logic  [31:0]  wdata_i,
  output logic [5:0]   rdata_o
);

//////////////////////////////////////////////////////
//						    //
//	Read Address/Search Query bit division      //
//						    //
//////////////////////////////////////////////////////

  logic [7:0] raddr_vtb1; // tcam virtual block 1
  logic [6:0] raddr_vtb2; // tcam virtual block 2
  logic [7:0] raddr_vtb3; // tcam virtual block 3
  logic [6:0] raddr_vtb4; // tcam virtual block 4
  logic       c_hi;
  
  always_comb begin : search_query_bits
    raddr_vtb1 = {1'b0, addr_i[27:21]};
//     raddr_vtb2 = addr_i[20:14];
    raddr_vtb3 = {1'b0, addr_i[13:7]};
//     raddr_vtb4 = addr_i[6:0];
    c_hi = 1'b1;
  end
  
//////////////////////////////////////////////////////
//						    //
//	     write address bit division             //
//						    //
//////////////////////////////////////////////////////

  logic       aw_select;
  logic       we;
  logic [7:0] aw_sb1; // sram block 1
  logic [7:0] aw_sb2; // sram block 2
  
  logic [7:0] addr1;
  logic [7:0] addr2;
  
  always_comb begin : write_address_demux
    aw_select = addr_i[8];
    we        = ~web_i;
    aw_sb1    =  {8{we}} & {8{(~aw_select)}} & addr_i[7:0];
    aw_sb2    =  {8{we}} &   {8{aw_select}}  & addr_i[7:0];
    addr1 = web_i ? raddr_vtb1 : aw_sb1;
    addr2 = web_i ? raddr_vtb3 : aw_sb2;
  end
  

  
//////////////////////////////////////////////////////
//						    //
//	            write masking                   //
//						    //
//////////////////////////////////////////////////////

  
  logic [3:0] wmask1;
  logic [3:0] wmask2;
  
  always_comb begin
   wmask1 = wmask_i & {4{~aw_select}};
   wmask2 = wmask_i & {4{aw_select}};
  end

  
//////////////////////////////////////////////////////
//						    //
//	       Read/Write clock gating              //
//						    //
////////////////////////////////////////////////////// 
  
/*  
  logic b1_wclkg;
  logic b1_clken;
  logic b2_wclkg;
  logic b2_clken;
  
  logic b1_clk;
  logic b2_clk;
  
 ;
  
  always_latch begin : b1_clk_gate
    if(!clk_i) begin
      b1_clken = (~(aw_select & web_i));
    end
  end
  assign b1_wclkg = b1_clken & clk_i;
  
  always_latch begin : b2_clk_gate
    if (!clk_i) begin
      b2_clken = (aw_select & (~web_i));
    end
  end*/
   logic vtb_clk;
  always_comb begin
//    b2_wclkg = b2_clken & clk_i;
//   
//    b1_clk = (~csb_i & ~web_i) ? clk_i : b1_wclkg;
  
   vtb_clk = (web_i) ? clk_i : 1'b0;
  end
  
//////////////////////////////////////////////////////
//						    //
//	           Output logic                     //
//						    //
////////////////////////////////////////////////////// 
  
  logic [31:0] vtb_out1;
  logic [31:0] vtb_out2;
  logic [31:0] vtb_out3;
  logic [31:0] vtb_out4;
  logic [31:0] p_out;
  logic [5:0] rdata;
  
  logic [31:0] vtb_out1_and_vtb_out2;
  logic [31:0] vtb_out3_and_vtb_out4;
  
  always_comb begin
   vtb_out1_and_vtb_out2 = vtb_out1 & vtb_out2;
   vtb_out3_and_vtb_out4 = vtb_out3 & vtb_out4;
  
   p_out = vtb_out1_and_vtb_out2 & vtb_out3_and_vtb_out4;
  end
  
//////////////////////////////////////////////////////
//						    //
//	         Priority Encoding                  //
//						    //
////////////////////////////////////////////////////// 

always @(p_out) begin
  if(p_out[0]) begin
    rdata = 6'd1;
  end else if (p_out[1]) begin
    rdata = 6'd2;
  end else if (p_out[2]) begin
    rdata = 6'd3;
  end else if (p_out[3]) begin
    rdata = 6'd4;
  end else if (p_out[4]) begin
    rdata = 6'd5;
  end else if (p_out[5]) begin
    rdata = 6'd6;
  end else if (p_out[6]) begin
    rdata = 6'd7;
  end else if (p_out[7]) begin
   rdata = 6'd8;
  end else if (p_out[8]) begin
   rdata = 6'd9;
  end else if (p_out[9]) begin
   rdata = 6'd10;
  end else if (p_out[10]) begin
   rdata = 6'd11;
  end else if (p_out[11]) begin
   rdata = 6'd12;
  end else if (p_out[12]) begin
   rdata = 6'd13;
  end else if (p_out[13]) begin
   rdata = 6'd14;
  end else if (p_out[14]) begin
   rdata = 6'd15;
  end else if (p_out[15]) begin
   rdata = 6'd16;
  end else if (p_out[16]) begin
   rdata = 6'd17;
  end else if (p_out[17]) begin
   rdata = 6'd18;
  end else if (p_out[18]) begin
   rdata = 6'd19;
  end else if (p_out[19]) begin
   rdata = 6'd20;
  end else if (p_out[20]) begin
   rdata = 6'd21;
  end else if (p_out[21]) begin
   rdata = 6'd22;
  end else if (p_out[22]) begin
   rdata = 6'd23;
  end else if (p_out[23]) begin
   rdata = 6'd24;
  end else if (p_out[24]) begin
   rdata = 6'd25;
  end else if (p_out[25]) begin
   rdata = 6'd26;
  end else if (p_out[26]) begin
   rdata = 6'd27;
  end else if (p_out[27]) begin
   rdata = 6'd28;
  end else if (p_out[28]) begin
   rdata = 6'd29;
  end else if (p_out[29]) begin
   rdata = 6'd30;
  end else if (p_out[30]) begin
   rdata = 6'd31;
  end else if (p_out[31]) begin
   rdata = 6'd32;
  end else begin
   rdata = 6'd0;
  end
end
  
  
  always_comb begin
   rdata_o = rdata;
  end
//////////////////////////////////////////////////////
//						    //
//	       SRAM/Virtual TCAM blocks             //
//						    //
////////////////////////////////////////////////////// 
  
  sky130_sram_1kbyte_1rw1r_32x256_8 vtb_sb1(
   `ifdef USE_POWER_PINS
     .vccd1	(),
     .vssd1	(),
   `endif
    // Port 0: RW
     .clk0	(clk_i),
     .csb0	(csb_i),
     .web0	(web_i),
     .wmask0	(wmask1),
     .addr0	(addr1),
     .din0	(wdata_i),
     .dout0	(vtb_out1),
    // Port 1: R
     .clk1	(vtb_clk),
     .csb1	(csb_i),
     .addr1	({c_hi,addr_i[20:14]}),
     .dout1	(vtb_out2)
  );
  
  sky130_sram_1kbyte_1rw1r_32x256_8 vtb_sb2(
   `ifdef USE_POWER_PINS
     .vccd1	(),
     .vssd1	(),
   `endif
    // Port 0: RW
     .clk0	(clk_i),
     .csb0	(csb_i),
     .web0	(web_i),
     .wmask0	(wmask2),
     .addr0	(addr2),
     .din0	(wdata_i),
     .dout0	(vtb_out3),
    // Port 1: R
     .clk1	(vtb_clk),
     .csb1	(csb_i),
     .addr1	({c_hi,addr_i[6:0]}),
     .dout1	(vtb_out4)
  );

endmodule 