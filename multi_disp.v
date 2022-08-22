`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/22 16:39:01
// Design Name: 
// Module Name: multi_disp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module multi_disp(

input clk, rst,
input key0,
input [3:0] enc,
input [7:0] dip,
output reg[7:0] seg_d,seg_com
    );

reg k0,k1;
reg [3:0] kcnt;
wire [3:0] d7h, d6h, d5h, d4h, d3h, d2h, d1h, d0h;
reg [3:0] sdh;

reg [17:0] tcnt;
reg [2:0] digit_sel;

wire [6:0] segd;

//tcnt & digit_sel generation 
always@(negedge rst, posedge clk)
if(rst == 0)
    begin
        tcnt <= 0;
        digit_sel <= 0;
    end 
else
    begin
        tcnt <= tcnt + 1;
        case(~enc)
        4'h0     : digit_sel <= tcnt[02:00];    
        4'h1     : digit_sel <= tcnt[03:01];    
        4'h2     : digit_sel <= tcnt[04:02];    
        4'h3     : digit_sel <= tcnt[05:03];    
        4'h4     : digit_sel <= tcnt[06:04];   
        4'h5     : digit_sel <= tcnt[07:05];   
        4'h6     : digit_sel <= tcnt[08:06];    
        4'h7     : digit_sel <= tcnt[09:07];    
        4'h8     : digit_sel <= tcnt[10:08]; 
        4'h9     : digit_sel <= tcnt[11:09];           
        4'ha     : digit_sel <= tcnt[12:10];     
        4'hb     : digit_sel <= tcnt[13:11];        
        4'hc     : digit_sel <= tcnt[14:12];     
        4'hd     : digit_sel <= tcnt[15:13];     
        4'he     : digit_sel <= tcnt[16:14];     
        default  : digit_sel <= tcnt[17:15];     
        endcase
    end
//key0 Edge Detect & KCNT Generation 
always@(negedge rst, posedge clk)
if(rst == 0)
    begin
        k0 <= 0;
        k1 <= 0;
        kcnt <= 0;
    end 
else
    begin
        k0 <= ~key0;
        k1 <= k0;
        if(k0 & ~k1)
            kcnt <= kcnt + 1;
    end 

//d#h generation 
assign  d7h = kcnt;
assign  d6h = kcnt + 1;
assign  d5h = kcnt + 2;
assign  d4h = kcnt + 3;
assign  d3h = kcnt + 4;
assign  d2h = kcnt + 5;
assign  d1h = kcnt + 6;
assign  d0h = kcnt + 7;


//sdh selection 
always@(negedge rst, posedge clk)
if(rst == 0)
    sdh <= 0;
else
    case(digit_sel)
    3'd0        : sdh <= d0h;
    3'd1        : sdh <= d1h;
    3'd2        : sdh <= d2h;
    3'd3        : sdh <= d3h;
    3'd4        : sdh <= d4h;
    3'd5        : sdh <= d5h;
    3'd6        : sdh <= d6h;
    default     : sdh <= d7h;
    endcase
    
//hex to segment converting 
assign segd = (sdh == 4'h0) ? (7'h3f) : 
              (sdh == 4'h1) ? (7'h06) : 
              (sdh == 4'h2) ? (7'h5d) : 
              (sdh == 4'h3) ? (7'h4f) : 
              (sdh == 4'h4) ? (7'h66) : 
              (sdh == 4'h5) ? (7'h6d) : 
              (sdh == 4'h6) ? (7'h7d) : 
              (sdh == 4'h7) ? (7'h27) : 
              (sdh == 4'h8) ? (7'h7f) : 
              (sdh == 4'h9) ? (7'h6f) : 
              (sdh == 4'ha) ? (7'h5f) : 
              (sdh == 4'hb) ? (7'h7c) : 
              (sdh == 4'hc) ? (7'h58) : 
              (sdh == 4'hd) ? (7'h5e) : 
              (sdh == 4'he) ? (7'h7b) : 
                              (7'h71) ;
        
//output selection 
always@(negedge rst, posedge clk)
if(rst == 0)
    begin 
        seg_d <= 8'h00;
        seg_com <= 8'h00;
    end
else
    begin
        seg_d <= {1'b0,segd};
        case(digit_sel)
        3'd0        : seg_com <= 8'h01;                
        3'd1        : seg_com <= 8'h02;                
        3'd2        : seg_com <= 8'h04;                
        3'd3        : seg_com <= 8'h08;                
        3'd4        : seg_com <= 8'h10;                
        3'd5        : seg_com <= 8'h20;                
        3'd6        : seg_com <= 8'h40;                
        default     : seg_com <= 8'h80;                
        endcase 
    end
       
    
endmodule
