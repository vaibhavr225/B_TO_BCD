# Binary to BCD Conversion Using Five-Stage Pipelined Processor

## Project Description
This project implements Binary to BCD conversion using the Double Dabble algorithm on a five-stage pipelined processor. The processor is designed using Verilog HDL and converts a binary number into its equivalent decimal (BCD) representation.

The design uses a two-phase clocking mechanism and five pipeline stages to improve instruction execution efficiency. The final BCD output is connected to a seven-segment display for displaying the converted number.

## Features
- Binary to BCD conversion using the Double Dabble algorithm.
- Five-stage pipelined processor architecture.
- Two-phase clocking using clk and clk2.
- Verilog HDL implementation.
- Seven-segment display interfacing.
- Simulation-based verification.

## Pipeline Architecture
The processor consists of five stages:

1. **Instruction Fetch (IF):** Fetches instructions from instruction memory.
2. **Instruction Decode (ID):** Decodes instructions and reads register values.
3. **Execute (EX):** Performs arithmetic, comparison and shift operations.
4. **Memory Access (MEM):** Handles memory read and write operations.
5. **Write Back (WB):** Stores the final results in the registers.

## Project Files

The project contains the following Verilog files:

- `bintobcd.v` – Main five-stage pipelined processor and Binary to BCD conversion implementation.
- `bin_to_bcd_tf.v` – Testbench for simulation.
- `main.v` – Top module connecting the processor and seven-segment display.
- `sev_seg_led.v` – Seven-segment display decoder and display control.

## Working Principle
The binary input is converted into BCD using the Double Dabble algorithm. The algorithm checks each BCD digit before shifting. If a digit is greater than 4, 3 is added to it. The binary and BCD values are then shifted left, and the process continues until all input bits are processed.

## Results
The implementation successfully converts binary input into its corresponding BCD representation.

The observed clock cycle comparison is:

| Implementation | Clock Cycles |
|---|---:|
| Without Pipeline | 6020 |
| With Pipeline | 2935 |

The pipelined implementation requires fewer clock cycles compared to the non-pipelined implementation.

The design is also intended for implementation on a Spartan-6 FPGA board, where the converted output can be viewed on a seven-segment display.

## Tools 
- Xilinx ISE
- FPGA (Spartan-6)

## Conclusion
This project demonstrates Binary to BCD conversion using the Double Dabble algorithm on a five-stage pipelined processor. The design combines processor architecture, Verilog programming and seven-segment display interfacing. It also demonstrates how pipelining can reduce the number of clock cycles required for instruction execution.
