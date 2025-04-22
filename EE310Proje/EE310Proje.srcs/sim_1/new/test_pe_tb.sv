`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2025 18:14:16
// Design Name: 
// Module Name: test_pe_tb
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

`timescale 1ns / 1ps

module tb_pe_insallah;

    // Parameters
    localparam weightRow = 3;
    localparam inputRow = 5;
    localparam outLen = inputRow - weightRow + 1;

    // Inputs
    reg [15:0] psum   [outLen];
    reg [15:0] weight [0:weightRow-1];
    reg [15:0] inputs [0:inputRow-1];

    // Output
    wire [15:0] out_psum [outLen];

    // Instantiate the Unit Under Test (UUT)
    pe_insallah #(.weightRow(weightRow), .inputRow(inputRow)) uut (
        .psum(psum),
        .weight(weight),
        .inputs(inputs),
        .out_psum(out_psum)
    );

    


    // Tasks to initialize inputs
    initial begin
        // Initialize weights (example values)
        weight[0] = 16'h3C00; // 1.0
        weight[1] = 16'h4000; // 2.0
        weight[2] = 16'h4200; // 3.0

        // Initialize inputs
        inputs[0] = 16'h3C00; // 1.0
        inputs[1] = 16'h4000; // 2.0
        inputs[2] = 16'h4200; // 3.0
        inputs[3] = 16'h4400; // 4.0
        inputs[4] = 16'h4600; // 5.0


        // Initialize psum
        psum[0] = 16'h0000; // 0.0
        psum[1] = 16'h3c00;
        psum[2] = 16'h3c00;


        #100;
        $finish;
        // Print outputs
        $display("=== Output PSUMs ===");
        for (int i = 0; i < outLen; i = i + 1) begin
            $display("out_psum[%0d] = %h", i, out_psum[i]);
        end

        #10;
        
    end

endmodule