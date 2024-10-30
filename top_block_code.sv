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
        code_length,
        //
        vec4_o
    );

    input clk;
    input rst;
    input [DATA_WIDTH - 1:0] rx_symbols;
    input rx_symbols_valid;
    input [3:0] code_length;
    output [3:0] vec4_o;


    reg [DATA_WIDTH - 1:0] rx_symbols_array [20];
    reg [DATA_WIDTH - 1:0] rx_symbols_extended [32] = '{32{0}};
    reg rx_symbols_valid_del;
    wire strb_permutation;

    reg [7:0] permutation_for_A20 [32];

    initial begin
        permutation_for_A20[0] = 8'h20;     permutation_for_A20[1] = 8'h01;     permutation_for_A20[2] = 8'h15;     permutation_for_A20[3] = 8'h02;
        permutation_for_A20[4] = 8'h03;     permutation_for_A20[5] = 8'h16;     permutation_for_A20[6] = 8'h04;     permutation_for_A20[7] = 8'h05;
        permutation_for_A20[8] = 8'h17;     permutation_for_A20[9] = 8'h06;     permutation_for_A20[10] = 8'h07;    permutation_for_A20[11] = 8'h18;
        permutation_for_A20[12] = 8'h08;    permutation_for_A20[13] = 8'h09;    permutation_for_A20[14] = 8'h0A;    permutation_for_A20[15] = 8'h19;
        permutation_for_A20[16] = 8'h14;    permutation_for_A20[17] = 8'h1A;    permutation_for_A20[18] = 8'h0B;    permutation_for_A20[19] = 8'h0C;
        permutation_for_A20[20] = 8'h0D;    permutation_for_A20[21] = 8'h0E;    permutation_for_A20[22] = 8'h1B;    permutation_for_A20[23] = 8'h1C;
        permutation_for_A20[24] = 8'h0F;    permutation_for_A20[25] = 8'h10;    permutation_for_A20[26] = 8'h1D;    permutation_for_A20[27] = 8'h11;
        permutation_for_A20[28] = 8'h12;    permutation_for_A20[29] = 8'h13;    permutation_for_A20[30] = 8'h1E;    permutation_for_A20[31] = 8'h1F;
    end

    reg [7:0] pucch_mask [4096] = '{4096{8'h01}};

    initial begin // -1 index for matlab 
        pucch_mask[36] = 8'hFF;
        pucch_mask[38] = 8'hFF;
        pucch_mask[39] = 8'hFF;
        pucch_mask[41] = 8'hFF;
        pucch_mask[42] = 8'hFF;
        pucch_mask[44] = 8'hFF;
        pucch_mask[45] = 8'hFF;
        pucch_mask[46] = 8'hFF;
        pucch_mask[50] = 8'hFF;
        pucch_mask[51] = 8'hFF;
        pucch_mask[52] = 8'hFF;
        pucch_mask[53] = 8'hFF;
        pucch_mask[56] = 8'hFF;
        pucch_mask[57] = 8'hFF;
        pucch_mask[59] = 8'hFF;
        pucch_mask[60] = 8'hFF;
        pucch_mask[65] = 8'hFF;
        pucch_mask[67] = 8'hFF;
        pucch_mask[68] = 8'hFF;
        pucch_mask[70] = 8'hFF;
        pucch_mask[71] = 8'hFF;
        pucch_mask[73] = 8'hFF;
        pucch_mask[74] = 8'hFF;
        pucch_mask[76] = 8'hFF;
        pucch_mask[77] = 8'hFF;
        pucch_mask[78] = 8'hFF;
        pucch_mask[82] = 8'hFF;
        pucch_mask[83] = 8'hFF;
        pucch_mask[84] = 8'hFF;
        pucch_mask[85] = 8'hFF;
        pucch_mask[91] = 8'hFF;
        pucch_mask[92] = 8'hFF;
    end

    
