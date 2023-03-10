`timescale 1 ns / 10 ps

module TM();

    parameter  L = 15;

    reg     clk, a;
    reg     [5:0] add_count;
    reg     signed [L-1:0] x1, x2, x3, x4, x5, x6, x7, x8;
    wire    signed [31:0] z1, z2, z3, z4, z5, z6, z7, z8;
	integer output_DCT;

    reg     [L-1:0] memory_in [1:80];

    //Data intput
    initial begin
        $readmemb("data_input.txt", memory_in);
    end


    //produce vcd
    initial begin
        $dumpfile("DCT.vcd");
        $dumpvars;
    end


    //conect circuit
    DCT     test(
        .clk    (clk),
        .x1      (x1),
		.x2      (x2),
		.x3      (x3),
		.x4      (x4),
		.x5      (x5),
		.x6      (x6),
		.x7      (x7),
		.x8      (x8),
		.z1      (z1),
		.z2      (z2),
		.z3      (z3),
		.z4      (z4),
		.z5      (z5),
		.z6      (z6),
		.z7      (z7),
		.z8      (z8)
    );


    //counter set
    always@(posedge clk)
    begin                                      /*if判斷*/
        if(!a)                                 // a 不等於 0，if(!a) = true
            add_count <= 6'b000000;            // a = 0 ，if(a) = true
        else
            add_count <= add_count + 1'b1;
    end

/*--------------------------data_input setup for add_count------------------------------*/
    //input_x1 for clock
    always@(posedge clk)
    begin
        if(!a)
            x1 <= 15'b000000000000000;
        else
         #1 x1 <= memory_in[add_count*8-7];  /*要有#1(delay 1個period的原因是因為，在add_count從0轉1的時候這邊trg判斷是否抓資料時add_count還沒+1
		                                       所以要等一下*/
    end

    //input_x2 for clock
    always@(posedge clk)
    begin
        if(!a)
            x2 <= 15'b000000000000000;
        else
         #1 x2 <= memory_in[add_count*8-6];
			
    end

    //input_x3 for clock
    always@(posedge clk)
    begin
        if(!a)
            x3 <= 15'b000000000000000;
        else
         #1 x3 <= memory_in[add_count*8-5];
			
    end

    //input_x4 for clock
    always@(posedge clk)
    begin
        if(!a)
            x4 <= 15'b000000000000000;
        else
         #1 x4 <= memory_in[add_count*8-4];
			
    end

    //input_x5 for clock
    always@(posedge clk)
    begin
        if(!a)
            x5 <= 15'b000000000000000;
        else
         #1 x5 <= memory_in[add_count*8-3];
			
    end

    //input_x6 for clock
    always@(posedge clk)
    begin
        if(!a)
            x6 <= 15'b000000000000000;
        else
         #1 x6 <= memory_in[add_count*8-2];
			
    end

    //input_x7 for clock
    always@(posedge clk)
    begin
        if(!a)
            x7 <= 15'b000000000000000;
        else
         #1 x7 <= memory_in[add_count*8-1];
			
    end

    //input_x8 for clock
    always@(posedge clk)
    begin
        if(!a)
            x8 <= 15'b000000000000000;
        else
         #1 x8 <= memory_in[add_count*8];
			
    end
//---------------------------------------------------------------------------------------


    //period set
    parameter  t = 10;
    parameter  th = t/2;



    //clock negative
    always #th clk = ~clk;



    //result output & clock & count setup
    initial begin
        output_DCT = $fopen("DCT_output.txt","w");
        clk = 1'b0;
        a = 1'b0;
        #t
        a = 1'b1;
        #1000
        a = 1'b0;
        $finish;
        $fclose(output_DCT);
    end


    //output(out) to output_DCT 
    always@(posedge clk)
    begin
        if(add_count>0 && add_count<11)
            $fwrite(output_DCT, "%d\n", z1);
            $fwrite(output_DCT, "%d\n", z2);
            $fwrite(output_DCT, "%d\n", z3);
            $fwrite(output_DCT, "%d\n", z4);
            $fwrite(output_DCT, "%d\n", z5);
            $fwrite(output_DCT, "%d\n", z6);
            $fwrite(output_DCT, "%d\n", z7);
            $fwrite(output_DCT, "%d\n", z8);			
    end

    
endmodule