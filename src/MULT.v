
module multy (
	 input			[demention_dataa-1:0]	iDataa,
	 input			[demention_datab-1:0]	iDatab,
	 output			[demention_dataa+demention_datab-2:0]	oResult
	 );
	parameter demention_dataa = 1;
	parameter demention_datab = 1;
	 //	The underlying assumption, here, is that both fixed-point values are of the same length (N,Q)
	 //		Because of this, the results will be of length N+N = 2N bits....
	 //		This also simplifies the hand-back of results, as the binimal point 
	 //		will always be in the same location...
	
	reg [demention_dataa+demention_datab-2:0]	r_result;		//	Multiplication by 2 values of N bits requires a 
											//		register that is N+N = 2N deep...
	reg [demention_dataa+demention_datab-2:0]		r_RetVal;
	
//--------------------------------------------------------------------------------
	assign oResult = r_RetVal;	//	Only handing back the same number of bits as we received...
											//		with fixed point in same location...
	
//---------------------------------------------------------------------------------
	always @(iDataa, iDatab)	begin						//	Do the multiply any time the inputs change
		r_result <= iDataa[demention_dataa-2:0] * iDatab[demention_datab-2:0];	//	Removing the sign bits from the multiply - that 
																					//		would introduce *big* errors	
		end
	
		//	This always block will throw a warning, as it uses a & b, but only acts on changes in result...
	always @(r_result) begin													//	Any time the result changes, we need to recompute the sign bit,
		r_RetVal[demention_dataa+demention_datab-2] <= iDataa[demention_dataa-1] ^ iDatab[demention_datab-1];	//		which is the XOR of the input sign bits...  (you do the truth table...)
		r_RetVal[demention_dataa+demention_datab-3:0] <= r_result[demention_dataa+demention_datab-3:0];								//	And we also need to push the proper N bits of result up to 
																						//		the calling entity...
		end
endmodule