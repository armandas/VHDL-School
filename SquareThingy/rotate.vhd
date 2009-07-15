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
    constant M: integer := 28;
    signal disp_next: std_logic_vector(3 downto 0);
    signal counter: std_logic_vector(M-1 downto 0);
    signal sel: std_logic_vector(1 downto 0);
    signal top: std_logic;
begin

    process(clk, counter)
    begin
        if (clk'event and clk = '0') then
            counter <= counter + '1';
            disp <= disp_next;
        end if;
    end process;

    top <= '0' when (cw = '1' and disp_next = "1110") or
                    (cw = '0' and disp_next = "0111") else
           '1' when (cw = '1' and disp_next = "0111") or
                    (cw = '0' and disp_next = "1110");
    value <= "01100011" when (top = '1') else "00011101";

    sel <= counter(M-1 downto M-2);
    with sel select
        disp_next <= "1110" when "00",
                     "1101" when "01",
                     "1011" when "10",
                     "0111" when others;
end rotate;

