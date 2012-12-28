----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:21:13 12/27/2012 
-- Design Name: 
-- Module Name:    main - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( LEDS : out STD_LOGIC_VECTOR (3 downto 0);
			  D_AN : out STD_LOGIC_VECTOR (3 downto 0);
			  D_C : out STD_LOGIC_VECTOR (7 downto 0);
           BTN0 : in  STD_LOGIC;
           BTN1 : in  STD_LOGIC;
			  SW0 : in STD_LOGIC;
			  SW1 : in STD_LOGIC; 
			  MCLK : in STD_LOGIC);
end main;

architecture Behavioral of main is

component clk_gen
	Port (Clk : in STD_LOGIC;
         Clk_mod : out std_logic;
         divide_value : in integer
			);
end component;

signal cycle_reg : STD_LOGIC_VECTOR (3 downto 0) := "1110";
signal A1, B1, C1, D1 : STD_LOGIC_VECTOR (6 downto 0);
signal fullclk1 : STD_LOGIC;

begin

--	CLK_DIV16_inst1 : CLK_DIV16
--	port map (
--		CLKDV => fullclk1,
--		CLKIN => CLK
--	);

	clk_gen_inst1 : clk_gen
	port map (
		Clk => MCLK,
		Clk_mod => fullclk1,
		divide_value => 500 -- 8MHz / 500 = 16kHz
	);

	-- LEDS <= "1101";

	process (A1, B1, C1, D1)
	begin 
		if (BTN0='1') then
			A1 <= "0001000";
			B1 <= "1111001";
			C1 <= "1001000";
			D1 <= "0001000";
		else
			A1 <= "0000110";
			B1 <= "1000001";
			C1 <= "1000000";
			D1 <= "1000111";
		end if;
	end process;
	
	cycle : process (fullclk1, cycle_reg)
	begin
		if (rising_edge(fullclk1)) then
			cycle_reg <= cycle_reg(0) & cycle_reg(3 downto 1);
		end if;
	end process;
	
	D_AN <= cycle_reg;
	
	process (cycle_reg, A1, B1, C1, D1)
	begin
		case cycle_reg is
			when "0111" => D_C <= ('1'& A1);
			when "1011" => D_C <= ('1'& B1);
			when "1101" => D_C <= ('1'& C1);
			when "1110" => D_C <= ('1'& D1);
			when others => D_C <= "11111111";
		end case;
	end process;

end Behavioral;

