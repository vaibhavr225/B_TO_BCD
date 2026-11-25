`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:26:37 06/11/2026
// Design Name:   bintobcd
// Module Name:   G:/adld_proj/bintobcd_v1/bintobcd_tf.v
// Project Name:  bintobcd_v1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bintobcd
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module bin_to_bcd_tf;

// Inputs
	reg clk;
	wire [19:0] outreg;
	wire [19:0] counter;
	wire [19:0] b_counter1;
	wire [19:0] b_counter2;

	// Instantiate the Unit Under Test (UUT)
	bin_to_bcd test(clk, outreg);
	assign counter = test.counter;
	assign b_counter1 = test.b_counter1;
	assign b_counter2 = test.b_counter2;
	initial begin
		// Initialize Inputs
		clk = 0;
		forever begin
			#10 clk = 0; #10 clk = 1;
		end
	end
	always @(posedge clk or posedge test.clk2) begin
  $display(
    "C=%0d IF=%h ID=%h EX=%h MEM=%h WB=%h",
    counter,
    test.IF_ID_IR,
    test.ID_EX_IR,
    test.EX_MEM_IR,
    test.MEM_WB_IR,
    test.MEM_WB_IR
  );
end
	
	initial begin
		$dumpfile("bintobcd.vcd");
		$dumpvars("0, bintobcd");
	end
endmodule
