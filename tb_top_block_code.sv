



`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

import axi4stream_vip_pkg::*;
import axi4stream_vip_mst_pkg::*;


module tb_top_block_code();

    localparam CLK_PERIOD = 4ns; // 250 MHz
    localparam NUM_SYMBOLS = 20;
    localparam DATA_WIDTH = 8;

	bit clk = 1'b0;
    bit arst = 1'b0;
    bit m_axis_tlast;
    bit m_axis_tvalid;
    bit [7:0] code_length;

    integer input_data;
    integer count = 0;
    string line;

    event rst_done;

    wire m_axis_tready;
    wire [DATA_WIDTH-1 : 0] m_axis_tdata;

    always #(CLK_PERIOD/2) clk = ~clk;

	xil_axi4stream_data_beat out_tdata, in_tdata;
    axi4stream_vip_mst_mst_t	 axi4stream_vip_mst_mst;

    task mst_gen_transaction(   input xil_axi4stream_data_beat in_tdata,
                                input integer count
							);

        axi4stream_transaction                         wr_transaction; 
        wr_transaction = axi4stream_vip_mst_mst.driver.create_transaction("Master VIP write transaction");
        
        if(count == NUM_SYMBOLS-1) begin
            // set tlast to 1
            wr_transaction.set_last(1);
        end else begin
            // set tlast to 0
            wr_transaction.set_last(0);
        end
            
        // for(int i = 0; i < 4;i++) begin
            wr_transaction.set_data_beat(in_tdata);
            wr_transaction.set_delay(0);
        // end  
//      in_tlast = wr_transaction.get_last;
//      queue_mst.push_back(in_tdata[DATA_WIDTH-1:0]);

			axi4stream_vip_mst_mst.driver.send(wr_transaction);

    endtask

    
    
	initial begin
	    axi4stream_vip_mst_mst = new("axi4stream_vip_mst_mst", tb_top_block_code.axi4stream_vip_mst_inst.inst.IF);
        axi4stream_vip_mst_mst.start_master();
        arst <= 1'b0;
        fork 
            begin
                #150;
                @(posedge clk);
                arst <= 1'b1;
                -> rst_done;
            end

            begin
                input_data = $fopen("input_snr-2_size13.txt", "r");
                @(rst_done);
                code_length = 13;
                while (!$feof(input_data)) begin
    	            $fgets(line,input_data);
         			mst_gen_transaction(line.atoi(), count);
                    count = count + 1; 
                end

            end
        join
            // begin
            //     input_data = $fopen("input_snr-2_size5.txt", "r");
            //     @(m_axis_tlast);
            //     code_length = 5;
            //     while (!$feof(input_data)) begin
    	    //         @(posedge clk);
    	    //         $fgets(line,input_data);
    	    //         rx_symbols <= line.atoi();
            //         rx_symbols_valid <= 1'b1;
            //     end
            //     rx_symbols_valid <= 1'b0;
            // end
    end

top_block_code  #(.DATA_WIDTH(4), .NUM_SYMBOLS(NUM_SYMBOLS))
top_block_code_instance
    (
        .clk                (clk),
        .s_axis_aresetn     (arst),
        .code_length        (code_length),
        .s_axis_tdata       (m_axis_tdata),
        .s_axis_tvalid      (m_axis_tvalid),
        .s_axis_tready      (m_axis_tready),
        .s_axis_tlast		(m_axis_tlast),
        .m_axis_tdata       (),
        .m_axis_tvalid      (),
        .m_axis_tlast       (m_axis_tlast)
    );

axi4stream_vip_mst axi4stream_vip_mst_inst 
    (
        .aclk               (clk),
        .aresetn            (arst),
        .m_axis_tvalid      (m_axis_tvalid),
        .m_axis_tready      (m_axis_tready),
        .m_axis_tdata       (m_axis_tdata),
        .m_axis_tlast		(m_axis_tlast)
    );
    
    

endmodule
