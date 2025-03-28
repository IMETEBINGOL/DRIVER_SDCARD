/*
MODULE BEHAVIOUR 
CS:
        ‾‾‾‾‾‾‾‾|                                                                       |‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
                |_______________________________________________________________________|

CLOCK:      |‾‾‾|    |‾‾‾|    |‾‾‾|    |‾‾‾|    |‾‾‾|    |‾‾‾|    |‾‾‾|    |‾‾‾|    |‾‾‾|    |‾‾‾|    |‾‾‾|    |‾‾‾|    |‾‾‾|    |‾‾‾|    |‾‾‾|    |‾‾‾|
        ____|   |____|   |____|   |____|   |____|   |____|   |____|   |____|   |____|   |____|   |____|   |____|   |____|   |____|   |____|   |____|   |_____________


SDI:
        ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|                          |‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
                                  |__________________________|

SDO:
        ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|        |‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|                 |‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
                         |________|                                   |_________________|

RD_EN:
                |‾‾‾‾‾‾‾‾|
        ________|        |___________________________________________________________________________________________________________________________________________
                DATARD = 0x7C
                DATAWR = 0xC7
*/

// ENG : IBRAHIM METE BINGOL 
// PROJECT : DRIVER_SDCARD
// AIM: THIS MODULE PROVIDE A SPI INTERFACE WTH CONTROL SIGNALs. DATA HANDLING MUST BE SET UP WTIH FIFOs
module spi_interface
#(
    parameter                                           PACKAGE_WIDTH           = 8        // PACKAGE WIDTH MUST BE THE POWER OF TWO 
)                   
(   
    // CLOCK AND RESET
    // ---                
    input                                               clk,
    input                                               rstb,
    // ---
    // DATA TRANSMIT AND RECEIVE FIFOs
    // ---
    output  reg                                         spi_fifo_rd_en,
    input       [PACKAGE_WIDTH-1:0]                     spi_fifo_rd_data,
    input                                               spi_fifo_rd_empty,
    output  reg                                         spi_fifo_wr_en,
    output  reg [PACKAGE_WIDTH-1:0]                     spi_fifo_wr_data,
    input                                               spi_fifo_wr_full,
    // ---
    // SPI PORT 
    // ---
    output  reg                                         spi_cs,
    input                                               spi_sdi,
    output  reg                                         spi_sdo
    // ---
);


// LOCAL PARAMETER 
// ---
localparam                                              HIGH        = 1'b1;
localparam                                              LOW         = 1'b0;
localparam                                              DRST        = 32'd0; 
// ---


// STATES
// ---
localparam                                              IDLE        = 0;
localparam                                              EXEC        = 1;
localparam                                              NUMSTATE    = 2;
// ---

// LOCAL VARIABLE 
// ---
reg     [$clog2(PACKAGE_WIDTH)-1:0]                     count;
wire                                                    count_en;
reg     [$clog2(NUMSTATE)-1:0]                          next_state;
reg     [$clog2(NUMSTATE)-1:0]                          state;
reg     [PACKAGE_WIDTH-2:0]                             write_reg;       
reg     [PACKAGE_WIDTH-2:0]                             read_reg;       
// ---


// LOGICAL DESIGN 
assign count_en                                         = (state == EXEC);
// ---
// *************** WRITE OPERATION ***************
always @(negedge clk or negedge rstb) 
begin
    if (!rstb)
    begin
        write_reg                                       <= DRST;
        spi_cs                                          <= HIGH;
        spi_sdo                                         <= HIGH;
    end
    else
    begin
        spi_fifo_rd_en                                  <= LOW;
        case (state)
            IDLE:
            begin
                write_reg                               <= DRST;
                spi_cs                                  <= HIGH;
                spi_sdo                                 <= HIGH;
                if (!spi_fifo_rd_empty)
                begin
                    spi_cs                              <= LOW;
                    spi_fifo_rd_en                      <= HIGH;
                end
            end
            EXEC:
            begin
                {spi_sdo, write_reg}                    <= {write_reg, 1'b1};
                if (~|count)
                begin
                    {spi_sdo, write_reg}                <= spi_fifo_rd_data;
                end
                if (&count)
                begin
                    spi_fifo_rd_en                      <= (spi_fifo_rd_empty) ? LOW : HIGH;
                    spi_cs                              <= (spi_fifo_rd_empty) ? HIGH : LOW;
                end
            end 
            default:
            begin
                write_reg                               <= DRST;
                spi_cs                                  <= HIGH;
                spi_sdo                                 <= HIGH;                
            end 
        endcase
    end
end
// *************** READ OPERATION ****************
always @(posedge clk or negedge rstb) 
begin
    if(!rstb)
    begin
        read_reg                                        <= DRST;
        spi_fifo_wr_data                                <= DRST;
        spi_fifo_wr_en                                  <= LOW;
    end
    else
    begin
        spi_fifo_wr_en                                  <= LOW;
        case (state)
            IDLE:
            begin
                spi_fifo_wr_data                        <= DRST;
            end 
            EXEC:
            begin
                read_reg                                <= {read_reg[PACKAGE_WIDTH-3:0], spi_sdi};
                if (&count)
                begin
                    spi_fifo_wr_en                      <= spi_fifo_wr_full ? LOW : HIGH;
                    spi_fifo_wr_data                    <= {read_reg, spi_sdi};
                end
            end
            default:
            begin
                read_reg                                <= DRST;
            end
        endcase
    end
end
// *************** STATES CONTROL ****************
always @(posedge clk)       // TRIGGER METHOD CAN BE RECONFIGURATED TO SHIFT STATE CHANGE AS THE HALF CYCLE
begin
    if (!rstb)
    begin
        state                                           <= IDLE;
    end
    else
    begin
        state                                           <= next_state;
    end
end
/*
                                                GO IF FIFO NOT EMPTY
                                            ↓-----------|
        [IDLE] ---------------------------> [EXEC] -----|
           ↑     GO IF FIFO NOT EMPTY                   |
           |--------------------------------------------|
                            GO IF FIFO EMPTY
*/
always @(*)
begin
    case (state)
        IDLE:       next_state                          = spi_fifo_rd_empty ? IDLE:EXEC;
        EXEC:       next_state                          = (&count) ? (spi_fifo_rd_empty ? IDLE:EXEC):EXEC;  
        default:    next_state                          = IDLE;
    endcase
end

// *************** COUNTER SPI *******************        
always @(posedge clk or negedge rstb) 
begin
    if (!rstb)
    begin
        count                                           <= DRST;
    end
    else
    begin
        if (count_en)
        begin
            count                                       <= count + 1;            
        end
        else
        begin
            count                                       <= DRST;
        end
    end
end
// ---
// END OF MODULE 
endmodule