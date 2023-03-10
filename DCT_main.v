module DCT(clk, rst, x0, x1, x2, x3, x4, x5, x6, x7, z0, z1, z2, z3, z4, z5, z6, z7);
//a0, a1, a2, a3, a4, a5, a6, a7);


parameter W_I = 9;
parameter W_C = 15;
parameter W_CT = 15;
parameter W_O = W_I + W_C + 2;      //26 bit

parameter W_II = W_O;
parameter W_OO = W_II + W_CT + 2;   //43 bit
parameter F_O = 16;


parameter signed y01 = 4'b0111;
parameter signed y02 = 4'b0111;
parameter signed y03 = 4'b0110;
parameter signed y04 = 4'b0101;
parameter signed y05 = 4'b0100;
parameter signed y06 = 4'b0011;
parameter signed y07 = 4'b0001;
parameter signed y11 = 4'b1001;
parameter signed y12 = 4'b1001;
parameter signed y13 = 4'b1010;
parameter signed y14 = 4'b1011;
parameter signed y15 = 4'b1100;
parameter signed y16 = 4'b1101;
parameter signed y17 = 4'b1111;

input  signed clk, rst;
input  signed [W_I-1:0]  x0, x1, x2, x3, x4, x5, x6, x7;
output signed [F_O-1:0]  z0, z1, z2, z3, z4, z5, z6, z7;
//output signed [W_O-1:0]  a0, a1, a2, a3, a4, a5, a6, a7;


//DCT1
reg    signed [W_I-1:0] xx0, xx1, xx2, xx3, xx4, xx5, xx6, xx7;
wire   signed [W_O-1:0] zz0, zz1, zz2, zz3, zz4, zz5, zz6, zz7;
reg    signed [F_O-1:0] z0, z1, z2, z3, z4, z5, z6, z7;

