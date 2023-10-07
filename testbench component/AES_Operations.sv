package AES_Operations;

import GF_Arithmetic::*;

typedef logic [3:0][7:0] mtrx [4];

logic [0:15][0:8] LUT [16]= 
                '{
	                '{8'h63,    8'h7C,  8'h77,	    8'h7B,     8'hF2,  8'h6B,    8'h6F,   8'hC5,   8'h30,   8'h01,   8'h67,   8'h2B,   8'hFE,   8'hD7,   8'hAB,   8'h76},
	 	            '{8'hCA,    8'h82,  8'hC9, 	    8'h7D,     8'hFA,  8'h59,    8'h47,   8'hF0,   8'hAD,   8'hD4,   8'hA2,   8'hAF,   8'h9C,   8'hA4,   8'h72,   8'hC0},
	 	            '{8'hB7,    8'hFD,  8'h93, 	    8'h26,     8'h36,  8'h3F,    8'hF7,   8'hCC,   8'h34,   8'hA5,   8'hE5,   8'hF1,   8'h71,   8'hD8,   8'h31,   8'h15},
	 	            '{8'h04,    8'hC7,  8'h23, 	    8'hC3,     8'h18,  8'h96,    8'h05,   8'h9A,   8'h07,   8'h12,   8'h80,   8'hE2,   8'hEB,   8'h27,   8'hB2,   8'h75},
	 	            '{8'h09,    8'h83,  8'h2C, 	    8'h1A,     8'h1B,  8'h6E,    8'h5A,   8'hA0,   8'h52,   8'h3B,   8'hD6,   8'hB3,   8'h29,   8'hE3,   8'h2F,   8'h84},
	 	            '{8'h53,    8'hD1,  8'h00, 	    8'hED,     8'h20,  8'hFC,    8'hB1,   8'h5B,   8'h6A,   8'hCB,   8'hBE,   8'h39,   8'h4A,   8'h4C,   8'h58,   8'hCF},
		            '{8'hD0,    8'hEF,  8'hAA, 	    8'hFB,     8'h43,  8'h4D,    8'h33,   8'h85,   8'h45,   8'hF9,   8'h02,   8'h7F,   8'h50,   8'h3C,   8'h9F,   8'hA8},
		            '{8'h51,    8'hA3,  8'h40, 	    8'h8F,     8'h92,  8'h9D,    8'h38,   8'hF5,   8'hBC,   8'hB6,   8'hDA,   8'h21,   8'h10,   8'hFF,   8'hF3,   8'hD2},
                    '{8'hCD,    8'h0C,  8'h13, 	    8'hEC,     8'h5F,  8'h97,    8'h44,   8'h17,   8'hC4,   8'hA7,   8'h7E,   8'h3D,   8'h64,   8'h5D,   8'h19,   8'h73},
	 	            '{8'h60,    8'h81,  8'h4F, 	    8'hDC,     8'h22,  8'h2A,    8'h90,   8'h88,   8'h46,   8'hEE,   8'hB8,   8'h14,   8'hDE,   8'h5E,   8'h0B,   8'hDB},
	 	            '{8'hE0,    8'h32,  8'h3A, 	    8'h0A,     8'h49,  8'h06,    8'h24,   8'h5C,   8'hC2,   8'hD3,   8'hAC,   8'h62,   8'h91,   8'h95,   8'hE4,   8'h79},
	 	            '{8'hE7,    8'hC8,  8'h37, 	    8'h6D,     8'h8D,  8'hD5,    8'h4E,   8'hA9,   8'h6C,   8'h56,   8'hF4,   8'hEA,   8'h65,   8'h7A,   8'hAE,   8'h08},
	 	            '{8'hBA,    8'h78,  8'h25, 	    8'h2E,     8'h1C,  8'hA6,    8'hB4,   8'hC6,   8'hE8,   8'hDD,   8'h74,   8'h1F,   8'h4B,   8'hBD,   8'h8B,   8'h8A},
	 	            '{8'h70,    8'h3E,  8'hB5, 	    8'h66,     8'h48,  8'h03,    8'hF6,   8'h0E,   8'h61,   8'h35,   8'h57,   8'hB9,   8'h86,   8'hC1,   8'h1D,   8'h9E},
	 	            '{8'hE1,    8'hF8,  8'h98, 	    8'h11,     8'h69,  8'hD9,    8'h8E,   8'h94,   8'h9B,   8'h1E,   8'h87,   8'hE9,   8'hCE,   8'h55,   8'h28,   8'hDF},
	 	            '{8'h8C,    8'hA1,  8'h89, 	    8'h0D,     8'hBF,  8'hE6,    8'h42,   8'h68,   8'h41,   8'h99,   8'h2D,   8'h0F,   8'hB0,   8'h54,   8'hBB,   8'h16}
                };

