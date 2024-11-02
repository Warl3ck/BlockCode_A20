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

    parameter CLK_PERIOD = 4ns; // 250 MHz
    parameter NUM_SYMBOLS = 20;

	bit clk = 1'b0;
    bit arst = 1'b0;
    bit [3:0] rx_symbols;
    bit m_axis_tlast;
    bit [7:0] code_length;

    integer input_data, input_data1; //, hadamard_out;
    string line;
    bit rx_symbols_valid;

    event rst_done;

    always #(CLK_PERIOD/2) clk = ~clk;


	initial begin
        input_data = $fopen("input_snr-2_size13.txt", "r");
        input_data1 = $fopen("input_snr-2_size5.txt", "r");
        arst = 1'b0;
        fork 
            begin
                #150;
                @(posedge clk);
                arst = 1'b1;
                -> rst_done;
            end

            begin
                // @(rst_done);
                // code_length = 13;
                // while (!$feof(input_data)) begin
    	        //     @(posedge clk);
    	        //     $fgets(line,input_data);
    	        //     rx_symbols <= line.atoi();
                //     rx_symbols_valid <= 1'b1;
                // end
                // rx_symbols_valid <= 1'b0;
            end
        join
            begin
                // @(m_axis_tlast);
                code_length = 5;
                while (!$feof(input_data1)) begin
    	            @(posedge clk);
    	            $fgets(line,input_data1);
    	            rx_symbols <= line.atoi();
                    rx_symbols_valid <= 1'b1;
                end
                rx_symbols_valid <= 1'b0;
            end
    end

top_block_code  #(.DATA_WIDTH(4), .NUM_SYMBOLS(NUM_SYMBOLS))
top_block_code_inst
    (
        .clk                (clk),
        .s_axis_aresetn     (arst),
        .code_length        (code_length),
        .s_axis_tdata       (rx_symbols),
        .s_axis_tvalid      (rx_symbols_valid),
        .m_axis_tdata       (),
        .m_axis_tvalid      (),
        .m_axis_tlast       (m_axis_tlast)
    );

endmodule
