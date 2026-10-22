`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: RLU-fpga
// Engineer: Rytis
// 
// Create Date: 10/21/2026 09:56:01 PM
// Design Name: PDM-I-PCM
// Module Name: Konverteris
// Project Name: Akustine dronu aptikimo sistema
// Target Devices: aptikt dronus
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module drone_detector(
    input wire CLK,
    input wire RST,
    input wire pdm_in,
    output reg signed [15:0] pcm_clean,
    output reg signed [47:0] corr_out,
    output reg corr_valid

    );
    reg signed [27:0] din;
    
    always @(pdm_in) begin
        if (pdm_in == 1'b1)
            din = 1;
        else 
            din = -1;
    end
     
    reg signed [27:0] int1, int2, int3;
    
    
    always @(posedge CLK) begin
        if (RST == 1'b1) begin
            int1 <= 0;
            int2 <= 0;
            int3 <= 0;
            
        end else begin
            int1 <= int1 + din;
            int2 <= int2 + int1;
            int3 <= int3 + int2;
            
        end
    end
        
    reg [8:0] dec_cnt;
    wire dec_pulse = (dec_cnt == 9'd511);
    
    always @(posedge CLK) begin
        if(RST == 1'b1) begin
            dec_cnt <= 9'd0;
        end
        
        else begin
            if(dec_pulse) 
                dec_cnt <= 0;
            else
                dec_cnt <= dec_cnt + 1;
        end
    end
        
    //Registrai rezultatams    
    reg signed [27:0] comb1;
    reg signed [27:0] comb2;
    reg signed [27:0] comb3;
    
    //Registrai praejusioms reiksmems d_ delay
    reg signed [27:0] d_int3;
    reg signed [27:0] d_comb1;
    reg signed [27:0] d_comb2;
    
    reg cic_valid;
    
    always @(posedge CLK) begin
        if(RST == 1'b1) begin
            comb1 <= 0;
            comb2 <= 0;
            comb3 <= 0;
            d_int3 <= 0;
            d_comb1 <= 0;
            d_comb2 <= 0;
            cic_valid <= 1'b0;
        end else begin
            cic_valid <= 1'b0;
        end
        
        if (dec_pulse) begin
            
            
            comb1 <= int3 - d_int3;
            d_int3 <= int3;
            
            comb2 <= comb1 - d_comb1;
            d_comb1 <= comb1;
            
            comb3 <= comb2 - d_comb2;
            d_comb2 <= comb2;
            
            cic_valid <= 1'b1;
            
            
        end
    
    end
    
    
endmodule
