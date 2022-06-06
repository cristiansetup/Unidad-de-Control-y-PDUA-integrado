-------------------------------------------------------
-- RAM
-- Cristian Durán
--	Organización de computadores
--	06-06-2022
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
--------

ENTITY spram IS 

	GENERIC(DATA_WIDTH     : integer:= 8;
	        ADDR_WIDTH     : integer:= 2);
			  
	PORT(   clk            :IN STD_LOGIC;
	        wr_rdn         :IN STD_LOGIC;
			  addr           :IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
			  w_data         :IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
			  r_data         :OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
			  );
END spram;

ARCHITECTURE rtl OF spram IS
	TYPE ram_type IS ARRAY (2**DATA_WIDTH-1 downto 0) OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
	SIGNAL ram: ram_type;
	-- assign ram contents.mif 
	ATTRIBUTE ram_init_file : STRING;
	ATTRIBUTE ram_init_file of ram: SIGNAL IS "spram_inicializacion.mif";
	SIGNAL addr_reg : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

BEGIN 
-- write process
   write_process: PROCESS(CLK) 
	BEGIN 
		IF(rising_edge(clk)) THEN
	      IF(wr_rdn = '1') THEN
				ram(to_integer(unsigned(addr)))<= w_data;
			END IF;
		   addr_reg <= addr;
	END IF;
   END PROCESS;
   -- READ
   r_data <= ram(to_integer(unsigned(addr_reg)));	

END ARCHITECTURE;

----  