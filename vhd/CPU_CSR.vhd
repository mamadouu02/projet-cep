library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PKG.all;

entity CPU_CSR is
    generic (
        INTERRUPT_VECTOR : waddr   := w32_zero;
        mutant           : integer := 0
    );
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;

        -- Interface de et vers la PO
        cmd         : in  PO_cs_cmd;
        it          : out std_logic;
        pc          : in  w32;
        rs1         : in  w32;
        imm         : in  W32;
        csr         : out w32;
        mtvec       : out w32;
        mepc        : out w32;

        -- Interface de et vers les IP d'interruption
        irq         : in  std_logic;
        meip        : in  std_logic;
        mtip        : in  std_logic;
        mie         : out w32;
        mip         : out w32;
        mcause      : in  w32
    );
end entity;

architecture RTL of CPU_CSR is
    -- Fonction retournant la valeur à écrire dans un csr en fonction
    -- du « mode » d'écriture, qui dépend de l'instruction
    function CSR_write (CSR        : w32;
                         CSR_reg    : w32;
                         WRITE_mode : CSR_WRITE_mode_type)
        return w32 is
        variable res : w32;
    begin
        case WRITE_mode is
            when WRITE_mode_simple =>
                res := CSR;
            when WRITE_mode_set =>
                res := CSR_reg or CSR;
            when WRITE_mode_clear =>
                res := CSR_reg and (not CSR);
            when others => null;
        end case;
        return res;
    end CSR_write;

    signal to_csr, to_mepc : w32;
    signal mtvec_d, mtvec_q : w32;
    signal mie_d, mie_q : w32;
    signal mepc_d, mepc_q : w32;
    signal mstatus_d, mstatus_q : w32;
    signal mcause_q : w32;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                mtvec_q <= w32_zero;
                mie_q <= w32_zero;
                mepc_q <= w32_zero;
                mstatus_q <= w32_zero;
            else
                mtvec_q <= mtvec_d;
                mie_q <= mie_d;
                mepc_q <= mepc_d;
                mstatus_q <= mstatus_d;
            end if;
        end if;
    end process;

    to_csr <= rs1 when cmd.TO_CSR_sel = TO_CSR_from_rs1 else imm;
    to_mepc <= to_csr when cmd.MEPC_sel = MEPC_from_csr else pc;

    mtvec <= mtvec_q;
    mie <= mie_q;
    mepc <= mepc_q;
    mip(7) <= mtip;
    mip(11) <= meip;
    it <= mstatus_q(3) and irq;
    csr <=  mcause_q when cmd.CSR_sel = CSR_from_mcause else
            mepc_q when cmd.CSR_sel = CSR_from_mepc else
            mtvec_q when cmd.CSR_sel = CSR_from_mtvec else
            mstatus_q when cmd.CSR_sel = CSR_from_mstatus else
            mie_q when cmd.CSR_sel = CSR_from_mie else
            mip when cmd.CSR_sel = CSR_from_mip;

    process(all)
    begin
        mtvec_d <= mtvec_q;
        mie_d <= mie_q;
        mepc_d <= mepc_q;
        mstatus_q <= mstatus_d;

        if (irq = '1') then
            mcause_q <= mcause;
        end if;

        if (cmd.MSTATUS_mie_set = '1') then
            mstatus_q(3) <= '1';
        elsif (cmd.MSTATUS_mie_reset = '1') then
            mstatus_q(3) <= '0';
        end if;

        case cmd.CSR_we is
            when CSR_mtvec =>
                mtvec_d <= CSR_WRITE(to_csr, mtvec_q, cmd.CSR_WRITE_mode);
            when CSR_mie =>
                mie_d <= CSR_WRITE(to_csr, mie_q, cmd.CSR_WRITE_mode);
            when CSR_mepc =>
                mepc_d <= CSR_WRITE(to_mepc, mepc_q, cmd.CSR_WRITE_mode);
            when CSR_mstatus =>
                mstatus_d <= CSR_WRITE(to_csr, mstatus_q, cmd.CSR_WRITE_mode);
        end case;

    end process;

end architecture;
