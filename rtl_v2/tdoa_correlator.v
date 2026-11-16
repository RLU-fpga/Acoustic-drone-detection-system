`timescale 1ns / 1ps

module tdoa_correlator(

    input wire clock_100m,
    input wire reset,
    input wire pcm_ready_flag,

    input wire drone_detected_flag,
    input wire signed [15:0] memory0,
    
    input wire signed [15:0] pcm_signal_in1,
    input wire signed [15:0] pcm_signal_in2,
    input wire signed [15:0] pcm_signal_in3,
    input wire signed [15:0] pcm_signal_in4,
    
    output reg [3:0] best_id1,
    output reg [3:0] best_id2,
    output reg [3:0] best_id3,
    output reg [3:0] best_id4
    
    
    );
    
        // There will be alot of mem channels doing multiplication
    // with DSP48E1 blocks, which zynq7020 has 220 off.
    
    // acc0 <= acc0 + (mic0mem[8] * mic1mem[0]);
    
    // acc8 <= acc8 + (mic0mem[8] * mic1mem[8]);
    
    // acc16 <= acc16 + (mic0mem[8] * mic1mem[16]);
    
    // They will count up for about 256 cycles, and will be compared which one was the highest
    
    // The winning numbers from mic0 - mic1; mic0 - mic2; mic0 - mic3; mic0 - mic4;
    // Will be sent to PS through AXI lite probably and calculated internally by the arm cores on metal.
    
    
    reg signed [15:0] memory1 [0:8];
    reg signed [39:0] accumulator_1 [0:8];
    
    reg signed [15:0] memory2 [0:8];
    reg signed [39:0] accumulator_2 [0:8];
    
    reg signed [15:0] memory3 [0:8];
    reg signed [39:0] accumulator_3 [0:8];
    
    reg signed [15:0] memory4 [0:8];
    reg signed [39:0] accumulator_4 [0:8];
    
    
    reg [7:0] counter; 
    integer k, i, z;
    
    reg comparing;
    reg [3:0] comporator_id;
    
    reg signed [39:0] best_value1;
    
    reg signed [39:0] best_value2;

    reg signed [39:0] best_value3;

    reg signed [39:0] best_value4;
    
    
    always @(posedge clock_100m) begin
    
        if (reset) begin
        
            for(z = 0; z <= 8; z = z + 1) begin
            
                accumulator_1[z] <= 40'sd0;
                accumulator_2[z] <= 40'sd0;
                accumulator_3[z] <= 40'sd0;
                accumulator_4[z] <= 40'sd0;
                
                best_value1 <= 40'sd0;
                best_id1 <= 4'd0;
                
                best_value2 <= 40'sd0;
                best_id2 <= 4'd0;
                
                best_value3 <= 40'sd0;
                best_id3 <= 4'd0;
                
                best_value4 <= 40'sd0;
                best_id4 <= 4'd0;
                
                comparing <= 1'b0;
                comporator_id <= 4'd0;
                counter <= 8'd0;
                
                
            end
        
        end
        else begin
        
            if (comparing) begin
            
                comporator_id <= comporator_id + 8'd1;
                
                accumulator_1[comporator_id] <= 40'sd0;
                accumulator_2[comporator_id] <= 40'sd0;
                accumulator_3[comporator_id] <= 40'sd0;
                accumulator_4[comporator_id] <= 40'sd0;
                
                if (accumulator_1[comporator_id] > best_value1) begin
                
                    best_value1 <= accumulator_1[comporator_id];
                    best_id1 <= comporator_id;
                
                end
                
                if (accumulator_2[comporator_id] > best_value2) begin
                
                    best_value2 <= accumulator_2[comporator_id];
                    best_id2 <= comporator_id;
                    
                end
                
                if (accumulator_3[comporator_id] > best_value3) begin
                
                    best_value3 <= accumulator_3[comporator_id];
                    best_id3 <= comporator_id;
                    
                end
                
                
                if (accumulator_4[comporator_id] > best_value4) begin
                
                    best_value4 <= accumulator_4[comporator_id];
                    best_id4 <= comporator_id;
                    
                end
                
                if (comporator_id == 4'd8) begin
                
                    
                    comparing <= 1'b0;
                    
                                    
                end
            
            end
            
            if (pcm_ready_flag && (drone_detected_flag != 1'b1)) begin
                
                    for (z = 0; z <= 8; z = z + 1) begin
                        
                        accumulator_1[z] <= 40'sd0;
                        accumulator_2[z] <= 40'sd0;
                        accumulator_3[z] <= 40'sd0;
                        accumulator_4[z] <= 40'sd0;
                        
                        counter <= 8'd0;
                        
                    end
                
                end
        
            if (pcm_ready_flag) begin
            
                memory1[0] <= pcm_signal_in1;
                memory2[0] <= pcm_signal_in2;
                memory3[0] <= pcm_signal_in3;
                memory4[0] <= pcm_signal_in4;
                
                counter <= counter + 8'd1;
                
                for (k = 1; k <= 8; k = k + 1) begin
                
                    memory1[k] <= memory1[k-1];
                    memory2[k] <= memory2[k-1];
                    memory3[k] <= memory3[k-1];
                    memory4[k] <= memory4[k-1]; 
                
                end
                
                for (i = 0; i <= 8; i = i + 1) begin
                
                    accumulator_1[i] <= accumulator_1[i] + (memory0 * memory1[i]);
                    accumulator_2[i] <= accumulator_2[i] + (memory0 * memory2[i]);
                    accumulator_3[i] <= accumulator_3[i] + (memory0 * memory3[i]);
                    accumulator_4[i] <= accumulator_4[i] + (memory0 * memory4[i]);
                    
                end
                
                if (drone_detected_flag && counter == 255) begin
                
                    comparing <= 1'b1;
                    comporator_id <= 8'd1;
                    
                    
                    best_value1 <= accumulator_1[0];
                    best_id1 <= 8'd0;
                    accumulator_1[0] <= 40'sd0;
                    
                    best_value2 <= accumulator_2[0];
                    best_id2 <= 8'd0;
                    accumulator_2[0] <= 40'sd0;
                    
                    best_value3 <= accumulator_3[0];
                    best_id3 <= 8'd0;
                    accumulator_3[0] <= 40'sd0;
                    
                    best_value4 <= accumulator_4[0];
                    best_id4 <= 8'd0;
                    accumulator_4[0] <= 40'sd0;
                    
                end
            
            
            end

        end
    
    
    
    
    end
    
    
    
    
       
endmodule
