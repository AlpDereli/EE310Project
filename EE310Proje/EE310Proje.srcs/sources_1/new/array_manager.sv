`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2025 22:04:34
// Design Name: 
// Module Name: array_manager
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

module array_manager #(
    parameter weightRow = 3,
    parameter inputRow = 5
)(
    input logic clk,
    input logic reset,
    input logic [15:0] weightVector [0:weightRow-1][0:weightRow-1],
    input logic [15:0] inputVector [0:inputRow-1][0:inputRow-1],
    output logic [15:0] psums [0:inputRow-weightRow][0:inputRow-weightRow]
);

    localparam outnum = inputRow - weightRow + 1;
    
    logic [15:0] psumIn [outnum][outnum];
    logic [15:0] weightIn[weightRow][outnum];
    logic [15:0] inputIn [inputRow][outnum];
    logic [15:0] out_psum [outnum][outnum];
    
    genvar i;
    generate 
    for (i=0;i<outnum;i++)begin
        pe_insallah#(.weightRow(weightRow), .inputRow(inputRow))(
        .psum(psumIn[i]),
        .weight(weightIn[i]),
        .inputs(inputIn[i]),
        .out_psum(out_psum[i])
        );
    end
    
    endgenerate 
    
    
    reg [99:0] counter;   // bunu daha sonra parametize et
    localparam firstprocess = 2'b0;
    localparam process = 2'b01;
    reg [1:0]state;
    always@(posedge clk) begin
        if (reset)begin
            counter <=0;
            state<=firstprocess;
        end else begin
            case (state)
                firstprocess: begin
                    for (int k = weightRow; k ==0; k--)begin
                        weightIn[weightRow]<= weightVector[weightRow];
                        for (int a = weightRow; a < outnum;a++)begin
                            inputIn[weightRow]<=inputVector[a];  // bu yanlýþ olabilir düzelt burayý genel                          
                        end
                        if (k == weightRow)begin
                        integer j;
                        for (j = 0; j < outnum; j = j + 1) begin
                            psumIn[weightRow][j] <= 16'b0;  
                        end
                        end else begin
                            psumIn[weightRow]<=out_psum[weightRow+1];
                        end
                    end
                end
            endcase 
        end
    
    
    end
    
    
    
    
endmodule





