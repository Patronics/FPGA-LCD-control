// 1.14 inch 240x135 SPI LCD TEST for TANG NANO 9K
// by fanoble, QQ:87430545
// 27/6/2022

`timescale 1ps/1ps

module top(
	input clk, // 27M
	input resetn,

	output ser_tx,
	input ser_rx,

	output lcd_resetn,
	output lcd_clk,
	output lcd_cs,
	output lcd_rs,
	output lcd_data
);
	wire[15:0] pixel_index;
	wire[15:0] pixel_value={rpixel, gpixel, bpixel};
	
	wire [4:0] rpixel = pixel_index[14:10];//(pixel_cnt >= 21600) ? 5'h1F : (pixel_cnt >= 240) ? 5'h00 : 5'h1F;
    wire [5:0] gpixel = pixel_index[10:5];
    //assign gpixel [4:0] = (pixel_cnt >= 21600) ? 5'h0 :(pixel_cnt >= 10800) ? 5'h3F : 5'h0;
    //assign gpixel [5] = pixel_cnt[11];
    wire [4:0] bpixel = pixel_index[4:0];//(pixel_cnt >= 21600) ? 5'h0 : (pixel_cnt >= 10800) ? 5'h0 : 5'h1F;




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
