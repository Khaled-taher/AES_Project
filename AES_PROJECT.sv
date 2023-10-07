module AES_PROJECT (rst,clk,start,ready,key,word_in,word_out,en,finish,nounce) ;
    
  input rst , clk , start , en , finish ;
  input [127:0] word_in , key ;
  
  output reg [63:0] nounce ;
  output reg ready  ;
  output reg [127:0] word_out ;
  
  reg [0:15][0:15][7:0] s_box = '{ { {8'h63} , {8'h7C} , {8'h77} , {8'h7B} , {8'hF2} , {8'h6B} , {8'h6F} , {8'hC5} , {8'h30} , {8'h01} , {8'h67} , {8'h2B} , {8'hFE} , {8'hD7} , {8'hAB} , {8'h76} }
                                 , { {8'hCA} , {8'h82} , {8'hC9} , {8'h7D} , {8'hFA} , {8'h59} , {8'h47} , {8'hF0} , {8'hAD} , {8'hD4} , {8'hA2} , {8'hAF} , {8'h9C} , {8'hA4} , {8'h72} , {8'hC0} }
                                 , { {8'hB7} , {8'hFD} , {8'h93} , {8'h26} , {8'h36} , {8'h3F} , {8'hF7} , {8'hCC} , {8'h34} , {8'hA5} , {8'hE5} , {8'hF1} , {8'h71} , {8'hD8} , {8'h31} , {8'h15} }
                                 , { {8'h04} , {8'hC7} , {8'h23} , {8'hC3} , {8'h18} , {8'h96} , {8'h05} , {8'h9A} , {8'h07} , {8'h12} , {8'h80} , {8'hE2} , {8'hEB} , {8'h27} , {8'hB2} , {8'h75} }
                                 , { {8'h09} , {8'h83} , {8'h2C} , {8'h1A} , {8'h1B} , {8'h6E} , {8'h5A} , {8'hA0} , {8'h52} , {8'h3B} , {8'hD6} , {8'hB3} , {8'h29} , {8'hE3} , {8'h2F} , {8'h84} }
                                 , { {8'h53} , {8'hD1} , {8'h00} , {8'hED} , {8'h20} , {8'hFC} , {8'hB1} , {8'h5B} , {8'h6A} , {8'hCB} , {8'hBE} , {8'h39} , {8'h4A} , {8'h4C} , {8'h58} , {8'hCF} }
                                 , { {8'hD0} , {8'hEF} , {8'hAA} , {8'hFB} , {8'h43} , {8'h4D} , {8'h33} , {8'h85} , {8'h45} , {8'hF9} , {8'h02} , {8'h7F} , {8'h50} , {8'h3C} , {8'h9F} , {8'hA8} }
                                 , { {8'h51} , {8'hA3} , {8'h40} , {8'h8F} , {8'h92} , {8'h9D} , {8'h38} , {8'hF5} , {8'hBC} , {8'hB6} , {8'hDA} , {8'h21} , {8'h10} , {8'hFF} , {8'hF3} , {8'hD2} }
                                 , { {8'hCD} , {8'h0C} , {8'h13} , {8'hEC} , {8'h5F} , {8'h97} , {8'h44} , {8'h17} , {8'hC4} , {8'hA7} , {8'h7E} , {8'h3D} , {8'h64} , {8'h5D} , {8'h19} , {8'h73} }
                                 , { {8'h60} , {8'h81} , {8'h4F} , {8'hDC} , {8'h22} , {8'h2A} , {8'h90} , {8'h88} , {8'h46} , {8'hEE} , {8'hB8} , {8'h14} , {8'hDE} , {8'h5E} , {8'h0B} , {8'hDB} }
                                 , { {8'hE0} , {8'h32} , {8'h3A} , {8'h0A} , {8'h49} , {8'h06} , {8'h24} , {8'h5C} , {8'hC2} , {8'hD3} , {8'hAC} , {8'h62} , {8'h91} , {8'h95} , {8'hE4} , {8'h79} }
                                 , { {8'hE7} , {8'hC8} , {8'h37} , {8'h6D} , {8'h8D} , {8'hD5} , {8'h4E} , {8'hA9} , {8'h6C} , {8'h56} , {8'hF4} , {8'hEA} , {8'h65} , {8'h7A} , {8'hAE} , {8'h08} }
                                 , { {8'hBA} , {8'h78} , {8'h25} , {8'h2E} , {8'h1C} , {8'hA6} , {8'hB4} , {8'hC6} , {8'hE8} , {8'hDD} , {8'h74} , {8'h1F} , {8'h4B} , {8'hBD} , {8'h8B} , {8'h8A} }
                                 , { {8'h70} , {8'h3E} , {8'hB5} , {8'h66} , {8'h48} , {8'h03} , {8'hF6} , {8'h0E} , {8'h61} , {8'h35} , {8'h57} , {8'hB9} , {8'h86} , {8'hC1} , {8'h1D} , {8'h9E} }
                                 , { {8'hE1} , {8'hF8} , {8'h98} , {8'h11} , {8'h69} , {8'hD9} , {8'h8E} , {8'h94} , {8'h9B} , {8'h1E} , {8'h87} , {8'hE9} , {8'hCE} , {8'h55} , {8'h28} , {8'hDF} }
                                 , { {8'h8C} , {8'hA1} , {8'h89} , {8'h0D} , {8'hBF} , {8'hE6} , {8'h42} , {8'h68} , {8'h41} , {8'h99} , {8'h2D} , {8'h0F} , {8'hB0} , {8'h54} , {8'hBB} , {8'h16} } } ;
  
  reg a , run ;
  reg [0:3][7:0] rcon ;
  reg [4:0] state , c1 , c2 , c3 , c4 ;
  reg [63:0] counter , IV ;
  reg [0:3][0:3][7:0] message , rnd_key ; 
  reg [0:3][7:0] nxt_rnd_key  ; 
  reg [0:3][0:3][7:0] mX1 , mX2 , mX3 ; 

  always @(posedge clk) begin
 
    if (rst == 1) begin 
      a <= 0 ;      ready <= 0 ;      word_out <= 0;      run <= 0 ;      state <= 0 ;      c1 <= 0 ;      c2 <= 0 ;      c3 <= 0 ;      c4 <= 0 ;
      message <= 0 ;                  counter <= 0 ;      rnd_key <= 0 ;                    nxt_rnd_key <= 0 ;            rcon <= 0 ;
      mX1 <= 0 ;    mX2 <= 0 ;        mX3 <= 0 ;
      IV <= 64'habac1597df017863 ;
 
    end 
    
    else if (en == 1) begin

      if (run == 0) begin 
        if ((finish == 1)&&(start ==0)) begin 
	  if (a == 0) begin
            IV <= (IV ^ 64'ha0a0b0b0c1c1d2d2)&(64'hfff0fff0fff0ff0f) ;
            counter <= 0 ;
	    a <= 1 ;
	  end
	  
	  else begin 
	    IV <= IV ;
	    counter <= counter ;
	  end
        end

        else if ((finish == 1)&&(start == 1)) begin
 	  run <= 1 ;

          if (a == 1) begin
            counter <= counter + 1 ;
	    a <= 0 ;	
          end

          else begin
            IV <= (IV ^ 64'ha0a0b0b0c1c1d2d2)&(64'hfff0fff0fff0ff0f) ;
            counter <= 1 ;
          end  
        end

	else if ((finish == 0)&&(start == 1)) begin
	  counter <= counter + 1 ;
	  run <= 1 ;
	  a <= 0 ;
	end

	else begin
	  ready <= ready ;
          word_out <= word_out ;
	  counter <= counter ; 
	  a <= 0 ;
        end 
      end
      
      else if (run == 1) begin 
        case (state)
        4'd0 : begin	 
          state <= 1 ;
          message [0][0] <= counter [7:0]     ;    message [1][0] <= counter [15:8]    ;   
          message [2][0] <= counter [23:16]   ;    message [3][0] <= counter [31:24]   ;
          message [0][1] <= counter [39:32]   ;    message [1][1] <= counter [47:40]   ;   
          message [2][1] <= counter [55:48]   ;    message [3][1] <= counter [63:56]   ;
          message [0][2] <= IV [7:0]          ;    message [1][2] <= IV [15:8]         ;   
          message [2][2] <= IV [23:16]        ;    message [3][2] <= IV [31:24]        ;
          message [0][3] <= IV [39:32]        ;    message [1][3] <= IV [47:40]        ;   
          message [2][3] <= IV [55:48]        ;    message [3][3] <= IV [63:56]        ;
      
          rnd_key [0][0] <= key [7:0]     ;    rnd_key [1][0] <= key [15:8]    ;   
          rnd_key [2][0] <= key [23:16]   ;    rnd_key [3][0] <= key [31:24]   ;
          rnd_key [0][1] <= key [39:32]   ;    rnd_key [1][1] <= key [47:40]   ;   
          rnd_key [2][1] <= key [55:48]   ;    rnd_key [3][1] <= key [63:56]   ;
          rnd_key [0][2] <= key [71:64]   ;    rnd_key [1][2] <= key [79:72]   ;   
          rnd_key [2][2] <= key [87:80]   ;    rnd_key [3][2] <= key [95:88]   ;
          rnd_key [0][3] <= key [103:96]  ;    rnd_key [1][3] <= key [111:104] ;   
          rnd_key [2][3] <= key [119:112] ;    rnd_key [3][3] <= key [127:120] ;
          
          c4 <= 0 ;      ready <= 0 ;      nounce <= IV ;
          rcon [0] <= 8'h01 ; rcon [1] <= 0 ; rcon [2] <= 0 ; rcon [3] <= 0 ;
        end
       
                            //initial round
        4'd1 : begin 
          message [0][0] <= message [0][0] ^ rnd_key [0][0] ;    message [1][0] <= message [1][0] ^ rnd_key [1][0] ;   
          message [2][0] <= message [2][0] ^ rnd_key [2][0] ;    message [3][0] <= message [3][0] ^ rnd_key [3][0] ;
          message [0][1] <= message [0][1] ^ rnd_key [0][1] ;    message [1][1] <= message [1][1] ^ rnd_key [1][1] ;   
          message [2][1] <= message [2][1] ^ rnd_key [2][1] ;    message [3][1] <= message [3][1] ^ rnd_key [3][1] ;
          message [0][2] <= message [0][2] ^ rnd_key [0][2] ;    message [1][2] <= message [1][2] ^ rnd_key [1][2] ;   
          message [2][2] <= message [2][2] ^ rnd_key [2][2] ;    message [3][2] <= message [3][2] ^ rnd_key [3][2] ;
          message [0][3] <= message [0][3] ^ rnd_key [0][3] ;    message [1][3] <= message [1][3] ^ rnd_key [1][3] ;   
          message [2][3] <= message [2][3] ^ rnd_key [2][3] ;    message [3][3] <= message [3][3] ^ rnd_key [3][3] ;
                      
          state <= 4'd2 ;
        end
                         
        4'd2 : begin
          if (c1 == 0) begin 
            nxt_rnd_key [0] <= rnd_key [1][3]   ;    nxt_rnd_key [1] <= rnd_key [2][3]    ;   
            nxt_rnd_key [2] <= rnd_key [3][3]   ;    nxt_rnd_key [3] <= rnd_key [0][3]    ;
        
            c1 <= c1 + 1 ;
          end
 
          else if (c1 == 1) begin 
            if (c2 == 0) begin
              nxt_rnd_key [0] <= s_box [nxt_rnd_key[0][7:4]][nxt_rnd_key[0][3:0]] ;
 
              c2 <= c2 +1 ;
            end

            else if (c2 == 1) begin
              nxt_rnd_key [1] <= s_box [nxt_rnd_key[1][7:4]][nxt_rnd_key[1][3:0]] ; 

              c2 <= c2 +1 ;
            end

            else if (c2 == 2) begin
              nxt_rnd_key [2] <= s_box [nxt_rnd_key[2][7:4]][nxt_rnd_key[2][3:0]] ;
 
              c2 <= c2 +1 ;
            end

            else begin
              nxt_rnd_key [3] <= s_box [nxt_rnd_key[3][7:4]][nxt_rnd_key[3][3:0]] ;
 
              c1 <= c1+1 ;      c2 <= 0 ;
            end
          end

          else if (c1 == 2) begin
            rnd_key [0][0] <= rnd_key [0][0] ^ nxt_rnd_key [0] ^ rcon [0] ;
            rnd_key [1][0] <= rnd_key [1][0] ^ nxt_rnd_key [1] ^ rcon [1] ;
            rnd_key [2][0] <= rnd_key [2][0] ^ nxt_rnd_key [2] ^ rcon [2] ;
            rnd_key [3][0] <= rnd_key [3][0] ^ nxt_rnd_key [3] ^ rcon [3] ;

            c1 <= c1+1 ;
          end 

          else if (c1 == 3) begin
            rnd_key [0][1] <= rnd_key [0][1] ^ rnd_key [0][0] ;
            rnd_key [1][1] <= rnd_key [1][1] ^ rnd_key [1][0] ;
            rnd_key [2][1] <= rnd_key [2][1] ^ rnd_key [2][0] ;
            rnd_key [3][1] <= rnd_key [3][1] ^ rnd_key [3][0] ; 

            c1 <= c1+1 ;        
          end 

          else if (c1 == 4) begin
            rnd_key [0][2] <= rnd_key [0][2] ^ rnd_key [0][1] ;
            rnd_key [1][2] <= rnd_key [1][2] ^ rnd_key [1][1] ;
            rnd_key [2][2] <= rnd_key [2][2] ^ rnd_key [2][1] ;
            rnd_key [3][2] <= rnd_key [3][2] ^ rnd_key [3][1] ; 

            c1 <= c1+1 ;        
          end

          else begin
            rnd_key [0][3] <= rnd_key [0][3] ^ rnd_key [0][2] ;
            rnd_key [1][3] <= rnd_key [1][3] ^ rnd_key [1][2] ;
            rnd_key [2][3] <= rnd_key [2][3] ^ rnd_key [2][2] ;
            rnd_key [3][3] <= rnd_key [3][3] ^ rnd_key [3][2] ; 

            c1 <= 0 ;      state <= 4'd3 ;      
          end
          
        end
        
        4'd3 : begin
          if (c1 == 0) begin
            if (c2 == 0) begin  
              message [0][0] <= s_box [message [0][0][7:4]][message [0][0][3:0]] ;

              c2 <= c2+1 ;
            end

            else if (c2 == 1) begin  
              message [0][1] <= s_box [message [0][1][7:4]][message [0][1][3:0]] ;

              c2 <= c2+1 ;
            end

            else if (c2 == 2) begin  
              message [0][2] <= s_box [message [0][2][7:4]][message [0][2][3:0]] ;

              c2 <= c2+1 ;
            end

            else begin  
              message [0][3] <= s_box [message [0][3][7:4]][message [0][3][3:0]] ;

              c2 <= 0 ;      c1 <= c1 + 1 ;
            end
          end

          else if (c1 == 1) begin
            if (c2 == 0) begin  
              message [1][0] <= s_box [message [1][0][7:4]][message [1][0][3:0]] ;

              c2 <= c2+1 ;
            end

            else if (c2 == 1) begin  
              message [1][1] <= s_box [message [1][1][7:4]][message [1][1][3:0]] ;

              c2 <= c2+1 ;
            end

            else if (c2 == 2) begin  
              message [1][2] <= s_box [message [1][2][7:4]][message [1][2][3:0]] ;

              c2 <= c2+1 ;
            end

            else begin  
              message [1][3] <= s_box [message [1][3][7:4]][message [1][3][3:0]] ;

              c2 <= 0 ;      c1 <= c1 + 1 ;
            end
          end

          else if (c1 == 2) begin
            if (c2 == 0) begin  
              message [2][0] <= s_box [message [2][0][7:4]][message [2][0][3:0]] ;

              c2 <= c2+1 ;
            end

            else if (c2 == 1) begin  
              message [2][1] <= s_box [message [2][1][7:4]][message [2][1][3:0]] ;

              c2 <= c2+1 ;
            end

            else if (c2 == 2) begin  
              message [2][2] <= s_box [message [2][2][7:4]][message [2][2][3:0]] ;

              c2 <= c2+1 ;
            end

            else begin  
              message [2][3] <= s_box [message [2][3][7:4]][message [2][3][3:0]] ;

              c2 <= 0 ;      c1 <= c1 + 1 ;
            end
          end

          else  begin
            if (c2 == 0) begin  
              message [3][0] <= s_box [message [3][0][7:4]][message [3][0][3:0]] ;

              c2 <= c2+1 ;
            end

            else if (c2 == 1) begin  
              message [3][1] <= s_box [message [3][1][7:4]][message [3][1][3:0]] ;

              c2 <= c2+1 ;
            end

            else if (c2 == 2) begin  
              message [3][2] <= s_box [message [3][2][7:4]][message [3][2][3:0]] ;

              c2 <= c2+1 ;
            end

            else begin  
              message [3][3] <= s_box [message [3][3][7:4]][message [3][3][3:0]] ;

              c2 <= 0 ;      state <= 4'd4 ;      c1 <= 0 ;
            end
          end

        end
        
        4'd4 : begin
          message [1][0] <= message [1][1] ; message [1][1] <= message [1][2] ; message [1][2] <= message [1][3] ; message [1][3] <= message [1][0] ;
          message [2][0] <= message [2][2] ; message [2][1] <= message [2][3] ; message [2][2] <= message [2][0] ; message [2][3] <= message [2][1] ;
          message [3][0] <= message [3][3] ; message [3][1] <= message [3][0] ; message [3][2] <= message [3][1] ; message [3][3] <= message [3][2] ;

          if (c4 == 9) 
            state <= 4'd6 ;
          
          else 
            state <= 4'd5 ;

        end  
        
        4'd5 : begin
          if (c1 == 0) begin 
            mX2 [0][0] <= message [0][0] << 1    ;   mX2 [1][0] <= message [1][0] << 1 ;
            mX2 [2][0] <= message [2][0] << 1    ;   mX2 [3][0] <= message [3][0] << 1 ;
            mX2 [0][1] <= message [0][1] << 1    ;   mX2 [1][1] <= message [1][1] << 1 ;
            mX2 [2][1] <= message [2][1] << 1    ;   mX2 [3][1] <= message [3][1] << 1 ;
            mX2 [0][2] <= message [0][2] << 1    ;   mX2 [1][2] <= message [1][2] << 1 ;
            mX2 [2][2] <= message [2][2] << 1    ;   mX2 [3][2] <= message [3][2] << 1 ;
            mX2 [0][3] <= message [0][3] << 1    ;   mX2 [1][3] <= message [1][3] << 1 ;
            mX2 [2][3] <= message [2][3] << 1    ;   mX2 [3][3] <= message [3][3] << 1 ;

	    mX1 [0][0] <= message [0][0] 	; mX1 [1][0] <= message [1][0] ;
            mX1 [2][0] <= message [2][0] 	; mX1 [3][0] <= message [3][0] ;
	    mX1 [0][1] <= message [0][1] 	; mX1 [1][1] <= message [1][1] ;
            mX1 [2][1] <= message [2][1] 	; mX1 [3][1] <= message [3][1] ;
	    mX1 [0][2] <= message [0][2] 	; mX1 [1][2] <= message [1][2] ;
            mX1 [2][2] <= message [2][2] 	; mX1 [3][2] <= message [3][2] ;
	    mX1 [0][3] <= message [0][3] 	; mX1 [1][3] <= message [1][3] ;
            mX1 [2][3] <= message [2][3]	; mX1 [3][3] <= message [3][3] ;
          
            c1 <= c1 + 1 ;
          end
         
          else if (c1 == 1) begin
            if (c2 == 0) begin 
                if (message [0][0][7])
                  mX2 [0][0] <= mX2 [0][0] ^ 8'b00011011 ;
                else 
                  mX2 [0][0] <= mX2 [0][0] ;

            c2 <= c2 + 1 ;
            end

            else if (c2 == 1) begin 
                if (message [1][0][7])
                  mX2 [1][0] <= mX2 [1][0] ^ 8'b00011011 ;
                else 
                  mX2 [1][0] <= mX2 [1][0] ;

            c2 <= c2 + 1 ;
            end

            else if (c2 == 2) begin 
                if (message [2][0][7])
                  mX2 [2][0] <= mX2 [2][0] ^ 8'b00011011 ;
                else 
                  mX2 [2][0] <= mX2 [2][0] ;

            c2 <= c2 + 1 ;
            end

            else if (c2 == 3) begin 
                if (message [3][0][7])
                  mX2 [3][0] <= mX2 [3][0] ^ 8'b00011011 ;
                else 
                  mX2 [3][0] <= mX2 [3][0] ;

            c2 <= c2 + 1 ;
            end

            else if (c2 == 4) begin 
                if (message [0][1][7])
                  mX2 [0][1] <= mX2 [0][1] ^ 8'b00011011 ;
                else 
                  mX2 [0][1] <= mX2 [0][1] ;

            c2 <= c2 + 1 ;
            end

            else if (c2 == 5) begin 
                if (message [1][1][7])
                  mX2 [1][1] <= mX2 [1][1] ^ 8'b00011011 ;
                else 
                  mX2 [1][1] <= mX2 [1][1] ;

            c2 <= c2 + 1 ;
            end

            else if (c2 == 6) begin 
                if (message [2][1][7])
                  mX2 [2][1] <= mX2 [2][1] ^ 8'b00011011 ;
                else 
                  mX2 [2][1] <= mX2 [2][1] ;

            c2 <= c2 + 1 ;
            end

            else if (c2 == 7) begin 
                if (message [3][1][7])
                  mX2 [3][1] <= mX2 [3][1] ^ 8'b00011011 ;
                else 
                  mX2 [3][1] <= mX2 [3][1] ;

            c2 <= c2 + 1 ;
            end

            else if (c2 == 8) begin 
                if (message [0][2][7])
                  mX2 [0][2] <= mX2 [0][2] ^ 8'b00011011 ;
                else 
                  mX2 [0][2] <= mX2 [0][2] ;

            c2 <= c2 + 1 ;
            end

            else if (c2 == 9) begin 
                if (message [1][2][7])
                  mX2 [1][2] <= mX2 [1][2] ^ 8'b00011011 ;
                else 
                  mX2 [1][2] <= mX2 [1][2] ;

            c2 <= c2 + 1 ;
            end

            else if (c2 == 10) begin 
                if (message [2][2][7])
                  mX2 [2][2] <= mX2 [2][2] ^ 8'b00011011 ;
                else 
                  mX2 [2][2] <= mX2 [2][2] ;

            c2 <= c2 + 1 ;
            end

            else if (c2 == 11) begin 
                if (message [3][2][7])
                  mX2 [3][2] <= mX2 [3][2] ^ 8'b00011011 ;
                else 
                  mX2 [3][2] <= mX2 [3][2] ;

            c2 <= c2 + 1 ;
            end

            else if (c2 == 12) begin 
                if (message [0][3][7])
                  mX2 [0][3] <= mX2 [0][3] ^ 8'b00011011 ;
                else 
                  mX2 [0][3] <= mX2 [0][3] ;

            c2 <= c2 + 1 ;
            end

            else if (c2 == 13) begin 
                if (message [1][3][7])
                  mX2 [1][3] <= mX2 [1][3] ^ 8'b00011011 ;
                else 
                  mX2 [1][3] <= mX2 [1][3] ;

            c2 <= c2 + 1 ;
            end

            else if (c2 == 14) begin 
                if (message [2][3][7])
                  mX2 [2][3] <= mX2 [2][3] ^ 8'b00011011 ;
                else 
                  mX2 [2][3] <= mX2 [2][3] ;

            c2 <= c2 + 1 ;
            end

            else begin 
                if (message [3][3][7])
                  mX2 [3][3] <= mX2 [3][3] ^ 8'b00011011 ;
                else 
                  mX2 [3][3] <= mX2 [3][3] ;

            c2 <= 0 ;      c1 <= c1 + 1 ;
            end
          end
          
          else if (c1 == 2) begin
            mX3 [0][0] <= message [0][0] ^  mX2 [0][0] ;	mX3 [1][0] <= message [1][0] ^  mX2 [1][0] ;
            mX3 [2][0] <= message [2][0] ^  mX2 [2][0] ;	mX3 [3][0] <= message [3][0] ^  mX2 [3][0] ;
            mX3 [0][1] <= message [0][1] ^  mX2 [0][1] ;	mX3 [1][1] <= message [1][1] ^  mX2 [1][1] ;
            mX3 [2][1] <= message [2][1] ^  mX2 [2][1] ;	mX3 [3][1] <= message [3][1] ^  mX2 [3][1] ;
            mX3 [0][2] <= message [0][2] ^  mX2 [0][2] ;	mX3 [1][2] <= message [1][2] ^  mX2 [1][2] ;
            mX3 [2][2] <= message [2][2] ^  mX2 [2][2] ;	mX3 [3][2] <= message [3][2] ^  mX2 [3][2] ;
            mX3 [0][3] <= message [0][3] ^  mX2 [0][3] ;	mX3 [1][3] <= message [1][3] ^  mX2 [1][3] ;
            mX3 [2][3] <= message [2][3] ^  mX2 [2][3] ;	mX3 [3][3] <= message [3][3] ^  mX2 [3][3] ;

            c1 <= c1 + 1 ;
          end

          else begin
            message [0][0] <= mX2 [0][0] ^ mX3 [1][0] ^ mX1 [2][0] ^ mX1 [3][0] ;
            message [1][0] <= mX1 [0][0] ^ mX2 [1][0] ^ mX3 [2][0] ^ mX1 [3][0] ;
            message [2][0] <= mX1 [0][0] ^ mX1 [1][0] ^ mX2 [2][0] ^ mX3 [3][0] ;
            message [3][0] <= mX3 [0][0] ^ mX1 [1][0] ^ mX1 [2][0] ^ mX2 [3][0] ;

            message [0][1] <= mX2 [0][1] ^ mX3 [1][1] ^ mX1 [2][1] ^ mX1 [3][1] ;
            message [1][1] <= mX1 [0][1] ^ mX2 [1][1] ^ mX3 [2][1] ^ mX1 [3][1] ;
            message [2][1] <= mX1 [0][1] ^ mX1 [1][1] ^ mX2 [2][1] ^ mX3 [3][1] ;
            message [3][1] <= mX3 [0][1] ^ mX1 [1][1] ^ mX1 [2][1] ^ mX2 [3][1] ;

            message [0][2] <= mX2 [0][2] ^ mX3 [1][2] ^ mX1 [2][2] ^ mX1 [3][2] ;
            message [1][2] <= mX1 [0][2] ^ mX2 [1][2] ^ mX3 [2][2] ^ mX1 [3][2] ;
            message [2][2] <= mX1 [0][2] ^ mX1 [1][2] ^ mX2 [2][2] ^ mX3 [3][2] ;
            message [3][2] <= mX3 [0][2] ^ mX1 [1][2] ^ mX1 [2][2] ^ mX2 [3][2] ;

            message [0][3] <= mX2 [0][3] ^ mX3 [1][3] ^ mX1 [2][3] ^ mX1 [3][3] ;
            message [1][3] <= mX1 [0][3] ^ mX2 [1][3] ^ mX3 [2][3] ^ mX1 [3][3] ;
            message [2][3] <= mX1 [0][3] ^ mX1 [1][3] ^ mX2 [2][3] ^ mX3 [3][3] ;
            message [3][3] <= mX3 [0][3] ^ mX1 [1][3] ^ mX1 [2][3] ^ mX2 [3][3] ;
 
            c1 <= 0 ;      state <= 4'd6 ;
          end

        end
        
        4'd6 : begin
          message [0][0] <= message [0][0] ^ rnd_key [0][0] ;    message [1][0] <= message [1][0] ^ rnd_key [1][0] ;   
          message [2][0] <= message [2][0] ^ rnd_key [2][0] ;    message [3][0] <= message [3][0] ^ rnd_key [3][0] ;
          message [0][1] <= message [0][1] ^ rnd_key [0][1] ;    message [1][1] <= message [1][1] ^ rnd_key [1][1] ;   
          message [2][1] <= message [2][1] ^ rnd_key [2][1] ;    message [3][1] <= message [3][1] ^ rnd_key [3][1] ;
          message [0][2] <= message [0][2] ^ rnd_key [0][2] ;    message [1][2] <= message [1][2] ^ rnd_key [1][2] ;   
          message [2][2] <= message [2][2] ^ rnd_key [2][2] ;    message [3][2] <= message [3][2] ^ rnd_key [3][2] ;
          message [0][3] <= message [0][3] ^ rnd_key [0][3] ;    message [1][3] <= message [1][3] ^ rnd_key [1][3] ;   
          message [2][3] <= message [2][3] ^ rnd_key [2][3] ;    message [3][3] <= message [3][3] ^ rnd_key [3][3] ;
         
          state <= 4'd7 ;
        end
        
        4'd7 : begin
          if (c4 == 0) begin 
            rcon [0] <= 8'h02 ;      state <= 4'd2 ;      c4 <= c4+1 ;
          end
          
          else if (c4 == 1) begin 
            rcon [0] <= 8'h04 ;      state <= 4'd2 ;      c4 <= c4+1 ;
          end
        
          else if (c4 == 2) begin 
            rcon [0] <= 8'h08 ;      state <= 4'd2 ;      c4 <= c4+1 ;
          end
          
          else if (c4 == 3) begin 
            rcon [0] <= 8'h10 ;      state <= 4'd2 ;      c4 <= c4+1 ;
          end
          
          else if (c4 == 4) begin 
            rcon [0] <= 8'h20 ;      state <= 4'd2 ;      c4 <= c4+1 ;
          end
          
          else if (c4 == 5) begin 
            rcon [0] <= 8'h40 ;      state <= 4'd2 ;      c4 <= c4+1 ;
          end
          
          else if (c4 == 6) begin 
            rcon [0] <= 8'h80 ;      state <= 4'd2 ;      c4 <= c4+1 ;
          end
          
          else if (c4 == 7) begin 
            rcon [0] <= 8'h1b ;      state <= 4'd2 ;      c4 <= c4+1 ;
          end
          
          else if (c4 == 8)begin 
            rcon [0] <= 8'h36 ;      state <= 4'd2 ;      c4 <= c4+1 ;
          end

          else
            state <= 4'd8 ;
            
        end
        
        4'd8 : begin
          word_out [7:0] <= message [0][0] ^ word_in [7:0]           ;   word_out [15:8] <= message [1][0] ^ word_in [15:8]         ;
          word_out [23:16] <= message [2][0] ^ word_in [23:16]       ;   word_out [31:24] <= message [3][0] ^ word_in [31:24]       ;
          word_out [39:32] <= message [0][1] ^ word_in [39:32]       ;   word_out [47:40] <= message [1][1] ^ word_in [47:40]       ;
          word_out [55:48] <= message [2][1] ^ word_in [55:48]       ;   word_out [63:56] <= message [3][1] ^ word_in [63:56]       ;
          word_out [71:64] <= message [0][2] ^ word_in [71:64]       ;   word_out [79:72] <= message [1][2] ^ word_in [79:72]       ;
          word_out [87:80] <= message [2][2] ^ word_in [87:80]       ;   word_out [95:88] <= message [3][2] ^ word_in [95:88]       ;
          word_out [103:96] <= message [0][3] ^ word_in [103:96]     ;   word_out [111:104] <= message [1][3] ^ word_in [111:104]   ;
          word_out [119:112] <= message [2][3] ^ word_in [119:112]   ;   word_out [127:120] <= message [3][3] ^ word_in [127:120]   ; 
          
          run <= 0 ;      state <= 4'd0 ;      ready <= 1 ;
	end
        
        endcase 
      end
    end  
    
    else begin 
      ready <= ready ;      word_out <= word_out ;    
    end 
    
  end
    
endmodule 

