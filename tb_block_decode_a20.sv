



`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

import axi4stream_vip_pkg::*;
import axi4stream_vip_mst_pkg::*;
import axi4stream_vip_slv_pkg::*;


module tb_block_decode_a20 ();

    localparam CLK_PERIOD = 4ns; // 250 MHz
    localparam NUM_SYMBOLS = 20;
    localparam DATA_WIDTH = 8;

    parameter string MY_PATH = "E:/Netlist/CRAT/8bit/BlockCode(A20)/test_data";

    

	bit clk = 1'b0;
    bit arst = 1'b0;

    bit [7:0] code_length;
    bit code_length_valid;

    // master
    bit m_axis_tlast;
    bit m_axis_tvalid;
    wire [DATA_WIDTH-1 : 0] m_axis_tdata;
    wire m_axis_tready;

    // slave
    wire s_axis_tlast;
    wire s_axis_tvalid; 
    wire s_axis_tdata;
    wire s_axis_tready;
    bit decoded_bit;

    bit queue_slv [$];
    bit queue_decode [$];

    integer input_data, output_data;
    integer count = 0;
    integer counter_right = 0;
    string line;

    event rst_done;

    

    // Ready signal created by slave VIP when TREADY is High
    axi4stream_ready_gen ready_gen;
    // Output data process
    axi4stream_monitor_transaction slv_mon_trans;
    // Monitor transaction queue for slave VIP
    axi4stream_monitor_transaction slave_moniter_transaction_queue[$];
    // Size of slave_moniter_transaction_queue
    xil_axi4stream_uint    slave_moniter_transaction_queue_size;

    axi4stream_vip_mst_mst_t	axi4stream_vip_mst_mst;
    axi4stream_vip_slv_slv_t    axi4stream_vip_slv_slv;

	xil_axi4stream_data_beat out_tdata, in_tdata;
    bit out_tlast;



    always #(CLK_PERIOD/2) clk = ~clk;


    task mst_gen_transaction(   input xil_axi4stream_data_beat in_tdata,
                                input integer count,
                                input integer wr_delay
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
            
        wr_transaction.set_data_beat(in_tdata);
        wr_transaction.set_delay(wr_delay);

		axi4stream_vip_mst_mst.driver.send(wr_transaction);

    endtask

    
    
	initial begin
        // start AXI MASTER VIP
	    axi4stream_vip_mst_mst = new("axi4stream_vip_mst_mst", tb_block_decode_a20.axi4stream_vip_mst_inst.inst.IF);
        axi4stream_vip_mst_mst.start_master();
        // start AXI SLAVE VIP
        axi4stream_vip_slv_slv = new("axi4stream_vip_slv_slv", tb_block_decode_a20.axi4stream_vip_slv_inst.inst.IF);
        axi4stream_vip_slv_slv.vif_proxy.set_dummy_drive_type(XIL_AXI4STREAM_VIF_DRIVE_NONE);
        axi4stream_vip_slv_slv.start_slave();
        axi4stream_vip_slv_slv.set_verbosity(0); // 400

        

        code_length_valid <= 1'b0;
        arst <= 1'b0;
        fork 
            begin
                #150;
                @(posedge clk);
                arst <= 1'b1;
                -> rst_done;
            end

            // write 
            begin
                @(rst_done);

                for (int i = 0; i < 13; i++) begin
                    queue_slv.delete();
                    queue_decode.delete();
                    slave_moniter_transaction_queue.delete();
                    count = 0;
                    slave_moniter_transaction_queue_size = 0;


                    input_data = $fopen($sformatf({MY_PATH, "/input_snr%0d_size%0d_8_bit.txt"}, i-3, i+1), "r");
                    output_data = $fopen($sformatf({MY_PATH, "/output_snr%0d_size%0d_8_bit.txt"}, i-3, i+1), "r");
                    
                    code_length_valid <= 1'b1;
                    code_length <= i+1;
                    #(CLK_PERIOD);
                    code_length_valid <= 1'b0;

                while (!$feof(input_data)) begin
    	            $fgets(line,input_data);
         			mst_gen_transaction(line.atoi(), count, 0);
                    count = count + 1; 
                end

                // check
                while (!$feof(output_data)) begin
    	            $fgets(line,output_data);
                    decoded_bit = line.atobin;
                    queue_slv.push_back(decoded_bit);  
                end

                ready_gen = axi4stream_vip_slv_slv.driver.create_ready("ready_gen");
                ready_gen.set_ready_policy(XIL_AXI4STREAM_READY_GEN_OSC);
                ready_gen.set_low_time(20);
                ready_gen.set_high_time(10);
                axi4stream_vip_slv_slv.driver.send_tready(ready_gen);


                forever begin
                    axi4stream_vip_slv_slv.monitor.item_collected_port.get(slv_mon_trans);
                    slave_moniter_transaction_queue.push_back(slv_mon_trans);
                    slave_moniter_transaction_queue_size++;
                    out_tdata = slv_mon_trans.get_data_beat();
                    queue_decode.push_back(out_tdata[0]);   
                 	out_tlast = slv_mon_trans.get_last;
                    $display(slave_moniter_transaction_queue_size);
                    if (slave_moniter_transaction_queue_size == (i+1)) begin
                        break;
                    end
                end

                $display($sformatf({MY_PATH, "/output_snr%0d_size%0d_8_bit.txt"}, i-3, i+1));
                $display(queue_slv, queue_decode);
            
                if (queue_slv != queue_decode) begin
                    $display (i+1, "-st CYCLE ERROR");
                    $finish;
                end else
                    $display(i+1, "-st CYCLE COMPLETE");
                end

                #10us;
            end

        join
            begin
                $display("Test complete");
            end
    end

block_decode_a20  #(.DATA_WIDTH(DATA_WIDTH), .NUM_SYMBOLS(NUM_SYMBOLS))
block_decode_a20_instance
    (
        .clk                (clk),
        .s_axis_aresetn     (arst),
        .code_length        (code_length),
        .code_length_valid  (code_length_valid),
        .s_axis_tdata       (m_axis_tdata),
        .s_axis_tvalid      (m_axis_tvalid),
        .s_axis_tready      (m_axis_tready),
        .s_axis_tlast		(m_axis_tlast),
        .m_axis_tdata       (s_axis_tdata),
        .m_axis_tvalid      (s_axis_tvalid),
        .m_axis_tlast       (s_axis_tlast),
        .m_axis_tready      (s_axis_tready)
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
    
axi4stream_vip_slv axi4stream_vip_slv_inst 
    (
        .aclk               (clk),
        .aresetn            (arst),
        .s_axis_tvalid      (s_axis_tvalid),
        .s_axis_tready      (s_axis_tready),
        .s_axis_tdata       ({{7{1'b0}}, s_axis_tdata}),
        .s_axis_tlast       (s_axis_tlast)
    );

endmodule
