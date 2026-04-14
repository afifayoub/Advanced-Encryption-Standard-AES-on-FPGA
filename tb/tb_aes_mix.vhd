library ieee;
use ieee.std_logic_1164.all;

entity tb_aes_mix is
end tb_aes_mix;

architecture behavioral of tb_aes_mix is

    signal tb_col_in : std_logic_vector(31 downto 0) := (others => '0');
    signal tb_col_out : std_logic_vector(31 downto 0);

begin 

    uut : entity work.MixColumns
        port map (
        col_in => tb_col_in,
        col_out => tb_col_out
    );


stimulus : process
begin

    -- Test 1 : NIST colonne 1
    tb_col_in <= x"d4bf5d30";
    wait for 20 ns;

    -- Test 2 : NIST colonne 2
    tb_col_in <= x"e0b452ae";
    wait for 20 ns;

    -- Test 3 : NIST colonne 3
    tb_col_in <= x"b84111f1";
    wait for 20 ns;

    -- Test 4 : zero test
    tb_col_in <= x"00000000";
    wait for 20 ns;

    wait;
end process;

end behavioral;