wire   signed [W_I+1:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;
wire   signed [W_I+1:0] ss0, ss1, ss2, ss3, ss4, ss5, ss6, ss7, ss8, ss9, ss10, ss11, ss12, ss13, ss14, ss15;


//----convert to 8x8 register----//
reg    [1:0] trg_in;
reg    [3:0] mem_count;
reg    [W_O-1:0] memory [0:127];

//----output register 2----//
reg    [3:0] trg_o;
reg    [3:0] readmem_count;
reg    signed [W_O-1:0] a0, a1, a2, a3, a4, a5, a6, a7;


//----convert to 8x8 register----//
//reg    signed [W_O-1:0] a0, a1, a2, a3, a4, a5, a6, a7;

//DCT_Transpose
wire   signed [W_II+1:0] ts0, ts1, ts2, ts3, ts4, ts5, ts6, ts7, ts8, ts9, ts10, ts11, ts12, ts13, ts14, ts15;
wire   signed [W_II+1:0] tss0, tss1, tss2, tss3, tss4, tss5, tss6, tss7, tss8, tss9, tss10, tss11, tss12, tss13, tss14, tss15;
wire   signed [W_OO-1:0] u0, u1, u2, u3, u4, u5, u6, u7;

//----out_count----//



//---------------------------Start-------------------------------//
//signal for input register
always@(posedge clk) begin
xx0 <= x0;
xx1 <= x1;
xx2 <= x2;
xx3 <= x3;
xx4 <= x4;
xx5 <= x5;
xx6 <= x6;
xx7 <= x7;
end


//---------------------------------------------------------------
//----DA_Left----//
assign s0 = 0;          
assign s1 = xx3;          //   3
assign s2 = xx2;          //   2
assign s3 = xx2 + xx3;    // 2 + 3

assign s4 = xx1;          // 1
assign s5 = xx1 + xx3;    // 1 + 3
assign s6 = xx1 + xx2;    // 1 + 2
assign s7 = xx1 + s3;     // 1 + 2 + 3

assign s8 = xx0;          // 0
assign s9 = xx0 + xx3;    // 0 + 3
assign s10 = xx0 + xx2;   // 0 + 2
assign s11 = xx0 + s3;    // 0 + 2 + 3

assign s12 = xx0 + xx1;   // 0 + 1
assign s13 = xx0 + s5;    // 0 + 1 + 3
assign s14 = xx0 + s6;    // 0 + 1 + 2
assign s15 = s12 + s3;    // 0 + 1 + 2 + 3

//----DA_Right----//
assign ss0 = 0;          
assign ss1 = xx7;         //   7
assign ss2 = xx6;         //   6
assign ss3 = xx6 + xx7;   // 6 + 7

assign ss4 = xx5;         //   5
assign ss5 = xx5 + xx7;   // 5 + 7
assign ss6 = xx5 + xx6;   // 5 + 6
assign ss7 = xx5 + ss3;   // 5 + 6 + 7

assign ss8 = xx4;         // 4
assign ss9 = xx4 + xx7;   // 4 + 7
assign ss10 = xx4 + xx6;  // 4 + 6
assign ss11 = xx4 + ss3;  // 4 + 6 + 7

assign ss12 = xx4 + xx5;  // 4 + 5
assign ss13 = xx4 + ss5;  // 4 + 5 + 7
assign ss14 = xx4 + ss6;  // 4 + 5 + 6
assign ss15 = ss12 + ss3; // 4 + 5 + 6 + 7

//--------Add--------//
assign zz0 = (s15<<13) + (s15<<11) + (s15<<10) + (s15<<8) + (s15<<6) + s15 + (ss15<<13) + (ss15<<11) + (ss15<<10) + (ss15<<8) + (ss15<<6) + ss15;
assign zz1 = (s14<<13) + (s12<<12) + (s9<<11) + (s13<<10) + (s10<<9) + (s6<<8) + (s10<<7) + (s9<<6) + (s5<<5) + (s5<<4) + (s3<<3) + (s15<<2) + (s6<<1) + s8 + (-ss15<<14) + (ss8<<13) + (ss12<<12) + (ss6<<11) + (ss4<<10) + (ss10<<9) + (ss9<<8) + (ss10<<7) + (ss6<<6) + (ss5<<5) + (ss5<<4) + (ss3<<3) + (ss8<<2) + (ss7<<1) + ss1;
assign zz2 = (-s3<<14) + (s10<<13) + (s12<<12) + (s12<<11) + (s3<<10) + (s10<<9) + (s10<<8) + (s3<<7) + (s5<<6) + (s13<<5) + (s4<<4) + (s4<<3) + (s4<<2) + (s2<<1) + s6 + (-ss12<<14) + (ss5<<13) + (ss3<<12) + (ss3<<11) + (ss12<<10) + (ss5<<9) + (ss5<<8) + (ss12<<7) + (ss10<<6) + (ss11<<5) + (ss2<<4) + (ss2<<3) + (ss2<<2) + (ss4<<1) + ss6;
assign zz3 = (-s7<<14) + (s12<<13) + (s13<<12) + (s1<<11) + (s9<<10) + (s4<<9) + (s14<<8) + (s4<<7) + (s1<<6) + (s11<<5) + (s11<<4) + (s2<<3) + (s12<<2) + (s11<<1) + s2 + (-ss1<<14) + (ss12<<13) + (ss4<<12) + (ss7<<11) + (ss6<<10) + (ss13<<9) + (ss8<<8) + (ss13<<7) + (ss7<<6) + (ss2<<5) + (ss2<<4) + (ss11<<3) + (ss14<<2) + (ss9<<1) + ss4;
assign zz4 = (-s6<<14) + (s9<<13) + (s6<<12) + (s9<<11) + (s9<<10) + (s6<<9) + (s9<<8) + (s6<<7) + (s9<<6) + (s6<<5) + (s6<<4) + (s6<<3) + (s6<<2) + (s6<<1) + s15 + (-ss6<<14) + (ss9<<13) + (ss6<<12) + (ss9<<11) + (ss9<<10) + (ss6<<9) + (ss9<<8) + (ss6<<7) + (ss9<<6) + (ss6<<5) + (ss6<<4) + (ss6<<3) + (ss6<<2) + (ss6<<1) + ss15;
assign zz5 = (-s4<<14) + (s9<<13) + (s1<<12) + (s2<<11) + (s3<<10) + (s8<<9) + (s13<<8) + (s8<<7) + (s2<<6) + (s7<<5) + (s7<<4) + (s14<<3) + (s11<<2) + (s13<<1) + s4 + (-ss13<<14) + (ss6<<13) + (ss7<<12) + (ss11<<11) + (ss3<<10) + (ss13<<9) + (ss4<<8) + (ss14<<7) + (ss11<<6) + (ss1<<5) + (ss1<<4) + (ss8<<3) + (ss6<<2) + (ss9<<1) + ss2;
assign zz6 = (-s5<<14) + (s3<<13) + (s10<<12) + (s10<<11) + (s5<<10) + (s3<<9) + (s3<<8) + (s5<<7) + (s12<<6) + (s14<<5) + (s8<<4) + (s8<<3) + (s8<<2) + (s1<<1) + s9 + (-ss10<<14) + (ss12<<13) + (ss5<<12) + (ss5<<11) + (ss10<<10) + (ss12<<9) + (ss12<<8) + (ss10<<7) + (ss3<<6) + (ss7<<5) + (ss1<<4) + (ss1<<3) + (ss1<<2) + (ss8<<1) + ss9;
assign zz7 = (-s5<<14) + (s2<<13) + (s6<<12) + (s12<<11) + (s14<<10) + (s3<<8) + (s12<<6) + (s15<<5) + (s15<<4) + (s9<<3) + (s10<<2) + (s7<<1) + s1 + (-ss5<<14) + (ss11<<13) + (ss9<<12) + (ss12<<11) + (ss8<<10) + (ss15<<9) + (ss3<<8) + (ss15<<7) + (ss12<<6) + (ss6<<3) + (ss11<<2) + (ss6<<1) + ss8;

//---------------------------------------------------------------







//-----------------------DCT_1 to memory------------------------//
//set a trigger in DCT circuit 
always@(posedge clk or negedge rst)begin
    if(!rst)
            trg_in <= 2'd0;
    else begin
        if(trg_in == 2'd1)
	        trg_in <= 2'd1;
	    else
            trg_in <= trg_in + 1;
    end
end

always@(posedge clk or negedge rst)begin
    if(!rst)
            mem_count <= 0;
    else begin
		    if(trg_in == 2'd1)                //when trg=3 then mem_cunt will work
		        mem_count <= mem_count + 1;  
	end
end


//----assign mem_reg[n] for DCT1 result----//
always@(posedge clk)begin
        if(mem_count == 4'd0)begin
		    memory[16*8-8] <= zz0;   //120
			memory[16*8-7] <= zz1;   //121
			memory[16*8-6] <= zz2;   //122
			memory[16*8-5] <= zz3;   //123
			memory[16*8-4] <= zz4;   //124
			memory[16*8-3] <= zz5;   //125
			memory[16*8-2] <= zz6;   //126
			memory[16*8-1] <= zz7;   //127
		end
		else begin
		     if(mem_count >= 4'd9)begin
			     memory[(mem_count-8)*16-8] <= zz0; //8_24_40..._104   ↓
				 memory[(mem_count-8)*16-7] <= zz1; //9_25_41..._105
				 memory[(mem_count-8)*16-6] <= zz2; //10_26_42..._106
				 memory[(mem_count-8)*16-5] <= zz3; //11_27_43..._107
				 memory[(mem_count-8)*16-4] <= zz4; //12_28_44..._108
				 memory[(mem_count-8)*16-3] <= zz5; //13_29_45..._109
				 memory[(mem_count-8)*16-2] <= zz6; //14_30_46..._120
				 memory[(mem_count-8)*16-1] <= zz7; //15_31_47..._121
			end
			else begin
			     memory[mem_count*16-16] <= zz0;    //0_16_32..._112   ↓
				 memory[mem_count*16-15] <= zz1;    //1_17_33..._113
				 memory[mem_count*16-14] <= zz2;    //2_18_34..._114
				 memory[mem_count*16-13] <= zz3;    //3_19_35..._115
				 memory[mem_count*16-12] <= zz4;    //4_20_36..._116
				 memory[mem_count*16-11] <= zz5;    //5_21_37..._117
				 memory[mem_count*16-10] <= zz6;    //6_22_38..._118
				 memory[mem_count*16-9] <= zz7;	    //7_23_39..._119
			end
	     end
end





//----output from 8x8 convert register----//
always@(posedge clk or negedge rst)begin
    if(!rst)
            trg_o <= 4'd0;
    else begin
        if(trg_o == 4'd9)
	        trg_o <= 4'd9;
	    else
            trg_o <= trg_o + 1;
    end
end

always@(posedge clk or negedge rst)begin
    if(!rst)
            readmem_count <= -1;
    else begin
		    if(trg_o == 4'd9)                //when trg_o=11 then mem_cunt will work
		        readmem_count <= readmem_count + 1;  
	end
end

always@(posedge clk)begin
a0 <= memory[(readmem_count)];
a1 <= memory[(readmem_count + 16)];
a2 <= memory[(readmem_count + 32)];
a3 <= memory[(readmem_count + 48)];
a4 <= memory[(readmem_count + 64)];
a5 <= memory[(readmem_count + 80)];
a6 <= memory[(readmem_count + 96)];
a7 <= memory[(readmem_count + 112)];
end
//---------------------------------------------------------------




//---------------------------------------------------------------
//----Transpose_DA_Left----//
assign ts0 = 0;          
assign ts1 = a3;          //   3
assign ts2 = a2;          //   2
assign ts3 = a2 + a3;     // 2 + 3

assign ts4 = a1;          // 1
assign ts5 = a1 + a3;     // 1 + 3
assign ts6 = a1 + a2;     // 1 + 2
assign ts7 = a1 + ts3;    // 1 + 2 + 3

assign ts8 = a0;          // 0
assign ts9 = a0 + a3;     // 0 + 3
assign ts10 = a0 + a2;    // 0 + 2
assign ts11 = a0 + ts3;   // 0 + 2 + 3

assign ts12 = a0 + a1;    // 0 + 1
assign ts13 = a0 + ts5;   // 0 + 1 + 3
assign ts14 = a0 + ts6;   // 0 + 1 + 2
assign ts15 = ts12 + ts3; // 0 + 1 + 2 + 3

//----Transpose_DA_Right----//
assign tss0 = 0;          
assign tss1 = a7;            //   7
assign tss2 = a6;            //   6
assign tss3 = a6 + a7;       // 6 + 7

assign tss4 = a5;            //   5
assign tss5 = a5 + a7;       // 5 + 7
assign tss6 = a5 + a6;       // 5 + 6
assign tss7 = a5 + tss3;     // 5 + 6 + 7

assign tss8 = a4;            // 4
assign tss9 = a4 + a7;       // 4 + 7
assign tss10 = a4 + a6;      // 4 + 6
assign tss11 = a4 + tss3;    // 4 + 6 + 7

assign tss12 = a4 + a5;      // 4 + 5
assign tss13 = a4 + tss5;    // 4 + 5 + 7
assign tss14 = a4 + tss6;    // 4 + 5 + 6
assign tss15 = tss12 + tss3; // 4 + 5 + 6 + 7

//--------Add--------//
assign u0 = (ts15<<13) + (ts15<<11) + (ts15<<10) + (ts15<<8) + (ts15<<6) + ts15 + (tss15<<13) + (tss15<<11) + (tss15<<10) + (tss15<<8) + (tss15<<6) + tss15;
assign u1 = (ts14<<13) + (ts12<<12) + (ts9<<11) + (ts13<<10) + (ts10<<9) + (ts6<<8) + (ts10<<7) + (ts9<<6) + (ts5<<5) + (ts5<<4) + (ts3<<3) + (ts15<<2) + (ts6<<1) + ts8 + (-tss15<<14) + (tss8<<13) + (tss12<<12) + (tss6<<11) + (tss4<<10) + (tss10<<9) + (tss9<<8) + (tss10<<7) + (tss6<<6) + (tss5<<5) + (tss5<<4) + (tss3<<3) + (tss8<<2) + (tss7<<1) + tss1;
assign u2 = (-ts3<<14) + (ts10<<13) + (ts12<<12) + (ts12<<11) + (ts3<<10) + (ts10<<9) + (ts10<<8) + (ts3<<7) + (ts5<<6) + (ts13<<5) + (ts4<<4) + (ts4<<3) + (ts4<<2) + (ts2<<1) + ts6 + (-tss12<<14) + (tss5<<13) + (tss3<<12) + (tss3<<11) + (tss12<<10) + (tss5<<9) + (tss5<<8) + (tss12<<7) + (tss10<<6) + (tss11<<5) + (tss2<<4) + (tss2<<3) + (tss2<<2) + (tss4<<1) + tss6;
assign u3 = (-ts7<<14) + (ts12<<13) + (ts13<<12) + (ts1<<11) + (ts9<<10) + (ts4<<9) + (ts14<<8) + (ts4<<7) + (ts1<<6) + (ts11<<5) + (ts11<<4) + (ts2<<3) + (ts12<<2) + (ts11<<1) + ts2 + (-tss1<<14) + (tss12<<13) + (tss4<<12) + (tss7<<11) + (tss6<<10) + (tss13<<9) + (tss8<<8) + (tss13<<7) + (tss7<<6) + (tss2<<5) + (tss2<<4) + (tss11<<3) + (tss14<<2) + (tss9<<1) + tss4;
assign u4 = (-ts6<<14) + (ts9<<13) + (ts6<<12) + (ts9<<11) + (ts9<<10) + (ts6<<9) + (ts9<<8) + (ts6<<7) + (ts9<<6) + (ts6<<5) + (ts6<<4) + (ts6<<3) + (ts6<<2) + (ts6<<1) + ts15 + (-tss6<<14) + (tss9<<13) + (tss6<<12) + (tss9<<11) + (tss9<<10) + (tss6<<9) + (tss9<<8) + (tss6<<7) + (tss9<<6) + (tss6<<5) + (tss6<<4) + (tss6<<3) + (tss6<<2) + (tss6<<1) + tss15;
assign u5 = (-ts4<<14) + (ts9<<13) + (ts1<<12) + (ts2<<11) + (ts3<<10) + (ts8<<9) + (ts13<<8) + (ts8<<7) + (ts2<<6) + (ts7<<5) + (ts7<<4) + (ts14<<3) + (ts11<<2) + (ts13<<1) + ts4 + (-tss13<<14) + (tss6<<13) + (tss7<<12) + (tss11<<11) + (tss3<<10) + (tss13<<9) + (tss4<<8) + (tss14<<7) + (tss11<<6) + (tss1<<5) + (tss1<<4) + (tss8<<3) + (tss6<<2) + (tss9<<1) + tss2;
assign u6 = (-ts5<<14) + (ts3<<13) + (ts10<<12) + (ts10<<11) + (ts5<<10) + (ts3<<9) + (ts3<<8) + (ts5<<7) + (ts12<<6) + (ts14<<5) + (ts8<<4) + (ts8<<3) + (ts8<<2) + (ts1<<1) + ts9 + (-tss10<<14) + (tss12<<13) + (tss5<<12) + (tss5<<11) + (tss10<<10) + (tss12<<9) + (tss12<<8) + (tss10<<7) + (tss3<<6) + (tss7<<5) + (tss1<<4) + (tss1<<3) + (tss1<<2) + (tss8<<1) + tss9;
assign u7 = (-ts5<<14) + (ts2<<13) + (ts6<<12) + (ts12<<11) + (ts14<<10) + (ts3<<8) + (ts12<<6) + (ts15<<5) + (ts15<<4) + (ts9<<3) + (ts10<<2) + (ts7<<1) + ts1 + (-tss5<<14) + (tss11<<13) + (tss9<<12) + (tss12<<11) + (tss8<<10) + (tss15<<9) + (tss3<<8) + (tss15<<7) + (tss12<<6) + (tss6<<3) + (tss11<<2) + (tss6<<1) + tss8;


//--------------------------------------------------------------------------//



always@(posedge clk)begin
z0 <= (u0>>27);
z1 <= (u1>>27);
z2 <= (u2>>27);
z3 <= (u3>>27);
z4 <= (u4>>27);
z5 <= (u5>>27);
z6 <= (u6>>27);
z7 <= (u7>>27);
end



endmodule
