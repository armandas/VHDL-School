library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity circle is
    port(
        clk: in std_logic;
        cw: in std_logic;
        disp: out std_logic_vector(3 downto 0);
        value: out std_logic_vector(7 downto 0)
    );
end circle;

architecture rotate of circle is
    constant M: integer := 23;
    signal disp_next: std_logic_vector(3 downto 0);
    signal clock_divider: std_logic_vector(M-1 downto 0);
    signal counter, counter_next: std_logic_vector(2 downto 0);
    signal top, top_next: std_logic;
begin

    process(clk, clock_divider)
    begin
        if (clk'event and clk = '0') then
            clock_divider <= clock_divider + '1';
            if (clock_divider = 0) then
                counter <= counter_next;
                disp <= disp_next;
                top <= top_next;
            end if;
        end if;
    end process;

    counter_next <= counter + 1;

    top_next <= '1' when (counter = "111" and cw = '0') or
                         (counter = "011" and cw = '1') else
                '0' when (counter = "111" and cw = '1') or
                         (counter = "011" and cw = '0') else top;

    value <= "01100011" when (top = '1') else "00011101";
    
    process(counter_next)
    begin
        case counter_next is
            when "000" | "111" =>
                disp_next <= "1110";
            when "001" | "110" =>
                disp_next <= "1101";
            when "010" | "101" =>
                disp_next <= "1011";
            when others =>
                disp_next <= "0111";
        end case;
    end process;

end rotate;

