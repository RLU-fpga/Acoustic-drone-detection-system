`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2026 08:41:23 PM
// Design Name: 
// Module Name: drone_sonar_core
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


module drone_sonar_core(
        
        input wire  clk_100m,
        input wire rst,
        input [4:0] pdm_pins, //sukuria penkis skiritngus pdm in inputus kad butu sujungti su generuotais MIC_CH vietoje kur parasyta pdm_pins[i]
        output wire pdm_clk_out, // Iseina i mikrofonu CLK kojytes
        
        
        output wire drone_detected,
        
        output wire signed [7:0] lag_01, //fiksuojama kokiu laiko skirtumu i mikrofonus atejo garsas
        output wire signed [7:0] lag_02, // Yra tik 4 lagai, nes penktas signalas bus naudojamas kaip atskaitos taskas.
        output wire signed [7:0] lag_03, // tikrinama bus kiek laiko veluoja visi keturi mikrofonai palyginus su 0 mikrofonu etalonu,
        output wire signed [7:0] lag_04
        
    );
    
    wire w_pdm_ce; // vidinis 2.78MHz impulsas
    
    // Laikrodzio daliklio modulis
    
    clk_div_pdm u_clk_div (
    
        .clk_100m (clk_100m),
        .rst (rst),
        .pdm_clk_out (pdm_clk_out),
        .pdm_ce (w_pdm_ce)
    
    );
    
    
    
    // 5 Mikrofonu sukuriamas masyvas NAUJA pridetas w_pdm_ce
    
    
    
    wire signed [15:0] pcm_clean [0:4]; //pcm clean tai sukuria 5 apdirbtus outputus kurie turi 16 bit informacijos
    
    wire pcm_val [0:4]; // [x:y] po kintamojo apraso kiek yra tokiu masyvu, o pries kintamaji [x:y] Kiek bitu turi tokia juosta. 
    
    genvar i; //sukuriam kintamaji pagal kuri vivado copy pastins koda
    generate // cia vyks copy pastinimas
        for (i = 0; i < 5; i = i + 1) begin : MIC_CH // MIC_CH pataps MIC_CH[i] ir taip gaunasi 5 skirtingi kanalai be kompiliavimo
            pdm_to_pcm_channel u_channel ( // aprasomas dar vienas U tai mikruskes typo blokas. Ju bus padaryti penki, nes i eis nuo 0 iki 4
                
                .clk (clk_100m),
                .rst (rst),
                .pdm_in (pdm_pins[i]),
                .pdm_ce (w_pdm_ce),
                .pcm_out (pcm_clean[i]),//I raidytes leidzia priskirt MC_CH[i] pcm_out jiem skirtingus [i] kintamuosius 
                .pcm_valid (pcm_val[i])
            );
        end
    endgenerate
    
    
endmodule
