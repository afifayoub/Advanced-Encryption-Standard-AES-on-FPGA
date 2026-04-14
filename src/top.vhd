library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is 
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        start    : in  std_logic;
        ready    : out std_logic;
        key      : in  std_logic_vector(127 downto 0); 
        data_in  : in  std_logic_vector(127 downto 0); 
        data_out : out std_logic_vector(127 downto 0) 
    );
end top;

architecture behavioral of top is

    component AES_Round
        port (
            data_in    : in  std_logic_vector(127 downto 0);
            key        : in  std_logic_vector(127 downto 0);
            data_out   : out std_logic_vector(127 downto 0);
            last_round : in  std_logic
        );
    end component;

    component KeyExpansion
        port (
            key_in        : in  std_logic_vector(127 downto 0);
            round         : in  unsigned(3 downto 0);
            round_key_out : out std_logic_vector(127 downto 0)
        );
    end component;

    type fsm_state is (IDLE, INIT, RUN, DONE);
    signal state : fsm_state;

    signal data_reg      : std_logic_vector(127 downto 0);
    signal key_reg       : std_logic_vector(127 downto 0);
    signal round_counter : unsigned(3 downto 0);

    signal next_key      : std_logic_vector(127 downto 0);
    signal next_data     : std_logic_vector(127 downto 0);
    signal is_last_round : std_logic;

begin

    U_KEY_EXP: KeyExpansion port map (
        key_in        => key_reg,
        round         => round_counter,
        round_key_out => next_key
    );

    U_AES_ROUND: AES_Round port map (
        data_in    => data_reg,
        key        => next_key,
        data_out   => next_data,
        last_round => is_last_round
    );

    is_last_round <= '1' when round_counter = "1010" else '0';

   
    process(clk, reset)
    begin 
        if reset = '1' then 
            state         <= IDLE;
            ready         <= '0';
            round_counter <= (others => '0');
            data_out      <= (others => '0');
            key_reg       <= (others => '0');
            data_reg      <= (others => '0');

        elsif rising_edge(clk) then
            case state is
            
                when IDLE =>
                    ready <= '0';
                    if start = '1' then
                        key_reg  <= key;      
                        data_reg <= data_in; 
                        state    <= INIT;
                    end if;

                when INIT =>
        
                    data_reg      <= data_reg xor key_reg;
                    round_counter <= to_unsigned(1, 4); 
                    state         <= RUN;

                when RUN =>
                    data_reg <= next_data;
                    key_reg  <= next_key;
                    
                    if round_counter = 10 then
                        state <= DONE;
                    else
                        round_counter <= round_counter + 1;
                    end if;
                            
                when DONE =>
                    data_out <= data_reg; 
                    ready    <= '1';
                    if start = '0' then
                        state <= IDLE; 
                    end if;
            
            end case;
        end if;
    end process;
    
end behavioral;