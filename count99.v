module count99 (
    input  wire       i_clk,
    input  wire       i_rst,
    output wire [7:0] o_seg,
    output wire [3:0] o_dig
);

    parameter WAIT       = 27_000_000; // tang nano 9kは27MHz
    parameter BITS       = 25;
    parameter MAX        = 99;
    parameter TIMER_WAIT = 27_000;

    reg [BITS-1:0]  r_wait = 0;
    reg [6:0]       r_cnt  = 0;
    reg             r_dig  = 0;
    reg [7:0]       r_seg  [0:9];

    wire       w_rst;
    wire       w_tick;
    wire [3:0] w_ones;
    wire [3:0] w_tens;

    assign w_rst  = ~ i_rst; // Tang Nano 9Kのボタンは負論理であるため
    assign w_ones = r_cnt % 10;
    assign w_tens = (r_cnt / 10) % 10;

    assign o_dig = w_rst ? 4'b1100 : 
                   r_dig ? 4'b1101 : 4'b1110;
    assign o_seg = r_dig ? r_seg[w_tens] : r_seg[w_ones];

    initial begin
        r_seg[0] = 8'b11111100;
        r_seg[1] = 8'b01100000;
        r_seg[2] = 8'b11011010;
        r_seg[3] = 8'b11110010;
        r_seg[4] = 8'b01100110;
        r_seg[5] = 8'b10110110;
        r_seg[6] = 8'b10111110;
        r_seg[7] = 8'b11100000;
        r_seg[8] = 8'b11111110;
        r_seg[9] = 8'b11110110;
    end

    timer #(
        .TIMER_WAIT(TIMER_WAIT)
    ) timer (
        .i_rst  (w_rst ),
        .i_clk  (i_clk ),
        .o_tick (w_tick)
    );

    always @(posedge i_clk or posedge w_rst) begin
        if (w_rst) begin
            r_wait <= 0;
            r_cnt  <= 0;
            r_dig  <= 0;
        end else begin
            if (w_tick) begin
                r_dig <= ~r_dig;
            end

            if (r_cnt == MAX+1) begin
                r_cnt <= 0;
            end else begin
                if (r_wait == WAIT-1) begin
                    r_wait <= 0;
                    r_cnt  <= r_cnt + 1'b1;
                end else begin
                    r_wait <= r_wait + 1'b1;
                end
            end
        end
    end

endmodule



module timer (
    input  wire i_rst,
    input  wire i_clk,
    output wire o_tick 
);

    parameter TIMER_WAIT = 27_000; // 1ms間隔で出力

    reg [14:0] r_cnt = 0;

    assign o_tick = (r_cnt == TIMER_WAIT-1);

    always @(posedge i_clk) begin
        if (i_rst) begin
            r_cnt  <= 0;
        end else begin
            if (r_cnt == TIMER_WAIT-1) begin
                r_cnt  <= 0;
            end else begin
                r_cnt  <= r_cnt + 1'b1;
            end
        end
    end

endmodule
