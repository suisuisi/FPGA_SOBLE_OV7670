/*-------------------------------------------------------------------------
This confidential and proprietary software may be only used as authorized
by a licensing agreement from Amfpga.
(C) COPYRIGHT 2012 CrazyBingo. ALL RIGHTS RESERVED
Filename			:		CMOS_Capture.v
Author				:		suisuisi
Data				:		2018-10-09
Version				:		1.0
Description			:		sdram test with uart interface.
Modification History	:
Data			By			Version			Change Description
===========================================================================

--------------------------------------------------------------------------*/
/***************************************************			
R(C)=( (256-alpha)*R(B) + alpha*R(A) ) >> 8
G(C)=( (256-alpha)*G(B) + alpha*G(A) ) >> 8
B(C)=( (256-alpha)*B(B) + alpha*B(A) ) >> 8
wire	[15:0] 	red_data	=	( (8'd255 - alpha_data) * lcd_data1[15:11] + alpha_data * lcd_data2[15:11] ) >> 8;
wire	[15:0] 	gre_data	= 	( (8'd255 - alpha_data) * lcd_data1[10:5]  + alpha_data * lcd_data2[10:5] )  >> 8;
wire	[15:0] 	blu_data	= 	( (8'd255 - alpha_data) * lcd_data1[4:0]   + alpha_data * lcd_data2[4:0] )   >> 8;
***************************************************/

module	alpha_control
(
	input				clk,
	input				rst_n,
	input		[1:0]	key_data,
	output	reg	[8:0]	alpha_data
);

//------------------------------------
wire			key_flag;
wire	[1:0]	key_value;
key_down_scan	
#(
	.KEY_WIDTH(2)
)
u_key_down_scan
(
	.clk		(clk),
	.rst_n		(rst_n),	
	.key_data	(key_data),	

	.key_flag	(key_flag),
	.key_value	(key_value)	
);

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		alpha_data <= 9'd127;
	else if(key_flag)
		begin
		case(key_value)
		2'b10:	alpha_data <= (alpha_data == 9'd0) ? 9'd0 : alpha_data -1'b1;
		2'b01:	alpha_data <= (alpha_data == 9'd256) ? 9'd256 : alpha_data + 1'b1;
		default:;
		endcase
		end
end

endmodule
