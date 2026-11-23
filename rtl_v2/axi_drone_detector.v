`timescale 1ns / 1ps

module axi_drone_detector(
    
    // External pins for microphones
    input wire [4:0] pdm_data_in,
    
    (* X_INTERFACE_IGNORE = "true" *)
    output wire pdm_clock,
    
    // AXI4-LITE clock and active low reset
    input wire S_AXI_ACLK,
    input wire S_AXI_ARESETN,
    
    // Write Adress (AW) channel
    input wire [3:0] S_AXI_AWADDR,
    input wire S_AXI_AWVALID,
    output wire S_AXI_AWREADY,
    
    // Write Data (W) channel
    input wire [31:0] S_AXI_WDATA,
    input wire [3:0] S_AXI_WSTRB,
    input wire S_AXI_WVALID,
    output wire S_AXI_WREADY,
    
    // Write Response (B) channel
    output wire [1:0] S_AXI_BRESP,
    output wire S_AXI_BVALID,
    input wire S_AXI_BREADY,
    
    // Read Adress (AR) channel
    input wire [3:0] S_AXI_ARADDR,
    input wire S_AXI_ARVALID,
    output wire S_AXI_ARREADY,
    
    // Read Data (R) channel
    output wire [31:0] S_AXI_RDATA,
    output wire [1:0] S_AXI_RRESP,
    output wire S_AXI_RVALID,
    input wire S_AXI_RREADY

    

    );

    
    wire w_drone_detected_flag;
    wire [3:0] w_best_id1;
    wire [3:0] w_best_id2;
    wire [3:0] w_best_id3;
    wire [3:0] w_best_id4;
    
    wire w_best_id_flag1;
    wire w_best_id_flag2;
    wire w_best_id_flag3;
    wire w_best_id_flag4;
    
    PL_Connector u_PL_Connector(
    
        .clock_100m (S_AXI_ACLK),
        .reset (~S_AXI_ARESETN),
        .pdm_data_in (pdm_data_in),
        .pdm_clock (pdm_clock),
        .drone_detected_flag (w_drone_detected_flag),
        .best_id1 (w_best_id1),
        .best_id2 (w_best_id2),
        .best_id3 (w_best_id3),
        .best_id4 (w_best_id4),
        
        .best_id_flag1 (w_best_id_flag1),
        .best_id_flag2 (w_best_id_flag2),
        .best_id_flag3 (w_best_id_flag3),
        .best_id_flag4 (w_best_id_flag4)
        
        
    );
    
    // Adress Read & Read Data configuration
    
    reg axi_arready;
    reg axi_rvalid;
    reg [1:0] axi_rresp;
    reg [31:0] axi_rdata;
    
    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RVALID = axi_rvalid;
    assign S_AXI_RRESP = axi_rresp;
    assign S_AXI_RDATA = axi_rdata;
    
    wire [31:0] pl_status_reg;
    assign pl_status_reg = {
    
        11'd0, //[31:21] Reserve
        w_drone_detected_flag, // [20]
        w_best_id_flag4, // [19]
        w_best_id_flag3, // [18]
        w_best_id_flag2, // [17]
        w_best_id_flag1, // [16]
        w_best_id4, // [15:12]
        w_best_id3, // [11:8]
        w_best_id2, // [7:4]
        w_best_id1 // [3:0]
    
    };
    
    
    
    
    
    always @(posedge S_AXI_ACLK) begin
    
        if (!S_AXI_ARESETN) begin // Active LOW reset (0 == reset)
        
            axi_arready <= 1'b0;
            axi_rvalid <= 1'b0;
            axi_rresp <= 2'b00;
            axi_rdata <= 32'd0;
                   
        end
        else begin
        
            if (!axi_arready && S_AXI_ARVALID && !axi_rvalid) begin
            
                axi_arready <= 1'b1;
            
            end
            else begin
            
                axi_arready <= 1'b0;
                
            end
            
            if (axi_arready && S_AXI_ARVALID) begin
            
                axi_rvalid <= 1'b1;
                axi_rresp <= 2'b00;
                
                case (S_AXI_ARADDR[3:2])
                
                    2'd0: axi_rdata <= pl_status_reg;
                    2'd1: axi_rdata <= 32'h1234_ABCD;
                    default: axi_rdata <= 32'd0;
                
                endcase
            
            
            end
            else if (axi_rvalid && S_AXI_RREADY) begin
            
                axi_rvalid <= 1'b0;
            
            end
        
        
        end
    
    
    end
    
    
    // Adress Write & Write Data configuration
    
    reg axi_awready;
    reg axi_wready;
    reg axi_bvalid;
    reg [1:0] axi_bresp;
    
    assign S_AXI_AWREADY = axi_awready;
    assign S_AXI_WREADY = axi_wready;
    assign S_AXI_BVALID = axi_bvalid;
    assign S_AXI_BRESP = axi_bresp;
    
    always @(posedge S_AXI_ACLK) begin
    
        if (!S_AXI_ARESETN) begin
        
            axi_awready <= 1'b0;
            axi_wready <= 1'b0;
            axi_bvalid <= 1'b0;
            axi_bresp <= 2'b00;
        
        end
        else begin
        
            if (!axi_awready && S_AXI_AWVALID && S_AXI_WVALID && !axi_bvalid) begin
            
                axi_awready <= 1'b1;
                axi_wready <= 1'b1;
            
            end
            else begin
            
                axi_awready <= 1'b0;
                axi_wready <= 1'b0;
                
            end
                
            if (axi_awready && S_AXI_AWVALID && axi_wready && S_AXI_WVALID) begin
            
                axi_bvalid <= 1'b1;
                axi_bresp <= 2'b00;
            
            end
            else if (axi_bvalid && S_AXI_BREADY) begin
            
                axi_bvalid <= 1'b0;
            
            end
            
            
        
        end
                
        
    
    
    end
    
    
    
    
    
    
    
    
    
    
    
    
        
    
    
endmodule
