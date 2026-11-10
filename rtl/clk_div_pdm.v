`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2026 10:17:31 PM
// Design Name: 
// Module Name: clk_div_pdm
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


module clk_div_pdm(

        input wire clk_100m, //Pagrindinis 100MHz laikrodis is zynq PS FCLK_CLK0
        input wire rst, // resetinimas pinas
        
        output reg pdm_clk_out, // Fizinis ~2.78 MHz clokas einanatis i adafruit 3482 pdm mikrofono clk inputa
        output reg pdm_ce // 1 takto impulsas clock enable vidinei fpga logikai ijungti

    );
    
    reg [5:0] cnt; // reikia skaiciuot nuo 0 iki 36 o vietos turim 0 63 :D 4:0 netinka nes overflowintu
    
    // 100 / 36 yra 2.77778MHz
    // nuo 0 iki 17 takto -> pdm clk out = 0
    // nuo 18 iki 35 takto -> pdm clk out = 1
    // abu vyksta 18 taktu.
    
    //Gaunamas Synchroninis Clock enable dizainas
    
    
    always @(posedge clk_100m) begin
        
        if (rst) begin
            
            cnt <= 6'd0;
            pdm_clk_out <= 1'b0;
            pdm_ce <= 1'b0;
        
        end
        else begin
            
            pdm_ce <= 1'b0; // Visada is pat pradziu clokas buna isjungtas
            
            if (cnt == 6'd17) begin //pakeliama mikrofono koja i teigema. mikrofonas mato TRUE vieneta 1
                
                cnt <= cnt + 6'd1; // cnt counteris tiesiog kuris visalaika kyla i virsu ir neapsikrauna
                pdm_clk_out <= 1'b1;
                           
            end
            
            else if (cnt == 6'd35) begin //po dar 18 taktu, pdm clk out tai mikrofono clk inputa nuleidziam iki nulio ir nunilinam counteri.
                
                cnt <= 6'd0;
                pdm_clk_out <= 1'b0;
            
            end
            
            else begin
                
                cnt <= cnt + 6'd1;
                
            end
            
            if (cnt == 6'd26) begin // kad isvengtume meto stabilumo, t.y. neiskios vertes ant mikrofono del visokiu talpumu ir induktyvumu ir kitu parazitu
            // tai palaukiam grynai puse laiko kol yra isijunges vienetukas ant mikrofono kad nuskaitytume jo koja, tokia kokia jinai yra tuo momentu o ne galbut tas ar anas
                pdm_ce <= 1'b1;
                
                // pdm_ce isvertus reiskia CIC valgyk bita dabar ir jis valgo, "-Atrodo logiska cia... - Tai taip nes logika aprasai", pokalbis tarp manes ir destytojaus
                
            end
          
            
        end
        
    
    
    
    end
    
    
    
endmodule
