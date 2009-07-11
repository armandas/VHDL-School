library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sseg_mux is
    port(
        clk, reset: in std_logic;
        in0, in1, in2, in3: in std_logic_vector(7 downto 0);
        en: out std_logic_vector(3 downto 0);
        sseg: out std_logic_vector(7 downto 0)
    );
end sseg_mux;

architecture mux_arch of sseg_mux is
    constant N: integer := 18;
    signal q, q_next: std_logic_vector(N - 1 downto 0);
    signal sel: std_logic_vector(1 downto 0);
begin
    q_next <= q + 1;
    process(clk, reset)
    begin
        if (reset = '1') then
            q <= (others => '0');
        elsif  (clk'event and clk = '0') then
            q <= q_next;
        end if;
    end process;
    
    sel <= q(N - 1 downto N - 2);
    process(sel, in0, in1, in2, in3)
    begin
        case sel is
            when "00" =>
                en <= "1110";
                sseg <= in0;
            when "01" =>
                en <= "1101";
                sseg <= in1;
            when "10" =>
                en <= "1011";
                sseg <= in2;
            when others =>
                en <= "0111";
                sseg <= in3;
        end case;
    end process;
    
end mux_arch;