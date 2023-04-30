library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PKG.all;


entity CPU_PC is
    generic(
        mutant: integer := 0
    );
    Port (
        -- Clock/Reset
        clk    : in  std_logic ;
        rst    : in  std_logic ;

        -- Interface PC to PO
        cmd    : out PO_cmd ;
        status : in  PO_status
    );
end entity;

architecture RTL of CPU_PC is
    type State_type is (
        S_Error,
        S_Init,
        S_Pre_Fetch,
        S_Fetch,
        S_Decode,
        S_ADD,
        S_ADDI,
        S_SUB,
        S_LUI,
        S_AUIPC,
        S_OR,
        S_ORI,
        S_AND,
        S_ANDI,
        S_XOR,
        S_XORI,
        S_SLL,
        S_SLLI,
        S_SRA,
        S_SRAI,
        S_SRL,
        S_SRLI,
        S_SET,
        S_SET_I,
        S_BRANCH,
        S_JAL,
        S_JALR,
        S_LOAD,
        S_LOAD_ADDR,
        S_LB, 
        S_LBU, 
        S_LH, 
        S_LHU,
        S_LW,
        S_STORE,
        S_SB, 
        S_SH,
        S_SW,
        S_PRE_CSR,
        S_CSR,
        S_MRET,
        S_PRE_IT,
        S_IT
    );

    signal state_d, state_q : State_type;


