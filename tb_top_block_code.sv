`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2024 15:28:42
// Design Name: 
// Module Name: tb_top_block_code
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


module tb_top_block_code();

    parameter CLK_PERIOD = 10ns;

	bit clk = 1'b0;
    bit rst = 1'b0;
    bit [3:0] rx_symbols;

    integer input_data;
    string line;
    bit rx_symbols_valid;

    always #(CLK_PERIOD/2) clk = ~clk;



	initial begin
        input_data = $fopen("input_snr-2_size13.txt", "r");
        while (!$feof(input_data)) begin
    	    @(posedge clk);
    	    $fgets(line,input_data);
    	    rx_symbols <= line.atoi();
            rx_symbols_valid <= 1'b1;
        end
        rx_symbols_valid <= 1'b0;
    end

top_block_code  #(.DATA_WIDTH(4))
top_block_code_inst
    (
        .clk                (clk),
        .rst                (rst),
        .rx_symbols         (rx_symbols),
        .rx_symbols_valid   (rx_symbols_valid),
        .code_length        ()
    );

endmodule