//     initial begin 
//         // $readmemh("permutation_for_A20_array.txt", permutation_for_A20);
// ////    	$readmemh("pucch_mask_hex.txt", pucch_mask);
//     end

	integer count = 0;
    reg hadamard_done;

    reg [3:0] vec [32]; 
    reg [3:0] vec1 [32]; 
    reg [3:0] vec2 [32];
    reg [3:0] vec3 [32];  
    reg [3:0] vec4 [32];  

	integer half;
	integer num1 = 32;

    //  task divide_sum  ( 
    //                  	input [3:0] data_in [32],
	//             	    input integer num,
	// 					// input integer half,
	// 					output [3:0] data_out [32]
	//             );

    //         // divide sum func
	// 	// for (int j = 0; j < num/half; j++ ) begin
    //         for (int i = 0; i < num/2; i++) begin
    //             data_out[i] = data_in[i] + data_in[i+num/2];     
    //             data_out[i+num/2] = data_in[i] - data_in[i+num/2];     
    //         end
	// 	// end

	// endtask : divide_sum


    reg [DATA_WIDTH - 1:0] rx_symbols_interleaved [32] = '{32{0}};
	reg [DATA_WIDTH - 1:0] de_masked [32]; 

    reg [15:0] counter = 0;

	integer j = 0; 
    integer q = 0;


    reg we;
    reg [11:0] addr;
    reg [7:0] pucch_mask_dout;

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
		IDLE 			    :   if (strb_permutation)  		next_state = DE_MASK;
							    else						next_state = IDLE;
		DE_MASK		        : 	if (count < 128)            next_state = HADAMARD_TRANSFORM;
                                else                        next_state = DE_MASK;
		 HADAMARD_TRANSFORM	: 	if (!hadamard_done)         next_state = DE_MASK;
                                else                        next_state = HADAMARD_TRANSFORM;
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

                // divide sum func
                for (int i = 0; i < 16; i++) begin
                    vec[i] <= de_masked[i] + de_masked[i+16];     
                    vec[i+16] <= de_masked[i] - de_masked[i+16];     
                end

                for (int i = 0; i < 8; i++) begin
                    vec1[i] <= vec[i] + vec[i+8];        
                    vec1[i+8] <= vec[i] - vec[i+8];   
                    vec1[i+16] <= vec[i+16] + vec[i+24];        
                    vec1[i+24] <= vec[i+16] - vec[i+24];  
                end

                for (int i = 0; i < 4; i++) begin // 8 matlab
                    // part 1
                    vec2[i] <= vec1[i] + vec1[i+4];        
                    vec2[i+4] <= vec1[i] - vec1[i+4];   
                    vec2[i+8] <= vec1[i+8] + vec1[i+12];        
                    vec2[i+12] <= vec1[i+8] - vec1[i+12];  
                    // part 2 
                    vec2[i+16] <= vec1[i+16] + vec1[i+20];      // ?? dont have bits  
                    vec2[i+20] <= vec1[i+16] - vec1[i+20];   
                    vec2[i+24] <= vec1[i+24] + vec1[i+28];        
                    vec2[i+28] <= vec1[i+24] - vec1[i+28];  
                end

//                for (int i = 0; i < 2; i++) begin // 4 matlab
//                    vec3[i]     <= vec2[i]      + vec2[i+2];        
//                    vec3[i+2]   <= vec2[i]      - vec2[i+2]; 
//                    vec3[i+4]   <= vec2[i+4]    + vec2[i+6];       
//                    vec3[i+6]   <= vec2[i+4]    - vec2[i+6]; 
//                    vec3[i+8]   <= vec2[i+8]    + vec2[i+10]; 
//                    vec3[i+10]  <= vec2[i+8]    - vec2[i+10]; 
//                    vec3[i+12]  <= vec2[i+12]   + vec2[i+14]; 
//                    vec3[i+14]  <= vec2[i+12]   - vec2[i+14]; 
//                    vec3[i+16]  <= vec2[i+16]   + vec2[i+18];        
//                    vec3[i+18]  <= vec2[i+16]   - vec2[i+18]; 
//                    vec3[i+20]  <= vec2[i+20]   + vec2[i+22]; 
//                    vec3[i+22]  <= vec2[i+20]   - vec2[i+22]; 
//                    vec3[i+24]  <= vec2[i+24]   + vec2[i+26];   
//                    vec3[i+26]  <= vec2[i+24]   - vec2[i+26]; 
//                    vec3[i+28]  <= vec2[i+28]   + vec2[i+30]; 
//                    vec3[i+30]  <= vec2[i+28]   - vec2[i+30]; 
//                end


