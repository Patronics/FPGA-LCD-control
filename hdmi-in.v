module hdmi(

);



endmodule

module tmdsDecode(
    input wire [9:0] inBits,
    output reg [7:0] color,
    output reg isControlSignal,
    output reg [1:0] controlType
    );

    wire invertValues = inBits[9];
    wire useXor = inBits[8];
    reg [7:0] rawBitValues;

always @(*) begin
    //handle control symbols, only 4 valid combinations:
    case(inBits)
        10'b0010101011: begin
            isControlSignal <= 1'b1;
            controlType <= 2'b00;
        end
        10'b0010101010: begin
            isControlSignal <= 1'b1;
            controlType <= 2'b10;
        end
        10'b1101010100: begin
            isControlSignal <= 1'b1;
            controlType <= 2'b01;
        end
        10'b1101010101: begin
            isControlSignal <= 1'b1;
            controlType <= 2'b11;
        end
        default: begin
            isControlSignal <= 1'b0;
            controlType <= 2'b00;
        end
    endcase


    rawBitValues <= invertValues ? ~inBits[7:0] : inBits[7:0];
    color[0] <= rawBitValues[0];
    if(useXor == 1'b1) begin
        color[2] <= rawBitValues[2] ^ rawBitValues[1];
        color[1] <= rawBitValues[1] ^ rawBitValues[0];
        color[3] <= rawBitValues[3] ^ rawBitValues[2];
        color[4] <= rawBitValues[4] ^ rawBitValues[3];
        color[5] <= rawBitValues[5] ^ rawBitValues[4];
        color[6] <= rawBitValues[6] ^ rawBitValues[5];
        color[7] <= rawBitValues[7] ^ rawBitValues[6];
    end else begin //use xnor instead of xor
        color[1] <= ~(rawBitValues[1] ^ rawBitValues[0]);
        color[2] <= ~(rawBitValues[2] ^ rawBitValues[1]);
        color[3] <= ~(rawBitValues[3] ^ rawBitValues[2]);
        color[4] <= ~(rawBitValues[4] ^ rawBitValues[3]);
        color[5] <= ~(rawBitValues[5] ^ rawBitValues[4]);
        color[6] <= ~(rawBitValues[6] ^ rawBitValues[5]);
        color[7] <= ~(rawBitValues[7] ^ rawBitValues[6]);
    end
end

endmodule