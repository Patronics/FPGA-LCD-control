// 1.14 inch 240x135 SPI LCD TEST for TANG NANO 9K
// by fanoble, QQ:87430545
// 27/6/2022

`timescale 1ps/1ps

module top(
	input clk, // 27M
	input resetn,

	output ser_tx,
	input ser_rx,

	input switch1,

	output lcd_resetn,
	output lcd_clk,
	output lcd_cs,
	output lcd_rs,
	output lcd_data
);
	wire[15:0] pixel_index;
	wire[15:0] pixel_value;
	


	reg [4:0] rpixel;// = pixel_index[14:10];//(pixel_cnt >= 21600) ? 5'h1F : (pixel_cnt >= 240) ? 5'h00 : 5'h1F;
    reg [5:0] gpixel;// = pixel_index[10:5];
    //assign gpixel [4:0] = (pixel_cnt >= 21600) ? 5'h0 :(pixel_cnt >= 10800) ? 5'h3F : 5'h0;
    //assign gpixel [5] = pixel_cnt[11];
    reg [4:0] bpixel;// = pixel_index[4:0];//(pixel_cnt >= 21600) ? 5'h0 : (pixel_cnt >= 10800) ? 5'h0 : 5'h1F;

	reg [1:0] state;

	reg [15:0] newPixelValue;
	reg [13:0] newPixelAddress;
	reg BRAMwen =0;

	always@(posedge clk) begin
		if (state == 1) begin
			rpixel <= newPixelValue [14:10];
			if (newPixelAddress/120>60) begin
				gpixel <= newPixelValue [10:5];
			end else begin
				gpixel <= newPixelValue [10:5]/8;
			end
			bpixel <= newPixelValue [4:0];
			if(switch1 == 1) begin
				newPixelAddress <= newPixelAddress+1;
			end
		end else if (state == 2) begin
			BRAMwen <= 1;
		end else if (state == 3) begin
			BRAMwen <= 0;
		end else if (state == 0) begin
			newPixelValue <= newPixelValue+1;

		end

		
		state <= state+1;
	end

	testBRAM myBRAM(
		.clk(clk), 
		.wen(BRAMwen), 
		.ren(1),
		.waddr(newPixelAddress),
		.raddr(pixel_index/2),
		.wdata(newPixelValue),
		.rdata(pixel_value)
	);

	lcd mylcd (
		.clk(clk), // 27M
		.resetn(resetn),

		.ser_tx(ser_tx),
		.ser_rx(ser_rx),
		.pixel_index(pixel_index),
		.pixel_value(pixel_value),

		.lcd_resetn(lcd_resetn),
		.lcd_clk(lcd_clk),
		.lcd_cs(lcd_cs),
		.lcd_rs(lcd_rs),
		.lcd_data(lcd_data)
	);


endmodule


module testBRAM (
	input clk, wen, ren,
	input [13:0] waddr, raddr,
	input [15:0] wdata,
	output reg [15:0] rdata
);
	reg [15:0] mem [0:16383];
	always @(posedge clk) begin
			if (wen)
					mem[waddr] <= wdata;
			if (ren)
					rdata <= mem[raddr];
	end
endmodule