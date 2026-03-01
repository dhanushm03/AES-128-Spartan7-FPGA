module aes_round (
    input  wire [127:0] state_in,
    input  wire [127:0] key_in, // This is actually the NEXT key, used for AddRoundKey at end
    input  wire         is_last_round,
    output wire [127:0] state_out
);

    wire [127:0] sb_out;
    wire [127:0] sr_out;
    wire [127:0] mc_out;

    // 1. SubBytes
    sub_bytes SB (.in(state_in), .out(sb_out));

    // 2. ShiftRows
    shift_rows SR (.in(sb_out), .out(sr_out));

    // 3. MixColumns (Skipped if last round)
    mix_columns MC (.in(sr_out), .out(mc_out));

    // 4. AddRoundKey (XOR with generated key)
    // If last round, bypass MixColumns (use sr_out). Else use mc_out.
    // NOTE: In the iterative architecture, the key_expand module gives us the key 
    // for the *current* round transformation.
    
    // IMPORTANT: The key coming into this module from AES_TOP is already the
    // "Round Key" derived for this specific round.
    
    assign state_out = (is_last_round ? sr_out : mc_out) ^ key_in;

endmodule