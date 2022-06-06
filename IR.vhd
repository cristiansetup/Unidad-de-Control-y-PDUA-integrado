-------------------------------------------------------
-- IR
-- Cristian Durán
--	Organización de computadores
--	06-06-2022
-------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY IR IS 
	GENERIC (MAX_WIDTH : INTEGER:=4); 
	PORT (clk    		: IN STD_LOGIC; 
			reset  		: IN STD_LOGIC; 
			ir_en  		: IN STD_LOGIC;
			sclr        : IN STD_LOGIC;
			d      		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			q      		: OUT STD_LOGIC_VECTOR(MAX_WIDTH DOWNTO 0)
			);
END ENTITY;

-------

ARCHITECTURE rtl of IR is 
BEGIN
	dff: PROCESS(clk, d, sclr)
	BEGIN
		IF(sclr = '1') THEN
			q <= (OTHERS => '0');
		ELSIF(rising_edge(clk)) THEN
			IF (ir_en = '1') THEN 
			  q <= d(MAX_WIDTH DOWNTO 0);
			
			END IF;
	   END IF;
	END PROCESS;

END ARCHITECTURE;

