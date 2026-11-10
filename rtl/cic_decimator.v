`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2026 10:23:48 PM
// Design Name: 
// Module Name: cic_decimator
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


module cic_decimator(

    input wire clk, // clockas 2.8224MHz eis i mikrofono CLK Pino
    
    input wire pdm_ce, // NAUJAS SIGNALAS: 2.78 MHz impulsas kuris ateina is clk_div_pdm.v modulio
    
    input wire rst, // resetas
    input wire pdm_in, // 1-bito pdm signalas is mikrofono DAT Pino
    output reg signed [27:0] cic_out, //28 bitu isejimas
    output reg cic_valid //Bus signalas kas 512 taktu 5.5khz
    
    );
    wire signed [27:0] din = pdm_in ? 28'sd1 : -28'sd1; //klaustukas reiskiasi jei true false tai jei pdmin 1 tai true tai bus sd1 jei 0 tai -sd1
    reg signed [27:0] int1, int2, int3; //integratoriu akumuliatoriai nes CIC yra kaskadinis filtras
    
    //Integratoriai 2.8224MHz
    always @(posedge clk) begin
        if (rst) begin //jeigu rst ijungtas tai visi akumuliatoriai nunulinami vienu metu del <= zenklo (lygiagretu)
            int1 <= 28'sd0;
            int2 <= 28'sd0;
            int3 <= 28'sd0;
        end
        else if (pdm_ce) begin
            int1 <= int1 + din; // prasideda pdm signalo kaupimas, jie visi veikia lygegraciai ir kaupia iki 2 pakelta 28
            int2 <= int2 + int1;
            int3 <= int3 + int2;
        end
     end
     
     //decimacija, dalinsim signala is 512 kad gautume naikvisto dazni 2.75KHz Fdiskretizacijos bus apie 5.5KHz
     reg [8:0] dec_cnt; //counteris 2 pakelta 9 yra lygu 511 reiksmiu 
     wire dec_pulse = (dec_cnt == 9'd511) && pdm_ce; //Pulsas kuris suveiks kai counteris pasieks 511 skaiciu ir pdm_ce bus teigemas skaicius t.y. TRUE
     
     
     
     
     always @(posedge clk) begin
        if (rst) begin //jeigu viena eilute tai nebutina rasyt begin end, bet taip yra geriau kiek suprantu
            dec_cnt <= 9'd0;
        end
        else if (pdm_ce) begin // tas pats ir cia begin end normaliai apibrezia ribas
            dec_cnt <= dec_cnt + 9'd1; // kai registras overflowins 511 reiksmiu jis pats pataps 0
        end
     end
     
     
     
     //Comb filtras ir draugai
     
     reg signed [27:0] comb1, comb2; //Difrencijavimas
     reg signed [27:0] d_int3, d_comb1, d_comb2; //d reiskiasi delay, ir velinimas yra per 512 taktu
     
     always @(posedge clk) begin
        if (rst) begin //viska nunulinam kad butu svaru grazu
        
            comb1 <= 28'd0;
            comb2 <= 28'd0;
        
            cic_out <= 28'd0;
            d_comb1 <= 28'd0;
            d_comb2 <= 28'd0;
            d_int3 <= 28'd0;
        
            cic_valid <= 1'b0;
        
        end
        else begin
            cic_valid <= 1'b0; //Visa laika flagas off, nebent dec_pulse su pdm_ce gauna signala tada cic_valid tampa jau vienetukas 1 True
            
            if (dec_pulse) begin //suveikia kas 512 taktu apiberzta pagal decimacijos koda
                
                comb1 <= int3 - d_int3; //Dabartine verte atemama is praeitos vertes
                d_int3 <= int3; //Dabartine verte irasoma i praeita verte
                
                comb2 <= comb1 - d_comb1;
                d_comb1 <= comb1;
                
                cic_out <= comb2 - d_comb2; // Apskaiciuotas galutinis skirtumas uzrasomas tiesiai i isejima
                d_comb2 <= comb2;
                
                cic_valid <= 1'b1; //kai atsinaujina cic_out tai atsinauja ir cic_valid i vienetuka, ir kita takta jau bus nuliukas.
            
            end
        
        end
     
     
     
     end


    
    
endmodule
