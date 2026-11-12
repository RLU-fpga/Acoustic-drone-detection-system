`timescale 1ns / 1ps

module cic_decimator(

    input wire clock_100m, // 100MHz Main clock
    
    input wire pdm_read_flag, // Microphone ready flag
    
    input wire pdm_data_in, // Pdm_data from microphone pin
    
    input wire reset,
    
    output reg signed [23:0] cic_signal_out,
    
    output reg cic_ready_flag 



    );
    
    // F_drone_3rd harmonic = 900Hz
    // Speed of sound V_c= 343 m/s; Velocity of observer V_o = 0 m/s;
    // Maximum Velocity of drone V_s = 200 km/h = 55.6 m/s 
    // Doppler effect => F_doppler = F_drone * ((V_c + V_o) / V_c - V_s))
    // F_doppler = 1075Hz
    
    // Cascade number N = 3
    // Decimation coefficient R = 1024
    // Differential Delay M = 1
    
    // F_sampling = pdm_clock / R = 2.78MHz / 1024 = 2714 Hz
    // F_nyquist treshold = F_sampling / 2
    // F_nyquist > F_doppler; F_doppler headroom =  26.23% 
    
    // Integrator bit value = B_input + B_growth + Signed_bit; So integrator doesn't overflow
    // B_growth = [log_2 (RM)^N] = log_2 (1024 * 1) ^ 3 = 10 * 3 = 30 bits
    
    // Integrator bit_value = 1 + 30 + 1 = 32 bits => signed [31:0] integrator1...
    
    
    reg signed [31:0] integrator1, integrator2, integrator3; //Integration accumulators -- integrator1 bit value is correct, others can be optimized?
    
    reg signed [31:0] decimator_comb1, decimator_comb2; // Decimators -- Bit value needs to be calculated for higher optimization
    
    reg signed [31:0] delayed_integrator3, delayed_decimator_comb1, delayed_decimator_comb2; // Delayed values for decimation
    
    reg [9:0] counter; // R = 1024
    
    wire signed [31:0] pdm_bipolar = pdm_data_in ? 32'sd1 : -32'sd1; // Asign +1 or -1 value for integration
   
    wire signed [31:0] comb3_diff = decimator_comb2 - delayed_decimator_comb2; // Subtraction before cutting off LSB bits turning the signal into 16bit
    
    always @(posedge clock_100m) begin
    
    
        if (reset) begin
        
            integrator1 <= 32'sd0;
            integrator2 <= 32'sd0;
            integrator3 <= 32'sd0;
            
            decimator_comb1 <= 32'sd0;
            decimator_comb2 <= 32'sd0;
            
            delayed_integrator3 <= 32'sd0;
            delayed_decimator_comb1 <= 32'sd0;
            delayed_decimator_comb2 <= 32'sd0;
            
            cic_signal_out <= 24'sd0;
            cic_ready_flag <= 1'b0;
            
            counter <= 10'd0;
        
        end
        
        
        //Integration
        else begin
            
            cic_ready_flag <= 1'b0;        
        
            if (pdm_read_flag) begin

                integrator1 <= integrator1 + pdm_bipolar;
                integrator2 <= integrator2 + integrator1;
                integrator3 <= integrator3 + integrator2;
            
                counter <= counter + 10'd1;
            
            end
        
        
        
        
            //Comb decimation
            if (counter == 1023 && pdm_read_flag) begin // counter == R 1024 Decimation coefficient
        
                decimator_comb1 <= integrator3 - delayed_integrator3;
                delayed_integrator3 <= integrator3;
                
                decimator_comb2 <= decimator_comb1 - delayed_decimator_comb1;
                delayed_decimator_comb1 <= decimator_comb1;
            
            
                cic_signal_out <= comb3_diff[31:8]; // LSB bits are removed to get clean 24Bit CIC signal
                delayed_decimator_comb2 <= decimator_comb2;
                
                cic_ready_flag <= 1'b1;
            
            
            
            
        
            end
        
        end
    
    end
    
    
    
    
    
endmodule
