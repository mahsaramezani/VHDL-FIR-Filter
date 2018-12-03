
---------------------------------------------------------------------------------
-- Company: Khatam
-- Engineer: Mahsa Ramezani
-- 
-- Create Date:    931112 
-- Design Name:    FIR_filter
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
package pkg is  
  type fir_array is array (0 to 16) of std_logic_vector(15 downto 0);
  
  constant B : fir_array :=(
          "0000000000010100", "0000000000000000",  "1111111110000111", "0000000000000000", 
          "0000000111000101", "0000000000000000", "1111110001111101","0000000000000000",
          "0000010001010101", "0000000000000000", "1111110001111101", "0000000000000000", 
          "0000000111000101",  "0000000000000000", "1111111110000111", "0000000000000000",      "0000000000010100" );
end pkg;

package body pkg is
end pkg;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;
use work.pkg.all;

entity FIR_filter is
    Port ( FIR_clk : in  STD_LOGIC;
           X : in  STD_LOGIC_VECTOR (15 downto 0);
           Y : out STD_LOGIC_VECTOR (15 downto 0));
end FIR_filter;

architecture FILTER of FIR_filter is
   
  component FIR_Multiplier is port(M1 ,M2: in STD_LOGIC_VECTOR (15 downto 0);M3: out STD_LOGIC_VECTOR (15 downto 0));
  end component;
  component FIR_latch is port( L_clk : in STD_LOGIC;L_input : in STD_LOGIC_VECTOR (15 downto 0);L_output : out STD_LOGIC_VECTOR (15 downto 0));
  end component;
  component FIR_Adder is port(A1 ,A2: in STD_LOGIC_VECTOR (15 downto 0);A3: out STD_LOGIC_VECTOR (15 downto 0));
  end component;
  
  --type fir_array is array (0 to 16) of std_logic_vector(15 downto 0);
  
  

  signal Sig1,Sig2,Sig3: fir_array;

   begin
	 Sig1(0) <= X;
	 L1 : FIR_Multiplier port map(Sig1(0),B(0),Sig2(0)); 
	 Sig3(0) <= Sig2(0);
	 G1 : for i in 1 to 16 generate
			Li : FIR_latch port map (FIR_clk,Sig1(i-1),sig1(i));
		    Mi : FIR_Multiplier port map (Sig1(i),B(i),Sig2(i)); 
	        Ai : FIR_Adder port map (Sig3(i-1),Sig2(i),Sig3(i));

	end generate ;	  
	Y <= Sig3(16);

end FILTER;


----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FIR_latch is
    Port ( L_clk : in  STD_LOGIC;
           L_input : in  STD_LOGIC_VECTOR (15 downto 0);
           L_output : out  STD_LOGIC_VECTOR (15 downto 0));
end FIR_latch;

architecture Behv of FIR_latch is
begin 
 process(L_clk)
  begin 
    if L_clk='1' then L_output <= L_input;
	end if;
 end process; 

end Behv;
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity FIR_multiplier is
    Port ( M1 : in  STD_LOGIC_VECTOR (15 downto 0);
           M2 : in  STD_LOGIC_VECTOR (15 downto 0);
           M3 : out  STD_LOGIC_VECTOR (31 downto 0));
end FIR_multiplier;

architecture RTL of FIR_multiplier is
begin
 process(M1,M2)
    variable Y,Z : unsigned(15 downto 0);
	 begin
    Y:= unsigned(M1);
    Z:= unsigned(M2);
    M3 <=std_logic_vector(Z*Y);
 end process;
end RTL;
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity FIR_Adder is
    Port ( A1 : in  STD_LOGIC_VECTOR (15 downto 0);
           A2 : in  STD_LOGIC_VECTOR (15 downto 0);
           A3 : out STD_LOGIC_VECTOR (15 downto 0));
end FIR_Adder;

architecture rtl of FIR_Adder is
begin
 process(A1,A2)
    variable Y,Z : unsigned(15 downto 0);
	 begin
    Y:= unsigned(A1);
    Z:= unsigned(A2);
    A3 <=std_logic_vector(Z+Y);
 end process;
end rtl;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use work.pkg.all;

ENTITY testSignal1_vhd IS
END testSignal1_vhd;

ARCHITECTURE behavior OF testSignal1_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT FIR_filter
	PORT(
		FIR_clk : IN std_logic;
		X : IN std_logic_vector(15 downto 0);
		--B : IN std_logic_vector(0 to 16);          
		Y : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL FIR_clk :  std_logic := '0';
	SIGNAL X :  std_logic_vector(15 downto 0) := (others=>'0');
	--SIGNAL B :  std_logic_vector(0 to 16) := (others=>'0');

	--Outputs
	SIGNAL Y :  std_logic_vector(15 downto 0);
	SIGNAL B : fir_array;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: FIR_filter PORT MAP(
		FIR_clk => FIR_clk,
		X => X,
		--B => B,
		Y => Y
	);

	tb : PROCESS
	BEGIN

		 FIR_clk <='0',not FIR_clk after 10ns;
		 
		 X<="1111110001111101" ;
	 
	
		wait for 100 ns;

		-- Place stimulus here

		wait; -- will wait forever
	END PROCESS;

END;


