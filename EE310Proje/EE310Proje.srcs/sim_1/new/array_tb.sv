`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2025 22:26:06
// Design Name: 
// Module Name: array_tb
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

`timescale 1ns/1ps

module array_manager_tb;

    // Parameters
    parameter WEIGHT_SIZE = 3;
    parameter INPUT_SIZE = 5;
    localparam OUTPUT_SIZE = INPUT_SIZE - WEIGHT_SIZE + 1;
    
    // Clock and Reset
    reg clk = 0;
    reg reset = 1;
    
    // Test Data in explicit FP16 format
    reg [15:0] weights [WEIGHT_SIZE][WEIGHT_SIZE] = '{
        '{16'h3C00, 16'h0000, 16'h0000},  // 1.0, 0.0, 0.0
        '{16'h0000, 16'h3C00, 16'h0000},  // 0.0, 1.0, 0.0
        '{16'h0000, 16'h0000, 16'h3C00}   // 0.0, 0.0, 1.0
    };
    
    reg [15:0] inputs [INPUT_SIZE][INPUT_SIZE] = '{
        '{16'h3C00, 16'h4000, 16'h4200, 16'h4400, 16'h4500}, // 1.0, 2.0, 3.0, 4.0, 5.0
        '{16'h4600, 16'h4700, 16'h4800, 16'h4900, 16'h4A00}, // 6.0, 7.0, 8.0, 9.0, 10.0
        '{16'h4B00, 16'h4C00, 16'h4D00, 16'h4E00, 16'h4F00}, // 11.0,12.0,13.0,14.0,15.0
        '{16'h5000, 16'h5100, 16'h5200, 16'h5300, 16'h5400}, // 16.0,17.0,18.0,19.0,20.0
        '{16'h5500, 16'h5600, 16'h5700, 16'h5800, 16'h5900}  // 21.0,22.0,23.0,24.0,25.0
    };
    
    wire [15:0] outputs [OUTPUT_SIZE][OUTPUT_SIZE];
    
    // Expected results in FP16
    wire [15:0] expected [OUTPUT_SIZE][OUTPUT_SIZE] = '{
        '{16'h54A0, 16'h5600, 16'h5720},  // 21.0, 24.0, 27.0
        '{16'h5900, 16'h5A20, 16'h5B40},   // 36.0, 39.0, 42.0
        '{16'h5D40, 16'h5E60, 16'h5F80}    // 51.0, 54.0, 57.0
    };

    // Clock generation
    always #5 clk = ~clk;
    
    // DUT Instantiation
    array_manager #(
        .weightRow(WEIGHT_SIZE),
        .inputRow(INPUT_SIZE)
    ) dut (
        .clk(clk),
        .reset(reset),
        .weightVector(weights),
        .inputVector(inputs),
        .psums(outputs)
    );
    
    // Verification
    integer errors = 0;
    initial begin
        // Reset sequence
        #10 reset = 0;
        #10 reset = 1;
        #10 reset = 0;
        
        // Wait for pipeline to fill
        #(OUTPUT_SIZE * 10);
        
        // Verify results
        $display("\nResults Verification:");
        for (int i = 0; i < OUTPUT_SIZE; i++) begin
            for (int j = 0; j < OUTPUT_SIZE; j++) begin
                if (outputs[i][j] !== expected[i][j]) begin
                    $display("ERROR at [%0d][%0d]: Expected 0x%h, Got 0x%h", 
                            i, j, expected[i][j], outputs[i][j]);
                    errors++;
                end
                else begin
                    $display("PASS at [%0d][%0d]: 0x%h", i, j, outputs[i][j]);
                end
            end
        end
        
        // Test summary
        $display("\nTest %s with %0d errors", 
                errors ? "FAILED" : "PASSED", errors);
        $finish;
    end
    
    // Waveform dumping
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, array_manager_tb);
    end

endmodule
