`timescale 1ns / 1ps

module aes_wrapper(
    input  wire        clk,
    input  wire        rst_btn,
    input  wire        start_sw,
    output wire        done_led,
    output wire [7:0]  seg,
    output wire [3:0]  an
);

    // =====================================================
    // 1. HARDCODED INPUTS
    // =====================================================
    reg [127:0] key_reg;
    reg [127:0] text_reg;

    always @(posedge clk) begin
        if (rst_btn) begin
            key_reg  <= 128'h000102030405060708090A0B0C0D0E0F;
            text_reg <= 128'h00112233445566778899AABBCCDDEEFF;
        end
    end

    // =====================================================
    // 2. AES CORE
    // =====================================================
    wire [127:0] cipher_result;
    wire done_sig;

    aes_top u_aes_core (
        .clk(clk),
        .rst(rst_btn),
        .start(start_sw),
        .plain_text(text_reg),
        .key(key_reg),
        .cipher_text(cipher_result),
        .done(done_sig)
    );

    assign done_led = done_sig;

    // =====================================================
    // 3. SCROLLING (ONLY AFTER DONE)
    // =====================================================
//    reg [3:0]  byte_index;
//    reg [25:0] scroll_cnt;

//    always @(posedge clk) begin
//        if (rst_btn) begin
//            scroll_cnt <= 0;
//            byte_index <= 0;
//        end else if (done_sig) begin
//            if (scroll_cnt == 26'd50_000_000) begin
//                scroll_cnt <= 0;
//                byte_index <= byte_index + 1;
//            end else begin
//                scroll_cnt <= scroll_cnt + 1;
//            end
//        end
//    end
    reg [3:0]  byte_index;
    reg [28:0] scroll_cnt;   // 29-bit counter
    
    always @(posedge clk) begin
        if (rst_btn) begin
            scroll_cnt <= 0;
            byte_index <= 0;
        end 
        else if (done_sig) begin
            if (scroll_cnt == 29'd300_000_000) begin
                scroll_cnt <= 0;
                byte_index <= byte_index + 1;
            end 
            else begin
                scroll_cnt <= scroll_cnt + 1;
            end
        end
    end

    wire [7:0] curr_byte;
    assign curr_byte = cipher_result[127 - (byte_index * 8) -: 8];

    // =====================================================
    // 4. DISPLAY REFRESH (SINGLE REAL CLOCK)
    // =====================================================
    reg [16:0] refresh_cnt;
    reg        digit_sel;

    always @(posedge clk) begin
        if (rst_btn) begin
            refresh_cnt <= 0;
            digit_sel  <= 0;
        end else begin
            refresh_cnt <= refresh_cnt + 1;
            digit_sel  <= refresh_cnt[16]; // ~1 kHz
        end
    end

    // =====================================================
    // 5. HEX → 7 SEG (ACTIVE LOW)
    // {dp,g,f,e,d,c,b,a}
    // =====================================================
    function [7:0] hex_to_7seg;
        input [3:0] hex;
        begin
            case (hex)
                4'h0: hex_to_7seg = 8'b11000000;
                4'h1: hex_to_7seg = 8'b11111001;
                4'h2: hex_to_7seg = 8'b10100100;
                4'h3: hex_to_7seg = 8'b10110000;
                4'h4: hex_to_7seg = 8'b10011001;
                4'h5: hex_to_7seg = 8'b10010010;
                4'h6: hex_to_7seg = 8'b10000010;
                4'h7: hex_to_7seg = 8'b11111000;
                4'h8: hex_to_7seg = 8'b10000000;
                4'h9: hex_to_7seg = 8'b10010000;
                4'hA: hex_to_7seg = 8'b10001000;
                4'hB: hex_to_7seg = 8'b10000011;
                4'hC: hex_to_7seg = 8'b11000110;
                4'hD: hex_to_7seg = 8'b10100001;
                4'hE: hex_to_7seg = 8'b10000110;
                4'hF: hex_to_7seg = 8'b10001110;
                default: hex_to_7seg = 8'b11111111;
            endcase
        end
    endfunction

    // =====================================================
    // 6. OUTPUT DRIVER (NO GHOSTING)
    // =====================================================
    reg [7:0] seg_r;
    reg [3:0] an_r;

    assign seg = seg_r;
    assign an  = an_r;

    always @(*) begin
        // SAFE DEFAULTS (IMPORTANT)
        an_r  = 4'b1111;        // all digits OFF
        seg_r = 8'b11111111;    // all segments OFF

        case (digit_sel)
            1'b0: begin
                seg_r = hex_to_7seg(curr_byte[3:0]);
                an_r  = 4'b1110; // right digit ON
            end
            1'b1: begin
                seg_r = hex_to_7seg(curr_byte[7:4]);
                an_r  = 4'b1101; // left digit ON
            end
        endcase

        seg_r[7] = 1'b1; // DP OFF (MANDATORY)
    end

endmodule
