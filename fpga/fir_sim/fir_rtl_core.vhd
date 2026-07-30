-- ------------------------------------------------------------------------- 
-- High Level Design Compiler for Intel(R) FPGAs Version 25.1std (Release Build #1129)
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2025 Intel Corporation.  All rights reserved.
-- Your use of  Intel Corporation's design tools,  logic functions and other
-- software and  tools, and its AMPP partner logic functions, and any output
-- files any  of the foregoing (including  device programming  or simulation
-- files), and  any associated  documentation  or information  are expressly
-- subject  to the terms and  conditions of the  Intel FPGA Software License
-- Agreement, Intel MegaCore Function License Agreement, or other applicable
-- license agreement,  including,  without limitation,  that your use is for
-- the  sole  purpose of  programming  logic devices  manufactured by  Intel
-- and  sold by Intel  or its authorized  distributors. Please refer  to the
-- applicable agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from fir_rtl_core
-- VHDL created on Wed Jul 29 22:15:14 2026


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity fir_rtl_core is
    port (
        xIn_v : in std_logic_vector(0 downto 0);  -- sfix1
        xIn_c : in std_logic_vector(7 downto 0);  -- sfix8
        xIn_0 : in std_logic_vector(11 downto 0);  -- sfix12
        xOut_v : out std_logic_vector(0 downto 0);  -- ufix1
        xOut_c : out std_logic_vector(7 downto 0);  -- ufix8
        xOut_0 : out std_logic_vector(40 downto 0);  -- sfix41
        clk : in std_logic;
        areset : in std_logic
    );
end fir_rtl_core;

architecture normal of fir_rtl_core is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_xIn_0_13_q : STD_LOGIC_VECTOR (11 downto 0);
    signal d_in0_m0_wi0_wo0_assign_id1_q_13_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_run_count : STD_LOGIC_VECTOR (4 downto 0);
    signal u0_m0_wo0_run_preEnaQ : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_run_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_run_out : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_run_enableQ : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_run_ctrl : STD_LOGIC_VECTOR (2 downto 0);
    signal u0_m0_wo0_memread_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_compute_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_compute_q_13_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_compute_q_17_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_compute_q_18_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_count0_inner_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_count0_inner_i : SIGNED (6 downto 0);
    attribute preserve : boolean;
    attribute preserve of u0_m0_wo0_wi0_r0_ra1_count0_inner_i : signal is true;
    signal u0_m0_wo0_wi0_r0_ra1_count0_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_count0_i : UNSIGNED (5 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_ra1_count0_i : signal is true;
    signal u0_m0_wo0_wi0_r0_ra1_count1_lutreg_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_count1_q : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_count1_i : UNSIGNED (5 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_ra1_count1_i : signal is true;
    signal u0_m0_wo0_wi0_r0_ra1_count1_eq : std_logic;
    attribute preserve of u0_m0_wo0_wi0_r0_ra1_count1_eq : signal is true;
    signal u0_m0_wo0_wi0_r0_ra1_add_0_0_a : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_add_0_0_b : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_add_0_0_o : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_add_0_0_q : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_count0_q : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_count0_i : UNSIGNED (6 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_ra2_count0_i : signal is true;
    signal u0_m0_wo0_wi0_r0_ra2_count1_lutreg_q : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_add_0_0_a : STD_LOGIC_VECTOR (8 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_add_0_0_b : STD_LOGIC_VECTOR (8 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_add_0_0_o : STD_LOGIC_VECTOR (8 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_add_0_0_q : STD_LOGIC_VECTOR (8 downto 0);
    signal u0_m0_wo0_wi0_r0_ra3_count1_lutreg_q : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra3_add_0_0_a : STD_LOGIC_VECTOR (8 downto 0);
    signal u0_m0_wo0_wi0_r0_ra3_add_0_0_b : STD_LOGIC_VECTOR (8 downto 0);
    signal u0_m0_wo0_wi0_r0_ra3_add_0_0_o : STD_LOGIC_VECTOR (8 downto 0);
    signal u0_m0_wo0_wi0_r0_ra3_add_0_0_q : STD_LOGIC_VECTOR (8 downto 0);
    signal u0_m0_wo0_wi0_r0_we1_seq_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_r0_we1_seq_eq : std_logic;
    signal u0_m0_wo0_wi0_r0_we3_seq_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_r0_we3_seq_eq : std_logic;
    signal u0_m0_wo0_wi0_r0_we2_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_r0_we2_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_r0_we2_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_r0_wa0_q : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_wa0_i : UNSIGNED (5 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_wa0_i : signal is true;
    signal u0_m0_wo0_wi0_r0_wa1_q : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_wa1_i : UNSIGNED (5 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_wa1_i : signal is true;
    signal u0_m0_wo0_wi0_r0_wa2_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_wa2_i : UNSIGNED (6 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_wa2_i : signal is true;
    signal u0_m0_wo0_wi0_r0_wa3_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_wa3_i : UNSIGNED (6 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_wa3_i : signal is true;
    signal u0_m0_wo0_wi0_r0_memr0_reset0 : std_logic;
    signal u0_m0_wo0_wi0_r0_memr0_ia : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_memr0_aa : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_memr0_ab : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_memr0_iq : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_memr0_q : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_memr1_reset0 : std_logic;
    signal u0_m0_wo0_wi0_r0_memr1_ia : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_memr1_aa : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_memr1_ab : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_memr1_iq : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_memr1_q : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_memr2_reset0 : std_logic;
    signal u0_m0_wo0_wi0_r0_memr2_ia : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_memr2_aa : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_memr2_ab : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_memr2_iq : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_memr2_q : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_memr3_reset0 : std_logic;
    signal u0_m0_wo0_wi0_r0_memr3_ia : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_memr3_aa : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_memr3_ab : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_memr3_iq : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_memr3_q : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_ca1_q : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_ca1_i : UNSIGNED (5 downto 0);
    attribute preserve of u0_m0_wo0_ca1_i : signal is true;
    signal u0_m0_wo0_ca1_eq : std_logic;
    attribute preserve of u0_m0_wo0_ca1_eq : signal is true;
    signal u0_m0_wo0_cm0_q : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_cm1_q : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_sym_add0_a : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_sym_add0_b : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_sym_add0_o : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_sym_add0_q : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_symSuppress_1_seq_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_symSuppress_1_seq_eq : std_logic;
    signal u0_m0_wo0_sym_add1_a : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_sym_add1_b : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_sym_add1_i : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_sym_add1_o : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_sym_add1_q : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_mtree_add0_0_a : STD_LOGIC_VECTOR (34 downto 0);
    signal u0_m0_wo0_mtree_add0_0_b : STD_LOGIC_VECTOR (34 downto 0);
    signal u0_m0_wo0_mtree_add0_0_o : STD_LOGIC_VECTOR (34 downto 0);
    signal u0_m0_wo0_mtree_add0_0_q : STD_LOGIC_VECTOR (34 downto 0);
    signal u0_m0_wo0_aseq_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_aseq_eq : std_logic;
    signal u0_m0_wo0_accum_a : STD_LOGIC_VECTOR (40 downto 0);
    signal u0_m0_wo0_accum_b : STD_LOGIC_VECTOR (40 downto 0);
    signal u0_m0_wo0_accum_i : STD_LOGIC_VECTOR (40 downto 0);
    signal u0_m0_wo0_accum_o : STD_LOGIC_VECTOR (40 downto 0);
    signal u0_m0_wo0_accum_q : STD_LOGIC_VECTOR (40 downto 0);
    signal u0_m0_wo0_oseq_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_oseq_eq : std_logic;
    signal u0_m0_wo0_oseq_gated_reg_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im0_a0 : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im0_b0 : STD_LOGIC_VECTOR (3 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im0_s1 : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im0_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_1_im0_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im3_a0 : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im3_b0 : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im3_s1 : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im3_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_1_im3_q : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_result_add_0_0_a : STD_LOGIC_VECTOR (34 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_result_add_0_0_b : STD_LOGIC_VECTOR (34 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_result_add_0_0_o : STD_LOGIC_VECTOR (34 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_result_add_0_0_q : STD_LOGIC_VECTOR (34 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im0_a0 : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im0_b0 : STD_LOGIC_VECTOR (3 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im0_s1 : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im0_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_0_im0_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im3_a0 : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im3_b0 : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im3_s1 : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im3_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_0_im3_q : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_result_add_0_0_a : STD_LOGIC_VECTOR (34 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_result_add_0_0_b : STD_LOGIC_VECTOR (34 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_result_add_0_0_o : STD_LOGIC_VECTOR (34 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_result_add_0_0_q : STD_LOGIC_VECTOR (34 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_count0_run_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_r0_we2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_oseq_gated_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_count1_lut_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_count1_lut_q : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra3_count1_lut_q : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_resize_in : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_resize_b : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_resize_in : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_resize_b : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra3_resize_in : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra3_resize_b : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_bs1_merged_bit_select_b : STD_LOGIC_VECTOR (3 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_bs1_merged_bit_select_c : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_bs1_merged_bit_select_b : STD_LOGIC_VECTOR (3 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_bs1_merged_bit_select_c : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_align_8_q : STD_LOGIC_VECTOR (33 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_align_8_qint : STD_LOGIC_VECTOR (33 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_align_8_q : STD_LOGIC_VECTOR (33 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_align_8_qint : STD_LOGIC_VECTOR (33 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_bjA5_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_bjA5_q : STD_LOGIC_VECTOR (17 downto 0);

begin


    -- VCC(CONSTANT,1)@0
    VCC_q <= "1";

    -- u0_m0_wo0_run(ENABLEGENERATOR,13)@10 + 2
    u0_m0_wo0_run_ctrl <= u0_m0_wo0_run_out & xIn_v & u0_m0_wo0_run_enableQ;
    u0_m0_wo0_run_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_run_enable_c : SIGNED(6 downto 0);
        variable u0_m0_wo0_run_inc : SIGNED(4 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_run_q <= "0";
            u0_m0_wo0_run_enable_c := TO_SIGNED(36, 7);
            u0_m0_wo0_run_enableQ <= "0";
            u0_m0_wo0_run_count <= "00000";
            u0_m0_wo0_run_inc := (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_run_out = "1") THEN
                IF (u0_m0_wo0_run_enable_c(6) = '1') THEN
                    u0_m0_wo0_run_enable_c := u0_m0_wo0_run_enable_c - (-37);
                ELSE
                    u0_m0_wo0_run_enable_c := u0_m0_wo0_run_enable_c + (-1);
                END IF;
                u0_m0_wo0_run_enableQ <= STD_LOGIC_VECTOR(u0_m0_wo0_run_enable_c(6 downto 6));
            ELSE
                u0_m0_wo0_run_enableQ <= "0";
            END IF;
            CASE (u0_m0_wo0_run_ctrl) IS
                WHEN "000" | "001" => u0_m0_wo0_run_inc := "00000";
                WHEN "010" | "011" => u0_m0_wo0_run_inc := "11111";
                WHEN "100" => u0_m0_wo0_run_inc := "00000";
                WHEN "101" => u0_m0_wo0_run_inc := "01000";
                WHEN "110" => u0_m0_wo0_run_inc := "11111";
                WHEN "111" => u0_m0_wo0_run_inc := "00111";
                WHEN OTHERS => 
            END CASE;
            u0_m0_wo0_run_count <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_run_count) + SIGNED(u0_m0_wo0_run_inc));
            u0_m0_wo0_run_q <= u0_m0_wo0_run_out;
        END IF;
    END PROCESS;
    u0_m0_wo0_run_preEnaQ <= u0_m0_wo0_run_count(4 downto 4);
    u0_m0_wo0_run_out <= u0_m0_wo0_run_preEnaQ and VCC_q;

    -- u0_m0_wo0_memread(DELAY,14)@12
    u0_m0_wo0_memread : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_run_q, xout => u0_m0_wo0_memread_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_compute(DELAY,16)@12
    u0_m0_wo0_compute : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_memread_q, xout => u0_m0_wo0_compute_q, clk => clk, aclr => areset );

    -- d_u0_m0_wo0_compute_q_13(DELAY,105)@12 + 1
    d_u0_m0_wo0_compute_q_13 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_compute_q, xout => d_u0_m0_wo0_compute_q_13_q, clk => clk, aclr => areset );

    -- d_u0_m0_wo0_compute_q_17(DELAY,106)@13 + 4
    d_u0_m0_wo0_compute_q_17 : dspba_delay
    GENERIC MAP ( width => 1, depth => 4, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_compute_q_13_q, xout => d_u0_m0_wo0_compute_q_17_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_aseq(SEQUENCE,69)@17 + 1
    u0_m0_wo0_aseq_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_aseq_c : SIGNED(7 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_aseq_c := "00000000";
            u0_m0_wo0_aseq_q <= "0";
            u0_m0_wo0_aseq_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_17_q = "1") THEN
                IF (u0_m0_wo0_aseq_c = "00000000") THEN
                    u0_m0_wo0_aseq_eq <= '1';
                ELSE
                    u0_m0_wo0_aseq_eq <= '0';
                END IF;
                IF (u0_m0_wo0_aseq_eq = '1') THEN
                    u0_m0_wo0_aseq_c := u0_m0_wo0_aseq_c + 37;
                ELSE
                    u0_m0_wo0_aseq_c := u0_m0_wo0_aseq_c - 1;
                END IF;
                u0_m0_wo0_aseq_q <= STD_LOGIC_VECTOR(u0_m0_wo0_aseq_c(7 downto 7));
            END IF;
        END IF;
    END PROCESS;

    -- d_u0_m0_wo0_compute_q_18(DELAY,107)@17 + 1
    d_u0_m0_wo0_compute_q_18 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_compute_q_17_q, xout => d_u0_m0_wo0_compute_q_18_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_ca1(COUNTER,57)@13
    -- low=0, high=37, step=1, init=0
    u0_m0_wo0_ca1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_ca1_i <= TO_UNSIGNED(0, 6);
            u0_m0_wo0_ca1_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_13_q = "1") THEN
                IF (u0_m0_wo0_ca1_i = TO_UNSIGNED(36, 6)) THEN
                    u0_m0_wo0_ca1_eq <= '1';
                ELSE
                    u0_m0_wo0_ca1_eq <= '0';
                END IF;
                IF (u0_m0_wo0_ca1_eq = '1') THEN
                    u0_m0_wo0_ca1_i <= u0_m0_wo0_ca1_i + 27;
                ELSE
                    u0_m0_wo0_ca1_i <= u0_m0_wo0_ca1_i + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_ca1_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_ca1_i, 6)));

    -- u0_m0_wo0_cm0(LOOKUP,61)@13 + 1
    u0_m0_wo0_cm0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_cm0_q <= "000000001000110101011";
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (u0_m0_wo0_ca1_q) IS
                WHEN "000000" => u0_m0_wo0_cm0_q <= "000000001000110101011";
                WHEN "000001" => u0_m0_wo0_cm0_q <= "000000000111100101101";
                WHEN "000010" => u0_m0_wo0_cm0_q <= "000000000110001000001";
                WHEN "000011" => u0_m0_wo0_cm0_q <= "000000000100100010111";
                WHEN "000100" => u0_m0_wo0_cm0_q <= "000000000010111011111";
                WHEN "000101" => u0_m0_wo0_cm0_q <= "000000000001011000100";
                WHEN "000110" => u0_m0_wo0_cm0_q <= "111111111111111101011";
                WHEN "000111" => u0_m0_wo0_cm0_q <= "111111111110101101011";
                WHEN "001000" => u0_m0_wo0_cm0_q <= "111111111101101011110";
                WHEN "001001" => u0_m0_wo0_cm0_q <= "111111111100111001010";
                WHEN "001010" => u0_m0_wo0_cm0_q <= "111111111100010110111";
                WHEN "001011" => u0_m0_wo0_cm0_q <= "111111111100000011110";
                WHEN "001100" => u0_m0_wo0_cm0_q <= "111111111011111110111";
                WHEN "001101" => u0_m0_wo0_cm0_q <= "111111111100000110100";
                WHEN "001110" => u0_m0_wo0_cm0_q <= "111111111100011000101";
                WHEN "001111" => u0_m0_wo0_cm0_q <= "111111111100110010011";
                WHEN "010000" => u0_m0_wo0_cm0_q <= "111111111101010010000";
                WHEN "010001" => u0_m0_wo0_cm0_q <= "111111111101110100011";
                WHEN "010010" => u0_m0_wo0_cm0_q <= "111111111110011000000";
                WHEN "010011" => u0_m0_wo0_cm0_q <= "111111111110111010010";
                WHEN "010100" => u0_m0_wo0_cm0_q <= "111111111111011010000";
                WHEN "010101" => u0_m0_wo0_cm0_q <= "111111111111110110000";
                WHEN "010110" => u0_m0_wo0_cm0_q <= "000000000000001101100";
                WHEN "010111" => u0_m0_wo0_cm0_q <= "000000000000100000000";
                WHEN "011000" => u0_m0_wo0_cm0_q <= "000000000000101101100";
                WHEN "011001" => u0_m0_wo0_cm0_q <= "000000000000110110001";
                WHEN "011010" => u0_m0_wo0_cm0_q <= "000000000000111010101";
                WHEN "011011" => u0_m0_wo0_cm0_q <= "000000000000111011010";
                WHEN "011100" => u0_m0_wo0_cm0_q <= "000000000000111000111";
                WHEN "011101" => u0_m0_wo0_cm0_q <= "000000000000110100010";
                WHEN "011110" => u0_m0_wo0_cm0_q <= "000000000000101110011";
                WHEN "011111" => u0_m0_wo0_cm0_q <= "000000000000100111011";
                WHEN "100000" => u0_m0_wo0_cm0_q <= "000000000000100000010";
                WHEN "100001" => u0_m0_wo0_cm0_q <= "000000000000011001100";
                WHEN "100010" => u0_m0_wo0_cm0_q <= "000000000000010011000";
                WHEN "100011" => u0_m0_wo0_cm0_q <= "000000000000001101100";
                WHEN "100100" => u0_m0_wo0_cm0_q <= "000000000000001001001";
                WHEN "100101" => u0_m0_wo0_cm0_q <= "000000000000001000000";
                WHEN OTHERS => -- unreachable
                               u0_m0_wo0_cm0_q <= (others => '-');
            END CASE;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_mtree_mult1_1_bs1_merged_bit_select(BITSELECT,101)@14
    u0_m0_wo0_mtree_mult1_1_bs1_merged_bit_select_b <= STD_LOGIC_VECTOR(u0_m0_wo0_cm0_q(20 downto 17));
    u0_m0_wo0_mtree_mult1_1_bs1_merged_bit_select_c <= STD_LOGIC_VECTOR(u0_m0_wo0_cm0_q(16 downto 0));

    -- u0_m0_wo0_wi0_r0_ra1_count1(COUNTER,24)@12
    -- low=0, high=37, step=1, init=1
    u0_m0_wo0_wi0_r0_ra1_count1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra1_count1_i <= TO_UNSIGNED(1, 6);
            u0_m0_wo0_wi0_r0_ra1_count1_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                IF (u0_m0_wo0_wi0_r0_ra1_count1_i = TO_UNSIGNED(36, 6)) THEN
                    u0_m0_wo0_wi0_r0_ra1_count1_eq <= '1';
                ELSE
                    u0_m0_wo0_wi0_r0_ra1_count1_eq <= '0';
                END IF;
                IF (u0_m0_wo0_wi0_r0_ra1_count1_eq = '1') THEN
                    u0_m0_wo0_wi0_r0_ra1_count1_i <= u0_m0_wo0_wi0_r0_ra1_count1_i + 27;
                ELSE
                    u0_m0_wo0_wi0_r0_ra1_count1_i <= u0_m0_wo0_wi0_r0_ra1_count1_i + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra1_count1_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_ra1_count1_i, 6)));

    -- u0_m0_wo0_wi0_r0_ra3_count1_lut(LOOKUP,38)@12
    u0_m0_wo0_wi0_r0_ra3_count1_lut_combproc: PROCESS (u0_m0_wo0_wi0_r0_ra1_count1_q)
    BEGIN
        -- Begin reserved scope level
        CASE (u0_m0_wo0_wi0_r0_ra1_count1_q) IS
            WHEN "000000" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01110010";
            WHEN "000001" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01110011";
            WHEN "000010" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01110100";
            WHEN "000011" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01110101";
            WHEN "000100" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01110110";
            WHEN "000101" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01110111";
            WHEN "000110" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01111000";
            WHEN "000111" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01111001";
            WHEN "001000" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01101010";
            WHEN "001001" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01101011";
            WHEN "001010" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01101100";
            WHEN "001011" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01101101";
            WHEN "001100" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01101110";
            WHEN "001101" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01101111";
            WHEN "001110" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01110000";
            WHEN "001111" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01110001";
            WHEN "010000" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01100010";
            WHEN "010001" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01100011";
            WHEN "010010" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01100100";
            WHEN "010011" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01100101";
            WHEN "010100" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01100110";
            WHEN "010101" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01100111";
            WHEN "010110" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01101000";
            WHEN "010111" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01101001";
            WHEN "011000" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01011010";
            WHEN "011001" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01011011";
            WHEN "011010" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01011100";
            WHEN "011011" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01011101";
            WHEN "011100" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01011110";
            WHEN "011101" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01011111";
            WHEN "011110" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01100000";
            WHEN "011111" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01100001";
            WHEN "100000" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01010010";
            WHEN "100001" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01010011";
            WHEN "100010" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01010100";
            WHEN "100011" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01010101";
            WHEN "100100" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01010110";
            WHEN "100101" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01010111";
            WHEN OTHERS => -- unreachable
                           u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra3_count1_lutreg(REG,39)@12
    u0_m0_wo0_wi0_r0_ra3_count1_lutreg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra3_count1_lutreg_q <= "01110010";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                u0_m0_wo0_wi0_r0_ra3_count1_lutreg_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra3_count1_lut_q);
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra1_count0_inner(COUNTER,19)@12
    -- low=-1, high=36, step=-1, init=36
    u0_m0_wo0_wi0_r0_ra1_count0_inner_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra1_count0_inner_i <= TO_SIGNED(36, 7);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                IF (u0_m0_wo0_wi0_r0_ra1_count0_inner_i(6 downto 6) = "1") THEN
                    u0_m0_wo0_wi0_r0_ra1_count0_inner_i <= u0_m0_wo0_wi0_r0_ra1_count0_inner_i - 91;
                ELSE
                    u0_m0_wo0_wi0_r0_ra1_count0_inner_i <= u0_m0_wo0_wi0_r0_ra1_count0_inner_i - 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra1_count0_inner_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_ra1_count0_inner_i, 7)));

    -- u0_m0_wo0_wi0_r0_ra1_count0_run(LOGICAL,20)@12
    u0_m0_wo0_wi0_r0_ra1_count0_run_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra1_count0_inner_q(6 downto 6));

    -- u0_m0_wo0_wi0_r0_ra2_count0(COUNTER,29)@12
    -- low=0, high=127, step=8, init=0
    u0_m0_wo0_wi0_r0_ra2_count0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra2_count0_i <= TO_UNSIGNED(0, 7);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1" and u0_m0_wo0_wi0_r0_ra1_count0_run_q = "1") THEN
                u0_m0_wo0_wi0_r0_ra2_count0_i <= u0_m0_wo0_wi0_r0_ra2_count0_i + 8;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra2_count0_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_ra2_count0_i, 8)));

    -- u0_m0_wo0_wi0_r0_ra3_add_0_0(ADD,41)@12 + 1
    u0_m0_wo0_wi0_r0_ra3_add_0_0_a <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_r0_ra2_count0_q);
    u0_m0_wo0_wi0_r0_ra3_add_0_0_b <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_r0_ra3_count1_lutreg_q);
    u0_m0_wo0_wi0_r0_ra3_add_0_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra3_add_0_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_wi0_r0_ra3_add_0_0_o <= STD_LOGIC_VECTOR(UNSIGNED(u0_m0_wo0_wi0_r0_ra3_add_0_0_a) + UNSIGNED(u0_m0_wo0_wi0_r0_ra3_add_0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra3_add_0_0_q <= u0_m0_wo0_wi0_r0_ra3_add_0_0_o(8 downto 0);

    -- u0_m0_wo0_wi0_r0_ra3_resize(BITSELECT,42)@13
    u0_m0_wo0_wi0_r0_ra3_resize_in <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra3_add_0_0_q(6 downto 0));
    u0_m0_wo0_wi0_r0_ra3_resize_b <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra3_resize_in(6 downto 0));

    -- u0_m0_wo0_wi0_r0_ra2_count1_lut(LOOKUP,30)@12
    u0_m0_wo0_wi0_r0_ra2_count1_lut_combproc: PROCESS (u0_m0_wo0_wi0_r0_ra1_count1_q)
    BEGIN
        -- Begin reserved scope level
        CASE (u0_m0_wo0_wi0_r0_ra1_count1_q) IS
            WHEN "000000" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01110111";
            WHEN "000001" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01110110";
            WHEN "000010" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01110101";
            WHEN "000011" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01110100";
            WHEN "000100" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01110011";
            WHEN "000101" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01110010";
            WHEN "000110" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01110001";
            WHEN "000111" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01110000";
            WHEN "001000" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01101111";
            WHEN "001001" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01101110";
            WHEN "001010" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01101101";
            WHEN "001011" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01101100";
            WHEN "001100" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01101011";
            WHEN "001101" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01101010";
            WHEN "001110" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01101001";
            WHEN "001111" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01101000";
            WHEN "010000" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01100111";
            WHEN "010001" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01100110";
            WHEN "010010" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01100101";
            WHEN "010011" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01100100";
            WHEN "010100" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01100011";
            WHEN "010101" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01100010";
            WHEN "010110" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01100001";
            WHEN "010111" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01100000";
            WHEN "011000" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01011111";
            WHEN "011001" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01011110";
            WHEN "011010" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01011101";
            WHEN "011011" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01011100";
            WHEN "011100" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01011011";
            WHEN "011101" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01011010";
            WHEN "011110" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01011001";
            WHEN "011111" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01011000";
            WHEN "100000" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01010111";
            WHEN "100001" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01010110";
            WHEN "100010" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01010101";
            WHEN "100011" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01010100";
            WHEN "100100" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01010011";
            WHEN "100101" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01010010";
            WHEN OTHERS => -- unreachable
                           u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra2_count1_lutreg(REG,31)@12
    u0_m0_wo0_wi0_r0_ra2_count1_lutreg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra2_count1_lutreg_q <= "01110111";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                u0_m0_wo0_wi0_r0_ra2_count1_lutreg_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra2_count1_lut_q);
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra2_add_0_0(ADD,33)@12 + 1
    u0_m0_wo0_wi0_r0_ra2_add_0_0_a <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_r0_ra2_count0_q);
    u0_m0_wo0_wi0_r0_ra2_add_0_0_b <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_r0_ra2_count1_lutreg_q);
    u0_m0_wo0_wi0_r0_ra2_add_0_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra2_add_0_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_wi0_r0_ra2_add_0_0_o <= STD_LOGIC_VECTOR(UNSIGNED(u0_m0_wo0_wi0_r0_ra2_add_0_0_a) + UNSIGNED(u0_m0_wo0_wi0_r0_ra2_add_0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra2_add_0_0_q <= u0_m0_wo0_wi0_r0_ra2_add_0_0_o(8 downto 0);

    -- u0_m0_wo0_wi0_r0_ra2_resize(BITSELECT,34)@13
    u0_m0_wo0_wi0_r0_ra2_resize_in <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra2_add_0_0_q(6 downto 0));
    u0_m0_wo0_wi0_r0_ra2_resize_b <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra2_resize_in(6 downto 0));

    -- u0_m0_wo0_wi0_r0_ra1_count1_lut(LOOKUP,22)@12
    u0_m0_wo0_wi0_r0_ra1_count1_lut_combproc: PROCESS (u0_m0_wo0_wi0_r0_ra1_count1_q)
    BEGIN
        -- Begin reserved scope level
        CASE (u0_m0_wo0_wi0_r0_ra1_count1_q) IS
            WHEN "000000" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0111101";
            WHEN "000001" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0111110";
            WHEN "000010" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0111111";
            WHEN "000011" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0000000";
            WHEN "000100" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0000001";
            WHEN "000101" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0000010";
            WHEN "000110" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0000011";
            WHEN "000111" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0000100";
            WHEN "001000" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0000101";
            WHEN "001001" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0000110";
            WHEN "001010" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0000111";
            WHEN "001011" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0001000";
            WHEN "001100" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0001001";
            WHEN "001101" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0001010";
            WHEN "001110" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0001011";
            WHEN "001111" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0001100";
            WHEN "010000" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0001101";
            WHEN "010001" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0001110";
            WHEN "010010" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0001111";
            WHEN "010011" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0010000";
            WHEN "010100" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0010001";
            WHEN "010101" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0010010";
            WHEN "010110" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0010011";
            WHEN "010111" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0010100";
            WHEN "011000" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0010101";
            WHEN "011001" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0010110";
            WHEN "011010" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0010111";
            WHEN "011011" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0011000";
            WHEN "011100" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0011001";
            WHEN "011101" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0011010";
            WHEN "011110" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0011011";
            WHEN "011111" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0011100";
            WHEN "100000" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0011101";
            WHEN "100001" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0011110";
            WHEN "100010" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0011111";
            WHEN "100011" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0100000";
            WHEN "100100" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0100001";
            WHEN "100101" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "0100010";
            WHEN OTHERS => -- unreachable
                           u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra1_count1_lutreg(REG,23)@12
    u0_m0_wo0_wi0_r0_ra1_count1_lutreg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra1_count1_lutreg_q <= "0111101";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                u0_m0_wo0_wi0_r0_ra1_count1_lutreg_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra1_count1_lut_q);
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra1_count0(COUNTER,21)@12
    -- low=0, high=63, step=8, init=0
    u0_m0_wo0_wi0_r0_ra1_count0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra1_count0_i <= TO_UNSIGNED(0, 6);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1" and u0_m0_wo0_wi0_r0_ra1_count0_run_q = "1") THEN
                u0_m0_wo0_wi0_r0_ra1_count0_i <= u0_m0_wo0_wi0_r0_ra1_count0_i + 8;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra1_count0_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_ra1_count0_i, 7)));

    -- u0_m0_wo0_wi0_r0_ra1_add_0_0(ADD,25)@12 + 1
    u0_m0_wo0_wi0_r0_ra1_add_0_0_a <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_r0_ra1_count0_q);
    u0_m0_wo0_wi0_r0_ra1_add_0_0_b <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_r0_ra1_count1_lutreg_q);
    u0_m0_wo0_wi0_r0_ra1_add_0_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra1_add_0_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_wi0_r0_ra1_add_0_0_o <= STD_LOGIC_VECTOR(UNSIGNED(u0_m0_wo0_wi0_r0_ra1_add_0_0_a) + UNSIGNED(u0_m0_wo0_wi0_r0_ra1_add_0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra1_add_0_0_q <= u0_m0_wo0_wi0_r0_ra1_add_0_0_o(7 downto 0);

    -- u0_m0_wo0_wi0_r0_ra1_resize(BITSELECT,26)@13
    u0_m0_wo0_wi0_r0_ra1_resize_in <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra1_add_0_0_q(5 downto 0));
    u0_m0_wo0_wi0_r0_ra1_resize_b <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra1_resize_in(5 downto 0));

    -- u0_m0_wo0_wi0_r0_we1_seq(SEQUENCE,43)@12 + 1
    u0_m0_wo0_wi0_r0_we1_seq_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_wi0_r0_we1_seq_c : SIGNED(7 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_we1_seq_c := "00000000";
            u0_m0_wo0_wi0_r0_we1_seq_q <= "0";
            u0_m0_wo0_wi0_r0_we1_seq_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_compute_q = "1") THEN
                IF (u0_m0_wo0_wi0_r0_we1_seq_c = "11111001") THEN
                    u0_m0_wo0_wi0_r0_we1_seq_eq <= '1';
                ELSE
                    u0_m0_wo0_wi0_r0_we1_seq_eq <= '0';
                END IF;
                IF (u0_m0_wo0_wi0_r0_we1_seq_eq = '1') THEN
                    u0_m0_wo0_wi0_r0_we1_seq_c := u0_m0_wo0_wi0_r0_we1_seq_c + 37;
                ELSE
                    u0_m0_wo0_wi0_r0_we1_seq_c := u0_m0_wo0_wi0_r0_we1_seq_c - 1;
                END IF;
                u0_m0_wo0_wi0_r0_we1_seq_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_we1_seq_c(7 downto 7));
            ELSE
                u0_m0_wo0_wi0_r0_we1_seq_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_wa1(COUNTER,50)@13
    -- low=0, high=63, step=1, init=35
    u0_m0_wo0_wi0_r0_wa1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_wa1_i <= TO_UNSIGNED(35, 6);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_wi0_r0_we1_seq_q = "1") THEN
                u0_m0_wo0_wi0_r0_wa1_i <= u0_m0_wo0_wi0_r0_wa1_i + 1;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_wa1_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_wa1_i, 6)));

    -- u0_m0_wo0_wi0_r0_memr1(DUALMEM,54)@13
    u0_m0_wo0_wi0_r0_memr1_ia <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_memr0_q);
    u0_m0_wo0_wi0_r0_memr1_aa <= u0_m0_wo0_wi0_r0_wa1_q;
    u0_m0_wo0_wi0_r0_memr1_ab <= u0_m0_wo0_wi0_r0_ra1_resize_b;
    u0_m0_wo0_wi0_r0_memr1_dmem : altsyncram
    GENERIC MAP (
        ram_block_type => "M9K",
        operation_mode => "DUAL_PORT",
        width_a => 12,
        widthad_a => 6,
        numwords_a => 64,
        width_b => 12,
        widthad_b => 6,
        numwords_b => 64,
        lpm_type => "altsyncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        wrcontrol_wraddress_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK0",
        outdata_aclr_b => "NONE",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "FALSE",
        init_file => "UNUSED",
        intended_device_family => "Cyclone IV E"
    )
    PORT MAP (
        clocken0 => '1',
        clock0 => clk,
        address_a => u0_m0_wo0_wi0_r0_memr1_aa,
        data_a => u0_m0_wo0_wi0_r0_memr1_ia,
        wren_a => u0_m0_wo0_wi0_r0_we1_seq_q(0),
        address_b => u0_m0_wo0_wi0_r0_memr1_ab,
        q_b => u0_m0_wo0_wi0_r0_memr1_iq
    );
    u0_m0_wo0_wi0_r0_memr1_q <= u0_m0_wo0_wi0_r0_memr1_iq(11 downto 0);

    -- u0_m0_wo0_wi0_r0_we2_1(REG,45)@13
    u0_m0_wo0_wi0_r0_we2_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_we2_1_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_13_q = "1") THEN
                u0_m0_wo0_wi0_r0_we2_1_q <= u0_m0_wo0_wi0_r0_we1_seq_q;
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_we2_2(REG,46)@13
    u0_m0_wo0_wi0_r0_we2_2_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_we2_2_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_13_q = "1") THEN
                u0_m0_wo0_wi0_r0_we2_2_q <= u0_m0_wo0_wi0_r0_we2_1_q;
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_we2_3(REG,47)@13
    u0_m0_wo0_wi0_r0_we2_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_we2_3_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_13_q = "1") THEN
                u0_m0_wo0_wi0_r0_we2_3_q <= u0_m0_wo0_wi0_r0_we2_2_q;
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_we2(LOGICAL,48)@13
    u0_m0_wo0_wi0_r0_we2_q <= u0_m0_wo0_wi0_r0_we2_3_q and d_u0_m0_wo0_compute_q_13_q;

    -- u0_m0_wo0_wi0_r0_wa2(COUNTER,51)@13
    -- low=0, high=127, step=1, init=120
    u0_m0_wo0_wi0_r0_wa2_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_wa2_i <= TO_UNSIGNED(120, 7);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_wi0_r0_we2_q = "1") THEN
                u0_m0_wo0_wi0_r0_wa2_i <= u0_m0_wo0_wi0_r0_wa2_i + 1;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_wa2_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_wa2_i, 7)));

    -- u0_m0_wo0_wi0_r0_memr2(DUALMEM,55)@13
    u0_m0_wo0_wi0_r0_memr2_ia <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_memr1_q);
    u0_m0_wo0_wi0_r0_memr2_aa <= u0_m0_wo0_wi0_r0_wa2_q;
    u0_m0_wo0_wi0_r0_memr2_ab <= u0_m0_wo0_wi0_r0_ra2_resize_b;
    u0_m0_wo0_wi0_r0_memr2_dmem : altsyncram
    GENERIC MAP (
        ram_block_type => "M9K",
        operation_mode => "DUAL_PORT",
        width_a => 12,
        widthad_a => 7,
        numwords_a => 128,
        width_b => 12,
        widthad_b => 7,
        numwords_b => 128,
        lpm_type => "altsyncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        wrcontrol_wraddress_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK0",
        outdata_aclr_b => "NONE",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "FALSE",
        init_file => "UNUSED",
        intended_device_family => "Cyclone IV E"
    )
    PORT MAP (
        clocken0 => '1',
        clock0 => clk,
        address_a => u0_m0_wo0_wi0_r0_memr2_aa,
        data_a => u0_m0_wo0_wi0_r0_memr2_ia,
        wren_a => u0_m0_wo0_wi0_r0_we2_q(0),
        address_b => u0_m0_wo0_wi0_r0_memr2_ab,
        q_b => u0_m0_wo0_wi0_r0_memr2_iq
    );
    u0_m0_wo0_wi0_r0_memr2_q <= u0_m0_wo0_wi0_r0_memr2_iq(11 downto 0);

    -- u0_m0_wo0_wi0_r0_we3_seq(SEQUENCE,44)@12 + 1
    u0_m0_wo0_wi0_r0_we3_seq_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_wi0_r0_we3_seq_c : SIGNED(7 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_we3_seq_c := "11111000";
            u0_m0_wo0_wi0_r0_we3_seq_q <= "0";
            u0_m0_wo0_wi0_r0_we3_seq_eq <= '1';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_compute_q = "1") THEN
                IF (u0_m0_wo0_wi0_r0_we3_seq_c = "11111001") THEN
                    u0_m0_wo0_wi0_r0_we3_seq_eq <= '1';
                ELSE
                    u0_m0_wo0_wi0_r0_we3_seq_eq <= '0';
                END IF;
                IF (u0_m0_wo0_wi0_r0_we3_seq_eq = '1') THEN
                    u0_m0_wo0_wi0_r0_we3_seq_c := u0_m0_wo0_wi0_r0_we3_seq_c + 37;
                ELSE
                    u0_m0_wo0_wi0_r0_we3_seq_c := u0_m0_wo0_wi0_r0_we3_seq_c - 1;
                END IF;
                u0_m0_wo0_wi0_r0_we3_seq_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_we3_seq_c(7 downto 7));
            ELSE
                u0_m0_wo0_wi0_r0_we3_seq_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_wa3(COUNTER,52)@13
    -- low=0, high=127, step=1, init=122
    u0_m0_wo0_wi0_r0_wa3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_wa3_i <= TO_UNSIGNED(122, 7);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_wi0_r0_we3_seq_q = "1") THEN
                u0_m0_wo0_wi0_r0_wa3_i <= u0_m0_wo0_wi0_r0_wa3_i + 1;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_wa3_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_wa3_i, 7)));

    -- u0_m0_wo0_wi0_r0_memr3(DUALMEM,56)@13
    u0_m0_wo0_wi0_r0_memr3_ia <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_memr2_q);
    u0_m0_wo0_wi0_r0_memr3_aa <= u0_m0_wo0_wi0_r0_wa3_q;
    u0_m0_wo0_wi0_r0_memr3_ab <= u0_m0_wo0_wi0_r0_ra3_resize_b;
    u0_m0_wo0_wi0_r0_memr3_dmem : altsyncram
    GENERIC MAP (
        ram_block_type => "M9K",
        operation_mode => "DUAL_PORT",
        width_a => 12,
        widthad_a => 7,
        numwords_a => 128,
        width_b => 12,
        widthad_b => 7,
        numwords_b => 128,
        lpm_type => "altsyncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        wrcontrol_wraddress_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK0",
        outdata_aclr_b => "NONE",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "FALSE",
        init_file => "UNUSED",
        intended_device_family => "Cyclone IV E"
    )
    PORT MAP (
        clocken0 => '1',
        clock0 => clk,
        address_a => u0_m0_wo0_wi0_r0_memr3_aa,
        data_a => u0_m0_wo0_wi0_r0_memr3_ia,
        wren_a => u0_m0_wo0_wi0_r0_we3_seq_q(0),
        address_b => u0_m0_wo0_wi0_r0_memr3_ab,
        q_b => u0_m0_wo0_wi0_r0_memr3_iq
    );
    u0_m0_wo0_wi0_r0_memr3_q <= u0_m0_wo0_wi0_r0_memr3_iq(11 downto 0);

    -- d_xIn_0_13(DELAY,103)@10 + 3
    d_xIn_0_13 : dspba_delay
    GENERIC MAP ( width => 12, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => xIn_0, xout => d_xIn_0_13_q, clk => clk, aclr => areset );

    -- d_in0_m0_wi0_wo0_assign_id1_q_13(DELAY,104)@10 + 3
    d_in0_m0_wi0_wo0_assign_id1_q_13 : dspba_delay
    GENERIC MAP ( width => 1, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => xIn_v, xout => d_in0_m0_wi0_wo0_assign_id1_q_13_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_wi0_r0_wa0(COUNTER,49)@13
    -- low=0, high=63, step=1, init=34
    u0_m0_wo0_wi0_r0_wa0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_wa0_i <= TO_UNSIGNED(34, 6);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_in0_m0_wi0_wo0_assign_id1_q_13_q = "1") THEN
                u0_m0_wo0_wi0_r0_wa0_i <= u0_m0_wo0_wi0_r0_wa0_i + 1;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_wa0_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_wa0_i, 6)));

    -- u0_m0_wo0_wi0_r0_memr0(DUALMEM,53)@13
    u0_m0_wo0_wi0_r0_memr0_ia <= STD_LOGIC_VECTOR(d_xIn_0_13_q);
    u0_m0_wo0_wi0_r0_memr0_aa <= u0_m0_wo0_wi0_r0_wa0_q;
    u0_m0_wo0_wi0_r0_memr0_ab <= u0_m0_wo0_wi0_r0_ra1_resize_b;
    u0_m0_wo0_wi0_r0_memr0_dmem : altsyncram
    GENERIC MAP (
        ram_block_type => "M9K",
        operation_mode => "DUAL_PORT",
        width_a => 12,
        widthad_a => 6,
        numwords_a => 64,
        width_b => 12,
        widthad_b => 6,
        numwords_b => 64,
        lpm_type => "altsyncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        wrcontrol_wraddress_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK0",
        outdata_aclr_b => "NONE",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "FALSE",
        init_file => "UNUSED",
        intended_device_family => "Cyclone IV E"
    )
    PORT MAP (
        clocken0 => '1',
        clock0 => clk,
        address_a => u0_m0_wo0_wi0_r0_memr0_aa,
        data_a => u0_m0_wo0_wi0_r0_memr0_ia,
        wren_a => d_in0_m0_wi0_wo0_assign_id1_q_13_q(0),
        address_b => u0_m0_wo0_wi0_r0_memr0_ab,
        q_b => u0_m0_wo0_wi0_r0_memr0_iq
    );
    u0_m0_wo0_wi0_r0_memr0_q <= u0_m0_wo0_wi0_r0_memr0_iq(11 downto 0);

    -- u0_m0_wo0_sym_add0(ADD,63)@13 + 1
    u0_m0_wo0_sym_add0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 12 => u0_m0_wo0_wi0_r0_memr0_q(11)) & u0_m0_wo0_wi0_r0_memr0_q));
    u0_m0_wo0_sym_add0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 12 => u0_m0_wo0_wi0_r0_memr3_q(11)) & u0_m0_wo0_wi0_r0_memr3_q));
    u0_m0_wo0_sym_add0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_sym_add0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_sym_add0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_sym_add0_a) + SIGNED(u0_m0_wo0_sym_add0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_sym_add0_q <= u0_m0_wo0_sym_add0_o(12 downto 0);

    -- u0_m0_wo0_mtree_mult1_1_im0(MULT,79)@14 + 2
    u0_m0_wo0_mtree_mult1_1_im0_a0 <= STD_LOGIC_VECTOR(u0_m0_wo0_sym_add0_q);
    u0_m0_wo0_mtree_mult1_1_im0_b0 <= STD_LOGIC_VECTOR(u0_m0_wo0_mtree_mult1_1_bs1_merged_bit_select_b);
    u0_m0_wo0_mtree_mult1_1_im0_reset <= areset;
    u0_m0_wo0_mtree_mult1_1_im0_component : lpm_mult
    GENERIC MAP (
        lpm_widtha => 13,
        lpm_widthb => 4,
        lpm_widthp => 17,
        lpm_widths => 1,
        lpm_type => "LPM_MULT",
        lpm_representation => "SIGNED",
        lpm_hint => "DEDICATED_MULTIPLIER_CIRCUITRY=YES, MAXIMIZE_SPEED=5",
        lpm_pipeline => 2
    )
    PORT MAP (
        dataa => u0_m0_wo0_mtree_mult1_1_im0_a0,
        datab => u0_m0_wo0_mtree_mult1_1_im0_b0,
        clken => VCC_q(0),
        aclr => u0_m0_wo0_mtree_mult1_1_im0_reset,
        clock => clk,
        result => u0_m0_wo0_mtree_mult1_1_im0_s1
    );
    u0_m0_wo0_mtree_mult1_1_im0_q <= u0_m0_wo0_mtree_mult1_1_im0_s1;

    -- u0_m0_wo0_mtree_mult1_1_align_8(BITSHIFT,87)@16
    u0_m0_wo0_mtree_mult1_1_align_8_qint <= u0_m0_wo0_mtree_mult1_1_im0_q & "00000000000000000";
    u0_m0_wo0_mtree_mult1_1_align_8_q <= u0_m0_wo0_mtree_mult1_1_align_8_qint(33 downto 0);

    -- u0_m0_wo0_mtree_mult1_1_bjA5(BITJOIN,84)@14
    u0_m0_wo0_mtree_mult1_1_bjA5_q <= GND_q & u0_m0_wo0_mtree_mult1_1_bs1_merged_bit_select_c;

    -- u0_m0_wo0_mtree_mult1_1_im3(MULT,82)@14 + 2
    u0_m0_wo0_mtree_mult1_1_im3_a0 <= STD_LOGIC_VECTOR(u0_m0_wo0_mtree_mult1_1_bjA5_q);
    u0_m0_wo0_mtree_mult1_1_im3_b0 <= STD_LOGIC_VECTOR(u0_m0_wo0_sym_add0_q);
    u0_m0_wo0_mtree_mult1_1_im3_reset <= areset;
    u0_m0_wo0_mtree_mult1_1_im3_component : lpm_mult
    GENERIC MAP (
        lpm_widtha => 18,
        lpm_widthb => 13,
        lpm_widthp => 31,
        lpm_widths => 1,
        lpm_type => "LPM_MULT",
        lpm_representation => "SIGNED",
        lpm_hint => "DEDICATED_MULTIPLIER_CIRCUITRY=YES, MAXIMIZE_SPEED=5",
        lpm_pipeline => 2
    )
    PORT MAP (
        dataa => u0_m0_wo0_mtree_mult1_1_im3_a0,
        datab => u0_m0_wo0_mtree_mult1_1_im3_b0,
        clken => VCC_q(0),
        aclr => u0_m0_wo0_mtree_mult1_1_im3_reset,
        clock => clk,
        result => u0_m0_wo0_mtree_mult1_1_im3_s1
    );
    u0_m0_wo0_mtree_mult1_1_im3_q <= u0_m0_wo0_mtree_mult1_1_im3_s1;

    -- u0_m0_wo0_mtree_mult1_1_result_add_0_0(ADD,89)@16 + 1
    u0_m0_wo0_mtree_mult1_1_result_add_0_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((34 downto 31 => u0_m0_wo0_mtree_mult1_1_im3_q(30)) & u0_m0_wo0_mtree_mult1_1_im3_q));
    u0_m0_wo0_mtree_mult1_1_result_add_0_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((34 downto 34 => u0_m0_wo0_mtree_mult1_1_align_8_q(33)) & u0_m0_wo0_mtree_mult1_1_align_8_q));
    u0_m0_wo0_mtree_mult1_1_result_add_0_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_1_result_add_0_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_1_result_add_0_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_1_result_add_0_0_a) + SIGNED(u0_m0_wo0_mtree_mult1_1_result_add_0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_1_result_add_0_0_q <= u0_m0_wo0_mtree_mult1_1_result_add_0_0_o(34 downto 0);

    -- u0_m0_wo0_cm1(LOOKUP,62)@13 + 1
    u0_m0_wo0_cm1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_cm1_q <= "000000000000000000000";
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (u0_m0_wo0_ca1_q) IS
                WHEN "000000" => u0_m0_wo0_cm1_q <= "000000000000000000000";
                WHEN "000001" => u0_m0_wo0_cm1_q <= "000010001111111011010";
                WHEN "000010" => u0_m0_wo0_cm1_q <= "000010001110101100010";
                WHEN "000011" => u0_m0_wo0_cm1_q <= "000010001011000010011";
                WHEN "000100" => u0_m0_wo0_cm1_q <= "000010000101000101010";
                WHEN "000101" => u0_m0_wo0_cm1_q <= "000001111101000000111";
                WHEN "000110" => u0_m0_wo0_cm1_q <= "000001110011000110100";
                WHEN "000111" => u0_m0_wo0_cm1_q <= "000001100111101010000";
                WHEN "001000" => u0_m0_wo0_cm1_q <= "000001011011000010011";
                WHEN "001001" => u0_m0_wo0_cm1_q <= "000001001101101000101";
                WHEN "001010" => u0_m0_wo0_cm1_q <= "000000111111110110010";
                WHEN "001011" => u0_m0_wo0_cm1_q <= "000000110010000100110";
                WHEN "001100" => u0_m0_wo0_cm1_q <= "000000100100101100101";
                WHEN "001101" => u0_m0_wo0_cm1_q <= "000000011000000011110";
                WHEN "001110" => u0_m0_wo0_cm1_q <= "000000001100011110000";
                WHEN "001111" => u0_m0_wo0_cm1_q <= "000000000010001011101";
                WHEN "010000" => u0_m0_wo0_cm1_q <= "111111111001011000111";
                WHEN "010001" => u0_m0_wo0_cm1_q <= "111111110010001101110";
                WHEN "010010" => u0_m0_wo0_cm1_q <= "111111101100101110010";
                WHEN "010011" => u0_m0_wo0_cm1_q <= "111111101000111010000";
                WHEN "010100" => u0_m0_wo0_cm1_q <= "111111100110101101010";
                WHEN "010101" => u0_m0_wo0_cm1_q <= "111111100110000000010";
                WHEN "010110" => u0_m0_wo0_cm1_q <= "111111100110101000101";
                WHEN "010111" => u0_m0_wo0_cm1_q <= "111111101000011001111";
                WHEN "011000" => u0_m0_wo0_cm1_q <= "111111101011000101010";
                WHEN "011001" => u0_m0_wo0_cm1_q <= "111111101110011100000";
                WHEN "011010" => u0_m0_wo0_cm1_q <= "111111110010001110100";
                WHEN "011011" => u0_m0_wo0_cm1_q <= "111111110110001110100";
                WHEN "011100" => u0_m0_wo0_cm1_q <= "111111111010001101111";
                WHEN "011101" => u0_m0_wo0_cm1_q <= "111111111110000000110";
                WHEN "011110" => u0_m0_wo0_cm1_q <= "000000000001011100111";
                WHEN "011111" => u0_m0_wo0_cm1_q <= "000000000100011010100";
                WHEN "100000" => u0_m0_wo0_cm1_q <= "000000000110110100000";
                WHEN "100001" => u0_m0_wo0_cm1_q <= "000000001000100110011";
                WHEN "100010" => u0_m0_wo0_cm1_q <= "000000001001110000011";
                WHEN "100011" => u0_m0_wo0_cm1_q <= "000000001010010011010";
                WHEN "100100" => u0_m0_wo0_cm1_q <= "000000001010010001111";
                WHEN "100101" => u0_m0_wo0_cm1_q <= "000000001001110000111";
                WHEN OTHERS => -- unreachable
                               u0_m0_wo0_cm1_q <= (others => '-');
            END CASE;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_mtree_mult1_0_bs1_merged_bit_select(BITSELECT,102)@14
    u0_m0_wo0_mtree_mult1_0_bs1_merged_bit_select_b <= STD_LOGIC_VECTOR(u0_m0_wo0_cm1_q(20 downto 17));
    u0_m0_wo0_mtree_mult1_0_bs1_merged_bit_select_c <= STD_LOGIC_VECTOR(u0_m0_wo0_cm1_q(16 downto 0));

    -- u0_m0_wo0_symSuppress_1_seq(SEQUENCE,64)@12 + 1
    u0_m0_wo0_symSuppress_1_seq_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_symSuppress_1_seq_c : SIGNED(7 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_symSuppress_1_seq_c := "00000001";
            u0_m0_wo0_symSuppress_1_seq_q <= "0";
            u0_m0_wo0_symSuppress_1_seq_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_compute_q = "1") THEN
                IF (u0_m0_wo0_symSuppress_1_seq_c = "00000000") THEN
                    u0_m0_wo0_symSuppress_1_seq_eq <= '1';
                ELSE
                    u0_m0_wo0_symSuppress_1_seq_eq <= '0';
                END IF;
                IF (u0_m0_wo0_symSuppress_1_seq_eq = '1') THEN
                    u0_m0_wo0_symSuppress_1_seq_c := u0_m0_wo0_symSuppress_1_seq_c + 37;
                ELSE
                    u0_m0_wo0_symSuppress_1_seq_c := u0_m0_wo0_symSuppress_1_seq_c - 1;
                END IF;
                u0_m0_wo0_symSuppress_1_seq_q <= STD_LOGIC_VECTOR(u0_m0_wo0_symSuppress_1_seq_c(7 downto 7));
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_sym_add1(ADD,65)@13 + 1
    u0_m0_wo0_sym_add1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 12 => u0_m0_wo0_wi0_r0_memr1_q(11)) & u0_m0_wo0_wi0_r0_memr1_q));
    u0_m0_wo0_sym_add1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((12 downto 12 => u0_m0_wo0_wi0_r0_memr2_q(11)) & u0_m0_wo0_wi0_r0_memr2_q));
    u0_m0_wo0_sym_add1_i <= u0_m0_wo0_sym_add1_a;
    u0_m0_wo0_sym_add1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_sym_add1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_symSuppress_1_seq_q = "1") THEN
                u0_m0_wo0_sym_add1_o <= u0_m0_wo0_sym_add1_i;
            ELSE
                u0_m0_wo0_sym_add1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_sym_add1_a) + SIGNED(u0_m0_wo0_sym_add1_b));
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_sym_add1_q <= u0_m0_wo0_sym_add1_o(12 downto 0);

    -- u0_m0_wo0_mtree_mult1_0_im0(MULT,90)@14 + 2
    u0_m0_wo0_mtree_mult1_0_im0_a0 <= STD_LOGIC_VECTOR(u0_m0_wo0_sym_add1_q);
    u0_m0_wo0_mtree_mult1_0_im0_b0 <= STD_LOGIC_VECTOR(u0_m0_wo0_mtree_mult1_0_bs1_merged_bit_select_b);
    u0_m0_wo0_mtree_mult1_0_im0_reset <= areset;
    u0_m0_wo0_mtree_mult1_0_im0_component : lpm_mult
    GENERIC MAP (
        lpm_widtha => 13,
        lpm_widthb => 4,
        lpm_widthp => 17,
        lpm_widths => 1,
        lpm_type => "LPM_MULT",
        lpm_representation => "SIGNED",
        lpm_hint => "DEDICATED_MULTIPLIER_CIRCUITRY=YES, MAXIMIZE_SPEED=5",
        lpm_pipeline => 2
    )
    PORT MAP (
        dataa => u0_m0_wo0_mtree_mult1_0_im0_a0,
        datab => u0_m0_wo0_mtree_mult1_0_im0_b0,
        clken => VCC_q(0),
        aclr => u0_m0_wo0_mtree_mult1_0_im0_reset,
        clock => clk,
        result => u0_m0_wo0_mtree_mult1_0_im0_s1
    );
    u0_m0_wo0_mtree_mult1_0_im0_q <= u0_m0_wo0_mtree_mult1_0_im0_s1;

    -- u0_m0_wo0_mtree_mult1_0_align_8(BITSHIFT,98)@16
    u0_m0_wo0_mtree_mult1_0_align_8_qint <= u0_m0_wo0_mtree_mult1_0_im0_q & "00000000000000000";
    u0_m0_wo0_mtree_mult1_0_align_8_q <= u0_m0_wo0_mtree_mult1_0_align_8_qint(33 downto 0);

    -- u0_m0_wo0_mtree_mult1_0_bjA5(BITJOIN,95)@14
    u0_m0_wo0_mtree_mult1_0_bjA5_q <= GND_q & u0_m0_wo0_mtree_mult1_0_bs1_merged_bit_select_c;

    -- u0_m0_wo0_mtree_mult1_0_im3(MULT,93)@14 + 2
    u0_m0_wo0_mtree_mult1_0_im3_a0 <= STD_LOGIC_VECTOR(u0_m0_wo0_mtree_mult1_0_bjA5_q);
    u0_m0_wo0_mtree_mult1_0_im3_b0 <= STD_LOGIC_VECTOR(u0_m0_wo0_sym_add1_q);
    u0_m0_wo0_mtree_mult1_0_im3_reset <= areset;
    u0_m0_wo0_mtree_mult1_0_im3_component : lpm_mult
    GENERIC MAP (
        lpm_widtha => 18,
        lpm_widthb => 13,
        lpm_widthp => 31,
        lpm_widths => 1,
        lpm_type => "LPM_MULT",
        lpm_representation => "SIGNED",
        lpm_hint => "DEDICATED_MULTIPLIER_CIRCUITRY=YES, MAXIMIZE_SPEED=5",
        lpm_pipeline => 2
    )
    PORT MAP (
        dataa => u0_m0_wo0_mtree_mult1_0_im3_a0,
        datab => u0_m0_wo0_mtree_mult1_0_im3_b0,
        clken => VCC_q(0),
        aclr => u0_m0_wo0_mtree_mult1_0_im3_reset,
        clock => clk,
        result => u0_m0_wo0_mtree_mult1_0_im3_s1
    );
    u0_m0_wo0_mtree_mult1_0_im3_q <= u0_m0_wo0_mtree_mult1_0_im3_s1;

    -- u0_m0_wo0_mtree_mult1_0_result_add_0_0(ADD,100)@16 + 1
    u0_m0_wo0_mtree_mult1_0_result_add_0_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((34 downto 31 => u0_m0_wo0_mtree_mult1_0_im3_q(30)) & u0_m0_wo0_mtree_mult1_0_im3_q));
    u0_m0_wo0_mtree_mult1_0_result_add_0_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((34 downto 34 => u0_m0_wo0_mtree_mult1_0_align_8_q(33)) & u0_m0_wo0_mtree_mult1_0_align_8_q));
    u0_m0_wo0_mtree_mult1_0_result_add_0_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_0_result_add_0_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_0_result_add_0_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_0_result_add_0_0_a) + SIGNED(u0_m0_wo0_mtree_mult1_0_result_add_0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_0_result_add_0_0_q <= u0_m0_wo0_mtree_mult1_0_result_add_0_0_o(34 downto 0);

    -- u0_m0_wo0_mtree_add0_0(ADD,68)@17 + 1
    u0_m0_wo0_mtree_add0_0_a <= STD_LOGIC_VECTOR(u0_m0_wo0_mtree_mult1_0_result_add_0_0_q);
    u0_m0_wo0_mtree_add0_0_b <= STD_LOGIC_VECTOR(u0_m0_wo0_mtree_mult1_1_result_add_0_0_q);
    u0_m0_wo0_mtree_add0_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add0_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add0_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add0_0_a) + SIGNED(u0_m0_wo0_mtree_add0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add0_0_q <= u0_m0_wo0_mtree_add0_0_o(34 downto 0);

    -- u0_m0_wo0_accum(ADD,70)@18 + 1
    u0_m0_wo0_accum_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((40 downto 35 => u0_m0_wo0_mtree_add0_0_q(34)) & u0_m0_wo0_mtree_add0_0_q));
    u0_m0_wo0_accum_b <= STD_LOGIC_VECTOR(u0_m0_wo0_accum_q);
    u0_m0_wo0_accum_i <= u0_m0_wo0_accum_a;
    u0_m0_wo0_accum_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_accum_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_18_q = "1") THEN
                IF (u0_m0_wo0_aseq_q = "1") THEN
                    u0_m0_wo0_accum_o <= u0_m0_wo0_accum_i;
                ELSE
                    u0_m0_wo0_accum_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_accum_a) + SIGNED(u0_m0_wo0_accum_b));
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_accum_q <= u0_m0_wo0_accum_o(40 downto 0);

    -- GND(CONSTANT,0)@0
    GND_q <= "0";

    -- u0_m0_wo0_oseq(SEQUENCE,71)@17 + 1
    u0_m0_wo0_oseq_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_oseq_c : SIGNED(7 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_oseq_c := "00100101";
            u0_m0_wo0_oseq_q <= "0";
            u0_m0_wo0_oseq_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_17_q = "1") THEN
                IF (u0_m0_wo0_oseq_c = "00000000") THEN
                    u0_m0_wo0_oseq_eq <= '1';
                ELSE
                    u0_m0_wo0_oseq_eq <= '0';
                END IF;
                IF (u0_m0_wo0_oseq_eq = '1') THEN
                    u0_m0_wo0_oseq_c := u0_m0_wo0_oseq_c + 37;
                ELSE
                    u0_m0_wo0_oseq_c := u0_m0_wo0_oseq_c - 1;
                END IF;
                u0_m0_wo0_oseq_q <= STD_LOGIC_VECTOR(u0_m0_wo0_oseq_c(7 downto 7));
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_oseq_gated(LOGICAL,72)@18
    u0_m0_wo0_oseq_gated_q <= u0_m0_wo0_oseq_q and d_u0_m0_wo0_compute_q_18_q;

    -- u0_m0_wo0_oseq_gated_reg(REG,73)@18 + 1
    u0_m0_wo0_oseq_gated_reg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_oseq_gated_reg_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_oseq_gated_reg_q <= STD_LOGIC_VECTOR(u0_m0_wo0_oseq_gated_q);
        END IF;
    END PROCESS;

    -- xOut(PORTOUT,78)@19 + 1
    xOut_v <= u0_m0_wo0_oseq_gated_reg_q;
    xOut_c <= STD_LOGIC_VECTOR("0000000" & GND_q);
    xOut_0 <= u0_m0_wo0_accum_q;

END normal;
