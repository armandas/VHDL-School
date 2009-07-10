library ieee;
use ieee.std_logic_1164.all;

--
-- This module connects buttons and
-- bcd_to_7-segment converter for testing purposes
--

entity disp is
    port(
        bcd: in std_logic_vector(3 downto 0);
        en: out std_logic_vector(3 downto 0);
        sseg: out std_logic_vector(7 downto 0)
    );
end disp ;

architecture disp_arch of disp is
begin
    en <= "0000";

    conv: entity work.bcd_to_sseg(convert)
        port map(bcd => bcd, sseg => sseg, dp => '0');
end disp_arch;