begin

    FSM_synchrone : process(clk)
    begin
        if clk'event and clk='1' then
            if rst='1' then
                state_q <= S_Init;
            else
                state_q <= state_d;
            end if;
        end if;
    end process FSM_synchrone;

    FSM_comb : process (state_q, status)
    begin

        -- Valeurs par défaut de cmd à définir selon les préférences de chacun
        cmd.ALU_op            <= UNDEFINED;
        cmd.LOGICAL_op        <= UNDEFINED;
        cmd.ALU_Y_sel         <= UNDEFINED;

        cmd.SHIFTER_op        <= UNDEFINED;
        cmd.SHIFTER_Y_sel     <= UNDEFINED;

        cmd.RF_we             <= '0';
        cmd.RF_SIZE_sel       <= UNDEFINED;
        cmd.RF_SIGN_enable    <= '0';
        cmd.DATA_sel          <= UNDEFINED;

        cmd.PC_we             <= '0';
        cmd.PC_sel            <= UNDEFINED;

        cmd.PC_X_sel          <= UNDEFINED;
        cmd.PC_Y_sel          <= UNDEFINED;

        cmd.TO_PC_Y_sel       <= UNDEFINED;

        cmd.AD_we             <= '0';
        cmd.AD_Y_sel          <= UNDEFINED;

        cmd.IR_we             <= '0';

        cmd.ADDR_sel          <= UNDEFINED;
        cmd.mem_we            <= '0';
        cmd.mem_ce            <= '0';

        cmd.cs.CSR_we            <= UNDEFINED;

        cmd.cs.TO_CSR_sel        <= UNDEFINED;
        cmd.cs.CSR_sel           <= UNDEFINED;
        cmd.cs.MEPC_sel          <= UNDEFINED;

        cmd.cs.MSTATUS_mie_set   <= '0';
        cmd.cs.MSTATUS_mie_reset <= '0';

        cmd.cs.CSR_WRITE_mode    <= UNDEFINED;

        state_d <= state_q;

        case state_q is
            when S_Error =>
                -- Etat transitoire en cas d'instruction non reconnue 
                -- Aucune action
                state_d <= S_Init;

            when S_Init =>
                -- PC <- RESET_VECTOR
                cmd.PC_we <= '1';
                cmd.PC_sel <= PC_rstvec;
                state_d <= S_Pre_Fetch;

            when S_Pre_Fetch =>
                -- mem[PC]
                cmd.mem_we   <= '0';
                cmd.mem_ce   <= '1';
                cmd.ADDR_sel <= ADDR_from_pc;
                state_d      <= S_Fetch;

            when S_Fetch =>
                -- IR <- mem_datain
                cmd.IR_we <= '1';
                state_d <= S_Decode;

            when S_Decode =>
                -- On peut aussi utiliser un case, ...
                -- et ne pas le faire juste pour les branchements et auipc

                -- addi
                if status.IR(14 downto 12) = "000" and status.IR(6 downto 0) = "0010011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_ADDI;

                -- add
                elsif status.IR(31 downto 25) = "0000000" and status.IR(14 downto 12) = "000" and status.IR(6 downto 0) = "0110011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_ADD;

                -- sub
                elsif status.IR(31 downto 25) = "0100000" and status.IR(14 downto 12) = "000" and status.IR(6 downto 0) = "0110011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SUB;

                -- lui
                elsif status.IR(6 downto 0) = "0110111" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_LUI;

                -- auipc
                elsif status.IR(6 downto 0) = "0010111" then
                    state_d <= S_AUIPC;

                -- or
                elsif status.IR(31 downto 25) = "0000000" and status.IR(14 downto 12) = "110" and status.IR(6 downto 0) = "0110011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_OR;

                -- ori
                elsif status.IR(14 downto 12) = "110" and status.IR(6 downto 0) = "0010011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_ORI;

                -- and
                elsif status.IR(31 downto 25) = "0000000" and status.IR(14 downto 12) = "111" and status.IR(6 downto 0) = "0110011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_AND;

                -- andi
                elsif status.IR(14 downto 12) = "111" and status.IR(6 downto 0) = "0010011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_ANDI;

                -- xor
                elsif status.IR(31 downto 25) = "0000000" and status.IR(14 downto 12) = "100" and status.IR(6 downto 0) = "0110011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_XOR;

                -- xori
                elsif status.IR(14 downto 12) = "100" and status.IR(6 downto 0) = "0010011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_XORI;

                -- sll
                elsif status.IR(31 downto 25) = "0000000" and status.IR(14 downto 12) = "001" and status.IR(6 downto 0) = "0110011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SLL;

                -- slli
                elsif status.IR(31 downto 25) = "0000000" and status.IR(14 downto 12) = "001" and status.IR(6 downto 0) = "0010011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SLLI;

                -- sra
                elsif status.IR(31 downto 25) = "0100000" and status.IR(14 downto 12) = "101" and status.IR(6 downto 0) = "0110011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SRA;

                -- srai
                elsif status.IR(31 downto 25) = "0100000" and status.IR(14 downto 12) = "101" and status.IR(6 downto 0) = "0010011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SRAI;

                -- srl
                elsif status.IR(31 downto 25) = "0000000" and status.IR(14 downto 12) = "101" and status.IR(6 downto 0) = "0110011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SRL;

                -- srli
                elsif status.IR(31 downto 25) = "0000000" and status.IR(14 downto 12) = "101" and status.IR(6 downto 0) = "0010011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SRLI;

                -- slt, sltu 
                elsif status.IR(31 downto 25) = "0000000" and (status.IR(14 downto 12) = "010" or status.IR(14 downto 12) = "011") and status.IR(6 downto 0) = "0110011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SET;

                -- slti, sltiu 
                elsif (status.IR(14 downto 12) = "010" or status.IR(14 downto 12) = "011") and status.IR(6 downto 0) = "0010011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_SET_I;

                -- beq, bge, bgeu, blt, bltu, bne
                elsif (status.IR(14 downto 12) = "000" or status.IR(14 downto 12) = "101" or status.IR(14 downto 12) = "111" or status.IR(14 downto 12) = "100" 
                or status.IR(14 downto 12) = "110" or status.IR(14 downto 12) = "001") and status.IR(6 downto 0) = "1100011" then
                    state_d <= S_BRANCH;

                -- jal
                elsif status.IR(6 downto 0) = "1101111" then
                    state_d <= S_JAL;

		        -- jalr
                elsif status.IR(14 downto 12) = "000" and status.IR(6 downto 0) = "1100111" then
                    state_d <= S_JALR;

                -- lb, lbu, lh, lhu, lw
                elsif (status.IR(14 downto 12) = "000" or status.IR(14 downto 12) = "100" or status.IR(14 downto 12) = "001" or status.IR(14 downto 12) = "101" or status.IR(14 downto 12) = "010") and status.IR(6 downto 0) = "0000011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_LOAD;

                -- sb, sh, sw
                elsif (status.IR(14 downto 12) = "000" or status.IR(14 downto 12) = "010" or status.IR(14 downto 12) = "001") and status.IR(6 downto 0) = "0100011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_STORE;

		        -- csrrc
                elsif status.IR(6 downto 0) = "1110011" and status.IR(14 downto 12)= "011" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_PRE_CSR;

		        -- csrrci
                elsif status.IR(6 downto 0) = "1110011" and status.IR(14 downto 12)= "111" then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_PRE_CSR;
		        -- csrrs
                elsif status.IR(6 downto 0) = "1110011" and status.IR(14 downto 12)= "010" then
			        cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_PRE_CSR;
		        --csrrsi
                elsif status.IR(6 downto 0) = "1110011" and status.IR(14 downto 12)= "110" then
			        cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_PRE_CSR;
		        -- csrrw
                elsif status.IR(6 downto 0) = "1110011" and status.IR(14 downto 12)= "001" then
			        cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_PRE_CSR;
		        -- csrrwi
                elsif status.IR(6 downto 0) = "1110011" and status.IR(14 downto 12)= "101" then
			        cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_PRE_CSR;

                -- mret
                elsif status.IR(31 downto 0) = "00110000001000000000000001110011" then
			        cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                    cmd.PC_sel <= PC_from_pc;
                    cmd.PC_we <= '1';
                    state_d <= S_MRET;

                else
                    state_d <= S_Error; -- Pour detecter les rates du decodage

                end if;

