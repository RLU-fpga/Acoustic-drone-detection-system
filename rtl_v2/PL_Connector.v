`timescale 1ns / 1ps



module PL_Connector(

    input wire clock_100m, // 100MHz main clock
    input wire reset, // Reset pin
    
    output wire pdm_clock,
    output wire pdm_read_flag

    );
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Link between PL_connector and pdm_to_pcm
    
    pdm_to_pcm u_pdm_to_pcm (
    
        .clock_100m (clock_100m)
    
    );
    
    
    
    // Link between PL_connector and clock_divider
    
    clock_divider u_clock_divider (
        
        .clock_100m (clock_100m),
        .reset (reset),
        
        .pdm_clock (pdm_clock),
        .pdm_read_flag (pdm_read_flag)
    
    );
    
    
    
endmodule
