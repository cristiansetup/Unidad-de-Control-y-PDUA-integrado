-------------------------------------------------------
-- Registro de inicialización
-- Cristian Durán
--	Organización de computadores
--	06-06-2022
-------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY INT_REG IS 
	PORT(clk         : IN STD_LOGIC;
		  int_clr     : IN STD_LOGIC;
	     INT         : IN STD_LOGIC;
	     d           : IN STD_LOGIC;

	     q     : OUT STD_LOGIC
	  );


END ENTITY INT_REG;

ARCHITECTURE RTL OF INT_REG IS

	SIGNAL ena   : STD_LOGIC;
	
	BEGIN 
	
	dff: PROCESS(clk, int_clr, d, INT)
	BEGIN 
		IF(int_clr = '1') THEN 
			q  <= '0';
		ELSIF(rising_edge(clk)) THEN 
			IF(ena = '1') THEN 
				q  <= '1';
			ELSIF (INT = '1') THEN 
			   q  <= d;
			END IF;
		END IF;
	END PROCESS;
	

END ARCHITECTURE;  
	