---------- Instructions avec immediat de type U ----------

            when S_LUI =>
                -- rd <- immU + 0
                cmd.PC_X_sel <= PC_X_cst_x00;
                cmd.PC_Y_sel <= PC_Y_immU;
                cmd.DATA_sel <= DATA_from_pc;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_AUIPC =>
                -- rd <- immU + PC
                cmd.PC_X_sel <= PC_X_pc;
                cmd.PC_Y_sel <= PC_Y_immU;
                cmd.DATA_sel <= DATA_from_pc;
                cmd.RF_we <= '1';
                -- PC = PC + 4
                cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                cmd.PC_sel <= PC_from_pc;
                cmd.PC_we <= '1';
                -- next state
                state_d <= S_Pre_Fetch;

---------- Instructions arithmétiques et logiques ----------

            when S_ADDI =>
                -- rd <- rs1 + immI
                cmd.ALU_Y_sel <= ALU_Y_immI;
                cmd.ALU_op <= ALU_plus;
                cmd.DATA_sel <= DATA_from_alu;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_ADD =>
                -- rd <- rs1 + rs2
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                cmd.ALU_op <= ALU_plus;
                cmd.DATA_sel <= DATA_from_alu;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_SUB =>
                -- rd <- rs1 - rs2
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                cmd.ALU_op <= ALU_minus;
                cmd.DATA_sel <= DATA_from_alu;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;
                
            when S_OR =>
                -- rd <- rs1 or rs2
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                cmd.LOGICAL_op <= LOGICAL_or;
                cmd.DATA_sel <= DATA_from_logical;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;
            
            when S_ORI =>
                -- rd <- rs1 or immI
                cmd.ALU_Y_sel <= ALU_Y_immI;
                cmd.LOGICAL_op <= LOGICAL_or;
                cmd.DATA_sel <= DATA_from_logical;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_AND =>
                -- rd <- rs1 and immI
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                cmd.LOGICAL_op <= LOGICAL_and;
                cmd.DATA_sel <= DATA_from_logical;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_ANDI =>
                -- rd <- rs1 andi immI
                cmd.ALU_Y_sel <= ALU_Y_immI;
                cmd.LOGICAL_op <= LOGICAL_and;
                cmd.DATA_sel <= DATA_from_logical;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_XOR =>
                -- rd <- rs1 xor immI
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                cmd.LOGICAL_op <= LOGICAL_xor;
                cmd.DATA_sel <= DATA_from_logical;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_XORI =>
                -- rd <- rs1 xori immI
                cmd.ALU_Y_sel <= ALU_Y_immI;
                cmd.LOGICAL_op <= LOGICAL_xor;
                cmd.DATA_sel <= DATA_from_logical;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_SLL =>
                -- rd <- rs1 << rs2
                cmd.SHIFTER_Y_sel <= SHIFTER_Y_rs2;
                cmd.SHIFTER_op <= SHIFT_ll;
                cmd.DATA_sel <= DATA_from_shifter;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_SLLI =>
                -- rd <- rs1 << immR
                cmd.SHIFTER_Y_sel <= SHIFTER_Y_ir_sh;
                cmd.SHIFTER_op <= SHIFT_ll;
                cmd.DATA_sel <= DATA_from_shifter;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_SRA =>
                -- rd <- rs1 >> rs2
                cmd.SHIFTER_Y_sel <= SHIFTER_Y_rs2;
                cmd.SHIFTER_op <= SHIFT_ra;
                cmd.DATA_sel <= DATA_from_shifter;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_SRAI =>
                -- rd <- rs1 >> immR
                cmd.SHIFTER_Y_sel <= SHIFTER_Y_ir_sh;
                cmd.SHIFTER_op <= SHIFT_ra;
                cmd.DATA_sel <= DATA_from_shifter;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_SRL =>
                -- rd <- rs1 >> rs2
                cmd.SHIFTER_Y_sel <= SHIFTER_Y_rs2;
                cmd.SHIFTER_op <= SHIFT_rl;
                cmd.DATA_sel <= DATA_from_shifter;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_SRLI =>
                -- rd <- rs1 >> immR
                cmd.SHIFTER_Y_sel <= SHIFTER_Y_ir_sh;
                cmd.SHIFTER_op <= SHIFT_rl;
                cmd.DATA_sel <= DATA_from_shifter;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

