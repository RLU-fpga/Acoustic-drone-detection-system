`timescale 1ns / 1ps

module tdoa_correlator(

    input wire clock_100m,
    input wire reset,
    input wire pcm_ready_flag,

    input wire drone_detected_flag,
    input wire signed [15:0] memory0, // Memory from mic_correlation file for phase correlation
    
    input wire signed [15:0] pcm_signal_in, // Pcm signal from different microphones
    
    output reg [3:0] best_id, // Best memory ID from calculations, used for calculations.
    output reg best_id_flag
    
    
    );
    
    // Tdoa_correlator works by comparing memory0 (center microphone) with microphones on each side
    // It determines the best value by multiplying memory0 with pcm_signal_memory
    // Which one gets the highest score, gets sent to best_id into PS through AXI_lite bus
    
    // accumulator[i] <= accumulator[i] + (memory0 * memory[i]) 
    // Satisfies DSP48E1 slice configuration 48 bit accumulator and 25 bit * 18 bit memory multiplication
    
    // After multiplying there is (1 / 2715hz) / (1 / 100Mhz) = 36832 free cycles
    
    // In those free Cycles comparing starts comparing bits and in 80ns it finishes
    // Raises the best_id_flag to True so the PS knows that the best_id was found
    
    // The memory is constantly refreshed with the newest values
    // Accumulators are kept at 0
    
    // When drone_detected_flag returns 1 then calculations begin
    
    
    
    reg signed [15:0] memory [0:8];
    reg signed [39:0] accumulator [0:8];
    
    
    
    reg [7:0] counter; 
    integer k, i, z;
    
    reg comparing;
    reg [3:0] comporator_id;
    
    reg signed [39:0] best_value;
    
    
    
    always @(posedge clock_100m) begin
    
        if (reset) begin // Resets Values to zero
        
            for(z = 0; z <= 8; z = z + 1) begin
            
                accumulator[z] <= 40'sd0;
                
            end
                
                best_value <= 40'sd0;
                best_id <= 4'd0;
                
                comparing <= 1'b0;
                comporator_id <= 4'd0;
                counter <= 8'd0;
                best_id_flag <= 1'b0;
                
                
        
        end
        else begin
        
            if (comparing) begin // Compares accumulator values, and finds Best_ID
            
                comporator_id <= comporator_id + 8'd1;
                
                accumulator[comporator_id] <= 40'sd0;
                
                if (accumulator[comporator_id] > best_value) begin
                
                    best_value <= accumulator[comporator_id];
                    best_id <= comporator_id;
                
                    
                end
                
                if (comporator_id == 4'd8) begin
                
                    
                    comparing <= 1'b0;
                    best_id_flag <= 1'b1;
                    
                                    
                end
            
            end
            
            if (pcm_ready_flag && (drone_detected_flag == 1'b0)) begin 
                
                    for (z = 0; z <= 8; z = z + 1) begin // Drones not detected accumulator and counter 0
                        
                        accumulator[z] <= 40'sd0;
                        
                        counter <= 8'd0;
                        
                    end
                
                end
        
            if (pcm_ready_flag) begin
            
                memory[0] <= pcm_signal_in; // Constantly updating memory
                
                for (k = 1; k <= 8; k = k + 1) begin
                
                    memory[k] <= memory[k-1];
                
                end
                
                if (drone_detected_flag) begin // When drone detected then calculations happen
                
                    counter <= counter + 8'd1;
                    
                    for (i = 0; i <= 8; i = i + 1) begin
                
                        accumulator[i] <= accumulator[i] + (memory0 * memory[i]);
                    
                    end
                
                    if (counter == 255) begin // Once counter reaches maximum value it gives flag for comporator
                
                        comparing <= 1'b1;
                        comporator_id <= 8'd1;
                    
                    
                        best_value <= accumulator[0];
                        best_id <= 8'd0;
                        accumulator[0] <= 40'sd0;
                        best_id_flag <= 1'b0;
                    
                    end
                    
                end
            
            
            end

        end
    
    
    
    
    end
    
    
    
    
       
endmodule
