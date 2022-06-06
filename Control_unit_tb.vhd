LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Control_unit_tb IS
END ENTITY Control_unit_tb;

ARCHITECTURE testbench of Control_unit_tb IS 

		SIGNAL clk 		: STD_LOGIC := '0'; -- inicialización del reloj 
		SIGNAL rst 		: STD_LOGIC := '1'; -- reset 
		SIGNAL int 		: STD_LOGIC := '0'; -- interrupcion
		SIGNAL C   		: STD_LOGIC := '0'; -- carry
		SIGNAL N   		: STD_LOGIC := '0'; -- negativo
		SIGNAL P   		: STD_LOGIC := '0'; -- paridad
		SIGNAL Z   		: STD_LOGIC := '0'; -- cero
		SIGNAL OPCODE	: STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0'); -- opcode inicial
		SIGNAL U_I   	: STD_LOGIC_VECTOR(20 DOWNTO 0); -- U_I 
		SIGNAL uaddr   : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0'); -- microdirecciones


BEGIN 

				DUT: ENTITY WORK.Control_unit
					PORT MAP(clk        => clk, -- reloj
								rst        => rst, -- reset
								int        => int,  -- interrupcion
								C          =>  C, -- carry
								N          =>  N, -- negativo
								P          =>  P, -- paridad
								Z          =>  Z, -- cero 
								opcode     =>  OPCODE, -- opcODE
								U_I        =>  U_I  
				);
				
				clk 		<= NOT clk after 10ns; -- reloj a 50MHZ
				rst 		<= '0' after 20ns; -- reset 
				int 		<= '1' after 50ns; -- interrupcion a 50ns
				C   		<= '1' after 150ns; -- carry 
			   P   		<= '1' after 200ns;
			   N   		<= '1' after 250ns;
			   Z   		<= '1' after 300ns;
			   OPCODE 	<= "00000" after 90ns, -- FETCH
				            "00001" after 190ns, -- MOV ACC,A
								"00010" after 210ns, -- MOV A, ACC
				            "00011" after 230ns, -- MOV ACC, CTE
								"00100" after 290ns, -- MOV ACC, [DPTR]
								"00101" after 350ns, -- MOV DPTR, ACC
								"00110" after 370ns, -- MOV [DPTR], ACC
								"00111" after 410ns, -- INV ACC
								"01000" after 430ns, -- AND ACC, A
								"01001" after 450ns, -- ADD ACC, A						
								"01010" after 470ns, -- JMP DIR
								"01011" after 530ns, -- JZ DIR
								"01100" after 610ns, -- JN DIR 
								"01101" after 690ns, -- JC DIR 
								"01110" after 790ns, -- CALL DIR 
								"01111" after 930ns, -- RET
								"10000" after 1030ns, -- MOV A, [DPTR]
								"10001" after 1110ns, -- PUSH ACC
								"10010" after 1170ns, -- POP ACC
								"10011" after 1250ns, -- ROTD A
								"10100" after 1270ns, -- ROTD ACC
								"10101" after 1290ns, -- Pasar ACC
								"10110" after 1310ns, -- SUB ACC, A
								"11000" after 1350ns, -- DESPL ACC
								"11001" after 1370ns, -- DEC ACC
								"11010" after 1390ns, -- MOV [DPTR], CTE 
								"11011" after 1490ns, -- MOV DPTR, CTE
								"11100" after 1570ns, -- DEC[DPTR]
							   "11101" after 1670ns, -- AND A, CTE
							   "11110" after 1790ns, -- MOV [DPTR], A
							   "11111" after 1850ns; -- STRMEM DIR, CTE 
				
					uaddr <= "00000000" after 70ns,
								"00000001" after 90ns,
								"00000010" after 110ns,
								"00000011" after 130ns,
								"00000100" after 150ns,
								"00000101" after 170ns,
								"00001000" after 190ns,
								"00010000" after 210ns,
								"00011000" after 230ns,
								"00011001" after 250ns,
								"00011010" after 270ns,
								"00100000" after 290ns,
								"00100001" after 310ns,
								"00100010" after 330ns,
								"00101000" after 350ns,
								"00110000" after 370ns,
								"00110001" after 390ns,
								"00111000" after 410ns,
								"01000000" after 430ns,
								"01001000" after 450ns,
								"01010000" after 470ns,
								"01010001" after 490ns,
								"01010010" after 510ns,
								"01011000" after 530ns,
								"01011001" after 550ns,
								"01011010" after 570ns,
								"01011011" after 590ns,
								"01100000" after 610ns,
								"01100001" after 630ns,
								"01100010" after 650ns,
								"01100011" after 670ns,
							   "01101000" after 690ns,
							   "01101001" after 710ns,
							   "01101010" after 730ns,
							   "01101011" after 750ns,
							   "01101100" after 770ns,
							   "01110000" after 790ns,	
								"01110001" after 810ns,
								"01110010" after 830ns,
								"01110011" after 850ns,
								"01110100" after 870ns,
								"01110101" after 890ns,
								"01110110" after 910ns,
								"01111000" after 930ns,
								"01111001" after 950ns,
								"01111010" after 970ns,
								"01111011" after 990ns,
								"01111100" after 1010ns,
								"01111110" after 1030ns,
								"10000000" after 1050ns,
								"10000001" after 1070ns,
								"10000010" after 1090ns,
								"10001000" after 1110ns,
								"10001001" after 1130ns,
								"10001010" after 1150ns,
								"10010000" after 1170ns,
								"10010001" after 1190ns,
								"10010010" after 1210ns,
								"10010011" after 1230ns,
								"10011000" after 1250ns,
								"10100000" after 1270ns,
								"10101000" after 1290ns,
								"10110000" after 1310ns,
								"10110001" after 1330ns,
								"11000000" after 1350ns,
								"11001000" after 1370ns,
								"11010000" after 1390ns,
								"11010001" after 1410ns,
								"11010010" after 1430ns,
								"11010011" after 1450ns,
								"11010100" after 1470ns,
								"11011000" after 1490ns,
								"11011001" after 1510ns,
								"11011010" after 1530ns,
								"11011011" after 1550ns,
							   "11100000" after 1570ns,
								"11100001" after 1590ns,
								"11100010" after 1610ns,
								"11100011" after 1630ns,
								"11100100" after 1650ns,
								"11101000" after 1670ns,
								"11101001" after 1690ns,
								"11101001" after 1710ns,
								"11101010" after 1730ns,
								"11101011" after 1750ns,
								"11101100" after 1770ns,
								"11110000" after 1790ns,
								"11110001" after 1810ns,
								"11110010" after 1830ns,
								"11111000" after 1850ns,
								"11111001" after 1870ns,
								"11111010" after 1890ns,
								"11111011" after 1910ns,
								"11111100" after 1930ns,
								"11111101" after 1950ns,
								"11111110" after 1970ns,
								"11111111" after 1990ns;
								
								
							
END ARCHITECTURE; 								
					