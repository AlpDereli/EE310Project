`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2025 18:01:14
// Design Name: 
// Module Name: process_engine_array
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


module process_engine_array #(
    parameter weightRow = 3,
    parameter inputRow = 5
)(
    input  [15:0] weights [0:2][0:2], // weightRow-1         // 3 sets of weights for 3 columns
    input  [15:0] inputs  [0:4][0:4], // inputRow-1           // 3 separate input vectors (one per column)
    output [15:0] final_outputs [0:2][0:inputRow - weightRow] // 3 output vectors (one per column)
);
    
    // Internal psum wires between rows
    wire [15:0] psum_row1 [0:2][0:2]; //inputRow - weightRow
    wire [15:0] psum_row2 [0:2][0:2]; // inputRow - weightRow

    // Initial psum (zero) for first row
    wire [15:0] initial_psum [0:inputRow - weightRow];
    genvar z;
    generate
        for (z = 0; z <= 2; z = z + 1) begin //inputRow - weightRow
            assign initial_psum[z] = 16'b0;
        end
    endgenerate

    genvar col;
    generate
        for (col = 0; col < 3; col = col + 1) begin : col_loop
            // Row 0
            pe_insallah #(.weightRow(weightRow), .inputRow(inputRow)) pe_row0 (
                .psum(initial_psum),
                .weight(weights[0]),
                .inputs(inputs[0+col]),
                .out_psum(psum_row1[col])
            );

            // Row 1
            pe_insallah #(.weightRow(weightRow), .inputRow(inputRow)) pe_row1 (
                .psum(psum_row1[col]),
                .weight(weights[1]),
                .inputs(inputs[1+col]),
                .out_psum(psum_row2[col])
            );

            // Row 2
            pe_insallah #(.weightRow(weightRow), .inputRow(inputRow)) pe_row2 (
                .psum(psum_row2[col]),
                .weight(weights[2]),
                .inputs(inputs[2+col]),
                .out_psum(final_outputs[col])
            );
        end
    endgenerate

endmodule


