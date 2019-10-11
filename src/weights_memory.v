module weights_memory(
	 oWeights
);

parameter 	weight_size = 32;
parameter	reservoir_size  = 3;

output  [weight_size*reservoir_size-1:0] oWeights;

	reg [weight_size-1:0] romWeights[reservoir_size-1:0] ;

genvar j;
generate
	
		for(j=0;j<reservoir_size;j=j+1)
		begin:init2
			assign oWeights[(j+1)*weight_size-1:j*weight_size] =  romWeights[j];
		end


	
endgenerate

initial
	begin
		$readmemb("weights_memory_init.txt", romWeights);
	end

endmodule