//                for (int i = 0; i < 1; i++) begin // 4 matlab
//                    vec4[i]     <= vec3[i]      + vec3[i+1];        
//                    vec4[i+1]   <= vec3[i]      - vec3[i+1];
//                    vec4[i+2]   <= vec3[i+2]    + vec3[i+3];   
//                    vec4[i+3]   <= vec3[i+2]    - vec3[i+3]; 
//                    vec4[i+4]   <= vec3[i+4]    + vec3[i+5]; 
//                    vec4[i+5]   <= vec3[i+4]    - vec3[i+5]; 
//                    vec4[i+6]   <= vec3[i+6]    + vec3[i+7]; 
//                    vec4[i+7]   <= vec3[i+6]    - vec3[i+7]; 
//                    vec4[i+8]   <= vec3[i+8]    + vec3[i+9]; 
//                    vec4[i+9]   <= vec3[i+8]    - vec3[i+9];
//                    vec4[i+10]  <= vec3[i+10]   + vec3[i+11]; 
//                    vec4[i+11]  <= vec3[i+10]   - vec3[i+11];
//                    vec4[i+12]  <= vec3[i+12]   + vec3[i+13]; 
//                    vec4[i+13]  <= vec3[i+12]   - vec3[i+13];
//                    vec4[i+14]  <= vec3[i+14]   + vec3[i+15];        
//                    vec4[i+15]  <= vec3[i+14]   - vec3[i+15]; 
//                    vec4[i+16]  <= vec3[i+16]   + vec3[i+17];        
//                    vec4[i+17]  <= vec3[i+16]   - vec3[i+17]; 
//                    vec4[i+18]  <= vec3[i+18]   + vec3[i+19];        
//                    vec4[i+19]  <= vec3[i+18]   - vec3[i+19];
//                    vec4[i+20]  <= vec3[i+20]   + vec3[i+21];        
//                    vec4[i+21]  <= vec3[i+20]   - vec3[i+21];  
//                    vec4[i+22]  <= vec3[i+22]   + vec3[i+23];        
//                    vec4[i+23]  <= vec3[i+22]   - vec3[i+23]; 
//                    vec4[i+24]  <= vec3[i+24]   + vec3[i+25]; 
//                    vec4[i+25]  <= vec3[i+24]   - vec3[i+25]; 
//                    vec4[i+26]  <= vec3[i+26]   + vec3[i+27];  
//                    vec4[i+27]  <= vec3[i+26]   - vec3[i+27];
//                    vec4[i+28]  <= vec3[i+28]   + vec3[i+29]; 
//                    vec4[i+29]  <= vec3[i+28]   - vec3[i+29];
//                    vec4[i+30]  <= vec3[i+30]   + vec3[i+31];        
//                    vec4[i+31]  <= vec3[i+30]   - vec3[i+31];  
//                end

        end 

			endcase
		end


    // rams_pucch_mask rams_pucch_mask_inst 
    // (
    //     .clk    (clk),
    //     .we     (we),
    //     .addr   (addr),
    //     .din    (),
    //     .dout   (pucch_mask_dout)
    // );

    assign vec4_o = vec2[30]; 

endmodule
