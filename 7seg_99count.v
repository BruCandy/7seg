module 7seg_100count (
    input        wire i_clk,
    input        wire i_rst,
    output [7:0] wire o_seg,
    output [3:0] wire dig
);

    parameter WAIT = 27_000_000 // tang nano 9kは27MHz
    reg [24:0]  r_wait = 0;
    reg [5:0]   r_cnt = 0;
    reg         r_seg1 = 11111100;
    reg         r_seg2 = 11111100;
    reg         r_seg3 = 11111100;

    wire [3:0] w_diw
    wire       w_ones;
    wire       w_tens;
    wire       w_hundreds;

    assign w_ones = r_cnt % 10;
    assign w_tens = (r_cnt / 10) % 10;
    assign w_hundreds = (r_cnt / 100) % 10;

    assign dig   = 4'b1110; // 1桁目に表示
    assign o_seg = r_seg;

    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            r_wait <= 0;
            r_cnt <= 0;
            r_seg <= 11111100;
        end else begin
            if (r_wait == WAIT-1) begin
                r_wait <= 0;
                r_cnt <= r_cnt + 1'b1;
            end else begin
                r_wait <= r_wait + 1'b1;
            end

            case (w_ones)
                0 : r_seg1 <= 8'b11111100;
                1 : r_seg1 <= 8'b01100000;
                2 : r_seg1 <= 8'b11011010;
                3 : r_seg1 <= 8'b11110010;
                4 : r_seg1 <= 8'b01100110;
                5 : r_seg1 <= 8'b10110110;
                6 : r_seg1 <= 8'b10111110;
                7 : r_seg1 <= 8'b11100000;
                8 : r_seg1 <= 8'b11111110;
                9 : r_seg1 <= 8'b11110110;
            endcase

            case (w_tens) 
                0 : r_seg2 <= 8'b11111100;
                1 : r_seg2 <= 8'b01100000;
                2 : r_seg2 <= 8'b11011010;
                3 : r_seg2 <= 8'b11110010;
                4 : r_seg2 <= 8'b01100110;
                5 : r_seg2 <= 8'b10110110;
                6 : r_seg2 <= 8'b10111110;
                7 : r_seg2 <= 8'b11100000;
                8 : r_seg2 <= 8'b11111110;
                9 : r_seg2 <= 8'b11110110;
            endcase

            case (w_hundreds) 
                0 : r_seg3 <= 8'b11111100;
                1 : r_seg3 <= 8'b01100000;
                2 : r_seg3 <= 8'b11011010;
                3 : r_seg3 <= 8'b11110010;
                4 : r_seg3 <= 8'b01100110;
                5 : r_seg3 <= 8'b10110110;
                6 : r_seg3 <= 8'b10111110;
                7 : r_seg3 <= 8'b11100000;
                8 : r_seg3 <= 8'b11111110;
                9 : r_seg3 <= 8'b11110110;
            endcase
        end
    end

endmodule



module timer (
    input  wire i_rst,
    input  wire i_clk,
    output wire o_overflow 
);

    parameter WAIT = 27_000; // 1ms間隔で出力
    reg [14:0] r_cnt = 0;
    reg        r_overflow = 0;

    assign o_overflow = r_overflow;

    always @(posedge i_clk or i_rst) begin
        if (i_rst) begin
            r_cnt <= 0;
            r_overflow <= 0;
        end else begin
            if (r_cnt == WAIT-1) begin
                r_cnt <= 0;
                r_overflow <= 1;
            end else begin
                r_cnt <= r_cnt + 1'b1;
                r_overflow <= 0;
            end
        end
    end

endmodule
