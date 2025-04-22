`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 20:39:35
// Design Name: 
// Module Name: mult_tb
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

module FloatingMultiplication_tb;

    // Parameters
    parameter XLEN = 32;

    // Inputs
    reg [XLEN-1:0] A;
    reg [XLEN-1:0] B;

    // Output
    wire [XLEN-1:0] result;

    // Instantiate the Unit Under Test (UUT)
    FloatingMultiplication #(XLEN) uut (
        .A(A),
        .B(B),
        .result(result)
    );

    initial begin
        // Display header
        $display("Time\tA\t\t\tB\t\t\tResult");
        $display("---------------------------------------------------------------");

        // Test 1: Positive multiplication (e.g., 2 * 3)
        A = 32'b00111111100000000000000000000000;  // +2.0 in IEEE 754 single-precision
        B = 32'b01000000010000000000000000000000;  // +3.0 in IEEE 754 single-precision
        #10; // Wait for 10 time units
        $display("%0t\t%h\t%h\t%h", $time, A, B, result);

        // Test 2: Positive by negative multiplication (e.g., 2 * -3)
        A = 32'b00111111100000000000000000000000;  // +2.0 in IEEE 754 single-precision
        B = 32'b11111111100000000000000000000000;  // -3.0 in IEEE 754 single-precision
        #10;
        $display("%0t\t%h\t%h\t%h", $time, A, B, result);

        // Test 3: Zero multiplication (e.g., 0 * 5)
        A = 32'b00000000000000000000000000000000;  // +0.0 in IEEE 754 single-precision
        B = 32'b01000000010000000000000000000000;  // +5.0 in IEEE 754 single-precision
        #10;
        $display("%0t\t%h\t%h\t%h", $time, A, B, result);

        // Test 4: Large positive multiplication (e.g., 1e38 * 1e-38)
        A = 32'b01111111011100000000000000000000;  // +3.4028235e+38 in IEEE 754 single-precision
        B = 32'b00000000011000000000000000000000;  // +1.1754944e-38 in IEEE 754 single-precision
        #10;
        $display("%0t\t%h\t%h\t%h", $time, A, B, result);

        // Test 5: Large negative multiplication (e.g., -1e38 * 1e-38)
        A = 32'b11111111011100000000000000000000;  // -3.4028235e+38 in IEEE 754 single-precision
        B = 32'b00000000011000000000000000000000;  // +1.1754944e-38 in IEEE 754 single-precision
        #10;
        $display("%0t\t%h\t%h\t%h", $time, A, B, result);

        // Test 6: Infinity by any non-zero value (e.g., Inf * 2.0)
        A = 32'b01111111100000000000000000000000;  // +Inf in IEEE 754 single-precision
        B = 32'b00111111100000000000000000000000;  // +2.0 in IEEE 754 single-precision
        #10;
        $display("%0t\t%h\t%h\t%h", $time, A, B, result);

        // Test 7: Multiplication by zero (e.g., 0 * Inf)
        A = 32'b00000000000000000000000000000000;  // +0.0 in IEEE 754 single-precision
        B = 32'b01111111100000000000000000000000;  // +Inf in IEEE 754 single-precision
        #10;
        $display("%0t\t%h\t%h\t%h", $time, A, B, result);

        // Test 8: Very small value (e.g., 1e-38 * 1e-38)
        A = 32'b00000000011000000000000000000000;  // +1.1754944e-38 in IEEE 754 single-precision
        B = 32'b00000000011000000000000000000000;  // +1.1754944e-38 in IEEE 754 single-precision
        #10;
        $display("%0t\t%h\t%h\t%h", $time, A, B, result);

        // Finish the simulation
        $finish;
    end

endmodule

