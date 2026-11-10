`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: RLU-fpga
// Engineer: Rytis
// 
// Create Date: 10/21/2026 09:56:01 PM
// Design Name: geriausias_dizainas
// Module Name: drone_detector
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
            int1 <= int1 + din; //Cia nesuprantu dar reikes pasiskaityt
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
        
    
    
    
    
    
    
    
endmodule
