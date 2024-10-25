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


    reg [DATA_WIDTH - 1:0] rx_symbols_array [20];
    reg [DATA_WIDTH - 1:0] rx_symbols_extended [32] = '{32{0}};
    reg rx_symbols_valid_del;
    wire strb_permutation;

    reg [7:0] permutation_for_A20 [32];
    initial $readmemh("permutation_for_A20_array.txt", permutation_for_A20);

    reg [7:0] rx_symbols_interleaved;// [32];
    reg [3:0] rx_symbols_interleaved11;// [32];
    reg [3:0] rx_symbols_interleaved22 [32] = '{32{0}};

	reg del;
	reg [7:0] count = 0;


    always_ff @(posedge clk) begin
        if (rx_symbols_valid) begin
			rx_symbols_array[19] <= rx_symbols;
            for (int i = 19; i > 0 ; i--) begin
                rx_symbols_array[i-1] <= rx_symbols_array[i];
            end
        end
    end



    // create feature for permutation
    always_ff @(posedge clk) begin
        rx_symbols_valid_del <= rx_symbols_valid;
    end

    assign strb_permutation = rx_symbols_valid_del && !rx_symbols_valid;


    // extend symbols
    always_comb begin
    	if (strb_permutation) begin
        	for (int i = 0; i < 20; i++) begin
            	rx_symbols_extended[i] = rx_symbols_array[i];
        	end
    	end
    end
    
    
    // permution data
	always_comb begin
		if (strb_permutation)
			// del <= 1'b1;
			for (int i = 1; i < 32; i++) begin
				rx_symbols_interleaved22[i] = rx_symbols_extended[(permutation_for_A20[i])-1];
            end
	end 



	










    // always_ff @(posedge clk) begin
    //     if (del) begin
	// 			count <= count + 1;
	// 			 rx_symbols_interleaved <= permutation_for_A20[count]; //rx_symbols_extended[permutation_for_A20[count]];
	// 			 rx_symbols_interleaved11 <= rx_symbols_extended[rx_symbols_interleaved-1];
	// 	end
    // end

endmodule
