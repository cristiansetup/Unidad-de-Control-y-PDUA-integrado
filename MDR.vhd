-------------------------------------------------------
-- MDR
-- Cristian Durán
--	Organización de computadores
--	06-06-2022
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

ENTITY MDR IS 
	GENERIC( MAX_WIDTH  : integer:=2;
				DATA_WIDTH  : integer:=8);
		      
	PORT(    clock            : IN  STD_LOGIC;											 --Reloj del sistema
				data_ex_in       : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0); 	 --Data que entra al MDR									 
			   mdr_alu_n        : IN  STD_LOGIC;   
				mdr_en			  : IN  STD_LOGIC;
				reset				  : IN  STD_LOGIC;--Reset de los registros
				
				dq					  : INOUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0); -- entrada salida
				Bus_data_out	  : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)   --Data que sale del MDR
	
		); 
END ENTITY;

ARCHITECTURE RTL of MDR IS
	
		SIGNAL	ena        :  STD_LOGIC;   										 
		SIGNAL	rst        :  STD_LOGIC;
		SIGNAL	clk        :  STD_LOGIC;
		SIGNAL	data0	     :  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		SIGNAL	q0	        :  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		SIGNAL	data1	     :  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		SIGNAL	q1	        :  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
		
		
BEGIN
		
		rst   			<= reset;
		clk   			<= clock;
		ena   			<= mdr_en;
		data0 			<= dq;
		Bus_data_out   <= q0;
		data1				<= data_ex_in;
				
		
		dq 	<= q1 WHEN mdr_alu_n = '1' ELSE (OTHERS => 'Z');
		
		dff0: PROCESS(clock, reset, mdr_en)
		BEGIN	
			IF(reset = '1') THEN
				q0 <= (OTHERS => '0');
			ELSIF (rising_edge(clock)) THEN
				IF (mdr_en = '1') THEN
					q0 <= data0;
				END IF;
			END IF;
		END PROCESS dff0;
		
			
		dff1: PROCESS(clock, reset, mdr_en)
		BEGIN	
			IF(reset = '1') THEN
				q1 <= (OTHERS => '0');
			ELSIF (rising_edge(clock)) THEN
				IF (mdr_en = '1') THEN
					q1 <= data1;
				END IF;
			END IF;
		END PROCESS dff1;

END ARCHITECTURE;

