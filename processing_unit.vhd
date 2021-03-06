-------------------------------------------------------
-- Processing unit
-- Cristian Durán
--	Organización de computadores
--	06-06-2022
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY processing_unit IS 
	GENERIC (N      : INTEGER :=8 );
	PORT(    clk    : IN STD_LOGIC;
				dataa  : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	         datab  : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				selop  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
				result : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				cout   : OUT STD_LOGIC
	);
	END ENTITY processing_unit;
	
	ARCHITECTURE rtl OF processing_unit IS 
	CONSTANT ONE      : STD_LOGIC_VECTOR(N-1 DOWNTO 0) := std_logic_vector(to_unsigned(1,N));
	CONSTANT ZEROS     : STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
	
	SIGNAL not_b      : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL a_and_b    : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL a_or_b     : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL a_xor_b    : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL a_plus_b   : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL b_plus_one : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL neg_b      : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL c_sel      : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL c_add, cplus1, c_negB : STD_LOGIC;

BEGIN

		not_b    <= NOT(datab);
		a_and_b  <= dataa AND datab;
		a_or_b   <= dataa OR datab;
		a_xor_b  <= dataa XOR datab; 
		
		AplusB: ENTITY WORK.add_sub
		GENERIC MAP (N => N)
		PORT MAP( a => dataa,
					 b => datab,
					 addn_sub => '0',
					 s => a_plus_b,
					 cout => c_add
					 );
		Bplus1: ENTITY WORK.add_sub
		GENERIC MAP (N => N)
		PORT MAP( a        => datab,
					 b        => ONE,
					 addn_sub => '0',
					 s        => b_plus_one,
					 cout     => cplus1);
		
		negB: ENTITY WORK.add_sub
		GENERIC MAP (N => N)
		PORT MAP( a => ZEROS,
					 b => datab,
					 addn_sub => '1',
					 s => neg_b,
					 cout => c_negB
					 );
		
		--resultado mux 
		WITH selop SELECT
			result <= datab      WHEN "000",
						 not_b      WHEN "001",
						 a_and_b    WHEN "010",
						 a_or_b     WHEN "011",
						 a_xor_b    WHEN "100",
						 a_plus_b   WHEN "101",
						 b_plus_one WHEN "110",-- PC +1 BUS(B)=PC , SELEOP =110 BUSC=PC+1 ADRRESBUSC0=0 BANKREG=1 
						 neg_b      WHEN OTHERS;
						 
			-- CARRY MUX 
			c_sel <= selop(1 DOWNTO 0);
			WITH c_sel SELECT
				cout <= c_add   WHEN "01",
						  cplus1  WHEN "10",
						  c_negB  WHEN "11", 
						  '0'     WHEN OTHERS;
			
			END ARCHITECTURE; 
			