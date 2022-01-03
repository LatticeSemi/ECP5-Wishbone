
module x_pcie_sync1s (
                f_clk ,
                s_clk ,
                rst_n ,
                in_fclk,
                out_sclk
               );


parameter WIDTH = 1 ;

input              f_clk ;       // Fast clock.
input              s_clk ;       // Slow clock.
input              rst_n ;       // reset signal.
input  [WIDTH-1:0] in_fclk ;     // Input pulse in fast clock domain.
output [WIDTH-1:0] out_sclk ;    // Output pulse in slow clock domain.

reg [WIDTH-1:0]   f_reg1 ;
reg [WIDTH-1:0]   f_reg2 ;
reg [WIDTH-1:0]   f_reg3 ;
reg [WIDTH-1:0]   s_reg1 ;
reg [WIDTH-1:0]   s_reg2 ;

wire [WIDTH-1:0]  hold_fb ;
wire [WIDTH-1:0]  out_sclk ;

integer i ;

// register fast clock signal edge and hold it untill
// it is transfered into slower clock domain.
always @(posedge f_clk or negedge rst_n) begin
   if (!rst_n)
      f_reg1 <= {WIDTH{1'b0}};
   else
      for (i = 0; i <= WIDTH-1; i = i+1) begin
         f_reg1[i] <= (hold_fb[i]=== 1'b1) ? f_reg1[i] : in_fclk[i];
      end
end

// first register in slower clock domain, this can be 
// a metastable flop.
always @(posedge s_clk or negedge rst_n) begin
   if (!rst_n)
      s_reg1 <= {WIDTH{1'b0}};
   else
      s_reg1 <= f_reg1;
end

// Cleaner registering in slower clock domain.
always @(posedge s_clk or negedge rst_n) begin
   if (!rst_n)
      s_reg2 <= {WIDTH{1'b0}};
   else
      s_reg2 <= s_reg1;
end

// Output signal.
assign out_sclk  = s_reg2 ;

// Register clean output in slower clock domain into
// fast clock domains, this can be metastable flop.
always @(posedge f_clk or negedge rst_n) begin
   if (!rst_n)
      f_reg2 <= {WIDTH{1'b0}};
   else
      f_reg2 <= s_reg2;
end

// Cleaner registering in faster clock domain.
always @(posedge f_clk or negedge rst_n) begin
   if (!rst_n)
      f_reg3 <= {WIDTH{1'b0}};
   else
      f_reg3 <= f_reg2;
end

// generate feed back hold signal for holding
// input signal in fast clock domain, until it reaches
// slower clock domain.
assign hold_fb  = f_reg1 ^ f_reg3;

endmodule



