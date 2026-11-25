    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 09.03.2026 23:55:50
    // Design Name: 
    // Module Name: bin_to_bcd
    // Project Name: 
    // Target Devices: 
    // Tool Versions: 
    // Description: 
    // 
    // Dependencies: 
    // 
    // Revision:
    // Revision 0.01 - File Created
    // Additional Comments:
    // 
    //////////////////////////////////////////////////////////////////////////////////
    
module bintobcd(clk,outreg);
  // Two-phase clock
  input clk;
  wire clk2;
  output reg [19:0]outreg;

assign clk2 = ~clk;

  reg [31:0] PC, IF_ID_IR, IF_ID_NPC;
  reg [31:0] ID_EX_IR, ID_EX_NPC, ID_EX_A, ID_EX_B, ID_EX_Imm;
  reg [2:0] ID_EX_type, EX_MEM_type, MEM_WB_type;
  reg [31:0] EX_MEM_IR, EX_MEM_ALUOut, EX_MEM_B;
  reg EX_MEM_cond;
  reg [31:0] MEM_WB_IR, MEM_WB_ALUOut, MEM_WB_LMD;

  reg [31:0] Reg [0:31];
  // Register bank (32 x 32)
  reg [31:0] Mem [0:1023];
  // 1024 x 32 memory
  
  reg Zflag;
  reg Nflag;
  reg Vflag;

  parameter ADD=6'b000000, SUB=6'b000001, AND=6'b000010, OR=6'b000011,
            SLT=6'b000100, MUL=6'b000101, HLT=6'b111111, LW=6'b001000,
            SW=6'b001001, ADDI=6'b001010, SUBI=6'b001011, SLTI=6'b001100,
            BNEQZ=6'b001101, BEQZ=6'b001110, MOV=6'b001111,MOVI=6'b010000,
            LSL=6'b010001, CMP=6'b100110, LSR=6'b010010, ADDGE= 6'b010011;

  parameter RR_ALU=3'b000, RM_ALU=3'b001, LOAD=3'b010, STORE=3'b011,
            BRANCH=3'b100, HALT=3'b101;

  reg HALTED;
  // Set after HLT instruction is completed (in WB stage)

  reg TAKEN_BRANCH;
  // Required to disable instructions after branch
  
  integer i;
  
  
  initial begin
	PC           = 0;
	HALTED       = 0;
	TAKEN_BRANCH = 0;

	for (i = 0; i < 32; i = i + 1) Reg[i] = 0;
Mem[0] = 32'h4001FFFF;
Mem[1] = 32'h3C001000;
Mem[2] = 32'h40030010;
Mem[3] = 32'h40108000;
//out_loop:
Mem[4] = 32'h40040005;
Mem[5] = 32'h4005000F;
Mem[6] = 32'h40060003;
Mem[7] = 32'h40070004;
Mem[8] = 32'h40080000;
//inner_loop:
Mem[9] = 32'h08454800;
Mem[10] = 32'h3C000000;
Mem[11] = 32'h3C000000;
Mem[12] = 32'h3C000000;
Mem[13] = 32'h49285000;
Mem[14] = 32'h3C000000;
Mem[15] = 32'h3C000000;
Mem[16] = 32'h3C000000;
Mem[17] = 32'h3D404800;
Mem[18] = 32'h3C000000;
Mem[19] = 32'h3C000000;
Mem[20] = 32'h3C000000;
Mem[21] = 32'h99200005;
Mem[22] = 32'h3C000000;
Mem[23] = 32'h3C000000;
Mem[24] = 32'h3C000000;
Mem[25] = 32'h4C461000;
Mem[26] = 32'h2C840001;
Mem[27] = 32'h44A72800;
Mem[28] = 32'h3C000000;
Mem[29] = 32'h44C73000;
Mem[30] = 32'h29080004;
Mem[31] = 32'h308F0001;
Mem[32] = 32'h3C000000;
Mem[33] = 32'h3C000000;
Mem[34] = 32'h3C000000;
Mem[35] = 32'h39E0FFE5;
Mem[36] = 32'h08305800;
Mem[37] = 32'h4005000F;
Mem[38] = 32'h3C000000;
Mem[39] = 32'h3C000000;
Mem[40] = 32'h3C000000;
Mem[41] = 32'h49656000;
Mem[42] = 32'h3C000000;
Mem[43] = 32'h3C000000;
Mem[44] = 32'h3C000000;
Mem[45] = 32'h3D805800;
Mem[46] = 32'h40060001;
Mem[47] = 32'h3C000000;
Mem[48] = 32'h3C000000;
Mem[49] = 32'h3C000000;
Mem[50] = 32'h44466800;
Mem[51] = 32'h3C000000;
Mem[52] = 32'h3C000000;
Mem[53] = 32'h3C000000;
Mem[54] = 32'h3DA01000;
Mem[55] = 32'h3C000000;
Mem[56] = 32'h3C000000;
Mem[57] = 32'h3C000000;
Mem[58] = 32'h0C4B8800;
Mem[59] = 32'h44267000;
Mem[60] = 32'h3C000000;
Mem[61] = 32'h3C000000;
Mem[62] = 32'h3C000000;
Mem[63] = 32'h3DC00800;
Mem[64] = 32'h2C630001;
Mem[65] = 32'h3C000000;
Mem[66] = 32'h3E201000;
Mem[67] = 32'h3C000000;
Mem[68] = 32'h306F0001;
Mem[69] = 32'h3C000000;
Mem[70] = 32'h3C000000;
Mem[71] = 32'h3C000000;
Mem[72] = 32'h39E0FFBA;
Mem[73] = 32'h3C000000;
Mem[74] = 32'h3C000000;
Mem[75] = 32'hFC000000;

	IF_ID_IR   = Mem[0]; 
  end

