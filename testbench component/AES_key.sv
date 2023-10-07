package AES_Key;

    import GF_Arithmetic::*;
    
    import AES_Operations::*;
    //import AES_Operations::ByteSub;

    typedef logic [3:0][31:0] KeySchedule [11];

    function logic [31:0] G (logic [31:0] A, logic [3:0] i);
       
       static logic [9:0] [7:0] Rcon = '{8'h36, 8'h1b, 8'h80, 8'h40, 8'h20, 
                                            8'h10, 8'h08, 8'h04, 8'h02, 8'h01 }; 

        logic [31:0] B;

        $displayh ("A:%p", A);

        //Rotate Word
        B = A << 8;
        B [3:0] = A[27:24];
        B [7:4] = A[31:28];

        $displayh ("Rotate:%p", B);
        
        //Substitute Word
        B[7:0]   = ByteSub(B[7:0]);
        B[15:8]  = ByteSub(B[15:8]);
        B[23:16] = ByteSub(B[23:16]);
        B[31:24] = ByteSub(B[31:24]);

        $displayh ("Sub:%p", B);
        
        //Xor
        B[31:24] = B[31:24]^Rcon[i];

        $displayh ("Xor:%p", B);
        //
        G = B;
        $displayh ("final:%p", B); 
    endfunction:G

    function KeySchedule KeyGen (logic [127:0] A);
        KeyGen[0] = A;

        for (int i = 0; i <10; i++)
        begin
        KeyGen[i+1][3] = G(KeyGen[i][0], i)^ KeyGen[i][3];
        KeyGen[i+1][2] = KeyGen[i+1][3] ^ KeyGen[i][2];
        KeyGen[i+1][1] = KeyGen[i+1][2] ^ KeyGen[i][1];
        KeyGen[i+1][0] = KeyGen[i+1][1] ^ KeyGen[i][0];
        end
        
    endfunction: KeyGen


endpackage: AES_Key