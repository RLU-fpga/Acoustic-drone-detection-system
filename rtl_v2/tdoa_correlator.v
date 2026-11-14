`timescale 1ns / 1ps

module tdoa_correlator(




    );
    
    
    // There will be alot of mem channels doing multiplication
    // with DSP48E1 blocks, which zynq7020 has 220 off.
    
    // acc0 <= acc0 + (mic0mem[8] * mic1mem[0]);
    
    // acc8 <= acc8 + (mic0mem[8] * mic1mem[8]);
    
    // acc16 <= acc16 + (mic0mem[8] * mic1mem[16]);
    
    // They will count up for about 256 cycles, and will be compared which one was the highest
    
    // The winning numbers from mic0 - mic1; mic0 - mic2; mic0 - mic3; mic0 - mic4;
    // Will be sent to PS through AXI lite probably and calculated internally by the arm cores on metal. 
    
    
       
endmodule
