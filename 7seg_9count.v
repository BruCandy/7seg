module 7seg_9count (
    input        wire i_clk,
    input        wire i_rst,
    output [7:0] wire o_seg,
    output [3:0] wire dig
);

    parameter WAIT = 27_000_000; // tang nano 9kは27MHz
    parameter MAX = 10;
    reg [24:0]  r_wait = 0;
    reg [3:0]   r_cnt = 0;
    reg [7:0]   r_seg = 8'b11111100;

    assign dig   = 4'b1110; // 1桁目に表示
    assign o_seg = r_seg;

    always @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            r_wait <= 0;
            r_cnt <= 0;
            r_seg <= 8'b11111100;
        end else begin
            if (r_cnt == MAX) begin
                r_cnt <= 0;
            end else begin
                if (r_wait == WAIT-1) begin
                    r_wait <= 0;
                    r_cnt <= r_cnt + 1'b1;
                end else begin
                    r_wait <= r_wait + 1'b1;
                end

                case (r_cnt) 
                    0 : r_seg <= 8'b11111100;
                    1 : r_seg <= 8'b01100000;
                    2 : r_seg <= 8'b11011010;
                    3 : r_seg <= 8'b11110010;
                    4 : r_seg <= 8'b01100110;
                    5 : r_seg <= 8'b10110110;
                    6 : r_seg <= 8'b10111110;
                    7 : r_seg <= 8'b11100000;
                    8 : r_seg <= 8'b11111110;
                    9 : r_seg <= 8'b11110110;
                endcase
            end
        end
    end

endmodule