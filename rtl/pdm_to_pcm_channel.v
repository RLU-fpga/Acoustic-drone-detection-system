`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2026 12:48:38 AM
// Design Name: 
// Module Name: pdm_to_pcm_channel
// Project Name: 
// Target Devices: 
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


module pdm_to_pcm_channel(
    
    input wire clk, // 100MHz FPGA clockas
    input wire rst, //Resetas viskam nunulint
    input wire pdm_in, // 1bit signalo srautas is mikrofono
    input wire pdm_ce, // 2.78Mhz clockas is clk_div_pdm modulio 
    
    output wire signed [15:0] pcm_out, //galutinis signalas 16bit garsas, kas 5.5KHz
    output wire pcm_valid // velevyte kad garsas pasiruoses
   

    );
    
    wire signed [27:0] w_cic_data; // CIC isejimas su dc blocker iejimus
    wire w_cic_valid; //cic valid velevyte    
    
    cic_decimator u_cic (
    
        .clk (clk), //.clk tai cic_decimator clk surisamas su pdm_to_pcm_channel clocku ir t.t. kitiem varijantam
        .pdm_ce (pdm_ce), // praleidziamas w_pdm_ce cloko failiukas
        .rst (rst),
        .pdm_in (pdm_in),
        .cic_out (w_cic_data), //cic_out data is cic_decimator sujungiam su w_cic_data esancia pdm_to_pcm_channeli.
        .cic_valid (w_cic_valid)
    
    );
    
    dc_blocker u_dc (
        
        .clk (clk), //.clk tai dc_blocker clk surisamas su pdm_to_pcm_channel clocku ir t.t. kitiem varijantam
        .rst (rst),
        .cic_in (w_cic_data),
        .cic_valid (w_cic_valid),
        .pcm_out (pcm_out), 
        .pcm_valid (pcm_valid)
    
    );
    
    
    
endmodule
