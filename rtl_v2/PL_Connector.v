`timescale 1ns / 1ps



module PL_Connector(

    input wire clock_100m, // 100MHz main clock
    input wire reset, // Reset pin
    input wire [4:0] pdm_data_in,
    
    output wire pdm_clock,
    
    // Outputs into AXI-LITE BUS
    output wire drone_detected_flag,
    output wire [3:0] best_id1,
    output wire [3:0] best_id2,
    output wire [3:0] best_id3,
    output wire [3:0] best_id4,
    
    output wire best_id_flag1,
    output wire best_id_flag2,
    output wire best_id_flag3,
    output wire best_id_flag4
    
    );
    
    
    wire w_pdm_read_flag;
    wire w_pcm_ready_flag [0:4];
    
    wire signed [15:0] w_pcm_signal [0:4];
    
    wire w_drone_detected_flag;
    
    wire signed [15:0] w_memory0;
    
    wire [3:0] w_best_id [1:4];
    wire w_best_id_flag [1:4]; 
    
    assign best_id1 = w_best_id[1];
    assign best_id2 = w_best_id[2];
    assign best_id3 = w_best_id[3];
    assign best_id4 = w_best_id[4];
    
    assign best_id_flag1 = w_best_id_flag[1];
    assign best_id_flag2 = w_best_id_flag[2];
    assign best_id_flag3 = w_best_id_flag[3];
    assign best_id_flag4 = w_best_id_flag[4];
    
    assign drone_detected_flag = w_drone_detected_flag;
    
    
    
    
    // Link between PL_connector and 5 pdm_to_pcm
    
    genvar i;
    
    
    
    generate
        for ( i = 0; i < 5; i = i +1) begin : Microphone_module
    pdm_to_pcm u_pdm_to_pcm (
    
        .clock_100m (clock_100m),
        .pdm_read_flag (w_pdm_read_flag),
        .pdm_data_in (pdm_data_in[i]),
        
        .reset (reset),
        
        .pcm_signal_out (w_pcm_signal[i]),
        .pcm_ready_flag (w_pcm_ready_flag[i])
    
    );
    
        end
    endgenerate 
    
    
    
    // Link between PL_connector and clock_divider
    
    clock_divider u_clock_divider (
        
        .clock_100m (clock_100m),
        .reset (reset),
        
        .pdm_clock (pdm_clock),
        .pdm_read_flag (w_pdm_read_flag)
    
    );
    
    // Link between PL_connector and tdoa_mic_correlatio
    
    mic_correlation u_mic_correlation (
        
        .clock_100m (clock_100m),
        .pcm_signal_in0 (w_pcm_signal[0]),
        .reset (reset),
        .pcm_ready_flag0 (w_pcm_ready_flag[0]),
        .drone_detected_flag (w_drone_detected_flag),
        .microphone0_delayed_out (w_memory0)
        
    );
    
    
    // Link between PL_connector and tdoa_correlator
    
    genvar z;
    
    generate
        for (z = 1; z < 5; z = z +1) begin : tdoa_best
    
        tdoa_correlator u_tdoa_correlator (
    
            .clock_100m (clock_100m),
            .reset (reset),
        
            .pcm_signal_in (w_pcm_signal[z]),
            .pcm_ready_flag (w_pcm_ready_flag[z]),
        
            .memory0 (w_memory0),
            .drone_detected_flag (w_drone_detected_flag),
            .best_id (w_best_id[z]),
            .best_id_flag (w_best_id_flag[z])
    
        );
        end
    endgenerate
    
    
endmodule
