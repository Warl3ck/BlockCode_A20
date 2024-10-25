`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2024 14:20:20
// Design Name: 
// Module Name: top_block_code
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


module top_block_code #(

		parameter DATA_WIDTH = 4
	)
    (
        clk,
        rst,
        rx_symbols,
        rx_symbols_valid,
        code_length

    );

    input clk;
    input rst;
    input [DATA_WIDTH - 1:0] rx_symbols;
    input rx_symbols_valid;
    input [3:0] code_length;


    reg [DATA_WIDTH - 1:0] rx_symbols_extended [32];
    reg rx_symbols_valid_del;
    wire strb_permutation;

    reg [0:7] permutation_for_A20 [32];
    initial $readmemh("permutation_for_A20_array.txt", permutation_for_A20);

    reg [0:7] rx_symbols_interleaved [32];

    initial begin
        foreach (rx_symbols_extended[i]) begin
            rx_symbols_extended[i] <= {DATA_WIDTH{1'b0}};
        end
    end


    // extend symbols

    assign rx_symbols_extended[0] = rx_symbols;

    always_ff @(posedge clk) begin
        if (rx_symbols_valid) begin
            foreach (rx_symbols_extended[i]) begin
                rx_symbols_extended[i+1] <= rx_symbols_extended[i];
            end
        end
    end


    // create feature for permutation
    always_ff @(posedge clk) begin
        rx_symbols_valid_del <= rx_symbols_valid;
    end

    assign strb_permutation = rx_symbols_valid_del && !rx_symbols_valid;


    always_comb begin
        if (strb_permutation) 
            foreach(rx_symbols_extended[i]) begin
                rx_symbols_interleaved[i] <= rx_symbols_extended[permutation_for_A20[i]];
            end
    end

endmodule
