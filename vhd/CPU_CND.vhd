library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PKG.all;

entity CPU_CND is
    generic (
        mutant      : integer := 0
    );
    port (
        rs1         : in w32;
        alu_y       : in w32;
        IR          : in w32;
        slt         : out std_logic;
        jcond       : out std_logic
    );
end entity;

architecture RTL of CPU_CND is

    signal s, z, ext : std_logic;
    signal x, y, res : signed(32 downto 0);

begin

ext <= (not IR(13) and IR(6)) or (not IR(6) and not IR(12));

x <= signed(rs1(31) & rs1) when ext = '1' else signed('0' & rs1);
y <= signed(alu_y(31) & alu_y) when ext = '1' else signed('0' & alu_y);
res <= x - y;

s <= res(32);
z <= '1' when res = signed('0' & w32_zero) else '0';

slt <= s;
jcond <= (not IR(14) and (IR(12) xor z)) or ((s xor IR(12)) and IR(14));

end architecture;
