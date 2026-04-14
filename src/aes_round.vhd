
-- AES Round : SubBytes, ShiftRows, MixColumns, AddRoundKey
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AES_Round is
    port (
        data_in : in std_logic_vector(127 downto 0);
        key : in std_logic_vector(127 downto 0);
        data_out : out std_logic_vector(127 downto 0);
        last_round : in std_logic
    );
end AES_Round;

architecture behavioral of AES_Round is

    component SubBytes
        port (
            data_in : in std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    component MixColumns
        port (
            col_in : in std_logic_vector(31 downto 0);
            col_out : out std_logic_vector(31 downto 0)
        );
    end component;

    signal subbytes_out : std_logic_vector(127 downto 0);
    signal mixcolumns_out : std_logic_vector(127 downto 0);
    signal shiftrows_out : std_logic_vector(127 downto 0);
    signal addroundkey_out : std_logic_vector(127 downto 0);


begin
    gen_sbox : for i in 0 to 15 generate
        sbox_inst : SubBytes port map (
            data_in => data_in(i*8+7 downto i*8),
            data_out => subbytes_out(i*8+7 downto i*8)
        );
    end generate;


    shiftrows_out(127 downto 120) <= subbytes_out(127 downto 120); 
    shiftrows_out(95 downto 88)   <= subbytes_out(95 downto 88);  
    shiftrows_out(63 downto 56)   <= subbytes_out(63 downto 56);   
    shiftrows_out(31 downto 24)   <= subbytes_out(31 downto 24);  
    
    shiftrows_out(119 downto 112) <= subbytes_out(87 downto 80);  
    shiftrows_out(87 downto 80)   <= subbytes_out(55 downto 48);  
    shiftrows_out(55 downto 48)   <= subbytes_out(23 downto 16);  
    shiftrows_out(23 downto 16)   <= subbytes_out(119 downto 112); 


    shiftrows_out(111 downto 104) <= subbytes_out(47 downto 40);  
    shiftrows_out(79 downto 72)   <= subbytes_out(15 downto 8);    
    shiftrows_out(47 downto 40)   <= subbytes_out(111 downto 104); 
    shiftrows_out(15 downto 8)    <= subbytes_out(79 downto 72);   

    shiftrows_out(103 downto 96)  <= subbytes_out(7 downto 0);     
    shiftrows_out(71 downto 64)   <= subbytes_out(103 downto 96); 
    shiftrows_out(39 downto 32)   <= subbytes_out(71 downto 64); 
    shiftrows_out(7 downto 0)     <= subbytes_out(39 downto 32);   

    gen_mix : for i in 0 to 3 generate
        mix_inst : MixColumns port map (
            col_in  => shiftrows_out(32*i+31 downto 32*i),
            col_out => mixcolumns_out(32*i+31 downto 32*i)
        );
    end generate;

    addroundkey_out <= mixcolumns_out when last_round = '0' else shiftrows_out;

    data_out <= addroundkey_out xor key;

end behavioral;
    
