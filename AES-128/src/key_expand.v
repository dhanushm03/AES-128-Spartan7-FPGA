module key_expand (
    input  wire [127:0] key_in,
    input  wire [3:0]   round, // Current round index (1 to 10)
    output wire [127:0] key_out
);

    wire [31:0] w0, w1, w2, w3;
    wire [31:0] k0, k1, k2, k3; // Output words
    wire [31:0] g_out;
    wire [7:0]  rcon;
    
    // Split input key into 4 words
    assign w0 = key_in[127:96];
    assign w1 = key_in[95:64];
    assign w2 = key_in[63:32];
    assign w3 = key_in[31:0];

    // Rcon Lookup (Only defined for rounds 1-10)
    function [7:0] get_rcon;
        input [3:0] r;
        begin
            case(r)
                1:  get_rcon = 8'h01;
                2:  get_rcon = 8'h02;
                3:  get_rcon = 8'h04;
                4:  get_rcon = 8'h08;
                5:  get_rcon = 8'h10;
                6:  get_rcon = 8'h20;
                7:  get_rcon = 8'h40;
                8:  get_rcon = 8'h80;
                9:  get_rcon = 8'h1B;
                10: get_rcon = 8'h36;
                default: get_rcon = 8'h00;
            endcase
        end
    endfunction

    assign rcon = get_rcon(round);

    // g-function: RotWord -> SubWord -> XOR Rcon
    wire [31:0] rot_w3;
    wire [31:0] sub_w3;
    
    // RotWord (Left rotate by 8 bits): [a0,a1,a2,a3] -> [a1,a2,a3,a0]
    assign rot_w3 = {w3[23:0], w3[31:24]};

    // SubWord (Apply S-Box to each byte)
    sbox S0 (.in(rot_w3[31:24]), .out(sub_w3[31:24]));
    sbox S1 (.in(rot_w3[23:16]), .out(sub_w3[23:16]));
    sbox S2 (.in(rot_w3[15:8]),  .out(sub_w3[15:8]));
    sbox S3 (.in(rot_w3[7:0]),   .out(sub_w3[7:0]));

    assign g_out = sub_w3 ^ {rcon, 24'b0};

    // Calculate new words
    assign k0 = w0 ^ g_out;
    assign k1 = w1 ^ k0;
    assign k2 = w2 ^ k1;
    assign k3 = w3 ^ k2;

    assign key_out = {k0, k1, k2, k3};

endmodule