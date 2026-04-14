library ieee;
use ieee.std_logic_1164.all;

entity MixColumns is
    port (
        col_in : in std_logic_vector(31 downto 0);
        col_out : out std_logic_vector(31 downto 0)
    );
end MixColumns;


architecture behavioral of MixColumns is
    function xtime(x : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable result : std_logic_vector(7 downto 0);
    begin
        if x(7) = '1' then
            result := (x(6 downto 0) & '0') xor x"1B";
        else
            result := x(6 downto 0) & '0';
        end if;
        return result;
    end function;


    signal s0, s1, s2, s3 : std_logic_vector(7 downto 0);
begin

        s0 <= col_in(31 downto 24);
        s1 <= col_in(23 downto 16);
        s2 <= col_in(15 downto 8);
        s3 <= col_in(7 downto 0);

        -- s0' = 2*s0 + 3*s1 + s2 + s3
        -- s1' = s0 + 2*s1 + 3*s2 + s3
        -- s2' = s0 + s1 + 2*s2 + 3*s3
        -- s3' = 3*s0 + s1 + s2 + 2*s3

        col_out(31 downto 24) <= xtime(s0) xor (xtime(s1) xor s1) xor s2 xor s3;
        col_out(23 downto 16) <= s0 xor xtime(s1) xor (xtime(s2) xor s2) xor s3;
        col_out(15 downto 8) <= s0 xor s1 xor xtime(s2) xor (xtime(s3) xor s3);
        col_out(7 downto 0) <= (xtime(s0) xor s0) xor s1 xor s2 xor xtime(s3);

end behavioral;


