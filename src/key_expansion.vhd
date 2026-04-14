library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity KeyExpansion is
    port (

        key_in        : in  std_logic_vector(127 downto 0);
        round         : in  unsigned(3 downto 0);
        round_key_out : out std_logic_vector(127 downto 0)
    );
end KeyExpansion;

architecture rtl of KeyExpansion is

    component SubBytes
        port (
            data_in  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    type rcon_array is array (1 to 10) of std_logic_vector(7 downto 0);
    constant RCON_LUT : rcon_array := (
        x"01", x"02", x"04", x"08", x"10",
        x"20", x"40", x"80", x"1B", x"36"
    );

    signal W0, W1, W2, W3 : std_logic_vector(31 downto 0);
    signal rotword        : std_logic_vector(31 downto 0);
    signal subword        : std_logic_vector(31 downto 0);
    signal rcon_word      : std_logic_vector(31 downto 0);
    

    signal new_W0, new_W1, new_W2, new_W3 : std_logic_vector(31 downto 0);

begin

    W0 <= key_in(127 downto 96);
    W1 <= key_in(95 downto 64);
    W2 <= key_in(63 downto 32);
    W3 <= key_in(31 downto 0);


    rotword <= W3(23 downto 0) & W3(31 downto 24);

    sbox0 : SubBytes port map (data_in => rotword(31 downto 24), data_out => subword(31 downto 24));
    sbox1 : SubBytes port map (data_in => rotword(23 downto 16), data_out => subword(23 downto 16));
    sbox2 : SubBytes port map (data_in => rotword(15 downto 8),  data_out => subword(15 downto 8));
    sbox3 : SubBytes port map (data_in => rotword(7 downto 0),   data_out => subword(7 downto 0));


    rcon_word <= RCON_LUT(to_integer(round)) & x"000000"
        when (round >= 1 and round <= 10)
        else (others => '0');

  
    new_W0 <= W0 xor subword xor rcon_word;
    new_W1 <= W1 xor new_W0;
    new_W2 <= W2 xor new_W1;
    new_W3 <= W3 xor new_W2;

   
    round_key_out <= key_in when round = 0 else (new_W0 & new_W1 & new_W2 & new_W3);

end architecture;