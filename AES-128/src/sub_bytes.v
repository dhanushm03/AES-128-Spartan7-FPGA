module sub_bytes (
    input  wire [127:0] in,
    output wire [127:0] out
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : sbox_inst
            sbox S (
                .in (in[i*8 +: 8]),//[start+width-1:start] indha formula la tha o/p varum
                                   // width=8 bcz sbox ku pora data ellam 8bits ahh pogum 1by=8bit. 
                .out(out[i*8 +: 8])
            );
        end
    endgenerate
endmodule