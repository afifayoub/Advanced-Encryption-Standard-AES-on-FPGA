
library ieee;
use ieee.std_logic_1164.all;

entity tb_aes_sbox is
end tb_aes_sbox;

architecture behavioral of tb_aes_sbox is

    signal tb_data_in  : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_data_out : std_logic_vector(7 downto 0);

begin

   
    uut : entity work.SubBytes
        port map (
            data_in  => tb_data_in,
            data_out => tb_data_out
        );

  
    stimulus : process
begin

    -- Test 1
    tb_data_in <= x"00";
    wait for 10 ns;
    assert tb_data_out = x"63" report "Erreur 00" severity error;

    -- Test 2
    tb_data_in <= x"FF";
    wait for 10 ns;
    assert tb_data_out = x"16" report "Erreur FF" severity error;

    -- Test 3
    tb_data_in <= x"1B";
    wait for 10 ns;
    assert tb_data_out = x"AF" report "Erreur 1B" severity error;

    -- Test 4
    tb_data_in <= x"7A";
    wait for 10 ns;
    assert tb_data_out = x"DA" report "Erreur 7A" severity error;

    wait;
end process;

end behavioral;
    
