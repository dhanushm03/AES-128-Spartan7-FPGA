module shift_rows (
    input  wire [127:0] in,
    output wire [127:0] out
);

    // AES operates on bytes. Let's define bytes for clarity (optional, but helps reading)
    // But for a simple wire assignment, we can just map the ranges.
    
    // We construct the output column by column to match AES standard.
    // Out Byte 0 (Top left) comes from In Byte 0 (Row 0, no shift)
    // Out Byte 1 (Row 1, Col 0) comes from In Byte 5 (Row 1, shifted)
    // Out Byte 2 (Row 2, Col 0) comes from In Byte 10 (Row 2, shifted)
    // ... and so on
    //------------innoru type============================
//wire [7:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;

//    // Step 2: Unpack the input (Standard Big Endian)
//    assign {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15} = in;

//    // Step 3: Reassemble in the new order
//    // We just list the bytes in the order they should appear in the output.
//    // Remember AES is Column-Major, so we group them by columns.

//    assign out = {
//        // Col 0: r0, r1(shifted), r2(shifted), r3(shifted)
//        s0, s5, s10, s15, 
        
//        // Col 1
//        s4, s9, s14, s3, 
        
//        // Col 2
//        s8, s13, s2, s7, 
        
//        // Col 3
//        s12, s1, s6, s11
//    };

//endmodule
//======================================================
    assign out = {
        // --- Column 0 ---
        in[127:120], // Row 0 (Byte 0)  -> stays at Byte 0
        in[87:80],   // Row 1 (Byte 5)  -> moves to Byte 1 position
        in[47:40],   // Row 2 (Byte 10) -> moves to Byte 2 position
        in[7:0],     // Row 3 (Byte 15) -> moves to Byte 3 position

        // --- Column 1 ---
        in[95:88],   // Row 0 (Byte 4)
        in[55:48],   // Row 1 (Byte 9)
        in[15:8],    // Row 2 (Byte 14)
        in[103:96],  // Row 3 (Byte 3)

        // --- Column 2 ---
        in[63:56],   // Row 0 (Byte 8)
        in[23:16],   // Row 1 (Byte 13)
        in[111:104], // Row 2 (Byte 2)
        in[71:64],   // Row 3 (Byte 7)

        // --- Column 3 ---
        in[31:24],   // Row 0 (Byte 12)
        in[119:112], // Row 1 (Byte 1)
        in[79:72],   // Row 2 (Byte 6)
        in[39:32]    // Row 3 (Byte 11)
    };

endmodule
