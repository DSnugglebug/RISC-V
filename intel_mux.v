module mux_struc (a,b,s, m);
input a, b, s;
output m;

wire x, y;

assign x = a & s;
assign y = b & ~s;

assign m = x | y;

endmodule



module mux_behv (a,b,s, m);
input a, b, s;
output m;

always@*
begin
	if (s==1'b1)
		m = a;
	else
		m = b;
end
endmodule
