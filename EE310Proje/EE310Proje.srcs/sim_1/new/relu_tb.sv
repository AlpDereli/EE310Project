`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 20:11:35
// Design Name: 
// Module Name: relu_tb
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

module relu_tb;

    // Inputs
    reg [15:0] in;

    // Outputs
    wire [15:0] o;

    // Instantiate the relu module
    relu uut (
        .in(in),
        .o(o)
    );

    // Test stimulus
    initial begin
        // Initialize input
        in = 16'b0;

        // Apply test cases
        #10 in = 16'b1000000000000000; // Negative input (MSB=1)
        #10 in = 16'b0000000000000010; // Positive input
        #10 in = 16'b0000000000000000; // Zero input
        #10 in = 16'b0000000000000100; // Positive input

        // Add more test cases as needed

        #10 $finish;  // End the simulation
    end

    // Monitor output
    initial begin
        $monitor("At time %t, in = %b, o = %b", $time, in, o);
    end

endmodule


