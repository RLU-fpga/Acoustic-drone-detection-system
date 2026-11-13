`timescale 1ns / 1ps


module mic_correlation(
    
    input wire clock_100m,
    input wire reset,
    
    input wire signed [15:0] pcm_signal_in,
    
    input wire pcm_ready_flag,
    
    output reg drone_detected_flag
    
    
    
    );
    
    
    // Top microphone detecs when the drone signal +-300Hz is present in the input
    
    // New PCM signal arrives every 368us = 1 / 2715Hz
    
    // 300Hz signal takes 3.33ms = 1 / 300Hz; 
    
    // Signal period will be complete in around 9 cycles = 3.33ms / 0.368ms
    
    // Two accumulators_0 & 8 keep the Value
    // Accumulator_8 multiplication pcm_signal_in * memory[9] means it will mainly multiple the same 300Hz - noise
    // Since noise will be different after 3.33ms it will be removed.
    
    // Drones make harmonics which aid in accumulator_9 Value to go up
    // Next Harmonic 600Hz will be at peaks and valeys at the same time, which adds up
    
    // If Accumulator_8 reaches more than half Value accumulator_0, after 256 cycles it will know if there is a drone
    
    // Later depending on the phase difference between memory0 and memory8, real drone signal could be determined for better cross corelation
    
    
    integer k; 
    
    reg [7:0] counter; //Sample will be taken for around 0.1 secconds; 0.1s / 368us = 271 cycles
    
    reg signed [15:0] memory [0:8]; // Signal Memory 9 steps for auto correlation
    
    reg signed [39:0] accumulator_0, accumulator_8; // Accumulators for auto correlation
    
    always @(posedge clock_100m) begin
    
        if (reset) begin
        
            counter <= 8'd0;
            
            memory[0] <= 16'sd0;
            memory[1] <= 16'sd0;
            memory[2] <= 16'sd0;
            memory[3] <= 16'sd0;
            memory[4] <= 16'sd0;
            memory[5] <= 16'sd0;
            memory[6] <= 16'sd0;
            memory[7] <= 16'sd0;
            memory[8] <= 16'sd0;
            
            accumulator_0 <= 40'd0;
            accumulator_8 <= 40'd0;
            drone_detected_flag <= 1'b0;
        
        end
        
        else begin
        
            if (pcm_ready_flag) begin
            
                memory[0] <= pcm_signal_in;
                
                for(k = 1; k <= 8; k = k + 1)
                    memory[k] <= memory[k-1];
                
                
                accumulator_0 <= accumulator_0 + (pcm_signal_in * pcm_signal_in);
                accumulator_8 <= accumulator_8 + (pcm_signal_in * memory[8]);
                
                counter <= 8'd1 + counter;
                
                if ((counter == 255) && (accumulator_8 > (accumulator_0 >>> 1))) begin
                
                    drone_detected_flag <= 1'b1;
                    
                    accumulator_0 <= 40'sd0;
                    accumulator_8 <= 40'sd0;
                
                end
                else if(counter == 255) begin
                
                    drone_detected_flag <= 1'b0;
                    
                    accumulator_0 <= 40'sd0;
                    accumulator_8 <= 40'sd0;
                    
                end
                
                
                
                
            end
            
        
        
        end
    
    
    end 
    
    
    
    
endmodule
