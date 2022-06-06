-------------------------------------------------------
-- PDUA
-- Cristian Durán
--	Organización de computadores
--	06-06-2022
-------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY PDUA IS 
	GENERIC (MAX_WIDTH : INTEGER:=8);
	PORT (clk    				 : IN STD_LOGIC;
			reset  				 : IN STD_LOGIC;
			INT                : IN STD_LOGIC; 
			rdata              : IN STD_LOGIC_VECTOR(20 DOWNTO 0);
			per_in             : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			per_out_led1       : OUT STD_LOGIC;
			per_out_led2		 : OUT STD_LOGIC;
			per_out_led3		 : OUT STD_LOGIC
		--	U_I					 : IN STD_LOGIC_VECTOR(17 DOWNTO 0) -- esa señal es una entrada provisional, esa señal va a ser de salida del bloque de control
			-- entrada signal futuro, signal conectado a la unidad de control, señal que controla los enable, unidad de ctrl, cuando se activan bloques 
			); -- pruebas de testbench, formato de ensamble desde la ROM, va a unidad de ctrl, salida, traducir instrucción en bloques de activación para proced a realizar. 
END ENTITY;

ARCHITECTURE PDUA_ctrl OF PDUA IS
	SIGNAL BUSC				:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- bus interconex con dq, mar e IR
   SIGNAL BUSC1			:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- bus interconex con dq, mar e IR	
	SIGNAL CONTROL_UNIT 	: 	STD_LOGIC_VECTOR(7 DOWNTO 0);	-- señal unidad ctr
	SIGNAL ADDRESS_BUS	:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- bus dir
	SIGNAL BUSA				:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- BUSA
	SIGNAL BUSB				:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- BUSB
	SIGNAL BUS_DATA_OUT	:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- bus datos salida
	SIGNAL BUS_DATA_IN	:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- bus datos entrada
	SIGNAL mdr_en			:	STD_LOGIC; -- mdr_en
	SIGNAL mdr_alu_n		:	STD_LOGIC; -- mdr_alu_n
	SIGNAL ir_en			:	STD_LOGIC; -- señal ir-en
	SIGNAL mar_en			:	STD_LOGIC; -- señal enable mar
	SIGNAL bank_wr_en		: 	STD_LOGIC; -- enable banco rtas
	SIGNAL BusB_addr		:	STD_LOGIC_VECTOR(2 DOWNTO 0):= (OTHERS => '0'); -- vector dirs busb
	SIGNAL BusC_addr		:	STD_LOGIC_VECTOR(2 DOWNTO 0):= (OTHERS => '0'); -- vector dirs busc
	SIGNAL wr_rdn        :  STD_LOGIC;-- enable write = 1, read = 1
	SIGNAL C             :  STD_LOGIC;-- carry
	SIGNAL N             :  STD_LOGIC;-- negativo
	SIGNAL P             :  STD_LOGIC;-- paridad
	SIGNAL Z             :  STD_LOGIC;-- cero
	SIGNAL rst           :  STD_LOGIC;-- reset
	SIGNAL selop         :  STD_LOGIC_VECTOR(2 DOWNTO 0); -- selector op
   SIGNAL shamt         :  STD_LOGIC_VECTOR(1 DOWNTO 0); -- desp
	SIGNAL enaf          :  STD_LOGIC;-- enable
	SIGNAL int_clr       :  STD_LOGIC;
	SIGNAL ENA           :  STD_LOGIC; 
	SIGNAL opcode        :  STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL U_I           :  STD_LOGIC_VECTOR(20 DOWNTO 0);
	SIGNAL INT_REG       :  STD_LOGIC;
	SIGNAL q             :  STD_LOGIC;
	SIGNAL iom           :  STD_LOGIC;
	SIGNAL ir_clr        :  STD_LOGIC;
	SIGNAL external_bus  :  STD_LOGIC;
	SIGNAL addr          :  STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL dataout       :  STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL datainmem     :  STD_LOGIC_VECTOR(7 DOWNTO 0);
								
BEGIN
		
	
	 shamt				<= U_I(20 DOWNTO 19); -- vector desplazamiento
	 selop				<= U_I(18 DOWNTO 16); -- selector 3 bits
	 ir_en            <= U_I(15);
	 mar_en           <= U_I(14);
	 bank_wr_en		   <= U_I(13); -- enable banco
	 BusC_addr		   <= U_I(12 DOWNTO 10); -- dirbusc
	 BusB_addr		   <= U_I(9 DOWNTO 7); -- dirbusb
    mdr_alu_n		   <= U_I(6);
	 mdr_en			   <= U_I(5);
	 enaf             <= U_I(3);
	 iom              <= U_I(2);
    ir_clr           <= U_I(1);
	 int_clr          <= U_I(0);
	 wr_rdn <=  U_I(4) when iom = '0' else 
	             '0' when iom = '1';
	  addr <=  ADDRESS_BUS when iom = '0' else 
	             (OTHERS => '0') when iom = '1';		  
	  dataout <=  BUS_DATA_OUT when iom = '0' else 
	             (OTHERS => '0') when iom = '1';
	  BUS_DATA_IN <=  datainmem when iom = '0' else 
	                  per_in  when iom = '1';
	  per_out_led1 <=  '1' when iom = '0' else 
	             '0' when iom = '1';				
	  per_out_led2 <=  '1' when iom = '0' else 
	             '0' when iom = '1';
	  per_out_led3 <=  '1' when iom = '0' else 
	             '0' when iom = '1';					 
	  
