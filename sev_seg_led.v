module seven_se_led (
    CLK_12MHZ,
    RESET,
    SIG_PD,
    sig_a,
    sig_b,
    sig_c,
    sig_d,
    sig_e,
    sig_f,
    sig_g,
    sel_disp1,
	 out_reg
	);

    input  wire        CLK_12MHZ;
    input  wire        RESET;
    output wire        SIG_PD;
    output wire        sig_a;
    output wire        sig_b;
    output wire        sig_c;
    output wire        sig_d;
    output wire        sig_e;
    output wire        sig_f;
    output wire        sig_g;
    output reg         sel_disp1;
    input             [19:0] out_reg; // input reg

    reg [23:0] counter = 0;   // slow down clock
    reg [3:0]  digit   = 0;   // 0–9
	 reg [2:0] dig_count = 0;
    reg [6:0]  DISP;
	 reg toggle = 0;
    // Clock divider (visible speed)
    always @(posedge CLK_12MHZ) begin
		if(RESET) begin
			counter <= 0;
			dig_count <= 0;
			toggle <= 0;
		 end 
		 else begin
			  counter <= counter + 1;

			  if (counter == 24'd6_000_000) begin // 1s
					counter <= 0;
					toggle <= ~toggle;
				   if(toggle == 0)dig_count <= (dig_count == 3'd4) ? 0 : dig_count + 1;
        end
		end
    end
	 
	always @(*) begin
	if(toggle) digit = 4'hF;
	else begin
		case(dig_count)
				3'd0 : digit = out_reg[19:16];
				3'd1 : digit = out_reg[15:12];
				3'd2 : digit = out_reg[11:8];
				3'd3 : digit = out_reg[7:4];
				3'd4 : digit = out_reg[3:0];
				default: digit = 4'd0;
			endcase
		end
	end
    // 7-segment decoder (COMMON ANODE)
    always @(*) begin
	 sel_disp1 = 1'b1;
        case (digit)
            4'd0: DISP = 7'b1000000;
            4'd1: DISP = 7'b1111001;
            4'd2: DISP = 7'b0100100;
            4'd3: DISP = 7'b0110000;
            4'd4: DISP = 7'b0011001;
            4'd5: DISP = 7'b0010010;
            4'd6: DISP = 7'b0000010;
            4'd7: DISP = 7'b1111000;
            4'd8: DISP = 7'b0000000;
            4'd9: DISP = 7'b0010000;
				4'hA: DISP = 7'b0001000; // A
            4'hB: DISP = 7'b0000011; // b
            4'hC: DISP = 7'b1000110; // C
            4'hD: DISP = 7'b0100001; // d
            4'hE: DISP = 7'b0000110; // E
            4'hF: DISP = 7'b1111111; // blank
            default: DISP = 7'b1111111;
        endcase
    end

    // Output
    assign sig_a = DISP[0];
    assign sig_b = DISP[1];
    assign sig_c = DISP[2];
    assign sig_d = DISP[3];
    assign sig_e = DISP[4];
    assign sig_f = DISP[5];
    assign sig_g = DISP[6];
	 assign SIG_PD = 1'b0;

endmodule
