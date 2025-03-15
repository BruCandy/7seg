module seven_seg (
    output wire [7:0] o_seg,    // Positive Logic
    output wire [3:0] o_dig     // Negative Logic
);

    assign o_seg = 8'b11111100;
    assign o_dig = 4'b1110; // 1桁目に表示

    /*
    0: 8'b11111100 // a,b,c,d,e,f,g,dp
    1: 8'b01100000
    2: 8'b11011010
    3: 8'b11110010
    4: 8'b01100110
    5: 8'b10110110
    6: 8'b10111110
    7: 8'b11100000
    8: 8'b11111110
    9: 8'b11110110
    */

endmodule
