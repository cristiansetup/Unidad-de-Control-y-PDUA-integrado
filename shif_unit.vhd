-------------------------------------------------------
-- Shif_unit
-- Cristian Durán
--	Organización de computadores
--	06-06-2022
-------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY shif_unit IS 
	GENERIC (N : INTEGER :=8);

	PORT( clk     : IN STD_LOGIC;
			shamt   : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		   dataa   : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			dataout : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	);
	END ENTITY shif_unit;
	----
	ARCHITECTURE rtl OF shif_unit IS 
	BEGIN 
	
--	dataout <= dataa                      WHEN shamt = "00" ELSE   
--					'0' & dataa(N-1 DOWNTO 1) WHEN shamt = "01" ELSE 
--					dataa(N-2 DOWNTO 0) & '0' WHEN shamt = "10" ELSE 
--					(OTHERS => '0');
					

					WITH shamt SELECT 
						dataout <= dataa              WHEN "00", -- NO SHIFT
						'0' & dataa(N-1 DOWNTO 1)     WHEN "01", -- srl
						dataa(N-2 DOWNTO 0) & '0'     WHEN "10",
						(OTHERS => '0')               WHEN OTHERS;
						
											
	
	END ARCHITECTURE; 