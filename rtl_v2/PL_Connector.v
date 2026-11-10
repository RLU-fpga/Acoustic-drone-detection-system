`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2026 12:55:41 AM
// Design Name: 
// Module Name: PL_Connector
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


module PL_Connector(

    input wire clock_100m // 100MHz main clock

    );
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Link between PL_connector and clock_divider
    
    clock_divider u_clock_divider (
        
        .clock_100m (clock_100m)
    
    );
    
    
    
endmodule