--	 enaf             <= U_I(2);

	-- 
	-- 
--		load <= '0' WHEN jcond = "000" ELSE 
--			     '1'	WHEN jcond = "001" ELSE 				 
--		         Z WHEN jcond =  "010" ELSE
--				   N WHEN jcond =  "011" ELSE
--		         C WHEN jcond =  "100" ELSE 
--		         P WHEN jcond =  "101" ELSE 
--		       int WHEN jcond =  "110" ELSE
--	          '0' WHEN jcond =  "111"; 		
--			
--	   d <= result WHEN load = '0' ELSE
--					  offset WHEN load = '1';
	-- wr_rdn			<= U_I(1);
	-- enaf 				<= U_I(0);
						
	BUSC	<= BUSC1 WHEN mdr_alu_n = '0' ELSE (OTHERS => 'Z');
	ir_component: ENTITY WORK.IR 
	PORT MAP(clk    => clk, -- reloj
				--reset  => reset, -- reset
				ir_en  => ir_en,
				d      => BUSC,-- busc que carga a data
				reset => reset,
				sclr   => ir_clr, 
				q      => opcode );-- unidad ctrl carga a q
				
	mar_component: ENTITY WORK.MAR  
	PORT MAP(clk		=>	clk,     -- reloj
				reset 	=>	reset, -- reset
				MAR_en 	=>	mar_en, -- enable del mar
				d        => BUSC, -- similar al IR
				q        =>	ADDRESS_BUS);
				
	register_bank_component: ENTITY WORK.Register_Bank  				
	PORT	MAP(clk             => clk, -- reloj
				 reset           => reset, -- reset
				 wr_en           => bank_wr_en, -- write enable partiendo de valor del banco de reg enable
				 wr_addr          => BusC_addr, -- dir busc cargada a wr_addr
				 rd_addr          => BusB_addr, -- bus b dir cargada a rd_addr
				 wr_data          => BUSC, -- wr_data cargada a BUS C
				 BUSA 	        => BUSA, -- BUSA
				 BUSB            => BUSB);
	
	mdr_component: ENTITY WORK.MDR 
	PORT MAP(    clock            => clk,   --Reloj del sistema
				data_ex_in           => BUS_DATA_IN, 	--Data que entra al MDR									 
			   mdr_alu_n        		=> mdr_alu_n,   -- asignacion MDR
				mdr_en			  		=> mdr_en, -- mdr_en asignacion PDUA referente a entity
				reset				  		=> reset, -- Reset de los registros
				dq					  		=> BUSC, -- 
				Bus_data_out	  		=> bus_data_out   --Data que sale del MDR
			   
				); 
				
	spram_component: ENTITY WORK.spram  


			  
	PORT MAP(  clk  =>  clk, -- reloj
	        wr_rdn => wr_rdn, -- def enable
			  addr   => addr, -- definicion address cargado a bus dir
			  w_data  => dataout,-- bus datos de escritura a bus salida
			  r_data  => datainmem   -- bus de lectura a bus de datos de entrada
			  );

		ALU_component: ENTITY WORK.ALU
			
		
		PORT MAP(
		clk    => clk, -- reloj
		rst    => reset, -- reset
		BUSB   => BUSB, -- valor bus con ref entidad alu a PDUA
		BUSA   => BUSA,
		shamt  => shamt, -- desplazamiento
		selop  => selop, -- selector
		enaf   => enaf, --enable definicion
		C      =>  C,
		N      =>  N,
		Z      =>  Z,
		P      =>  P, --
		BUSC   => BUSC1
		
		);
		
		INT_REG_COMPONENT: ENTITY WORK.INT_REG
		PORT MAP(
		  clk          => clk,     
		  int_clr      => int_clr,
		  INT        => INT, 
	     q         => INT_REG,
		 -- rst       => rst,  
	     d          => '1' 
        
	);
		

		
		Control_Unit_component: ENTITY WORK.control_unit
		PORT MAP(
		clk    => clk, -- reloj
		rst    => reset, -- reset
		INT    => INT_REG,
		opcode =>  opcode,
		C      =>  C,
		N      =>  N,
		Z      =>  Z,
		P      =>  P,
	   U_I    => U_I 
		
		);
		
		
		
end ARCHITECTURE;