---------- Instructions de saut ----------

            when S_SET =>
                -- if rs1 < rs2 => rd <- 1
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                cmd.DATA_sel <= DATA_from_slt;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_SET_I =>
                -- if rs1 < immI => rd <- 1
                cmd.ALU_Y_sel <= ALU_Y_immI;
                cmd.DATA_sel <= DATA_from_slt;
                cmd.RF_we <= '1';
                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                -- next state
                state_d <= S_Fetch;

            when S_BRANCH =>
                -- if rs1 ~ rs2 => PC = PC + immB
                cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
                if status.JCOND then
                    cmd.TO_PC_Y_sel <= TO_PC_Y_immB;
                else
                    cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                end if;
                cmd.PC_sel <= PC_from_pc;
                cmd.PC_we <= '1';
                -- next state
                state_d <= S_Pre_Fetch;
                
           when S_JAL =>
                -- rd = PC + 4
                cmd.PC_X_sel <= PC_X_pc;
                cmd.PC_Y_sel <= PC_Y_cst_x04;
                cmd.DATA_sel <= DATA_from_pc;
		        cmd.RF_we <= '1';
		        -- PC = PC + immJ        
                cmd.TO_PC_Y_sel <= TO_PC_Y_immJ;
                cmd.PC_sel <= PC_from_pc;               
                cmd.PC_we <= '1';
                -- next state
                state_d <= S_Pre_Fetch;
               
           when S_JALR =>
		        -- rd = PC + 4
                cmd.PC_X_sel <= PC_X_pc;
                cmd.PC_Y_sel <= PC_Y_cst_x04;
                cmd.DATA_sel <= DATA_from_pc;
        		cmd.RF_we <= '1';
		        -- PC = rs1 + immI         
                cmd.ALU_Y_sel <= ALU_Y_immI;
                cmd.ALU_op <= ALU_plus; 
                cmd.PC_sel <= PC_from_alu;            
                cmd.PC_we <= '1';
                -- next state
                state_d <= S_Pre_Fetch;
                
