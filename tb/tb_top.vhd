library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top is
    end tb_top;

architecture behavioral of tb_top is
  
    component top
        port (
            clk      : in  std_logic;
            reset    : in  std_logic;
            start    : in  std_logic;
            ready    : out std_logic;
            key      : in  std_logic_vector(127 downto 0); 
            data_in  : in  std_logic_vector(127 downto 0); 
            data_out : out std_logic_vector(127 downto 0) 
        );
    end component;

    signal tb_clk      : std_logic := '0'; 
    signal tb_reset    : std_logic := '0';
    signal tb_start    : std_logic := '0';
    signal tb_ready    : std_logic;
    signal tb_key      : std_logic_vector(127 downto 0) := (others => '0');
    signal tb_data_in  : std_logic_vector(127 downto 0) := (others => '0');
    signal tb_data_out : std_logic_vector(127 downto 0);

    constant clk_period : time := 20 ns;


begin

    uut : entity work.top
        port map (
            clk      => tb_clk,
            reset    => tb_reset,
            start    => tb_start,
            ready    => tb_ready,
            key      => tb_key,
            data_in  => tb_data_in,
            data_out => tb_data_out
        );

    clk_process : process
    begin
            tb_clk <= '0';
            wait for clk_period / 2;
            tb_clk <= '1';
            wait for clk_period / 2;
    end process;

    stim_process: process
    begin		
        tb_reset <= '1';
        wait for 40 ns;
        tb_reset <= '0';
        wait for 20 ns;

        -- Clé secrète officielle : 2b7e151628aed2a6abf7158809cf4f3c
        tb_key     <= x"2b7e151628aed2a6abf7158809cf4f3c";
        
        -- Message en clair officiel : 3243f6a8885a308d313198a2e0370734
        tb_data_in <= x"3243f6a8885a308d313198a2e0370734";
        
        -- On appuie sur le bouton Start (pendant 1 cycle d'horloge)
        tb_start <= '1';
        wait for clk_period;
        tb_start <= '0'; 

        wait until tb_ready = '1';
        
        -- Le résultat DOIT être : 39 25 84 1D 02 DC 09 FB DC E1 14 28 71 58 AB 1D
        
        wait for 100 ns;
        
        
        wait;
    end process;

end behavioral;

        



