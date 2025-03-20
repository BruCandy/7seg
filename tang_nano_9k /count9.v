module count9 (
    input  wire       i_clk,
    input  wire       i_rst,
    output wire [7:0] o_seg,
    output wire [3:0] o_dig
);

    parameter WAIT = 27_000_000; // tang nano 9kは27MHz
    parameter BITS = 25;
    parameter MAX  = 9;

    reg [BITS-1:0]  r_wait = 0;
    reg [3:0]       r_cnt = 0;
    reg [7:0]       r_seg = 8'b11111100;

    wire w_rst;

    assign o_dig = 4'b1110; // 1桁目に表示
    assign o_seg = r_seg;
    assign w_rst = ~ i_rst; // Tang Nano 9Kのボタンは負論理であるため

    always @(posedge i_clk or posedge w_rst) begin
        if (w_rst) begin
            r_wait <= 0;
            r_cnt  <= 0;
            r_seg  <= 8'b11111100;
        end else begin
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

endmodule