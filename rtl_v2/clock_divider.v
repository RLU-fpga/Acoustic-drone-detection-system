`timescale 1ns / 1ps

module clock_divider(

        input wire clock_100m, // Main clock 100MHz
        input wire reset,
        
        output reg pdm_clock, //Pdm clock 2.78MHz
        output reg pdm_read_flag // Flag for CIC to read.
        
    );
    
    // 2.78MHz = 100MHz / 36 -- requirement of MP34DT01-M Mems PDM microphone
    // 36 Cycles need duty cycle of 50%
    // 18 Cycles pdm_clock set to high
    // 18 cycles pdm_clock set to low
    
    
    
    reg [5:0] counter; // 64 bit size, for counter 36 bit requirment  
    
    
    
    always @(posedge clock_100m) begin
    
        if (reset) begin // Reset signal resets values to zero
            
            pdm_clock <= 1'b0;
            pdm_read_flag <= 1'b0;
            counter <= 6'd0;
            
        end
        
        else begin
        
            pdm_read_flag <= 1'b0; //Pdm read flag set to zero
            
            counter <= counter + 6'd1; //Each cycle Counter increases by one digit
            
            if (counter == 6'd17) begin // After 18 cycles pdm_clock becomes High
            
                pdm_clock <= 1'b1;
                
            end
            
            else if (counter == 6'd35) begin // After 18 more cycles pdm_clock becomes Low
            
                pdm_clock <= 1'b0;
                
                counter <= 6'd0;
            
            end
            
            else if (counter == 6'd25) begin // Microphone has a min 18ns delay for T_en after Clock high signal
            
                pdm_read_flag <= 1'b1; // To avoid Meta_Stability, pdm_read_flag is delayed by 8 cycles (80ns > 18ns) after pdm_clock == 1 
            
            end
        
        
        end
        
    
    
    end
    
    
    
endmodule
