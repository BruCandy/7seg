module count99_tb();
    reg i_clk = 1'b1;
    reg i_rst;
    wire [7:0] o_seg;
    wire [3:0] o_dig;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, count99_tb);
    end

    count99 # (
        .WAIT(10),
        .BITS(4),
        .TIMER_WAIT(1)
    ) count99 (
        .i_clk  (i_clk),
        .i_rst  (i_rst),
        .o_seg  (o_seg),
        .o_dig  (o_dig)
    );

    always #10 begin
        i_clk <= ~i_clk;
    end

    initial begin
        i_rst <= 0; #30;
        i_rst <= 1;

        #5000;

        i_rst <= 0; #30;
        i_rst <= 1;

        #5000;      

        $finish;
    end
endmodule