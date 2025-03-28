`timescale 1ns/1ps
module spi_interface_tb
(

);

`include "system_parameter.vh"



// LOCAL PARAMETER
// ---
localparam                                      HIGH                    = 1'b1;
localparam                                      LOW                     = 1'b0;
localparam                                      DRST                    = 32'd0;
localparam                                      SECOND_IN_NANOSECOND    = 1_000_000_000;
localparam                                      CLK_FREQUENCY           = 100_000_000;
localparam                                      CLK_PERIOD              = SECOND_IN_NANOSECOND/CLK_FREQUENCY;
// ---

// CLOCK GENERATION
wire                                            clk;
// ---
clock_generation_sim #(
    .CLK_1_FREQUENCY                            (CLK_FREQUENCY),
    .CLK_1_INITIALIZING_DELAY                   (0),
    .CLK_1_PHASE                                (0)
) 
CLOCK_GENERATION
(
    .clk_out_1                                  (clk)
);
// ---

// RESET GENERATION 
reg     rstb                                    = LOW;
// ---
initial
begin
    rstb                                        = LOW;
    #(10*CLK_PERIOD);
    rstb                                        = HIGH;
end
// ---

// UUT INSTANTATION
reg                                             spi_fifo_rd_empty;
reg     [SPI_SPI_INTERFACE_PACKAGE_WIDTH-1:0]   spi_fifo_rd_data;
wire                                            spi_fifo_rd_en;
wire                                            spi_fifo_wr_en;
wire    [SPI_SPI_INTERFACE_PACKAGE_WIDTH-1:0]   spi_fifo_wr_data;
reg                                             spi_fifo_wr_full;
wire                                            spi_cs;
wire                                            spi_sdo;
reg                                             spi_sdi;
// ---
spi_interface #(
    .PACKAGE_WIDTH                              (SPI_SPI_INTERFACE_PACKAGE_WIDTH)
) 
UUT 
(
    .clk                                        (clk),
    .rstb                                       (rstb),
    .spi_fifo_rd_en                             (spi_fifo_rd_en),
    .spi_fifo_rd_data                           (spi_fifo_rd_data),
    .spi_fifo_rd_empty                          (spi_fifo_rd_empty),
    .spi_fifo_wr_en                             (spi_fifo_wr_en),
    .spi_fifo_wr_data                           (spi_fifo_wr_data),
    .spi_fifo_wr_full                           (spi_fifo_wr_full),
    .spi_cs                                     (spi_cs),
    .spi_sdi                                    (spi_sdi),
    .spi_sdo                                    (spi_sdo)
);
// ---

initial
begin
    spi_fifo_rd_empty                           = HIGH;
    spi_fifo_rd_data                            = DRST;
    spi_fifo_wr_full                            = LOW;
    spi_sdi                                     = HIGH;
    @(posedge rstb)
    spi_fifo_rd_empty                           = HIGH;
    spi_fifo_rd_data                            = DRST;
    spi_fifo_wr_full                            = LOW;
    spi_sdi                                     = HIGH;
    repeat (100);                               // 100 clock cycle wait 
    begin
        @(posedge clk);
    end
    spi_fifo_rd_empty                           = LOW;
    @(posedge spi_fifo_rd_en);
    spi_fifo_rd_data                            = 8'h7C;    // TEST DATA INPUT
    @(negedge clk);
    spi_fifo_rd_empty                           = HIGH;
    spi_sdi                                     = HIGH;
    @(negedge clk);
    spi_sdi                                     = HIGH;
    @(negedge clk);
    spi_sdi                                     = LOW;
    @(negedge clk);
    spi_sdi                                     = LOW;
    @(negedge clk);
    spi_sdi                                     = LOW;
    @(negedge clk);
    spi_sdi                                     = HIGH;
    @(negedge clk);
    spi_sdi                                     = HIGH;
    @(negedge clk);
    spi_sdi                                     = HIGH;
    @(posedge spi_fifo_wr_en);
    if (spi_fifo_wr_data == 8'hC7)
    begin
        $display("TEST PASSSED.");
    end
    else
    begin
        $display("TEST FAILED.");
    end
    $finish;
end
endmodule