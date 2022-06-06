-------------------------------------------------------
-- PDUA_tb
-- Cristian Durán
--	Organización de computadores
--	06-06-2022
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY PDUA_tb IS
END ENTITY PDUA_tb;

ARCHITECTURE testbench OF PDUA_tb IS
		
	SIGNAL BUSC				:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- bus interconex con dq, mar e IR 
	SIGNAL CONTROL_UNIT 	: 	STD_LOGIC_VECTOR(7 DOWNTO 0);	-- seÃ±al unidad ctr
	SIGNAL ADDRESS_BUS	:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- bus dir
	SIGNAL BUSA				:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- BUSA
	SIGNAL BUSB				:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- BUSB
	SIGNAL BUS_DATA_OUT	:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- bus datos salida
	SIGNAL BUS_DATA_IN	:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- bus datos entrada
	SIGNAL mdr_en			:	STD_LOGIC := '0'; -- mdr_en
	SIGNAL mdr_alu_n		:	STD_LOGIC := '0'; -- mdr_alu_n
	SIGNAL ir_en			:	STD_LOGIC := '0'; -- ir-en
	SIGNAL mar_en			:	STD_LOGIC := '0'; -- enable mar
	SIGNAL bank_wr_en		: 	STD_LOGIC := '0'; -- enable banco rtas
	SIGNAL BusB_addr		:	STD_LOGIC_VECTOR(2 DOWNTO 0):= (OTHERS => '0'); -- vector dirs busb
	SIGNAL BusC_addr		:	STD_LOGIC_VECTOR(2 DOWNTO 0):= (OTHERS => '0'); -- vector dirs busc
	SIGNAL wr_rdn        :  STD_LOGIC := '0';-- enable write = 1, read = 1
	SIGNAL C             :  STD_LOGIC;-- carry
	SIGNAL N             :  STD_LOGIC;-- negativo
	SIGNAL P             :  STD_LOGIC;-- paridad
	SIGNAL Z             :  STD_LOGIC;-- cero
	SIGNAL rst           :  STD_LOGIC;-- reset
	SIGNAL selop         :  STD_LOGIC_VECTOR(2 DOWNTO 0); -- selector op
   SIGNAL shamt         :  STD_LOGIC_VECTOR(1 DOWNTO 0); -- desp
	SIGNAL enaf          :  STD_LOGIC;-- enable
	SIGNAL clk           :  STD_LOGIC := '0'; 
	SIGNAL reset         :  STD_LOGIC := '1'; 
	SIGNAL INT           :  STD_LOGIC := '0';
	SIGNAL per_in        :  STD_LOGIC_VECTOR(7 DOWNTO 0):= (OTHERS => '0');
	SIGNAL per_out_led1  :  STD_LOGIC;
	SIGNAL per_out_led2  :  STD_LOGIC;
	SIGNAL per_out_led3  :  STD_LOGIC; 
	SIGNAL int_clr       :  STD_LOGIC;
	SIGNAL opcode        :  STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL U_I           :  STD_LOGIC_VECTOR(20 DOWNTO 0);
	SIGNAL q             :  STD_LOGIC;
	SIGNAL iom           :  STD_LOGIC;
	SIGNAL ir_clr        :  STD_LOGIC;
	SIGNAL external_bus  :  STD_LOGIC;
	SIGNAL addr          :  STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL dataout       :  STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL datainmem     :  STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL rdata         :  STD_LOGIC_VECTOR(20 DOWNTO 0);
	
	
