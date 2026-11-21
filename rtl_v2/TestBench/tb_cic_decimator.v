`timescale 1ns / 1ps

module tb_cic_decimator();

    reg clock_100m = 0;
    reg pdm_read_flag = 0;
    reg pdm_data_in = 0;
    reg reset = 1;
    
    wire signed [23:0] cic_signal_out;
    wire cic_ready_flag;
    
    always #5 clock_100m = ~clock_100m;
    
    cic_decimator uut (
    
        .clock_100m (clock_100m),
        .pdm_read_flag (pdm_read_flag),
        .pdm_data_in (pdm_data_in),
        .reset (reset),
        .cic_signal_out (cic_signal_out),
        .cic_ready_flag (cic_ready_flag)
    
    );
    
    reg pdm_mem [0:39999];
    integer i, out_file;
    
    // Python script "generate_pdm.py" generates a Golden Signal called "pdm_input.txt"
    
    // Then tb_cic_decimator.v is started, it takes the signal the .py generated and applies cic decimation
    
    // Once it finishes it creates a diagram in verilog, and a new file called "cic_output.txt"
    
    // "cic_output.txt" is ran through python script "check_cic.py" to double check if the "cic_decimator.v"
    // Did it correctly
    
    initial begin 
    
        $readmemb("/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/scripts/DataFiles/pdm_input.txt", pdm_mem);
        out_file = $fopen("/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/scripts/DataFiles/cic_output.txt", "w");
        
        reset = 1;
        #100;
        reset = 0;
        #50;
        
        for (i = 0; i < 40000; i = i + 1) begin
        
            @(posedge clock_100m);
            pdm_data_in <= pdm_mem[i];
            pdm_read_flag <= 1'b1;
            
            @(posedge clock_100m);
            pdm_read_flag <= 1'b0;
            
            repeat(2) @(posedge clock_100m);
        
        end
        
        $fclose (out_file);
        #100;
        $finish;
        
    end
    
    always @(posedge clock_100m) begin
    
        if (cic_ready_flag) begin
        
            $fwrite (out_file, "%d\n", cic_signal_out);
        
        end
        
    
    end
    
    

endmodule
