`timescale 1ns / 1ps

module aes_top (
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire [127:0] plain_text,
    input  wire [127:0] key,
    output reg  [127:0] cipher_text,
    output reg  done
);

    reg [3:0] round_ctr;//count round1 or 2 or 3
    reg [127:0] state;//current state value temp store panni vachikum
    reg [127:0] current_key;//since we need 10 key,oru oru current key inga temp store aagum
    wire [127:0] round_out;//gets output from aes_round and give it to state for next rounds
    wire [127:0] key_expansion_out;//same as round_out for key_expansion for key

    aes_round ROUND_LOGIC (
        .state_in(state),
        .key_in(key_expansion_out),
        .is_last_round(round_ctr == 4'd10),
        .state_out(round_out)
    );
    key_expand KEY_EXPANSION (
        .key_in(current_key),
        .round(round_ctr), // Takes current round to calculate Rcon
        .key_out(key_expansion_out)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <=128'b0;
            current_key <=128'b0;
            round_ctr   <=4'd0;
            done        <=1'b0;
            cipher_text <=128'b0;
        end else begin
            if (round_ctr == 0) begin
                if (start) begin
                    // Initial Round (Round 0): AddRoundKey only
                    state       <= plain_text^key;
                    current_key <= key;
                    round_ctr   <= 4'd1;
                    done        <= 1'b0;
                end
            end else if (round_ctr<=10) begin
                // Update State and Key for next round
                state       <=round_out;
                current_key <=key_expansion_out;
                
                if (round_ctr == 10) begin
                    done        <=1'b1;
                    cipher_text <=round_out;
                    round_ctr   <=4'd0; // Reset for next operation
                end else begin
                    round_ctr <= round_ctr + 1'b1;
                end
            end
        end
    end

endmodule