function logic [15:0][7:0] ByteSub (logic [15:0][7:0] A);
    for (int i = 0; i <16; i++)
    begin
        ByteSub[i] = LUT [A[i][7:4]][A[i][3:0]];
    end
endfunction: ByteSub

/*************************************************************************/

//another way of ByteSub without LUT: (Low space/ low data rate)

//Inverse Creation
function logic [7:0] Inverse (logic [7:0] A);
    
    //find the multiplicative inverse
    for (logic [7:0] i = 0; i <256; i++)
    begin
        if (A == 0)
        begin
            Inverse = 8'h00;
        end

        else if(GF_mult(A, i) == 1)
        begin
            Inverse = i;
        end

        else
        begin
            Inverse = Inverse;
        end
    end
endfunction: Inverse

//Affine transformation
function logic [7:0] Affine (logic [7:0] A);
    
    static logic [7:0] C = 8'b01100011;

    for (int i = 0; i<8; i++)
    begin
        Affine[i] = A[i]^A[i+4]^A[i+5]^A[i+6]^A[i+7]^C[i];
    end
endfunction: Affine

//Bytes substitution
function logic [7:0] SubBytes (logic [7:0] A);

    logic [7:0] b;

    b = Inverse(A);
    SubBytes = Affine(b);
endfunction: SubBytes

/*************************************************************************/

function mtrx ShiftRows4 (logic [3:0][7:0] A [4]);
    ShiftRows4 <= '{
                    '{A[0][0], A[0][1], A[0][2], A[0][3]},  //no shift                           
                    '{A[1][1], A[1][2], A[1][3], A[1][0]},  //shift by 1
                    '{A[2][2], A[2][3], A[2][0], A[2][1]},  //shift by 2
                    '{A[3][3], A[3][0], A[3][1], A[3][2]}   //shift by 3
    };
endfunction: ShiftRows4

function logic [15:0][7:0] ShiftRows (logic [15:0][7:0] A);     //2 dimensional operation operation
    //ShiftRows = '{A[0], A[5], A[10], A[15], A[4], A[9], A[14], A[3], A[8], A[13], A[2], A[7], A[12], A[1], A[6], A[11]};
    ShiftRows = '{A[11], A[6], A[1], A[12], A[7], A[2], A[13], A[8], A[3], A[14], A[9], A[4], A[15], A[10], A[5], A[0]};
endfunction: ShiftRows

/*************************************************************************/

function logic [15:0][7:0] MixColumns (logic [15:0][7:0] A);
    for (int i = 0; i < 4; i++)
    begin
        MixColumns[i*4] <= GF_mult(8'h02, A[i*4]) ^ GF_mult(8'h03, A[i*4+1]) ^ A[i*4+2] ^ A [i*4+3];
        MixColumns[i*4+1] <= A[i*4] ^ GF_mult(8'h02, A[i*4+1]) ^ GF_mult(8'h03, A[i*4+2]) ^ A[i*4+3];
        MixColumns[i*4+2] <= A[i*4] ^ A[i*4+1] ^ GF_mult(8'h02, A[i*4+2]) ^ GF_mult(8'h03, A[i*4+3]);
        MixColumns[i*4+3] <= GF_mult(8'h03, A[i*4]) ^ A[i*4+1] ^ A[i*4+2] ^ GF_mult(8'h02, A[i*4+3]);
    end
endfunction: MixColumns

/*************************************************************************/

function logic [127:0] AddRoundKey (logic [127:0] A,logic [127:0] Key);
    for (int i =0; i <128; i++)
    begin
    AddRoundKey[i] <= A[i] ^ Key[127-i];
    end
endfunction: AddRoundKey

endpackage