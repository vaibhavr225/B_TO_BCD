`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:36:11 05/04/2026 
// Design Name: 
// Module Name:    main 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module top (
    input  CLK_12MHZ,
    input  RESET,
	 output SIG_PD,
    output sig_a,
    output sig_b,
    output sig_c,
    output sig_d,
    output sig_e,
    output sig_f,
    output sig_g,
    output sel_disp1
);

wire [19:0] bcd_data;

// MIPS + BCD output
bintobcd cpu (
    .clk(CLK_12MHZ),
    .outreg(bcd_data)
);

// 7-segment display
seven_se_led display (
    .CLK_12MHZ(CLK_12MHZ),
    .RESET(RESET),
    .out_reg(bcd_data),

    .SIG_PD(SIG_PD),
    .sig_a(sig_a),
    .sig_b(sig_b),
    .sig_c(sig_c),
    .sig_d(sig_d),
    .sig_e(sig_e),
    .sig_f(sig_f),
    .sig_g(sig_g),
    .sel_disp1(sel_disp1)
);

endmodule
