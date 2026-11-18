`timescale 1ns / 1ps

module tdoa_correlator(

    input wire clock_100m,
    input wire reset,
    input wire pcm_ready_flag,

    input wire drone_detected_flag,
    input wire signed [15:0] memory0,
    
    input wire signed [15:0] pcm_signal_in,
    
    output reg [3:0] best_id
    
    
    );
    
        // There will be alot of mem channels doing multiplication
    // with DSP48E1 blocks, which zynq7020 has 220 off.
    
    // acc0 <= acc0 + (mic0mem[8] * mic1mem[0]);
    
    // acc8 <= acc8 + (mic0mem[8] * mic1mem[8]);
    
    // acc16 <= acc16 + (mic0mem[8] * mic1mem[16]);
    
    // They will count up for about 256 cycles, and will be compared which one was the highest
    
    // The winning numbers from mic0 - mic1; mic0 - mic2; mic0 - mic3; mic0 - mic4;
    // Will be sent to PS through AXI lite probably and calculated internally by the arm cores on metal.
    
    
    reg signed [15:0] memory [0:8];
    reg signed [39:0] accumulator [0:8];
    
    
    
    reg [7:0] counter; 
    integer k, i, z;
    
    reg comparing;
    reg [3:0] comporator_id;
    
    reg signed [39:0] best_value;
    
    
    
    always @(posedge clock_100m) begin
    
        if (reset) begin
        
            for(z = 0; z <= 8; z = z + 1) begin
            
                accumulator[z] <= 40'sd0;
                
            end
                
                best_value <= 40'sd0;
                best_id <= 4'd0;
                
                comparing <= 1'b0;
                comporator_id <= 4'd0;
                counter <= 8'd0;
                
                
        
        end
        else begin
        
            if (comparing) begin
            
                comporator_id <= comporator_id + 8'd1;
                
                accumulator[comporator_id] <= 40'sd0;
                
                if (accumulator[comporator_id] > best_value) begin
                
                    best_value <= accumulator[comporator_id];
                    best_id <= comporator_id;
                
                    
                end
                
                if (comporator_id == 4'd8) begin
                
                    
                    comparing <= 1'b0;
                    
                                    
                end
            
            end
            
            if (pcm_ready_flag && (drone_detected_flag == 1'b0)) begin
                
                    for (z = 0; z <= 8; z = z + 1) begin
                        
                        accumulator[z] <= 40'sd0;
                        
                        counter <= 8'd0;
                        
                    end
                
                end
        
            if (pcm_ready_flag) begin
            
                memory[0] <= pcm_signal_in;
                
                for (k = 1; k <= 8; k = k + 1) begin
                
                    memory[k] <= memory[k-1];
                
                end
                
                if (drone_detected_flag) begin
                
                    counter <= counter + 8'd1;
                    
                    for (i = 0; i <= 8; i = i + 1) begin
                
                        accumulator[i] <= accumulator[i] + (memory0 * memory[i]);
                    
                    end
                
                    if (counter == 255) begin
                
                        comparing <= 1'b1;
                        comporator_id <= 8'd1;
                    
                    
                        best_value <= accumulator[0];
                        best_id <= 8'd0;
                        accumulator[0] <= 40'sd0;
                    
                    end
                    
                end
            
            
            end

        end
    
    
    
    
    end
    
    
    
    
       
endmodule
