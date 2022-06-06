-------------------------------------------------------
-- UPC
-- Cristian Durán
--	Organización de computadores
--	06-06-2022
-------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY upc IS 
	PORT(clk         : IN STD_LOGIC;
		  clr_uPC     : IN STD_LOGIC;
	     en_uPC      : IN STD_LOGIC;
	     d           : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	     rst 	     : IN STD_LOGIC;
	     q           : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	  );


END ENTITY upc;

ARCHITECTURE RTL OF upc IS

	
	
	BEGIN 
	
	dff: PROCESS(clk, rst, d, clr_uPC)
	BEGIN 
		IF(rst = '1') THEN 
			q <= "000";
		ELSIF(rising_edge(clk)) THEN 
			IF(clr_uPC = '1') THEN 
				q <= "000";
			ELSIF (en_uPC = '1') THEN 
			   q <= d;
			END IF;
		END IF;
	END PROCESS;
	

END ARCHITECTURE;  
	