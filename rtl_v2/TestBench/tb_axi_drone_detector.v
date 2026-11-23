`timescale 1ns / 1ps

module tb_axi_drone_detector();
    
    reg [4:0] pdm_data_in = 5'b00000;
    wire pdm_clock;
    
    reg S_AXI_ACLK = 0;
    reg S_AXI_ARESETN = 0;
    
    reg [3:0] S_AXI_AWADDR = 4'b0000;
    reg S_AXI_AWVALID = 0;
    wire S_AXI_AWREADY;
    
    reg [31:0] S_AXI_WDATA = 32'd0;
    reg [3:0] S_AXI_WSTRB = 4'b0000;
    reg S_AXI_WVALID = 0;
    wire S_AXI_WREADY;
    
    wire [1:0] S_AXI_BRESP;
    wire S_AXI_BVALID;
    reg S_AXI_BREADY = 0;
    
    reg [3:0] S_AXI_ARADDR = 4'b0000;
    reg S_AXI_ARVALID = 0;
    wire S_AXI_ARREADY;
    
    wire [31:0] S_AXI_RDATA;
    wire [1:0] S_AXI_RRESP;
    wire S_AXI_RVALID;
    reg S_AXI_RREADY = 0; 
    
    always #5 S_AXI_ACLK = ~S_AXI_ACLK;
    
    axi_drone_detector uut (
        
        .pdm_data_in (pdm_data_in),
        .pdm_clock (pdm_clock),
        .S_AXI_ACLK (S_AXI_ACLK),
        .S_AXI_ARESETN (S_AXI_ARESETN),
        .S_AXI_AWADDR (S_AXI_AWADDR),
        .S_AXI_AWVALID (S_AXI_AWVALID),
        .S_AXI_AWREADY (S_AXI_AWREADY),
        .S_AXI_WDATA (S_AXI_WDATA),
        .S_AXI_WSTRB (S_AXI_WSTRB),
        .S_AXI_WVALID (S_AXI_WVALID),
        .S_AXI_WREADY (S_AXI_WREADY),
        .S_AXI_BRESP (S_AXI_BRESP),
        .S_AXI_BVALID (S_AXI_BVALID),
        .S_AXI_BREADY (S_AXI_BREADY),
        .S_AXI_ARADDR (S_AXI_ARADDR), 
        .S_AXI_ARVALID (S_AXI_ARVALID),
        .S_AXI_ARREADY (S_AXI_ARREADY),
        .S_AXI_RDATA (S_AXI_RDATA),
        .S_AXI_RRESP (S_AXI_RRESP), 
        .S_AXI_RVALID (S_AXI_RVALID),
        .S_AXI_RREADY (S_AXI_RREADY)
    
    
    );
    
    initial begin
    
        S_AXI_ARESETN <= 1'b0;
        #100;
        S_AXI_ARESETN <= 1'b1;
        #50;
        
        
    
        @(posedge S_AXI_ACLK); // First test: Reading from adress 0x04 Value expected (32'h1234_ABCD)
        
        S_AXI_ARADDR <= 4'h4;
        S_AXI_ARVALID <= 1'b1;
        S_AXI_RREADY <= 1'b1;
        
        wait (S_AXI_ARREADY == 1'b1);
        
        @(posedge S_AXI_ACLK);
        S_AXI_ARVALID <= 1'b0;
        
        wait (S_AXI_RVALID == 1'b1);
        
        @(posedge S_AXI_ACLK);
        $display("Read from 0x04: 0x%h", S_AXI_RDATA);
        S_AXI_RREADY <= 1'b0;
        
        #50;
        
        @(posedge S_AXI_ACLK); // Second test: Reading from adress 0x00 Value expected 32'd0; because no pdm signals are applied.
        S_AXI_ARADDR <= 4'h0;
        S_AXI_ARVALID <= 1'b1;
        S_AXI_RREADY <= 1'b1;
        
        wait (S_AXI_ARREADY == 1'b1);
        
        
        @(posedge S_AXI_ACLK);
        S_AXI_ARVALID <= 1'b0;
        
        wait (S_AXI_RVALID == 1'b1)
        
        @(posedge S_AXI_ACLK);
        $display("Read from 0x00: 0x%h", S_AXI_RDATA);
        S_AXI_RREADY <= 1'b0;
        
        #50;

        @(posedge S_AXI_ACLK); // Third test: Writing data to PL
        S_AXI_AWADDR <= 4'h0;
        S_AXI_AWVALID <= 1'b1;
        S_AXI_WDATA <= 32'hDEAD_BEEF;
        S_AXI_WSTRB <= 4'b1111;
        S_AXI_WVALID <= 1'b1;
        S_AXI_BREADY <= 1'b1;

        wait (S_AXI_AWREADY && S_AXI_WREADY);
        @(posedge S_AXI_ACLK);
        S_AXI_AWVALID <= 1'b0;
        S_AXI_WVALID <= 1'b0;

        wait (S_AXI_BVALID == 1'b1); 
        @(posedge S_AXI_ACLK);
        $display("BRESP: %b", S_AXI_BRESP);
        S_AXI_BREADY  <= 1'b0;
        
        
        
        
        
        
    
    
    end

endmodule
