module mix_columns (
    input  wire [127:0] in,
    output wire [127:0] out
);
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : col_loop
            mix_single_column MC (
                .in (in[i*32 +: 32]),
                .out(out[i*32 +: 32])
            );
        end
    endgenerate
endmodule

module mix_single_column (
    input  wire [31:0] in,
    output wire [31:0] out
);
    wire [7:0] b0, b1, b2, b3;
    wire [7:0] d0, d1, d2, d3; // Doubles (x2)
    
    assign b0 = in[31:24];
    assign b1 = in[23:16];
    assign b2 = in[15:8];
    assign b3 = in[7:0];

    // xtime function (multiply by 2 in GF(2^8))
    function [7:0] xtime;
        input [7:0] x;
        begin
            xtime = (x[7] == 1) ? ((x << 1) ^ 8'h1b) : (x << 1);
        end
    endfunction

    assign d0 = xtime(b0);
    assign d1 = xtime(b1);
    assign d2 = xtime(b2);
    assign d3 = xtime(b3);

    // MixColumns Matrix Multiplication
    // 2 3 1 1
    // 1 2 3 1
    // 1 1 2 3
    // 3 1 1 2
    
    // 3*x = 2*x + x = d + b
    
    assign out[31:24] = d0 ^ (d1 ^ b1) ^ b2 ^ b3;
    assign out[23:16] = b0 ^ d1 ^ (d2 ^ b2) ^ b3;
    assign out[15:8]  = b0 ^ b1 ^ d2 ^ (d3 ^ b3);
    assign out[7:0]   = (d0 ^ b0) ^ b1 ^ b2 ^ d3;

endmodule