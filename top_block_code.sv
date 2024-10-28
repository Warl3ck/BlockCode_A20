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

		parameter DATA_WIDTH = 4,
		parameter NUM_SYMBOLS = 20
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


    reg [7:0] pucch_mask [4096];
    initial $readmemh("pucch_mask_hex.txt", pucch_mask);



	integer count = 0;
    reg hadamard_done;

    reg [3:0] vec [32]; 
    reg [3:0] vec1 [32]; 
    reg [3:0] vec2 [32]; 

	integer half;
	integer num1 = 32;

     task divide_sum  ( 
                     	input [3:0] data_in [32],
	            	    input integer num,
						// input integer half,
						output [3:0] data_out [32]
	            );

            // divide sum func
		// for (int j = 0; j < num/half; j++ ) begin
            for (int i = 0; i < num/2; i++) begin
                data_out[i] = data_in[i] + data_in[i+num/2];     
                data_out[i+num/2] = data_in[i] - data_in[i+num/2];     
            end
		// end

	endtask : divide_sum


    reg [DATA_WIDTH - 1:0] rx_symbols_interleaved [32] = '{32{0}};
	reg [DATA_WIDTH - 1:0] de_masked [32]; 

	integer j = 0; 


    // extend symbols
    always_ff @(posedge clk) begin
        if (rx_symbols_valid) begin
			rx_symbols_extended[NUM_SYMBOLS-1] <= rx_symbols;
            for (int i = (NUM_SYMBOLS-1); i > 0 ; i--) begin
                rx_symbols_extended[i-1] <= rx_symbols_extended[i];
            end
        end
    end


    // create feature for permutation
    always_ff @(posedge clk) begin
        rx_symbols_valid_del <= rx_symbols_valid;
    end

    assign strb_permutation = rx_symbols_valid_del && !rx_symbols_valid;


    // permution data
	always_comb begin
		if (strb_permutation)
			for (int i = 1; i < 32; i++) begin
				rx_symbols_interleaved[i] = rx_symbols_extended[(permutation_for_A20[i])-1];
            end
	end 



	// FSM
	typedef enum logic [1:0] { IDLE, DE_MASK, HADAMARD_TRANSFORM } statetype;
	statetype state, next_state;


	always_ff @(posedge clk)
		if (rst) state <= IDLE;
		else state <= next_state;

    always_comb begin
		/*next_state = XXX;*/
		case (state)
		IDLE 			: 	if (strb_permutation)  			next_state = DE_MASK;
							else						   	next_state = IDLE;
		DE_MASK		    : 	if (count < 128)                next_state = HADAMARD_TRANSFORM;
                            else                            next_state = IDLE;

		// HADAMARD_TRANSFORM	: 	/*if (!hadamard_done)  */   next_state = DE_MASK;
                           // else                            next_state = HADAMARD_TRANSFORM;

		// CALCULATE_1 	: 	if (counter == 0)				next_state = SAVE_ARRAY;
		// 					else						   	next_state = CALCULATE_1;
		// // QWERTY			: 	next_state = SAVE_ARRAY;			
		// SAVE_ARRAY 		: 	if (counter == blklen + 4)		next_state = IDLE;
		// 					else						   	next_state = SAVE_ARRAY;
		// /*default 		: 	next_state = XXX;*/
		endcase
	end


    always_ff @(posedge clk) begin
		case (state)
		IDLE	: begin
                    count = 0;
                    hadamard_done = 1'b0;
			end
		DE_MASK	: begin
                for (int i = 0; i < 32; i++) begin
                    de_masked[i] <= (pucch_mask[i+j][7]) ? (~rx_symbols_interleaved[i] + 1) : rx_symbols_interleaved[i];
                end
                j = j + 32;
                hadamard_done = 1'b1;
        end 
        HADAMARD_TRANSFORM	: begin
                count = count + 1;
                hadamard_done = 1'b0;
				half = num1;

				// for (int i = 0; i < num1; i = i + num1) begin
					divide_sum (de_masked, num1, vec);
					divide_sum (vec1, num1, vec2);


				// end



				// half = half >> 1;

//				for (int i = 0; i < num1; i = i + half) begin
					// divide_sum (vec [0:16-1], num1/2, vec1[0:15]);
					// divide_sum (vec [16:31], num1/2, vec1[16:31]);
//				end



                // // divide sum func
                // for (int i = 0; i < 16; i++) begin
                //     vec[i] <= de_masked[i] + de_masked[i+16];     
                //     vec[i+16] <= de_masked[i] - de_masked[i+16];     
                // end

                // for (int i = 0; i < 8; i++) begin
                //     vec1[i] <= vec[i] + vec[i+8];     
                //     vec1[i+8] <= vec[i] - vec[i+8];     
                // end


        end 

			endcase
		end



endmodule