---------- Instructions de chargement à partir de la mémoire ----------

            when S_LOAD =>
                cmd.AD_Y_sel <= AD_Y_immI;
                cmd.AD_we <= '1';
                -- next state
                state_d <= S_LOAD_ADDR;

            when S_LOAD_ADDR => 
                -- lecture memoire
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                cmd.ADDR_sel <= ADDR_from_ad;
                 -- next state
                if status.IR(14 downto 12) = "000" then
                    state_d <= S_LB;
                elsif status.IR(14 downto 12) = "100" then 
                    state_d <= S_LBU;
                elsif status.IR(14 downto 12) = "001" then 
                    state_d <= S_LH;
                elsif status.IR(14 downto 12) = "101" then 
                    state_d <= S_LHU;
                else 
                    state_d <= S_LW;
                end if;

            when S_LB =>
                -- rd <- mem[immI + rs1]
                cmd.RF_SIZE_sel <= RF_SIZE_byte;
                cmd.RF_SIGN_enable <= '1';
                cmd.DATA_sel <= DATA_from_mem;
                cmd.RF_we <= '1';
                -- next state
                state_d <= S_Pre_Fetch;

            when S_LBU =>
                -- rd <- mem[immI + rs1]
                cmd.RF_SIZE_sel <= RF_SIZE_byte;
                cmd.RF_SIGN_enable <= '0';
                cmd.DATA_sel <= DATA_from_mem;
                cmd.RF_we <= '1';
                -- next state
                state_d <= S_Pre_Fetch;

            when S_LH =>
                -- rd <- mem[immI + rs1]
                cmd.RF_SIZE_sel <= RF_SIZE_half;
                cmd.RF_SIGN_enable <= '1';
                cmd.DATA_sel <= DATA_from_mem;
                cmd.RF_we <= '1';
                -- next state
                state_d <= S_Pre_Fetch;

            when S_LHU =>
                -- rd <- mem[immI + rs1]
                cmd.RF_SIZE_sel <= RF_SIZE_half;
                cmd.RF_SIGN_enable <= '0';
                cmd.DATA_sel <= DATA_from_mem;
                cmd.RF_we <= '1';
                -- next state
                state_d <= S_Pre_Fetch;

            when S_LW =>
                -- rd <- mem[immI + rs1]
                cmd.RF_SIZE_sel <= RF_SIZE_word;
                cmd.RF_SIGN_enable <= '1';
                cmd.DATA_sel <= DATA_from_mem;
                cmd.RF_we <= '1';
                -- next state
                state_d <= S_Pre_Fetch;

---------- Instructions de sauvegarde en mémoire ----------

            when S_STORE =>
                -- mem[immS + rs1] <- rs2
                cmd.AD_Y_sel <= AD_Y_immS;
                cmd.AD_we <= '1';
                -- next state
                if status.IR(14 downto 12) = "000" then
                    state_d <= S_SB;
                elsif status.IR(14 downto 12) = "001" then 
                    state_d <= S_SH;
                else 
                    state_d <= S_SW;
                end if; 

            when S_SB =>
                -- ecriture memoire
                cmd.mem_ce <= '1';
                cmd.mem_we <= '1';
                cmd.RF_SIZE_sel <= RF_SIZE_byte;
                cmd.ADDR_sel <= ADDR_from_ad;
                -- next state
                state_d <= S_Pre_Fetch;

            when S_SH =>
                -- ecriture memoire
                cmd.mem_ce <= '1';
                cmd.mem_we <= '1';
                cmd.RF_SIZE_sel <= RF_SIZE_half;
                cmd.ADDR_sel <= ADDR_from_ad;
                -- next state
                state_d <= S_Pre_Fetch;

            when S_SW =>
                -- ecriture memoire
                cmd.mem_ce <= '1';
                cmd.mem_we <= '1';
                cmd.RF_SIZE_sel <= RF_SIZE_word;
                cmd.ADDR_sel <= ADDR_from_ad;
                -- next state
                state_d <= S_Pre_Fetch;

