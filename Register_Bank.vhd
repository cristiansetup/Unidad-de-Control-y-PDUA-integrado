-------------------------------------------------------
-- Register Bank
-- Cristian Durán
--	Organización de computadores
--	06-06-2022
-------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


ENTITY Register_Bank IS 
	GENERIC( DATA_WIDTH  :integer:= 8; -- VARIABLES GENERICAS PARA DAR VALOR UNIVERSAL SOBRE VARIABLES DE INTERES
			   ADDR_WIDTH  :integer:= 3); 
	PORT(clk             :IN STD_LOGIC; -- reloj
		  wr_en            :IN STD_LOGIC; -- enable de escritura = 1, _VECTOR(1 DOWNTO 0)lectura = 0
		  wr_addr          :IN STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0); -- address escritura
		  rd_addr          :IN STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0); -- address lectura
		  wr_data          :IN STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0); -- data de escritura
		  reset            :IN STD_LOGIC;
		  BUSA 	         :OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0); -- bus de salida a 
		  BUSB            :OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0) -- bus de salida b
		  
		  );
		  END ENTITY; 
		  
		  ------ 
		  ARCHITECTURE rtl OF Register_Bank IS
				TYPE mem_2d_type IS ARRAY(0 TO 2**ADDR_WIDTH-1) OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0); -- definicion de arreglo
				SIGNAL array_reg: mem_2d_type; 
				SIGNAL en: std_logic_vector(2**ADDR_WIDTH-1 downto 0); --cable para condicion de enable
				CONSTANT acc_addr : unsigned(ADDR_WIDTH-1 DOWNTO 0) := to_unsigned(7,ADDR_WIDTH); -- constante de acc
			BEGIN
			MEM_BANK: PROCESS(clk, wr_en, reset) -- process para banco
				BEGIN
					IF(reset = '1') THEN
						array_reg(0) <= ("00000001");
						array_reg(1) <= ("01111111");
						array_reg(2) <= ("11111101");
						array_reg(3) <= ("11110111");
						array_reg(4) <= ("11100111");
						array_reg(5) <= ("10100011");
						array_reg(6) <= ("10001111");
						array_reg(7) <= ("10001001");
					ELSIF(rising_edge(clk))THEN -- condicion para flanco de subida
						IF(wr_en = '1') THEN -- condicional para escritura y lectura 
							array_reg(to_integer(unsigned(wr_addr)))<= wr_data; -- arreglo para definir escritura 
						END IF;
					END IF;
		END PROCESS;

BUSB <= array_reg(to_integer(unsigned(rd_addr)));		-- dato de lectura para el bus b 
BUSA <= array_reg(to_integer(acc_addr));-- si se quiere escribir en el acc el wr_addr sera 7 , es decir 111
END ARCHITECTURE;		  