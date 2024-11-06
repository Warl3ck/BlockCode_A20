



`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

import axi4stream_vip_pkg::*;
import axi4stream_vip_mst_pkg::*;
import axi4stream_vip_slv_pkg::*;


module tb_top_block_code();

    localparam CLK_PERIOD = 4ns; // 250 MHz
    localparam NUM_SYMBOLS = 20;
    localparam DATA_WIDTH = 8;

	bit clk = 1'b0;
    bit arst = 1'b0;


    // master
    bit m_axis_tlast;
    bit m_axis_tvalid;
    wire [DATA_WIDTH-1 : 0] m_axis_tdata;
    wire m_axis_tready;
    // slave
    wire s_axis_tlast;
    wire s_axis_tvalid; 
    wire [15:0] s_axis_tdata;
    wire s_axis_tready;
    bit decoded_bit;


    bit queue_slv [$];

    bit [7:0] code_length;

    integer input_data, output_data;
    integer input_data1, output_data1;
    integer count = 0;
    integer counter_right = 0;
    string line;

    event rst_done, write_complete;

    

    // Ready signal created by slave VIP when TREADY is High
    axi4stream_ready_gen ready_gen;
    // Output data process
    axi4stream_monitor_transaction slv_mon_trans;

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
            
        // for(int i = 0; i < 4;i++) begin
            wr_transaction.set_data_beat(in_tdata);
            wr_transaction.set_delay(wr_delay);
        // end  

		axi4stream_vip_mst_mst.driver.send(wr_transaction);

    endtask

    
    
	initial begin
        // start AXI MASTER VIP
	    axi4stream_vip_mst_mst = new("axi4stream_vip_mst_mst", tb_top_block_code.axi4stream_vip_mst_inst.inst.IF);
        axi4stream_vip_mst_mst.start_master();
        // start AXI SLAVE VIP
        axi4stream_vip_slv_slv = new("axi4stream_vip_slv_slv", tb_top_block_code.axi4stream_vip_slv_inst.inst.IF);
        axi4stream_vip_slv_slv.start_slave();


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
                input_data = $fopen("input_snr-2_size10_8_bit.txt", "r");
                output_data = $fopen("output_snr-2_size10_8_bit.txt", "r");

                @(rst_done);
                code_length = 10;
                while (!$feof(input_data)) begin
    	            $fgets(line,input_data);
         			mst_gen_transaction(line.atoi(), count, 0);
                    count = count + 1; 
                end

                // check
                while (!$feof(output_data)) begin
    	            $fgets(line,output_data);
                    // $display(line.atobin);
                    decoded_bit = line.atobin;
                    queue_slv.push_back(decoded_bit);  
                end

                ready_gen = axi4stream_vip_slv_slv.driver.create_ready("ready_gen");
                ready_gen.set_ready_policy(XIL_AXI4STREAM_READY_GEN_OSC);
                ready_gen.set_low_time(20);
                ready_gen.set_high_time(10);
                axi4stream_vip_slv_slv.driver.send_tready(ready_gen);

                $display(queue_slv);

                forever begin
                    axi4stream_vip_slv_slv.monitor.item_collected_port.get(slv_mon_trans);
                 	out_tdata = slv_mon_trans.get_data_beat();
                 	out_tlast = slv_mon_trans.get_last;
                    foreach (queue_slv[i]) begin
                        if (out_tdata[15-i] == queue_slv[i]) 
                            counter_right = counter_right + 1;
                    end

                    if (counter_right == queue_slv.size())
                        break;  
                end

                $display("1-st CYCLE COMPLETE");

                #1us;


            end

        join
            begin
                input_data1 = $fopen("input_snr0_size5_8_bit.txt", "r");
                output_data1 = $fopen("output_snr0_size5_8_bit.txt", "r");

                // init queque
                queue_slv.delete();
                count = 0;
                counter_right = 0;


         
                code_length = 5;
                while (!$feof(input_data1)) begin
    	            $fgets(line,input_data1);
         			mst_gen_transaction(line.atoi(), count, 5);
                    count = count + 1; 
                end

                // check
                while (!$feof(output_data1)) begin
    	            $fgets(line,output_data1);
                    decoded_bit = line.atobin;
                    queue_slv.push_back(decoded_bit);  
                end
                
                ready_gen = axi4stream_vip_slv_slv.driver.create_ready("ready_gen");
                ready_gen.set_ready_policy(XIL_AXI4STREAM_READY_GEN_OSC);
                ready_gen.set_low_time(30);
                ready_gen.set_high_time(10);
                axi4stream_vip_slv_slv.driver.send_tready(ready_gen);

                $display(queue_slv);

                forever begin
                    axi4stream_vip_slv_slv.monitor.item_collected_port.get(slv_mon_trans);
                 	out_tdata = slv_mon_trans.get_data_beat();
                 	out_tlast = slv_mon_trans.get_last;
                    foreach (queue_slv[i]) begin
                        if (out_tdata[15-i] == queue_slv[i]) 
                            counter_right = counter_right + 1;
                    end

                    if (counter_right == queue_slv.size())
                        break;  
                end

                $display("2-st CYCLE COMPLETE");
            end
    end

top_block_code  #(.DATA_WIDTH(DATA_WIDTH), .NUM_SYMBOLS(NUM_SYMBOLS))
top_block_code_instance
    (
        .clk                (clk),
        .s_axis_aresetn     (arst),
        .code_length        (code_length),
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
        .s_axis_tdata       (s_axis_tdata),
        .s_axis_tlast       (s_axis_tlast)
    );

    

endmodule
