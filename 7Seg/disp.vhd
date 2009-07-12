library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--
-- This module connects all other modules
-- for testing.
--

entity disp is
    port(
        clk: in std_logic;
        bcd: in std_logic_vector(3 downto 0);
        en: out std_logic_vector(3 downto 0);
        sseg: out std_logic_vector(7 downto 0)
    );
end disp ;

architecture disp_arch of disp is
    signal b0, b1, b2, b3: std_logic_vector(3 downto 0);
    signal d0, d1, d2, d3: std_logic_vector(7 downto 0);
begin

    b0 <= bcd + 4;
    b1 <= bcd + 3;
    b2 <= bcd + 2;
    b3 <= bcd + 1;

    conv0: entity work.bcd_to_sseg(convert)
        port map(bcd => b0, sseg => d0, dp => '0');

    conv1: entity work.bcd_to_sseg(convert)
        port map(bcd => b1, sseg => d1, dp => '0');

    conv2: entity work.bcd_to_sseg(convert)
        port map(bcd => b2, sseg => d2, dp => '0');

    conv3: entity work.bcd_to_sseg(convert)
        port map(bcd => b3, sseg => d3, dp => '0');

    disp: entity work.sseg_mux(mux_arch)
        port map(
            clk => clk, reset => '0',
            in0 => d0, in1 => d1, in2 => d2, in3 => d3,
            en => en,
            sseg => sseg
        );
        
end disp_arch;

