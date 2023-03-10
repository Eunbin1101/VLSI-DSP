`timescale 1 ns / 10 ps

module TM();


    parameter  DATA_COUNT = 256*256;
    parameter  IN_WORD_SIZE = 9;
	parameter  OUT_WORD_SIZE = 26;
	parameter  OOUT_WORD_SIZE = 43;
	parameter  Final_output = 16;
	

    reg                   clk, rst;
    reg            [20:0] add_count;
    reg     signed [IN_WORD_SIZE-1:0] x0, x1, x2, x3, x4, x5, x6, x7;
	wire    signed [Final_output-1:0] z0, z1, z2, z3, z4, z5, z6, z7;
    //wire    signed [OOUT_WORD_SIZE-1:0] z0, z1, z2, z3, z4, z5, z6, z7;

	

    reg     [IN_WORD_SIZE-1:0] memory_in [1:DATA_COUNT];
	integer output_2DDCT;

    //Data intput
    initial begin
        $readmemb("lena2.txt", memory_in);
    end


    //vcd
    initial begin
        $dumpfile("DCT.vcd");
        $dumpvars;
    end

    //---- gate_sim----//
    //initial begin
    //        $sdf_annotate("../dct.sdf", test);
    //        end

    //conection
    DCT     test(
        .clk    (clk),
		.rst    (rst),
		.x0      (x0),
        .x1      (x1),
		.x2      (x2),
		.x3      (x3),
		.x4      (x4),
		.x5      (x5),
		.x6      (x6),
		.x7      (x7),
		.z0      (z0),
		.z1      (z1),
		.z2      (z2),
		.z3      (z3),
		.z4      (z4),
		.z5      (z5),
		.z6      (z6),
		.z7      (z7)
    );


    //counter set
    always@(posedge clk)
    begin                                                     /*if判斷*/
        if(!rst)                                              // rst 不等於 0，if(!rst) = false
            add_count <= 21'b00000000000000000000;            // rst = 0 ，if(!rst) = true
        else
            add_count <= add_count + 1'b1;
    end

/*--------------------------data_input setup for add_count------------------------------*/
    //input_x1 for clock
    always@(posedge clk)
    begin
        if(!rst)
            x0 <= 9'b000000000;
        else
         #1 x0 <= memory_in[add_count*8-7];  /*要有#1(delay 1個period的原因是因為，在add_count從0轉1的時候這邊trg判斷是否抓資料時add_count還沒+1，所以要等一下*/
    end

    //input_x2 for clock
    always@(posedge clk)
    begin
        if(!rst)
            x1 <= 9'b000000000;
        else
         #1 x1 <= memory_in[add_count*8-6];
			
    end

    //input_x3 for clock
    always@(posedge clk)
    begin
        if(!rst)
            x2 <= 9'b000000000;
        else
         #1 x2 <= memory_in[add_count*8-5];
			
    end

    //input_x4 for clock
    always@(posedge clk)
    begin
        if(!rst)
            x3 <= 9'b000000000;
        else
         #1 x3 <= memory_in[add_count*8-4];
			
    end

    //input_x5 for clock
    always@(posedge clk)
    begin
        if(!rst)
            x4 <= 9'b000000000;
        else
         #1 x4 <= memory_in[add_count*8-3];
			
    end

    //input_x6 for clock
    always@(posedge clk)
    begin
        if(!rst)
            x5 <= 9'b000000000;
        else
         #1 x5 <= memory_in[add_count*8-2];
			
    end

    //input_x7 for clock
    always@(posedge clk)
    begin
        if(!rst)
            x6 <= 9'b000000000;
        else
         #1 x6 <= memory_in[add_count*8-1];
			
    end

    //input_x8 for clock
    always@(posedge clk)
    begin
        if(!rst)
            x7 <= 9'b000000000;
        else
         #1 x7 <= memory_in[add_count*8];
			
    end
//---------------------------------------------------------------------------------------


    //period set
    parameter  t = 10;
    parameter  th = t/2;
    reg        capture;

    //clock negative
    always #th clk = ~clk;



    //result output
    initial begin
        output_2DDCT = $fopen("DCT_output.txt","w");
        clk = 1'b0;
        rst = 1'b0;
        #t
		capture = 1;
        rst = 1'b1;
        #82500
        rst = 1'b0;
        $finish;
        $fclose(output_2DDCT);
    end


    //output(out) to output_DCT 
    always@(posedge clk)
    begin
        if(add_count>11 && add_count<8204)
		begin
            $fwrite(output_2DDCT, "%d\n", z0);
			$fwrite(output_2DDCT, "%d\n", z1);
            $fwrite(output_2DDCT, "%d\n", z2);
            $fwrite(output_2DDCT, "%d\n", z3);	
            $fwrite(output_2DDCT, "%d\n", z4);	
            $fwrite(output_2DDCT, "%d\n", z5);	
            $fwrite(output_2DDCT, "%d\n", z6);	
            $fwrite(output_2DDCT, "%d\n", z7);				
        end
	end

    
 

endmodule
