`default_nettype none
module serdes_pcs_vip (
  input wire clk, input wire rst_n, input wire mode_prbs31,
  input wire send_comma, input wire err_inject,
  output reg [9:0] tx_10b, output reg rx_locked,
  output reg [31:0] rx_ok_cnt, output reg [31:0] rx_err_cnt
);
  localparam [9:0] K28_5 = 10'b0011111010;
  function [7:0] next_p7(input [6:0] s, output [6:0] ns);
    integer i; reg [6:0] t;
    begin t=s; for(i=0;i<8;i=i+1) begin next_p7[i]=t[6]; t={t[5:0],t[6]^t[5]}; end ns=t; end
  endfunction
  function [7:0] next_p31(input [30:0] s, output [30:0] ns);
    integer i; reg [30:0] t;
    begin t=s; for(i=0;i<8;i=i+1) begin next_p31[i]=t[30]; t={t[29:0],t[30]^t[27]}; end ns=t; end
  endfunction
  reg [6:0] tx_p7, rx_p7, tx_p7_n, rx_p7_n; reg [30:0] tx_p31, rx_p31, tx_p31_n, rx_p31_n;
  reg [7:0] tx_b, exp_b; reg tx_comma_d;
  always @(*) begin
    tx_b = mode_prbs31 ? next_p31(tx_p31, tx_p31_n) : next_p7(tx_p7, tx_p7_n);
    exp_b = mode_prbs31 ? next_p31(rx_p31, rx_p31_n) : next_p7(rx_p7, rx_p7_n);
  end
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      tx_p7<=7'h7F; tx_p31<=31'h7FFFFFFF; tx_10b<=K28_5; tx_comma_d<=1;
      rx_p7<=7'h7F; rx_p31<=31'h7FFFFFFF; rx_locked<=0; rx_ok_cnt<=0; rx_err_cnt<=0;
    end else begin
      tx_comma_d <= send_comma;
      if (send_comma) begin
        tx_p7<=7'h7F; tx_p31<=31'h7FFFFFFF; tx_10b<=K28_5;
      end else begin
        tx_p7<=tx_p7_n; tx_p31<=tx_p31_n;
        tx_10b <= {~tx_b[0], tx_b, tx_b[0]} ^ (err_inject ? 10'd2 : 10'd0);
      end
      if (tx_10b == K28_5) begin
        rx_locked<=1; rx_p7<=7'h7F; rx_p31<=31'h7FFFFFFF;
      end else if (rx_locked) begin
        rx_p7<=rx_p7_n; rx_p31<=rx_p31_n;
        if (tx_10b[8:1] == exp_b) rx_ok_cnt <= rx_ok_cnt + 1;
        else rx_err_cnt <= rx_err_cnt + 1;
      end
    end
  end
endmodule
`default_nettype wire