always @(posedge clk)
  // IF Stage
    if (HALTED == 0)
      begin
        if (((EX_MEM_IR[31:26] == BEQZ) && (EX_MEM_cond == 1)) ||
            ((EX_MEM_IR[31:26] == BNEQZ) && (EX_MEM_cond == 0)))
          begin
            IF_ID_IR <=  Mem[EX_MEM_ALUOut];
            TAKEN_BRANCH <=  1'b1;
            IF_ID_NPC <=  EX_MEM_ALUOut + 1;
            PC <=  EX_MEM_ALUOut + 1;
          end
        else
          begin
            IF_ID_IR <=  Mem[PC];
            IF_ID_NPC <=  PC + 1;
            PC <=  PC + 1;
				TAKEN_BRANCH <= 0;
          end
      end



always @(posedge clk2)
  // ID Stage
  if (HALTED == 0)
  begin
    if (IF_ID_IR[31:26] == 6'b001111) //mov
	begin	
	 ID_EX_A <= 0;
	 ID_EX_B <=  Reg[IF_ID_IR[25:21]];
	end
    else if(IF_ID_IR[31:26] == 6'b010000) begin //movi
        ID_EX_A <= 0;
        ID_EX_Imm <=  {{16'b0}, {IF_ID_IR[15:0]}};  /// only 16 bit numbers can be moved
    end
    else begin
    	 if (IF_ID_IR[25:21] == 5'b00000) ID_EX_A <= 0; // R0 register
    	 else ID_EX_A <=  Reg[IF_ID_IR[25:21]]; // "rs"

	 if (IF_ID_IR[20:16] == 5'b00000) ID_EX_B <= 0; // R0 register
    	 else ID_EX_B <=  Reg[IF_ID_IR[20:16]]; // "rt"
    ID_EX_Imm <=  {{16{IF_ID_IR[15]}}, {IF_ID_IR[15:0]}};
    end
    ID_EX_NPC <=  IF_ID_NPC;
    ID_EX_IR <=  IF_ID_IR;
    case (IF_ID_IR[31:26])
      ADD, SUB, AND, OR, SLT, MUL, MOV, LSL, CMP, LSR, ADDGE: ID_EX_type <=  RR_ALU;
      ADDI, SUBI, SLTI, MOVI:                ID_EX_type <=  RM_ALU;
      LW:                          	         ID_EX_type <=  LOAD;
      SW:                          	         ID_EX_type <=  STORE;
      BNEQZ, BEQZ:                 	         ID_EX_type <=  BRANCH;
      HLT:                         	         ID_EX_type <=  HALT;
      default:                     	         ID_EX_type <=  HALT; // Invalid opcode
    endcase
  end

always @(posedge clk)
  // EX Stage
  if (HALTED == 0)
  begin
    EX_MEM_type <=  ID_EX_type;
    EX_MEM_IR <=  ID_EX_IR;

    case (ID_EX_type)
      RR_ALU: begin
        case (ID_EX_IR[31:26]) // "opcode"
          ADD, MOV:   EX_MEM_ALUOut <=  ID_EX_A + ID_EX_B;
          SUB:        EX_MEM_ALUOut <=  ID_EX_A - ID_EX_B;
          AND:        EX_MEM_ALUOut <=  ID_EX_A & ID_EX_B;
          OR:         EX_MEM_ALUOut <=  ID_EX_A | ID_EX_B;
          SLT:        EX_MEM_ALUOut <=  ID_EX_A < ID_EX_B;
          MUL:        EX_MEM_ALUOut <=  ID_EX_A * ID_EX_B;
          LSL:        EX_MEM_ALUOut <=  ID_EX_A << ID_EX_B;
          LSR:        EX_MEM_ALUOut <=  ID_EX_A >> ID_EX_B;
          CMP:         begin
                          if ((ID_EX_A - ID_EX_Imm) == 32'd0) Zflag <= 1'b1;
                          else Zflag <= 1'b0;
                          if((ID_EX_A - ID_EX_Imm) & 32'h80000000) Nflag <= 1'b1;
                          else Nflag <= 1'b0;
                       end
         ADDGE:       begin
                         if(~(Nflag) | Zflag)
                            EX_MEM_ALUOut <=  ID_EX_A + ID_EX_B;
                         else
                            EX_MEM_ALUOut <=  ID_EX_A;
                       end
         default: EX_MEM_ALUOut <=  32'hxxxxxxxx;
        endcase
      end
      RM_ALU: begin
        case (ID_EX_IR[31:26]) // "opcode"
          ADDI, MOVI:  EX_MEM_ALUOut <=  ID_EX_A + ID_EX_Imm;
          SUBI:        EX_MEM_ALUOut <=  ID_EX_A - ID_EX_Imm;
          SLTI:        EX_MEM_ALUOut <=  ID_EX_A < ID_EX_Imm;
          default:     EX_MEM_ALUOut <=  32'hxxxxxxxx;
        endcase
      end



    LOAD, STORE:
      begin
        EX_MEM_ALUOut <=  ID_EX_A + ID_EX_Imm;
        EX_MEM_B <=  ID_EX_B;
      end
    
    BRANCH:
      begin
        EX_MEM_ALUOut <=  ID_EX_NPC + ID_EX_Imm;
        EX_MEM_cond <=  (ID_EX_A == 0);
      end
    endcase
end

always @(posedge clk2)
  // MEM Stage
  if (HALTED == 0)
  begin
    MEM_WB_type <= EX_MEM_type;
    MEM_WB_IR <=  EX_MEM_IR;

    case (EX_MEM_type)
      RR_ALU, RM_ALU:
        MEM_WB_ALUOut <=  EX_MEM_ALUOut;
      LOAD:
        MEM_WB_LMD <=  Mem[EX_MEM_ALUOut];
      STORE:
        if (TAKEN_BRANCH == 0) // Disable write
          Mem[EX_MEM_ALUOut] <=  EX_MEM_B;
    endcase
  end

always @(posedge clk)
  // WB Stage
  begin
    if (TAKEN_BRANCH == 0) // Disable write if branch taken
      case (MEM_WB_type)
        RR_ALU:
          Reg[MEM_WB_IR[15:11]] <=  MEM_WB_ALUOut; // "rd"
        RM_ALU:
          Reg[MEM_WB_IR[20:16]] <=  MEM_WB_ALUOut; // "rt"
        LOAD:
          Reg[MEM_WB_IR[20:16]] <=  MEM_WB_LMD; // "rt"
        HALT:
          HALTED <=  1'b1;
      endcase
	
	  if (MEM_WB_type == HALT) begin
        outreg <= Reg[2][19:0]; 
    end
  end
endmodule

