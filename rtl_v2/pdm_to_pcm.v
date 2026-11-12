`timescale 1ns / 1ps

module pdm_to_pcm(

    input wire clock_100m,
    input wire pdm_read_flag,
    input wire pdm_data_in,
    input wire reset,
    
    output wire signed [15:0] pcm_signal_out,
    output wire pcm_ready_flag
    
    );
    
    
    
    wire signed [23:0] w_cic_signal;
    wire w_cic_ready_flag;
    
    
    
    
    cic_decimator u_cic_decimator (
    
        .clock_100m (clock_100m),
        .pdm_read_flag (pdm_read_flag),
        .pdm_data_in (pdm_data_in),
        .reset (reset),
        .cic_signal_out (w_cic_signal),
        .cic_ready_flag (w_cic_ready_flag)
        
        
        
    
    );
    
        
    dc_removal u_dc_removal (
    
        .clock_100m (clock_100m),
        .reset (reset),
        .cic_signal_in (w_cic_signal),
        .cic_ready_flag (w_cic_ready_flag),
        .pcm_signal_out (pcm_signal_out),
        .pcm_ready_flag (pcm_ready_flag)
        
        
        
        
        
    
    );
    
    
    
    
    
endmodule
