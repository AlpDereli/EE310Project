`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 22:06:08
// Design Name: 
// Module Name: pe_tb
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

module tb_pe_insallah();

    // Parameters
    parameter weightRow = 3;
    parameter inputRow = 5;
    localparam outputRow = inputRow - weightRow + 1;

    // Signals
    reg [15:0] psum [0:outputRow-1];
    reg [15:0] weight [0:weightRow-1];
    reg [15:0] inputs [0:inputRow-1];
    wire [15:0] out_psum [0:outputRow-1];

    // Instantiate the DUT
    pe_insallah #(
        .weightRow(weightRow),
        .inputRow(inputRow)
    ) dut (
        .psum(psum),
        .weight(weight),
        .inputs(inputs),
        .out_psum(out_psum)
    );

    // Floating-point test values (16-bit IEEE 754)
    // Format: 1 sign bit, 5 exponent bits, 10 mantissa bits
    // Example values:
    //   1.5  = 16'h3E00
    //   2.0  = 16'h4000
    //   0.5  = 16'h3800
    //   -1.25 = 16'hBE00
    initial begin
        // Initialize inputs (example values)
        inputs[0] = 16'h3E00; // 1.5
        inputs[1] = 16'h4000; // 2.0
        inputs[2] = 16'h3800; // 0.5
        inputs[3] = 16'hBC00; // -1.0
        inputs[4] = 16'h3C00; // 1.0

        // Initialize weights
        weight[0] = 16'h3800; // 0.5
        weight[1] = 16'h4000; // 2.0
        weight[2] = 16'hB800; // -0.5

        // Initialize partial sums (psum)
        psum[0] = 16'h3C00; // 1.0 (for out_psum[0])
        psum[1] = 16'h0000; // 0.0 (for out_psum[1])
        psum[2] = 16'hBC00; // -1.0 (for out_psum[2])

        // Wait for computation
        #10;

        // Display results
        $display("=== Convolution Results ===");
        for (integer k = 0; k < outputRow; k = k + 1) begin
            $display("out_psum[%0d] = %h (float: %f)", 
                     k, out_psum[k], $bitstoshortreal(out_psum[k]));
        end

        // Verify expected results (manually calculated)
        // Expected:
        //   out_psum[0] = 1.0 + (1.5*0.5 + 2.0*2.0 + 0.5*-0.5) = 1.0 + (0.75 + 4.0 - 0.25) = 5.5
        //   out_psum[1] = 0.0 + (2.0*0.5 + 0.5*2.0 + (-1.0)*-0.5) = 0.0 + (1.0 + 1.0 + 0.5) = 2.5
        //   out_psum[2] = -1.0 + (0.5*0.5 + (-1.0)*2.0 + 1.0*-0.5) = -1.0 + (0.25 - 2.0 - 0.5) = -3.25
        $display("\n=== Expected Results ===");
        $display("out_psum[0] should be ~5.5 (hex: ~16'h4580)");
        $display("out_psum[1] should be ~2.5 (hex: ~16'h4200)");
        $display("out_psum[2] should be ~-3.25 (hex: ~16'hC500)");

        $finish;
    end

endmodule
