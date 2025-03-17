module count99 (
    input wire i_clk,
    input wire i_rst,
    output wire [7:0] o_seg,
    output wire [3:0] o_dig
);

    parameter WAIT = 27_000_000; // tang nano 9kは27MHz
    parameter BITS = 25;
    parameter MAX  = 99;
    parameter TIMER_WAIT = 27_000;

    reg [BITS-1:0]  r_wait = 0;
    reg [5:0]   r_cnt = 0;
    reg [7:0]   r_seg1 = 8'b11111100;
    reg [7:0]   r_seg2 = 8'b11111100;
    reg [1:0]   r_dig = 0;

    wire       w_rst;
    wire       w_overflow;
    wire [3:0] w_ones;
    wire [3:0] w_tens;

    timer #(
        .TIMER_WAIT(TIMER_WAIT)
    ) timer (
        .i_rst(w_rst),
        .i_clk(i_clk),
        .o_overflow(w_overflow)
    );

    assign w_rst  = ~ i_rst;
    assign w_ones = r_cnt % 10;
    assign w_tens = (r_cnt / 10) % 10;

    assign o_dig = r_dig ? 4'b1101 : 4'b1110;
    assign o_seg = r_dig ? r_seg2 : r_seg1;

    always @(posedge i_clk or posedge w_rst) begin
        if (w_rst) begin
            r_wait <= 0;
            r_cnt <= 0;
            r_seg1 <= 8'b11111100;
            r_seg2 <= 8'b11111100;
            r_dig <= 0;
        end else begin
            if (w_overflow) begin
                if (r_dig == 1) begin
                    r_dig <= 0;
                end else begin
                    r_dig <= 1;
                end
            end

            if (r_cnt == MAX+1) begin
                r_cnt <= 0;
            end else begin
                if (r_wait == WAIT-1) begin
                    r_wait <= 0;
                    r_cnt <= r_cnt + 1'b1;
                end else begin
                    r_wait <= r_wait + 1'b1;
                end
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
        end
    end

endmodule



module timer (
    input  wire i_rst,
    input  wire i_clk,
    output wire o_overflow 
);

    parameter TIMER_WAIT = 27_000; // 1ms間隔で出力

    reg [14:0] r_cnt = 0;
    reg        r_overflow = 0;

    assign o_overflow = r_overflow;

    always @(posedge i_clk) begin
        if (i_rst) begin
            r_cnt <= 0;
            r_overflow <= 0;
        end else begin
            if (r_cnt == TIMER_WAIT-1) begin
                r_cnt <= 0;
                r_overflow <= 1;
            end else begin
                r_cnt <= r_cnt + 1'b1;
                r_overflow <= 0;
            end
        end
    end

endmodule