---------- Instructions d'accès aux CSR ----------

	        when S_PRE_CSR =>
			    cmd.RF_we <= '1';
			    cmd.DATA_sel <= DATA_from_csr;
                if status.IR(31 downto 20) = "001100000100" then
                    cmd.cs.CSR_sel <= CSR_from_mie;
                elsif status.IR(31 downto 20) = "001100000000" then
                    cmd.cs.CSR_sel <= CSR_from_mstatus;
                elsif status.IR(31 downto 20) = "001101000010" then
                    cmd.cs.CSR_sel <= CSR_from_mcause;
                elsif status.IR(31 downto 20) = "001101000100" then
                    cmd.cs.CSR_sel <= CSR_from_mip;
                elsif status.IR(31 downto 20) = "001100000101" then
                    cmd.cs.CSR_sel <= CSR_from_mtvec;
                else
                    cmd.cs.CSR_sel <= CSR_from_mepc;
                end if;
                state_d <= S_CSR;

	        when S_CSR =>
                if status.IR(31 downto 20) = "001100000100" then
                    cmd.cs.CSR_we <= CSR_mie;
                elsif status.IR(31 downto 20) = "001100000000" then
                    cmd.cs.CSR_we <= CSR_mstatus;
                elsif status.IR(31 downto 20) = "001100000101" then
                    cmd.cs.CSR_we <= CSR_mtvec;
                elsif status.IR(31 downto 20) = "001101000001" then
                    cmd.cs.CSR_we <= CSR_mepc;
		        else
		            cmd.cs.CSR_we <= CSR_none;
		            state_d <= S_Error;
                end if;

                -- csrrw
                if (status.IR(14 downto 12) = "001" and status.IR(6 downto 0) = "1110011") then
                    cmd.cs.TO_CSR_sel <= TO_CSR_from_rs1;
                    cmd.cs.CSR_WRITE_mode <= WRITE_mode_simple;
                -- csrrs
                elsif (status.IR(14 downto 12) = "010" and status.IR(6 downto 0) = "1110011") then
                    cmd.cs.TO_CSR_sel <= TO_CSR_from_rs1;
                    cmd.cs.CSR_WRITE_mode <= WRITE_mode_set;
                -- csrrc  
                elsif (status.IR(14 downto 12) = "011" and status.IR(6 downto 0) = "1110011") then
                    cmd.cs.TO_CSR_sel <= TO_CSR_from_rs1;
                    cmd.cs.CSR_WRITE_mode <= WRITE_mode_clear;
                -- csrrwi
                elsif (status.IR(14 downto 12) = "101" and status.IR(6 downto 0) = "1110011") then
                    cmd.cs.TO_CSR_sel <= TO_CSR_from_imm;
                    cmd.cs.CSR_WRITE_mode <= WRITE_mode_simple;
                -- csrrsi
                elsif (status.IR(14 downto 12) = "110" and status.IR(6 downto 0) = "1110011") then
                    cmd.cs.TO_CSR_sel <= TO_CSR_from_imm;
                    cmd.cs.CSR_WRITE_mode <= WRITE_mode_set;
                -- csrrci
                else
                    cmd.cs.TO_CSR_sel <= TO_CSR_from_imm;
                    cmd.cs.CSR_WRITE_mode <= WRITE_mode_clear;
                end if;

                -- lecture mem[PC]
                cmd.ADDR_sel <= ADDR_from_pc;
                cmd.mem_ce <= '1';
                cmd.mem_we <= '0';
                state_d <= S_Fetch;

	        when S_MRET =>
		        cmd.PC_sel <= PC_from_mepc;
                cmd.PC_we <= '1';
                cmd.cs.MSTATUS_mie_set <= '1';
                cmd.cs.MSTATUS_mie_reset <= '0';
                state_d <= S_Pre_Fetch;

	        when S_PRE_IT =>
                cmd.cs.MEPC_sel <= MEPC_from_pc;
                cmd.cs.CSR_we <= CSR_mepc;
                cmd.cs.MSTATUS_mie_set <= '0';
                cmd.cs.MSTATUS_mie_reset <= '1';
                cmd.cs.CSR_WRITE_mode <= WRITE_mode_simple;
                state_d <= S_IT;

            when S_IT =>
                cmd.PC_sel <= PC_mtvec;
                cmd.PC_we <= '1';
                state_d <= S_Pre_Fetch;

            when others => null;
        end case;

    end process FSM_comb;

end architecture;
