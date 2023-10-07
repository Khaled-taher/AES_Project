package GF_Arithmetic;

    function logic[7:0] GF_mult (logic [7:0] in1, logic [7:0]in2);
        
        logic [15:0] temp, reduction1;
        logic [15:0] temp1 [8];
    
        static logic [8:0] reduction = 9'd283; 
        
        temp = 0;
        reduction1 = 0;
        
        //multiplication
        foreach (in1[i])    
        begin
            if (in1[i] == 1)
            begin
                temp1[i] = in2 << i;
            end

            else
            begin
                temp1[i] = 0;
            end
        end

        //addition
        temp = temp1[0]^temp1[1]^temp1[2]^temp1[3]^temp1[4]^temp1[5]^temp1[6]^temp1[7];

        //reduction
        for (int i = 0; i < 8; i++) 
        begin
            if (temp[15-i] == 1)
            begin
                reduction1 = reduction << (7-i);
                temp = temp ^ reduction1;
                
            end

            else 
            begin
                reduction1 = reduction1;
            end
        end

        GF_mult = temp;
    endfunction

endpackage