BEGIN 
		
		DUT: ENTITY WORK.PDUA
			PORT MAP(clk                => clk,
						reset              => reset,
						INT		          => INT,			
						per_in             => per_in,
						per_out_led1       => per_out_led1,
						per_out_led2       => per_out_led2,
						per_out_led3       => per_out_led3,
						rdata              => rdata
			);
			
			
						clk <= not clk after 10ns;
						reset <= '0' after 20ns;
					   INT  <= '1' after 50ns;
						per_in <= not per_in after 250ns;
						rdata <=  "000000000001000000000" after 70ns, -- FETCH Jint 100 
									 "000000100000000000000" after 90ns, -- MAR <--PC
									 "000000000000000000000" after 110ns, 
									 "001100010000000100000" after 130ns, -- MDR <-- bus_datain 
									 "000001000000001000000" after 150ns, -- IR <--MDR
									 "000000000000000000000" after 170ns, -- MDR <--PC
									 -- aca finaliza Fetch 
									 "000000011110110001010" after 190ns, -- MOV ACC,A
								    -- mov acc, cte
									 "000000100000000000000" after 210ns, -- MAR <-- PC
									 "000000000000000000000" after 230ns, --
									 "001100010000000100000" after 250ns, -- MDR <-- bus_datain
									 "000000011110001000010" after 270ns, -- ACC <- MDR
									 -- mov ACC, [DPTR] 
									 "000000100000100000000" after 290ns, -- MAR <- DPTR
									 "000000100000100000000" after 310ns, -- MDR <- bus_datain
									 "000000011110001000010" after 330ns, -- ACC <- MDR 
									 -- ADD ACC, A
									 "000000000000000000000" after 350ns,
									 "001010011110110001000" after 370ns, -- ACC <- ACC + A
									 -- MOV DPTR, ACC
									 "000000000000000000000" after 390ns,
									 "000000010101110001000" after 410ns, -- DPTR = ACC
									 -- INV ACC
									 "000010100000000001000" after  430ns,
									-- MOV [DPTR],ACC
									 "000000100000100000111" after  450ns, -- MAR <- DPTR
									 "000000010011111011100" after  470ns, -- MAR = ACC
									-- AND ACC, A
									 "000100010101000001000" after 500ns, 
									 -- MOV A, ACC
									 "000000010111110001011" after 530ns, -- MOV A,ACC
									 -- JMP DIR 
									 "000000100000000000111" after 550ns,
									 "001100010000000100111" after 570ns,
									 "000000100010000000100" after 590ns,
									 "000000000000000000000" after 610ns,
									 -- JZ DIR
									 "000000000000000000011" after 630ns,
									 "000000010100000000000" after 650ns,
									 "000000100000100000111" after 670ns,
									 "000001000010001100100" after 690ns,
									 "000000000000000000000" after 710ns,
									 -- JN DIR 
									 "000000000000000000011" after 730ns,
									 "000001000000001000000" after 750ns,
									 "000000100000010000111" after 770ns,
									 "000001000010001100100" after 790ns,
									 "000000000000000000000"  after 810ns,
									 -- JC DIR
									 "000000000000000000000" after 830ns,
									 "001100010000000000010" after 850ns,
									 "000000100000000000000" after 870ns,
									 "000000000000001100000" after 890ns,
									 "000000010000000100010" after 910ns,
									-- CALL DIR  
									 "000000100000010000111" after 930ns,
									 "000000010011000100111" after 950ns,
									 "000000010010010000111" after 970ns,
									 "000000100000010000111" after 990ns,
									 "000000000000011110111" after 1010ns,
									 "000000010000100000111" after 1030ns,
									 "000000010000000000000" after 1050ns,
									 "000000000000000000000" after 1070ns,
									 -- RET 
									 "000000011101110000011" after 1090ns,
									 "000000011110100000011" after 1110ns,
									 "000000010101100000011" after 1130ns,
									 "000000100000100000111" after 1150ns,
									 "000000010010001100111" after 1170ns,
									 "000000011111010000000" after 1190ns,
									 -- MOV A, [DPTR]
									 "000000100000100000000" after 1210ns,
									 "000001001110001100000" after 1230ns,
									 "000001000111110001000" after 1250ns,
									 "000000000000000000000" after 1270ns,
									 -- PUSH ACC 
									 "000000100001000000101" after 1290ns,
									 "000000011110001000010" after 1310ns,
									 "001100010010010001100" after 1330ns,
									 "000000000000000000000" after 1350ns,
									 -- POP ACC
									 "000000101110100000100" after 1370ns,
									 "101000010011100000100" after 1390ns,
									 "000000100001000000101" after 1410ns,
									 "000001001110001100000" after 1430ns,
									 "000000000000000000000" after 1450ns,
									 -- ROTD A
									 "110000000000000001000" after 1470ns,
									 "000000000000000000000" after 1490ns,
									 -- ROTD ACC
									 "110000000001110001000" after 1510ns,
									 "000000000000000000000" after 1530ns,
									 -- PASAR ACC
									 "000000000001110001000" after 1550ns,
									 "000000000000000000000" after 1570ns,
									 -- SUB ACC,A
									 "001100010110110001011" after 1590ns,
									 "001010011110110001000" after 1610ns,
									 "000000000000000000000" after 1630ns,
									 -- DESPL ACC
									 "100000011111110001000" after 1650ns,
									 "000000000000000000000" after 1670ns,
									 -- DEC ACC
									 "001010011111100001000" after 1690ns,
									 "000000000000000000000" after 1710ns,
									 -- MOV [DPTR],CTE,--- Es la unión de MOV ACC, CTE y MOV[DPTR],ACC
									 "000000100000000000000" after 1730ns,
									 "001100010000000000010" after 1750ns,
									 "000000011110001100100" after 1770ns,
									 "000000100000100000000" after 1790ns,
									 "000001000001111111100" after 1810ns,
									 "000000000000000000000" after 1830ns,
									 -- MOV DPTR,CTE
									 "000000100000000000000" after 1850ns,
									 "001100010000000000010" after 1870ns,
									 "000000011110001100100" after 1890ns,
									 "000001000001111111100" after 1910ns,
									 "000000000000000000000" after 1930ns,
									 -- DEC [DPTR]
									 "000000100000100000000" after 1950ns,
									 "000001001110001100000" after 1970ns,
									 "001010011111100001000" after 1990ns,
									 "000000100000100000000" after 2010ns,
									 "000001000001111111100" after 2030ns,
									 "000000000000000000000" after 2050ns,
									 -- AND A, CTE
									 "000000100000000000000" after 2070ns,
									 "001100010000000000010" after 2090ns,
									 "000000011110001100100" after 2110ns,
									 "000100011110110001000" after 2130ns,
									 "000000011111110001000" after 2150ns,
									 "000000000000000000000" after 2170ns,
									 -- MOV [DPTR],A
									 "000000011110110001010" after 2190ns,
									 "000000100000100000000" after 2210ns,
									 "000001000001111111100" after 2230ns,
									 "000000000000000000000" after 2250ns,
									 -- STRMEM DIR, CTE 
									 "000000100000000000000" after 2270ns,
									 "001100010000000000010" after 2290ns,
									 "000001000001111111100" after 2310ns,
									 "000000100000000000000" after 2330ns,
									 "001100010000000000010" after 2350ns,
									 "000000011110001100100" after 2370ns,
									 "000000100000100000000" after 2390ns,
									 "000001000001111111100" after 2410ns; ---
									
END ARCHITECTURE;          

									