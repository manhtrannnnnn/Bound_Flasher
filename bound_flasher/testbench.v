// Code your testbench here
// or browse Examples

`timescale 1ns/1ns

module testbench;

	reg clk, rst_n, flick;
	wire[15:0] LED;

  bound_flasher uut(flick, clk, rst_n, LED);

	//Value initialization
	initial begin
		clk = 0;
		rst_n = 1;
		flick = 0;
	end

	//Test category
	initial begin
		//test_w0_kickback
// 		#5;
// 		rst_n = 0;
// 		#5;
// 		rst_n = 1;
// 		#20;
// 		flick = 1;
// 		#5;
// 		flick = 0;
// 		#1000;

		//test_w_kickback
		#5;
		rst_n = 0;
		#5;
		rst_n = 1;
		#20;
		flick = 1;
		#5;
		flick = 0;		
		#250;
		flick = 1;
    #50
    flick = 0;
    #500 
    flick = 1;
    #20
    flick = 0;
    #1000

		//stability_test
		// #5;
		// rst_n = 0;
		// #5;
		// rst_n = 1;
		// #20;
		// flick = 1;
		// #5;
		// flick = 0;		
		// #1000;

		//error_handling
		// #5;
		// rst_n = 0;
		// #20;
		// flick = 1;
		// #5;
		// flick = 0;		
		// #200;

		$finish;
	end

	//Waveform generation
	initial begin
  		$dumpfile("dump.vcd");
  		$dumpvars;
	end

	//Clock generation
	always #5 clk = ~clk;

endmodule