
//=======================================================
//  LTC1668 Tester using DE0 Nano board. 
//  Sinewave generated by NCO Megafunction
//  Phase increment for OSR50 85899346 (gives 1MHz with 50MHz clock)
//=======================================================
module DE0_NANO_LTC1668(
	CLK_50, // 50MHz clock input. Normally taken from onboard oscillator.
	
	CLKOUT, // Clock out to LTC1668
	LED,
	KEY,
	SW,
	G_SENSOR_CS_N,
	G_SENSOR_INT,
	I2C_SCLK,
	I2C_SDAT,
	port0,  // Using PORT0, see mapping below.
	adcclk0,
	adcclk1,
	adcclk2,
	adcclk3,
	adcclk4,
	GPIO,
	SCK,
	MOSI
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

input 		          		CLK_50;
output							CLKOUT;
output		     [7:0]		LED;
input 		     [1:0]		KEY;
input 		     [3:0]		SW;
output		          		G_SENSOR_CS_N;
input 		          		G_SENSOR_INT;
output		          		I2C_SCLK;
inout 		          		I2C_SDAT;
output 		    [33:0]		port0;
output 	                  adcclk0;
output 	                 	adcclk1;
output 	                 	adcclk2;
output 	                 	adcclk3;
output 	                 	adcclk4;
input								GPIO;
input								SCK;
input								MOSI;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire [15:0]sine;
wire CLKDIV;
wire CLKSHIFT;
wire ADCCLK;
wire [31:0]tuning_word;
reg [31:0]spi_tuning_word;

assign adcclk0 = ADCCLK;
assign adcclk1 = ADCCLK;
assign adcclk2 = ADCCLK;
assign adcclk3 = ADCCLK;
assign adcclk4 = ADCCLK;

//assign port0[15:0] = sine[15:0];
assign port0[0] = ~sine[15];
assign port0[1] = sine[14];
assign port0[2] = sine[13];
assign port0[3] = 1'b0;
assign port0[4] = sine[12];
assign port0[5] = 1'b0;
assign port0[6] = sine[11];
assign port0[7] = sine[10];
assign port0[8] = sine[9];
assign port0[9] = 1'b0;
assign port0[10] = sine[8];
assign port0[11] = 1'b0;
assign port0[12] = sine[7];
assign port0[13] = 1'b0;
assign port0[14] = sine[6];
assign port0[15] = 1'b0;
assign port0[16] = sine[5];
assign port0[17] = 1'b0;
assign port0[18] = sine[4];
assign port0[19] = 1'b0;
assign port0[20] = sine[3];
assign port0[21] = 1'b0;
assign port0[22] = sine[2];
assign port0[23] = sine[1];
assign port0[24] = ~sine[0];
assign port0[25] = 1'b0;
assign port0[26] = 1'b0;
assign port0[27] = 1'b0;
assign port0[28] = CLKOUT;
assign port0[29] = 1'b0;
assign port0[30] = 1'b0;
assign port0[31] = 1'b0;
assign port0[32] = CLKSHIFT;
assign port0[33] = 1'b0;

assign CLKOUT = CLKDIV;

//=======================================================
//  Structural coding
//=======================================================
NCO2	NCO2_inst(
	.phi_inc_i	(tuning_word), //32'd85899346 for 1MHz @25MSPS 2147483648
//	.phi_inc_i	(32'd8581120), // 2kHz at 25MHz clock, coherent w/1MSPS sample rate (or something)
	.clk			(CLKDIV),
	.reset_n		(1'b1),
	.clken		(1'b1),
	.fsin_o		(sine),
	.out_valid());
	
	
pll2 pll2_inst (
	.inclk0 (CLK_50),
	.c0 (CLKDIV),
	.c1 (CLKSHIFT),
	.c2 (ADCCLK),
	.locked (LED[4]));

	
// high=programmable, low=500kHz@25MHz clock
// for ?:, TRUE first, then FALSE
assign tuning_word = (GPIO) ? spi_tuning_word : 32'd85899346;
	

always@ (posedge SCK)begin						//Dirt-simpl, unregistered SPI port
	spi_tuning_word <= {spi_tuning_word[30:0], MOSI};
	end
	
endmodule
