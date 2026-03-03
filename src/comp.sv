`timescale 1ns / 1ps

module comp(
    input [31:0] a,
    input [31:0] b,
    output logic gt,
    output logic eq,
    output logic lt
    );
    
logic [31:0] eq_bit;
logic [31:0] prefix_eq;
logic [31:0] gt_bit;
logic [31:0] lt_bit;

genvar i;

generate
    for(i = 0; i < 32; i++) begin
        assign eq_bit[i] = ~(a[i] ^ b[i]);
    end
endgenerate

assign prefix_eq[31] = 1'b1;

generate
    for(i = 30; i >= 0; i--) begin
        assign prefix_eq[i] =
            prefix_eq[i+1] & eq_bit[i+1];
    end
endgenerate

generate
    for(i = 0; i < 32; i++) begin
        assign gt_bit[i] =
            prefix_eq[i] & a[i] & ~b[i];

        assign lt_bit[i] =
            prefix_eq[i] & ~a[i] & b[i];
    end
endgenerate

assign gt = |gt_bit;
assign lt = |lt_bit;
assign eq = &eq_bit; 
    
endmodule
