`timescale 1ns / 1ps



module PL_Connector(

    input wire clock_100m, // 100MHz main clock
    input wire reset, // Reset pin
    input wire [4:0] pdm_data_in,
    
    output wire pdm_clock

    );
    
    
    wire w_pdm_read_flag;
    wire [4:0] w_pcm_ready_flag;
    
    wire signed [15:0] w_pcm_signal [0:4];
    
    
    
    
    
    
    
    
    
    
    
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
    
    
    
endmodule
