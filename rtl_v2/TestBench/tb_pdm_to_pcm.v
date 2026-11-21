`timescale 1ns / 1ps

module tb_pdm_to_pcm();

    reg clock_100m = 0;
    reg pdm_read_flag = 0;
    reg pdm_data_in = 0;
    reg reset = 0;
    
    wire signed [15:0] pcm_signal_out;
    wire pcm_ready_flag;
    
    always #5 clock_100m = ~clock_100m;
    
    pdm_to_pcm uut (
    
    .clock_100m (clock_100m),
    .pdm_read_flag (pdm_read_flag),
    .pdm_data_in (pdm_data_in),
    .reset (reset),
    
    .pcm_signal_out (pcm_signal_out),
    .pcm_ready_flag (pcm_ready_flag)
    
    
    );
    
    reg pdm_mem [0:149999]; // Larger sample size is needed since Dc_blocker Takes longer to stabilize dc offset
    integer i, out_file;
    
    
    initial begin
    
        $readmemb("/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/scripts/DataFiles/pdm_to_pcm_bits.txt", pdm_mem);
        out_file = $fopen("/home/rytis/Documents/GitHub/Acoustic-drone-detection-system/scripts/DataFiles/pdm_to_pcm_output.txt", "w");
        
        reset = 1;
        #100;
        reset = 0;
        #50;
        
        for (i = 0; i < 150000; i = i + 1) begin
        
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
    
        if (pcm_ready_flag) begin
        
            $fwrite (out_file, "%d\n", pcm_signal_out);
        
        end
    
    end
    
    
    

endmodule
