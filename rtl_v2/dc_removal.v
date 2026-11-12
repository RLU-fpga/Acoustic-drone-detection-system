`timescale 1ns / 1ps

module dc_removal(

    input wire clock_100m, //100MHz Main clock
    input wire reset, // Reset state
    input wire signed [23:0] cic_signal_in, // CIC singal from cic_decimator module
    
    input wire cic_ready_flag, // CIC flag from cic_decimator module

    output reg signed [15:0] pcm_signal_out, // 16 bit pcm signal
    output reg pcm_ready_flag // pcm ready flag

    );
    
    // Real time dc removal module
    // The DC offset is unknown, and has to be removed, before correlation and other steps
    // basic formule for high pass filter
    
    // y[n] = x[n] - x[n-1] + R * y[n-1]
    
    // Closer R is to 1 lower the F_cutoff
    // R =  1 - (1 / (2 ^ k))
    // k bit shift number
    
    // F_cutoff = (F_samplerate * (1-R)) / 2* pi
    // F_cutoff = F_samplerate / (2 * pi * 2 ^ k)
    
    // F_cutoff = 2714 / (2 * pi * 2 ^ 8) = 1.7Hz; -3db @ 1.7Hz
    
    
    
    
    reg signed [23:0] delayed_cic_signal_in;
    reg signed [23:0] delayed_dc_removed_out; 
    
    wire signed [23:0] dc_removed = cic_signal_in - delayed_cic_signal_in + delayed_dc_removed_out - (delayed_dc_removed_out >>> 8);
    
    
    always @(posedge clock_100m) begin
    
        if (reset) begin
            
            pcm_signal_out <= 16'sd0;
            pcm_ready_flag <= 1'b0;
            
            delayed_cic_signal_in <= 24'sd0;
            delayed_dc_removed_out <= 24'sd0;            
            
        end
        
        else begin
        
            pcm_ready_flag <= 1'b0;
        
            if (cic_ready_flag) begin
            
                pcm_signal_out <= dc_removed[23:8];
                
                delayed_cic_signal_in <= cic_signal_in;
                delayed_dc_removed_out <= dc_removed;
                
                pcm_ready_flag <= 1'b1;
                
            end
        
        
        end
    
    
    
    end
    
    
    
    
endmodule
