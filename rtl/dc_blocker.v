`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2026 12:12:11 AM
// Design Name: 
// Module Name: dc_blocker
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


module dc_blocker(
    
    input wire clk, //clockas 2.8224MHz
    input wire rst, //restas viskas nusinulina
    input wire signed [27:0] cic_in, //cic_decimator faile suskaiciuota pcm verte
    input wire cic_valid, // pasako cic_decimator falga kada nauji skaiciai buvo iskepti
    
    output reg signed [15:0] pcm_out, // 16bit pcm garsas be dc dedamosios
    output reg pcm_valid // flagas kad pcm garsas gatovas keliaut toliau

    );
    
    wire signed [15:0] cic_scaled = cic_in[24:9]; // nujemami paskutiniai 8 bitai, ir paliekami MSB bitai nes LSB bitai yra tik papildomas triuksmas
    reg signed [23:0] dc_est; //dc_est -> dc_estimate tai registras kuris atsimena vidutini signalo lygi t.y. DC Offseta kuris bus isnaikintas
    
    always @(posedge clk) begin
    
        if (rst) begin //visos vertes nustatomos i nuliukus
        
        dc_est <= 24'sd0;
        pcm_out <= 16'sd0;
        pcm_valid <= 1'b0; 
        
        end
        else begin
        
        pcm_valid <= 1'b0;
        if (cic_valid) begin
            
            dc_est <= dc_est + ({{8{cic_scaled[15]}}, cic_scaled} - (dc_est >>> 8)); //{{8{cic_scaled[15]}}, cic_scaled} praplecia 16 bitu cic_scaled iki dc_est 24bitu kad abu butu galima sudet ir atema is dc_est / 256
            // pagal formule fc = (a * Fd) / 2pi gaunasi ribinis daznis kuris praleidzia viska auksciau ribinio t.y. auksto daznio filtras
            // fc = ((1/256) * 5500) / 6.28 = 3.4Hz tai DC offsetas ir visokie zemo daznio niuansai dingsta.
            // pats Dc_est veikia taip jeigu signalas svyruoja tarp 1100+ ir 1300+ tai jis pamato kad 1200 yra vidurkis ji atema ir gaunasi +- 100, cia gan protingai taip prasisukt galima.
            // o naudojami 2 kartotiniai skaiciai nes labai paprasta daugyba ir dalyba.
            
            pcm_out <= cic_scaled - dc_est[23:8]; // cic_scaled jau yra reikalingas man formatas MSB 16 bitu, o dc_est irgi pajemu tik MSB bitus ir gaunu pcm_out be pridetines itampos
            pcm_valid <= 1'b1; //Nustato velevyte kad pcm'as jau pasiruoses vygdyti savo sunkios pcmo misijos toliau i kodo giluma.
            
            end
        
        end
    
    
    end
    
    
    
    
endmodule
