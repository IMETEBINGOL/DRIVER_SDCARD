module spi_fifo 
#(
    parameter                           DEPTH               = 512,
    parameter                           WIDTH               = 8
) 
(   
    // CLOCK AND RESET
    // ---
    input                               clk,
    input                               rstb,
    // ---
    // FIFO CONTROL SIGNAL 
    // ---
    output  reg [WIDTH-1:0]             spi_fifo_rd_data,
    input                               spi_fifo_rd_en,
    output                              spi_fifo_rd_empty,
    input       [WIDTH-1:0]             spi_fifo_wr_data,
    input                               spi_fifo_wr_en,
    output                              spi_fifo_wr_full
    // ---                              
);


// LOCAL PARAMETER 
// ---
localparam                              HIGH    = 1'b1;
localparam                              LOW     = 1'b0;
localparam                              DRST    = 32'b0;
// ---


// STATE 
// ---
localparam                              IDLE            = 0;
localparam                              WRITE           = 1;
localparam                              READ            = 2;
localparam                              WRITEREAD       = 3;
localparam                              NUM_OF_STATE    = 4;
// ---


// LOCAL VARIABLE 
// ---
integer i;
reg     [WIDTH-1:0]                     buffer [0:DEPTH-1];
reg     [$clog2(DEPTH)-1:0]             wr_ptr;
reg     [$clog2(DEPTH)-1:0]             rd_ptr;
reg     [$clog2(DEPTH):0]               num_elem;
// ---


// LOGICAL DESIGN 
// ---
always @(posedge clk or negedge rstb) 
begin
    if (!rstb)
    begin
        for (i = 0; i < BUFFER_LENGTH; i = i + 1)
        begin
            buffer[i]                   <= DRST;
        end
        wr_ptr                          <=  DRST;
        rd_ptr                          <=  DRST;
        num_elem                        <=  DRST;
        spi_fifo_rd_data                <=  DRST;
    end
    else
    begin
        case ({spi_fifo_rd_en, spi_fifo_wr_en})
            IDLE:
            begin
                wr_ptr                  <= wr_ptr;
                rd_ptr                  <= rd_ptr;
                num_elem                <= num_elem;
            end
            WRITE:
            begin
                wr_ptr                  <= wr_ptr + 1;
                buffer[wr_ptr]          <= spi_fifo_wr_data;
                num_elem                <= num_elem + !full;
            end
            READ:
            begin
                rd_ptr                  <= rd_ptr + 1;
                spi_fifo_rd_data        <= buffer[rd_ptr];
                num_elem                <= num_elem - !empty;
            end 
            WRITEREAD:
            begin
                buffer[wr_ptr]          <= spi_fifo_wr_data;
                spi_fifo_rd_data        <= buffer[rd_ptr];
                wr_ptr                  <= wr_ptr + 1;
                rd_ptr                  <= rd_ptr + 1;
            end
            default:
            begin
                wr_ptr                  <= wr_ptr;
                rd_ptr                  <= rd_ptr;
                num_elem                <= num_elem; 
            end 
        endcase
    end
end
// ---


// PORT ASSIGMENT 
// ---
assign spi_fifo_rd_empty        = (num_elem == 0);
assign spi_fifo_wr_full         = (num_elem == DEPTH);
// ---
// END OF MODULE
endmodule