`timescale 1ns / 1ps

module tb_PL_Connector();

    reg clock_100m = 0;
    reg reset = 1;
    reg [4:0] pdm_data_in = 5'b00000;
    
    wire pdm_clock;
    
    wire drone_detected_flag;
    wire [3:0] best_id1;
    wire [3:0] best_id2;
    wire [3:0] best_id3;
    wire [3:0] best_id4;
    
    wire best_id_flag1;
    wire best_id_flag2;
    wire best_id_flag3;
    wire best_id_flag4;
    
    
    always #5 clock_100m = ~clock_100m;
    
    PL_Connector uut (
    
        .clock_100m (clock_100m),
        .reset (reset),
        .pdm_data_in (pdm_data_in),
        .pdm_clock (pdm_clock),
        .drone_detected_flag (drone_detected_flag),
        .best_id1 (best_id1),
        .best_id2 (best_id2),
        .best_id3 (best_id3),
        .best_id4 (best_id4),
        
        .best_id_flag1 (best_id_flag1),
        .best_id_flag2 (best_id_flag2),
        .best_id_flag3 (best_id_flag3),
        .best_id_flag4 (best_id_flag4)
        
        
    );
    
    reg mic0_pdm [0:5999999];
    reg mic1_pdm [0:5999999];
    reg mic2_pdm [0:5999999];
    reg mic3_pdm [0:5999999];
    reg mic4_pdm [0:5999999];
    
    integer i;
    
    initial begin
    
        $readmemb("/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/scripts/PL_Connector_scripts/PL_connector_bits0.txt",mic0_pdm);
        $readmemb("/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/scripts/PL_Connector_scripts/PL_connector_bits1.txt",mic1_pdm);
        $readmemb("/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/scripts/PL_Connector_scripts/PL_connector_bits2.txt",mic2_pdm);
        $readmemb("/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/scripts/PL_Connector_scripts/PL_connector_bits3.txt",mic3_pdm);
        $readmemb("/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/scripts/PL_Connector_scripts/PL_connector_bits4.txt",mic4_pdm);
        
        reset = 1;
        #100;
        reset = 0;
        #50;
        
        for (i = 0; i < 6000000; i = i + 1) begin
        
            @(posedge pdm_clock);
            
            pdm_data_in[0] <= mic0_pdm[i];
            pdm_data_in[1] <= mic1_pdm[i];
            pdm_data_in[2] <= mic2_pdm[i];
            pdm_data_in[3] <= mic3_pdm[i];
            pdm_data_in[4] <= mic4_pdm[i];

        end
        
        #1000;
        $finish;
        
    
    end

endmodule
