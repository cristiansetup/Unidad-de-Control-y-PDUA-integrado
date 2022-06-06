-------------------------------------------------------
-- ALU
-- Cristian Durán
--	Organización de computadores
--	06-06-2022
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ALU IS 
	GENERIC (MAX_WIDTH: INTEGER := 8);
	PORT(    clk      : IN STD_LOGIC;
         	rst      : IN STD_LOGIC;
				BUSA     : IN STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0);
				BUSB     : IN STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0);
				selop    : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    			shamt    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
				enaf     : IN STD_LOGIC;
			   BUSC     : OUT STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0);
				C,N,P,Z  : OUT STD_LOGIC
	);
	END ENTITY ALU;
	
	ARCHITECTURE RTL OF ALU IS



	SIGNAL cout          :  STD_LOGIC;
	SIGNAL carry         :  STD_LOGIC;
	SIGNAL dataout       :  STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0);
	SIGNAL dataa         : 	STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0);
	SIGNAL datab         :	STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0);
	SIGNAL result        : 	STD_LOGIC_VECTOR(MAX_WIDTH-1 DOWNTO 0);
	
BEGIN
		Processing_unit: ENTITY WORK.processing_unit
		PORT MAP(
					clk    => clk,
					dataa   => BUSA,
					datab   => BUSB ,
					selop  => selop,
					result => dataa,
					cout   => carry );
					
		flag_register: ENTITY WORK.flag_register
		PORT MAP(
				clk    => clk,
				enaf => enaf,
				dataa => dataa,
				carry => carry,
				rst    => rst,
				C      => C,
				N      => N,
				P      => P,
				Z      => Z);
				
		shif_unit: ENTITY WORK.shif_unit
		PORT MAP(clk    => clk,  
					dataa => dataa,
				   shamt  => shamt,
					dataout => BUSC
				);
	
	
	END ARCHITECTURE; 