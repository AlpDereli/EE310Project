`timescale 1ns / 1ps

module tb_process_engine_array;

    parameter weightRow = 3;
    parameter inputRow = 5;
    parameter OUT_LEN = inputRow - weightRow; // 5 - 3 = 2 (indexed as 0,1,2 = 3 outputs)

    // Inputs
    reg [15:0] weights [0:2][0:2]; // 3 rows of weights
    reg [15:0] inputs  [0:4][0:4]; // 5 input vectors, each of length 5

    // Outputs
    wire [15:0] final_outputs [0:2][0:2]; // 3 columns, each with 3 outputs

    // Instantiate the Unit Under Test (UUT)
    process_engine_array #(
        .weightRow(weightRow),
        .inputRow(inputRow)
    ) uut (
        .weights(weights),
        .inputs(inputs),
        .final_outputs(final_outputs)
    );

    integer i, j;

    initial begin
        $display("Starting testbench for updated process_engine_array...");

        // Initialize input vectors
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                inputs[i][j] = 16'h4000 + (i * 5 + j) * 16'h0100; // simple increasing pattern
            end
        end

        // Initialize weight sets for each row (row = PE row)
        for (i = 0; i < 3; i = i + 1) begin
            for (j = 0; j < 3; j = j + 1) begin
                weights[i][j] = 16'h3C00 + (i + j) * 16'h0200; // 1.0, 1.5, 1.5, etc.
            end
        end

        #10; // Wait for computation

        // Print outputs
        $display("\nFinal output psums:");
        for (i = 0; i < 3; i = i + 1) begin
            $display("Column %0d outputs:", i);
            for (j = 0; j <= OUT_LEN; j = j + 1) begin
                $display("  final_outputs[%0d][%0d] = %h", i, j, final_outputs[i][j]);
            end
        end

        $finish;
    end

endmodule
