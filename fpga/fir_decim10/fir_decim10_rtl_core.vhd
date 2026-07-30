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

-- VHDL created from fir_decim10_rtl_core
-- VHDL created on Fri Jul 31 01:51:46 2026


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

entity fir_decim10_rtl_core is
    port (
        xIn_v : in std_logic_vector(0 downto 0);  -- sfix1
        xIn_c : in std_logic_vector(7 downto 0);  -- sfix8
        xIn_0 : in std_logic_vector(11 downto 0);  -- sfix12
        xOut_v : out std_logic_vector(0 downto 0);  -- ufix1
        xOut_c : out std_logic_vector(7 downto 0);  -- ufix8
        xOut_0 : out std_logic_vector(43 downto 0);  -- sfix44
        clk : in std_logic;
        areset : in std_logic
    );
end fir_decim10_rtl_core;

architecture normal of fir_decim10_rtl_core is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_xIn_0_13_q : STD_LOGIC_VECTOR (11 downto 0);
    signal d_in0_m0_wi0_wo0_assign_id1_q_13_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_run_count : STD_LOGIC_VECTOR (5 downto 0);
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
    signal u0_m0_wo0_wi0_r0_ra0_count0_inner_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra0_count0_inner_i : SIGNED (6 downto 0);
    attribute preserve : boolean;
    attribute preserve of u0_m0_wo0_wi0_r0_ra0_count0_inner_i : signal is true;
    signal u0_m0_wo0_wi0_r0_ra0_count0_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra0_count0_i : UNSIGNED (5 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_ra0_count0_i : signal is true;
    signal u0_m0_wo0_wi0_r0_ra0_count1_lutreg_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra0_count1_q : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_ra0_count1_i : UNSIGNED (5 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_ra0_count1_i : signal is true;
    signal u0_m0_wo0_wi0_r0_ra0_count1_eq : std_logic;
    attribute preserve of u0_m0_wo0_wi0_r0_ra0_count1_eq : signal is true;
    signal u0_m0_wo0_wi0_r0_ra0_add_0_0_a : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra0_add_0_0_b : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra0_add_0_0_o : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra0_add_0_0_q : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_count0_q : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_count0_i : UNSIGNED (6 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_ra1_count0_i : signal is true;
    signal u0_m0_wo0_wi0_r0_ra1_count1_lutreg_q : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_add_0_0_a : STD_LOGIC_VECTOR (8 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_add_0_0_b : STD_LOGIC_VECTOR (8 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_add_0_0_o : STD_LOGIC_VECTOR (8 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_add_0_0_q : STD_LOGIC_VECTOR (8 downto 0);
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
    signal u0_m0_wo0_wi0_r0_wa0_q : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_wa0_i : UNSIGNED (5 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_wa0_i : signal is true;
    signal u0_m0_wo0_wi0_r0_wa1_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_wa1_i : UNSIGNED (6 downto 0);
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
    signal u0_m0_wo0_wi0_r0_memr1_aa : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_memr1_ab : STD_LOGIC_VECTOR (6 downto 0);
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
    signal u0_m0_wo0_cm0_q : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_cm1_q : STD_LOGIC_VECTOR (23 downto 0);
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
    signal u0_m0_wo0_mtree_add0_0_a : STD_LOGIC_VECTOR (37 downto 0);
    signal u0_m0_wo0_mtree_add0_0_b : STD_LOGIC_VECTOR (37 downto 0);
    signal u0_m0_wo0_mtree_add0_0_o : STD_LOGIC_VECTOR (37 downto 0);
    signal u0_m0_wo0_mtree_add0_0_q : STD_LOGIC_VECTOR (37 downto 0);
    signal u0_m0_wo0_aseq_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_aseq_eq : std_logic;
    signal u0_m0_wo0_accum_a : STD_LOGIC_VECTOR (43 downto 0);
    signal u0_m0_wo0_accum_b : STD_LOGIC_VECTOR (43 downto 0);
    signal u0_m0_wo0_accum_i : STD_LOGIC_VECTOR (43 downto 0);
    signal u0_m0_wo0_accum_o : STD_LOGIC_VECTOR (43 downto 0);
    signal u0_m0_wo0_accum_q : STD_LOGIC_VECTOR (43 downto 0);
    signal u0_m0_wo0_oseq_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_oseq_eq : std_logic;
    signal u0_m0_wo0_oseq_gated_reg_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im0_a0 : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im0_b0 : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im0_s1 : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im0_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_1_im0_q : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im3_a0 : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im3_b0 : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im3_s1 : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_im3_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_1_im3_q : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_result_add_0_0_a : STD_LOGIC_VECTOR (37 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_result_add_0_0_b : STD_LOGIC_VECTOR (37 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_result_add_0_0_o : STD_LOGIC_VECTOR (37 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_result_add_0_0_q : STD_LOGIC_VECTOR (37 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im0_a0 : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im0_b0 : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im0_s1 : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im0_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_0_im0_q : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im3_a0 : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im3_b0 : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im3_s1 : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_im3_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_0_im3_q : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_result_add_0_0_a : STD_LOGIC_VECTOR (37 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_result_add_0_0_b : STD_LOGIC_VECTOR (37 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_result_add_0_0_o : STD_LOGIC_VECTOR (37 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_result_add_0_0_q : STD_LOGIC_VECTOR (37 downto 0);
    signal u0_m0_wo0_wi0_r0_ra0_count0_run_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_r0_we2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_oseq_gated_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_r0_ra0_count1_lut_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_count1_lut_q : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_count1_lut_q : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra3_count1_lut_q : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_wi0_r0_ra0_resize_in : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_ra0_resize_b : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_resize_in : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra1_resize_b : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_resize_in : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_resize_b : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra3_resize_in : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra3_resize_b : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_bs1_merged_bit_select_b : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_bs1_merged_bit_select_c : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_bs1_merged_bit_select_b : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_bs1_merged_bit_select_c : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_align_8_q : STD_LOGIC_VECTOR (36 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_align_8_qint : STD_LOGIC_VECTOR (36 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_align_8_q : STD_LOGIC_VECTOR (36 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_align_8_qint : STD_LOGIC_VECTOR (36 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_bjA5_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_bjA5_q : STD_LOGIC_VECTOR (17 downto 0);

begin


    -- VCC(CONSTANT,1)@0
    VCC_q <= "1";

    -- u0_m0_wo0_run(ENABLEGENERATOR,13)@10 + 2
    u0_m0_wo0_run_ctrl <= u0_m0_wo0_run_out & xIn_v & u0_m0_wo0_run_enableQ;
    u0_m0_wo0_run_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_run_enable_c : SIGNED(6 downto 0);
        variable u0_m0_wo0_run_inc : SIGNED(5 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_run_q <= "0";
            u0_m0_wo0_run_enable_c := TO_SIGNED(54, 7);
            u0_m0_wo0_run_enableQ <= "0";
            u0_m0_wo0_run_count <= "000000";
            u0_m0_wo0_run_inc := (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_run_out = "1") THEN
                IF (u0_m0_wo0_run_enable_c(6) = '1') THEN
                    u0_m0_wo0_run_enable_c := u0_m0_wo0_run_enable_c - (-55);
                ELSE
                    u0_m0_wo0_run_enable_c := u0_m0_wo0_run_enable_c + (-1);
                END IF;
                u0_m0_wo0_run_enableQ <= STD_LOGIC_VECTOR(u0_m0_wo0_run_enable_c(6 downto 6));
            ELSE
                u0_m0_wo0_run_enableQ <= "0";
            END IF;
            CASE (u0_m0_wo0_run_ctrl) IS
                WHEN "000" | "001" => u0_m0_wo0_run_inc := "000000";
                WHEN "010" | "011" => u0_m0_wo0_run_inc := "111111";
                WHEN "100" => u0_m0_wo0_run_inc := "000000";
                WHEN "101" => u0_m0_wo0_run_inc := "001010";
                WHEN "110" => u0_m0_wo0_run_inc := "111111";
                WHEN "111" => u0_m0_wo0_run_inc := "001001";
                WHEN OTHERS => 
            END CASE;
            u0_m0_wo0_run_count <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_run_count) + SIGNED(u0_m0_wo0_run_inc));
            u0_m0_wo0_run_q <= u0_m0_wo0_run_out;
        END IF;
    END PROCESS;
    u0_m0_wo0_run_preEnaQ <= u0_m0_wo0_run_count(5 downto 5);
    u0_m0_wo0_run_out <= u0_m0_wo0_run_preEnaQ and VCC_q;

    -- u0_m0_wo0_memread(DELAY,14)@12
    u0_m0_wo0_memread : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_run_q, xout => u0_m0_wo0_memread_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_compute(DELAY,16)@12
    u0_m0_wo0_compute : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_memread_q, xout => u0_m0_wo0_compute_q, clk => clk, aclr => areset );

    -- d_u0_m0_wo0_compute_q_13(DELAY,111)@12 + 1
    d_u0_m0_wo0_compute_q_13 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_compute_q, xout => d_u0_m0_wo0_compute_q_13_q, clk => clk, aclr => areset );

    -- d_u0_m0_wo0_compute_q_17(DELAY,112)@13 + 4
    d_u0_m0_wo0_compute_q_17 : dspba_delay
    GENERIC MAP ( width => 1, depth => 4, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_compute_q_13_q, xout => d_u0_m0_wo0_compute_q_17_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_aseq(SEQUENCE,75)@17 + 1
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
                    u0_m0_wo0_aseq_c := u0_m0_wo0_aseq_c + 55;
                ELSE
                    u0_m0_wo0_aseq_c := u0_m0_wo0_aseq_c - 1;
                END IF;
                u0_m0_wo0_aseq_q <= STD_LOGIC_VECTOR(u0_m0_wo0_aseq_c(7 downto 7));
            END IF;
        END IF;
    END PROCESS;

    -- d_u0_m0_wo0_compute_q_18(DELAY,113)@17 + 1
    d_u0_m0_wo0_compute_q_18 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_compute_q_17_q, xout => d_u0_m0_wo0_compute_q_18_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_ca1(COUNTER,63)@13
    -- low=0, high=55, step=1, init=0
    u0_m0_wo0_ca1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_ca1_i <= TO_UNSIGNED(0, 6);
            u0_m0_wo0_ca1_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_13_q = "1") THEN
                IF (u0_m0_wo0_ca1_i = TO_UNSIGNED(54, 6)) THEN
                    u0_m0_wo0_ca1_eq <= '1';
                ELSE
                    u0_m0_wo0_ca1_eq <= '0';
                END IF;
                IF (u0_m0_wo0_ca1_eq = '1') THEN
                    u0_m0_wo0_ca1_i <= u0_m0_wo0_ca1_i + 9;
                ELSE
                    u0_m0_wo0_ca1_i <= u0_m0_wo0_ca1_i + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_ca1_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_ca1_i, 6)));

    -- u0_m0_wo0_cm0(LOOKUP,67)@13 + 1
    u0_m0_wo0_cm0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_cm0_q <= "111111111111110111101110";
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (u0_m0_wo0_ca1_q) IS
                WHEN "000000" => u0_m0_wo0_cm0_q <= "111111111111110111101110";
                WHEN "000001" => u0_m0_wo0_cm0_q <= "000000000001001101001010";
                WHEN "000010" => u0_m0_wo0_cm0_q <= "000000000010001001010111";
                WHEN "000011" => u0_m0_wo0_cm0_q <= "000000000010100100001011";
                WHEN "000100" => u0_m0_wo0_cm0_q <= "000000000010011100110101";
                WHEN "000101" => u0_m0_wo0_cm0_q <= "000000000001111001001010";
                WHEN "000110" => u0_m0_wo0_cm0_q <= "000000000001000011100111";
                WHEN "000111" => u0_m0_wo0_cm0_q <= "000000000000001000101001";
                WHEN "001000" => u0_m0_wo0_cm0_q <= "111111111111010100000101";
                WHEN "001001" => u0_m0_wo0_cm0_q <= "111111111110101110111011";
                WHEN "001010" => u0_m0_wo0_cm0_q <= "111111111110011110000001";
                WHEN "001011" => u0_m0_wo0_cm0_q <= "111111111110100001101011";
                WHEN "001100" => u0_m0_wo0_cm0_q <= "111111111110110110010010";
                WHEN "001101" => u0_m0_wo0_cm0_q <= "111111111111010101100001";
                WHEN "001110" => u0_m0_wo0_cm0_q <= "111111111111111000000000";
                WHEN "001111" => u0_m0_wo0_cm0_q <= "000000000000010110110010";
                WHEN "010000" => u0_m0_wo0_cm0_q <= "000000000000101100101100";
                WHEN "010001" => u0_m0_wo0_cm0_q <= "000000000000110111000000";
                WHEN "010010" => u0_m0_wo0_cm0_q <= "000000000000110101100110";
                WHEN "010011" => u0_m0_wo0_cm0_q <= "000000000000101010100101";
                WHEN "010100" => u0_m0_wo0_cm0_q <= "000000000000011001100100";
                WHEN "010101" => u0_m0_wo0_cm0_q <= "000000000000000110101011";
                WHEN "010110" => u0_m0_wo0_cm0_q <= "111111111111110101101111";
                WHEN "010111" => u0_m0_wo0_cm0_q <= "111111111111101001100010";
                WHEN "011000" => u0_m0_wo0_cm0_q <= "111111111111100011100001";
                WHEN "011001" => u0_m0_wo0_cm0_q <= "111111111111100011101110";
                WHEN "011010" => u0_m0_wo0_cm0_q <= "111111111111101001000000";
                WHEN "011011" => u0_m0_wo0_cm0_q <= "111111111111110001011110";
                WHEN "011100" => u0_m0_wo0_cm0_q <= "111111111111111010111110";
                WHEN "011101" => u0_m0_wo0_cm0_q <= "000000000000000011100101";
                WHEN "011110" => u0_m0_wo0_cm0_q <= "000000000000001001111001";
                WHEN "011111" => u0_m0_wo0_cm0_q <= "000000000000001101001101";
                WHEN "100000" => u0_m0_wo0_cm0_q <= "000000000000001101100000";
                WHEN "100001" => u0_m0_wo0_cm0_q <= "000000000000001011010110";
                WHEN "100010" => u0_m0_wo0_cm0_q <= "000000000000000111101001";
                WHEN "100011" => u0_m0_wo0_cm0_q <= "000000000000000011011000";
                WHEN "100100" => u0_m0_wo0_cm0_q <= "111111111111111111011101";
                WHEN "100101" => u0_m0_wo0_cm0_q <= "111111111111111100100000";
                WHEN "100110" => u0_m0_wo0_cm0_q <= "111111111111111010110101";
                WHEN "100111" => u0_m0_wo0_cm0_q <= "111111111111111010011101";
                WHEN "101000" => u0_m0_wo0_cm0_q <= "111111111111111011000111";
                WHEN "101001" => u0_m0_wo0_cm0_q <= "111111111111111100011100";
                WHEN "101010" => u0_m0_wo0_cm0_q <= "111111111111111110000010";
                WHEN "101011" => u0_m0_wo0_cm0_q <= "111111111111111111100100";
                WHEN "101100" => u0_m0_wo0_cm0_q <= "000000000000000000110000";
                WHEN "101101" => u0_m0_wo0_cm0_q <= "000000000000000001100001";
                WHEN "101110" => u0_m0_wo0_cm0_q <= "000000000000000001110101";
                WHEN "101111" => u0_m0_wo0_cm0_q <= "000000000000000001110010";
                WHEN "110000" => u0_m0_wo0_cm0_q <= "000000000000000001011111";
                WHEN "110001" => u0_m0_wo0_cm0_q <= "000000000000000001000110";
                WHEN "110010" => u0_m0_wo0_cm0_q <= "000000000000000000101101";
                WHEN "110011" => u0_m0_wo0_cm0_q <= "000000000000000000011000";
                WHEN "110100" => u0_m0_wo0_cm0_q <= "000000000000000000001001";
                WHEN "110101" => u0_m0_wo0_cm0_q <= "000000000000000000000001";
                WHEN "110110" => u0_m0_wo0_cm0_q <= "111111111111111111111110";
                WHEN "110111" => u0_m0_wo0_cm0_q <= "111111111111111111111100";
                WHEN OTHERS => -- unreachable
                               u0_m0_wo0_cm0_q <= (others => '-');
            END CASE;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_mtree_mult1_1_bs1_merged_bit_select(BITSELECT,107)@14
    u0_m0_wo0_mtree_mult1_1_bs1_merged_bit_select_b <= STD_LOGIC_VECTOR(u0_m0_wo0_cm0_q(23 downto 17));
    u0_m0_wo0_mtree_mult1_1_bs1_merged_bit_select_c <= STD_LOGIC_VECTOR(u0_m0_wo0_cm0_q(16 downto 0));

    -- u0_m0_wo0_wi0_r0_ra0_count1(COUNTER,24)@12
    -- low=0, high=55, step=1, init=1
    u0_m0_wo0_wi0_r0_ra0_count1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra0_count1_i <= TO_UNSIGNED(1, 6);
            u0_m0_wo0_wi0_r0_ra0_count1_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                IF (u0_m0_wo0_wi0_r0_ra0_count1_i = TO_UNSIGNED(54, 6)) THEN
                    u0_m0_wo0_wi0_r0_ra0_count1_eq <= '1';
                ELSE
                    u0_m0_wo0_wi0_r0_ra0_count1_eq <= '0';
                END IF;
                IF (u0_m0_wo0_wi0_r0_ra0_count1_eq = '1') THEN
                    u0_m0_wo0_wi0_r0_ra0_count1_i <= u0_m0_wo0_wi0_r0_ra0_count1_i + 9;
                ELSE
                    u0_m0_wo0_wi0_r0_ra0_count1_i <= u0_m0_wo0_wi0_r0_ra0_count1_i + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra0_count1_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_ra0_count1_i, 6)));

    -- u0_m0_wo0_wi0_r0_ra3_count1_lut(LOOKUP,46)@12
    u0_m0_wo0_wi0_r0_ra3_count1_lut_combproc: PROCESS (u0_m0_wo0_wi0_r0_ra0_count1_q)
    BEGIN
        -- Begin reserved scope level
        CASE (u0_m0_wo0_wi0_r0_ra0_count1_q) IS
            WHEN "000000" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00101110";
            WHEN "000001" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00101111";
            WHEN "000010" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00110000";
            WHEN "000011" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00110001";
            WHEN "000100" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00110010";
            WHEN "000101" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00110011";
            WHEN "000110" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00110100";
            WHEN "000111" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00110101";
            WHEN "001000" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00110110";
            WHEN "001001" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00110111";
            WHEN "001010" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00100100";
            WHEN "001011" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00100101";
            WHEN "001100" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00100110";
            WHEN "001101" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00100111";
            WHEN "001110" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00101000";
            WHEN "001111" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00101001";
            WHEN "010000" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00101010";
            WHEN "010001" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00101011";
            WHEN "010010" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00101100";
            WHEN "010011" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00101101";
            WHEN "010100" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00011010";
            WHEN "010101" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00011011";
            WHEN "010110" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00011100";
            WHEN "010111" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00011101";
            WHEN "011000" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00011110";
            WHEN "011001" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00011111";
            WHEN "011010" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00100000";
            WHEN "011011" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00100001";
            WHEN "011100" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00100010";
            WHEN "011101" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00100011";
            WHEN "011110" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00010000";
            WHEN "011111" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00010001";
            WHEN "100000" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00010010";
            WHEN "100001" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00010011";
            WHEN "100010" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00010100";
            WHEN "100011" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00010101";
            WHEN "100100" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00010110";
            WHEN "100101" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00010111";
            WHEN "100110" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00011000";
            WHEN "100111" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00011001";
            WHEN "101000" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00000110";
            WHEN "101001" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00000111";
            WHEN "101010" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00001000";
            WHEN "101011" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00001001";
            WHEN "101100" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00001010";
            WHEN "101101" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00001011";
            WHEN "101110" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00001100";
            WHEN "101111" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00001101";
            WHEN "110000" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00001110";
            WHEN "110001" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00001111";
            WHEN "110010" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01111100";
            WHEN "110011" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01111101";
            WHEN "110100" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01111110";
            WHEN "110101" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "01111111";
            WHEN "110110" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00000000";
            WHEN "110111" => u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= "00000001";
            WHEN OTHERS => -- unreachable
                           u0_m0_wo0_wi0_r0_ra3_count1_lut_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra3_count1_lutreg(REG,47)@12
    u0_m0_wo0_wi0_r0_ra3_count1_lutreg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra3_count1_lutreg_q <= "00101110";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                u0_m0_wo0_wi0_r0_ra3_count1_lutreg_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra3_count1_lut_q);
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra0_count0_inner(COUNTER,19)@12
    -- low=-1, high=54, step=-1, init=54
    u0_m0_wo0_wi0_r0_ra0_count0_inner_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra0_count0_inner_i <= TO_SIGNED(54, 7);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                IF (u0_m0_wo0_wi0_r0_ra0_count0_inner_i(6 downto 6) = "1") THEN
                    u0_m0_wo0_wi0_r0_ra0_count0_inner_i <= u0_m0_wo0_wi0_r0_ra0_count0_inner_i - 73;
                ELSE
                    u0_m0_wo0_wi0_r0_ra0_count0_inner_i <= u0_m0_wo0_wi0_r0_ra0_count0_inner_i - 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra0_count0_inner_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_ra0_count0_inner_i, 7)));

    -- u0_m0_wo0_wi0_r0_ra0_count0_run(LOGICAL,20)@12
    u0_m0_wo0_wi0_r0_ra0_count0_run_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra0_count0_inner_q(6 downto 6));

    -- u0_m0_wo0_wi0_r0_ra1_count0(COUNTER,29)@12
    -- low=0, high=127, step=10, init=0
    u0_m0_wo0_wi0_r0_ra1_count0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra1_count0_i <= TO_UNSIGNED(0, 7);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1" and u0_m0_wo0_wi0_r0_ra0_count0_run_q = "1") THEN
                u0_m0_wo0_wi0_r0_ra1_count0_i <= u0_m0_wo0_wi0_r0_ra1_count0_i + 10;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra1_count0_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_ra1_count0_i, 8)));

    -- u0_m0_wo0_wi0_r0_ra3_add_0_0(ADD,49)@12 + 1
    u0_m0_wo0_wi0_r0_ra3_add_0_0_a <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_r0_ra1_count0_q);
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

    -- u0_m0_wo0_wi0_r0_ra3_resize(BITSELECT,50)@13
    u0_m0_wo0_wi0_r0_ra3_resize_in <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra3_add_0_0_q(6 downto 0));
    u0_m0_wo0_wi0_r0_ra3_resize_b <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra3_resize_in(6 downto 0));

    -- u0_m0_wo0_wi0_r0_ra2_count1_lut(LOOKUP,38)@12
    u0_m0_wo0_wi0_r0_ra2_count1_lut_combproc: PROCESS (u0_m0_wo0_wi0_r0_ra0_count1_q)
    BEGIN
        -- Begin reserved scope level
        CASE (u0_m0_wo0_wi0_r0_ra0_count1_q) IS
            WHEN "000000" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00110011";
            WHEN "000001" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00110010";
            WHEN "000010" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00110001";
            WHEN "000011" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00110000";
            WHEN "000100" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00101111";
            WHEN "000101" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00101110";
            WHEN "000110" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00101101";
            WHEN "000111" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00101100";
            WHEN "001000" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00101011";
            WHEN "001001" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00101010";
            WHEN "001010" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00101001";
            WHEN "001011" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00101000";
            WHEN "001100" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00100111";
            WHEN "001101" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00100110";
            WHEN "001110" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00100101";
            WHEN "001111" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00100100";
            WHEN "010000" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00100011";
            WHEN "010001" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00100010";
            WHEN "010010" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00100001";
            WHEN "010011" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00100000";
            WHEN "010100" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00011111";
            WHEN "010101" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00011110";
            WHEN "010110" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00011101";
            WHEN "010111" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00011100";
            WHEN "011000" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00011011";
            WHEN "011001" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00011010";
            WHEN "011010" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00011001";
            WHEN "011011" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00011000";
            WHEN "011100" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00010111";
            WHEN "011101" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00010110";
            WHEN "011110" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00010101";
            WHEN "011111" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00010100";
            WHEN "100000" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00010011";
            WHEN "100001" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00010010";
            WHEN "100010" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00010001";
            WHEN "100011" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00010000";
            WHEN "100100" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00001111";
            WHEN "100101" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00001110";
            WHEN "100110" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00001101";
            WHEN "100111" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00001100";
            WHEN "101000" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00001011";
            WHEN "101001" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00001010";
            WHEN "101010" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00001001";
            WHEN "101011" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00001000";
            WHEN "101100" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00000111";
            WHEN "101101" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00000110";
            WHEN "101110" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00000101";
            WHEN "101111" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00000100";
            WHEN "110000" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00000011";
            WHEN "110001" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00000010";
            WHEN "110010" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00000001";
            WHEN "110011" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "00000000";
            WHEN "110100" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01111111";
            WHEN "110101" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01111110";
            WHEN "110110" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01111101";
            WHEN "110111" => u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= "01111100";
            WHEN OTHERS => -- unreachable
                           u0_m0_wo0_wi0_r0_ra2_count1_lut_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra2_count1_lutreg(REG,39)@12
    u0_m0_wo0_wi0_r0_ra2_count1_lutreg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra2_count1_lutreg_q <= "00110011";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                u0_m0_wo0_wi0_r0_ra2_count1_lutreg_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra2_count1_lut_q);
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra2_add_0_0(ADD,41)@12 + 1
    u0_m0_wo0_wi0_r0_ra2_add_0_0_a <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_r0_ra1_count0_q);
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

    -- u0_m0_wo0_wi0_r0_ra2_resize(BITSELECT,42)@13
    u0_m0_wo0_wi0_r0_ra2_resize_in <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra2_add_0_0_q(6 downto 0));
    u0_m0_wo0_wi0_r0_ra2_resize_b <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra2_resize_in(6 downto 0));

    -- u0_m0_wo0_wi0_r0_ra1_count1_lut(LOOKUP,30)@12
    u0_m0_wo0_wi0_r0_ra1_count1_lut_combproc: PROCESS (u0_m0_wo0_wi0_r0_ra0_count1_q)
    BEGIN
        -- Begin reserved scope level
        CASE (u0_m0_wo0_wi0_r0_ra0_count1_q) IS
            WHEN "000000" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01011001";
            WHEN "000001" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01011010";
            WHEN "000010" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01011011";
            WHEN "000011" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01011100";
            WHEN "000100" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01011101";
            WHEN "000101" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01011110";
            WHEN "000110" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01011111";
            WHEN "000111" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01100000";
            WHEN "001000" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01100001";
            WHEN "001001" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01100010";
            WHEN "001010" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01100011";
            WHEN "001011" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01100100";
            WHEN "001100" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01100101";
            WHEN "001101" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01100110";
            WHEN "001110" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01100111";
            WHEN "001111" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01101000";
            WHEN "010000" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01101001";
            WHEN "010001" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01101010";
            WHEN "010010" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01101011";
            WHEN "010011" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01101100";
            WHEN "010100" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01101101";
            WHEN "010101" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01101110";
            WHEN "010110" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01101111";
            WHEN "010111" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01110000";
            WHEN "011000" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01110001";
            WHEN "011001" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01110010";
            WHEN "011010" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01110011";
            WHEN "011011" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01110100";
            WHEN "011100" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01110101";
            WHEN "011101" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01110110";
            WHEN "011110" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01110111";
            WHEN "011111" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01111000";
            WHEN "100000" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01111001";
            WHEN "100001" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01111010";
            WHEN "100010" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01111011";
            WHEN "100011" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01111100";
            WHEN "100100" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01111101";
            WHEN "100101" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01111110";
            WHEN "100110" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "01111111";
            WHEN "100111" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00000000";
            WHEN "101000" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00000001";
            WHEN "101001" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00000010";
            WHEN "101010" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00000011";
            WHEN "101011" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00000100";
            WHEN "101100" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00000101";
            WHEN "101101" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00000110";
            WHEN "101110" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00000111";
            WHEN "101111" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00001000";
            WHEN "110000" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00001001";
            WHEN "110001" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00001010";
            WHEN "110010" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00001011";
            WHEN "110011" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00001100";
            WHEN "110100" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00001101";
            WHEN "110101" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00001110";
            WHEN "110110" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00001111";
            WHEN "110111" => u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= "00010000";
            WHEN OTHERS => -- unreachable
                           u0_m0_wo0_wi0_r0_ra1_count1_lut_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra1_count1_lutreg(REG,31)@12
    u0_m0_wo0_wi0_r0_ra1_count1_lutreg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra1_count1_lutreg_q <= "01011001";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                u0_m0_wo0_wi0_r0_ra1_count1_lutreg_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra1_count1_lut_q);
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra1_add_0_0(ADD,33)@12 + 1
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
    u0_m0_wo0_wi0_r0_ra1_add_0_0_q <= u0_m0_wo0_wi0_r0_ra1_add_0_0_o(8 downto 0);

    -- u0_m0_wo0_wi0_r0_ra1_resize(BITSELECT,34)@13
    u0_m0_wo0_wi0_r0_ra1_resize_in <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra1_add_0_0_q(6 downto 0));
    u0_m0_wo0_wi0_r0_ra1_resize_b <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra1_resize_in(6 downto 0));

    -- u0_m0_wo0_wi0_r0_we1_seq(SEQUENCE,51)@12 + 1
    u0_m0_wo0_wi0_r0_we1_seq_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_wi0_r0_we1_seq_c : SIGNED(7 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_we1_seq_c := "00000000";
            u0_m0_wo0_wi0_r0_we1_seq_q <= "0";
            u0_m0_wo0_wi0_r0_we1_seq_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_compute_q = "1") THEN
                IF (u0_m0_wo0_wi0_r0_we1_seq_c = "11110111") THEN
                    u0_m0_wo0_wi0_r0_we1_seq_eq <= '1';
                ELSE
                    u0_m0_wo0_wi0_r0_we1_seq_eq <= '0';
                END IF;
                IF (u0_m0_wo0_wi0_r0_we1_seq_eq = '1') THEN
                    u0_m0_wo0_wi0_r0_we1_seq_c := u0_m0_wo0_wi0_r0_we1_seq_c + 55;
                ELSE
                    u0_m0_wo0_wi0_r0_we1_seq_c := u0_m0_wo0_wi0_r0_we1_seq_c - 1;
                END IF;
                u0_m0_wo0_wi0_r0_we1_seq_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_we1_seq_c(7 downto 7));
            ELSE
                u0_m0_wo0_wi0_r0_we1_seq_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_wa1(COUNTER,56)@13
    -- low=0, high=127, step=1, init=17
    u0_m0_wo0_wi0_r0_wa1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_wa1_i <= TO_UNSIGNED(17, 7);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_wi0_r0_we1_seq_q = "1") THEN
                u0_m0_wo0_wi0_r0_wa1_i <= u0_m0_wo0_wi0_r0_wa1_i + 1;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_wa1_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_wa1_i, 7)));

    -- u0_m0_wo0_wi0_r0_memr1(DUALMEM,60)@13
    u0_m0_wo0_wi0_r0_memr1_ia <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_memr0_q);
    u0_m0_wo0_wi0_r0_memr1_aa <= u0_m0_wo0_wi0_r0_wa1_q;
    u0_m0_wo0_wi0_r0_memr1_ab <= u0_m0_wo0_wi0_r0_ra1_resize_b;
    u0_m0_wo0_wi0_r0_memr1_dmem : altsyncram
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
        address_a => u0_m0_wo0_wi0_r0_memr1_aa,
        data_a => u0_m0_wo0_wi0_r0_memr1_ia,
        wren_a => u0_m0_wo0_wi0_r0_we1_seq_q(0),
        address_b => u0_m0_wo0_wi0_r0_memr1_ab,
        q_b => u0_m0_wo0_wi0_r0_memr1_iq
    );
    u0_m0_wo0_wi0_r0_memr1_q <= u0_m0_wo0_wi0_r0_memr1_iq(11 downto 0);

    -- u0_m0_wo0_wi0_r0_we2_1(REG,53)@13
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

    -- u0_m0_wo0_wi0_r0_we2(LOGICAL,54)@13
    u0_m0_wo0_wi0_r0_we2_q <= u0_m0_wo0_wi0_r0_we2_1_q and d_u0_m0_wo0_compute_q_13_q;

    -- u0_m0_wo0_wi0_r0_wa2(COUNTER,57)@13
    -- low=0, high=127, step=1, init=52
    u0_m0_wo0_wi0_r0_wa2_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_wa2_i <= TO_UNSIGNED(52, 7);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_wi0_r0_we2_q = "1") THEN
                u0_m0_wo0_wi0_r0_wa2_i <= u0_m0_wo0_wi0_r0_wa2_i + 1;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_wa2_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_wa2_i, 7)));

    -- u0_m0_wo0_wi0_r0_memr2(DUALMEM,61)@13
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

    -- u0_m0_wo0_wi0_r0_we3_seq(SEQUENCE,52)@12 + 1
    u0_m0_wo0_wi0_r0_we3_seq_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_wi0_r0_we3_seq_c : SIGNED(7 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_we3_seq_c := "11110110";
            u0_m0_wo0_wi0_r0_we3_seq_q <= "0";
            u0_m0_wo0_wi0_r0_we3_seq_eq <= '1';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_compute_q = "1") THEN
                IF (u0_m0_wo0_wi0_r0_we3_seq_c = "11110111") THEN
                    u0_m0_wo0_wi0_r0_we3_seq_eq <= '1';
                ELSE
                    u0_m0_wo0_wi0_r0_we3_seq_eq <= '0';
                END IF;
                IF (u0_m0_wo0_wi0_r0_we3_seq_eq = '1') THEN
                    u0_m0_wo0_wi0_r0_we3_seq_c := u0_m0_wo0_wi0_r0_we3_seq_c + 55;
                ELSE
                    u0_m0_wo0_wi0_r0_we3_seq_c := u0_m0_wo0_wi0_r0_we3_seq_c - 1;
                END IF;
                u0_m0_wo0_wi0_r0_we3_seq_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_we3_seq_c(7 downto 7));
            ELSE
                u0_m0_wo0_wi0_r0_we3_seq_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_wa3(COUNTER,58)@13
    -- low=0, high=127, step=1, init=56
    u0_m0_wo0_wi0_r0_wa3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_wa3_i <= TO_UNSIGNED(56, 7);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_wi0_r0_we3_seq_q = "1") THEN
                u0_m0_wo0_wi0_r0_wa3_i <= u0_m0_wo0_wi0_r0_wa3_i + 1;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_wa3_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_wa3_i, 7)));

    -- u0_m0_wo0_wi0_r0_memr3(DUALMEM,62)@13
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

    -- u0_m0_wo0_wi0_r0_ra0_count1_lut(LOOKUP,22)@12
    u0_m0_wo0_wi0_r0_ra0_count1_lut_combproc: PROCESS (u0_m0_wo0_wi0_r0_ra0_count1_q)
    BEGIN
        -- Begin reserved scope level
        CASE (u0_m0_wo0_wi0_r0_ra0_count1_q) IS
            WHEN "000000" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0000001";
            WHEN "000001" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0000010";
            WHEN "000010" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0000011";
            WHEN "000011" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0000100";
            WHEN "000100" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0000101";
            WHEN "000101" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0000110";
            WHEN "000110" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0000111";
            WHEN "000111" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0001000";
            WHEN "001000" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0001001";
            WHEN "001001" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0001010";
            WHEN "001010" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0001011";
            WHEN "001011" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0001100";
            WHEN "001100" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0001101";
            WHEN "001101" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0001110";
            WHEN "001110" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0001111";
            WHEN "001111" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0010000";
            WHEN "010000" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0010001";
            WHEN "010001" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0010010";
            WHEN "010010" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0010011";
            WHEN "010011" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0010100";
            WHEN "010100" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0010101";
            WHEN "010101" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0010110";
            WHEN "010110" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0010111";
            WHEN "010111" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0011000";
            WHEN "011000" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0011001";
            WHEN "011001" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0011010";
            WHEN "011010" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0011011";
            WHEN "011011" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0011100";
            WHEN "011100" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0011101";
            WHEN "011101" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0011110";
            WHEN "011110" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0011111";
            WHEN "011111" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0100000";
            WHEN "100000" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0100001";
            WHEN "100001" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0100010";
            WHEN "100010" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0100011";
            WHEN "100011" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0100100";
            WHEN "100100" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0100101";
            WHEN "100101" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0100110";
            WHEN "100110" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0100111";
            WHEN "100111" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0101000";
            WHEN "101000" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0101001";
            WHEN "101001" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0101010";
            WHEN "101010" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0101011";
            WHEN "101011" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0101100";
            WHEN "101100" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0101101";
            WHEN "101101" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0101110";
            WHEN "101110" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0101111";
            WHEN "101111" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0110000";
            WHEN "110000" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0110001";
            WHEN "110001" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0110010";
            WHEN "110010" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0110011";
            WHEN "110011" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0110100";
            WHEN "110100" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0110101";
            WHEN "110101" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0110110";
            WHEN "110110" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0110111";
            WHEN "110111" => u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= "0111000";
            WHEN OTHERS => -- unreachable
                           u0_m0_wo0_wi0_r0_ra0_count1_lut_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra0_count1_lutreg(REG,23)@12
    u0_m0_wo0_wi0_r0_ra0_count1_lutreg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra0_count1_lutreg_q <= "0000001";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                u0_m0_wo0_wi0_r0_ra0_count1_lutreg_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra0_count1_lut_q);
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra0_count0(COUNTER,21)@12
    -- low=0, high=63, step=10, init=0
    u0_m0_wo0_wi0_r0_ra0_count0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra0_count0_i <= TO_UNSIGNED(0, 6);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1" and u0_m0_wo0_wi0_r0_ra0_count0_run_q = "1") THEN
                u0_m0_wo0_wi0_r0_ra0_count0_i <= u0_m0_wo0_wi0_r0_ra0_count0_i + 10;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra0_count0_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_ra0_count0_i, 7)));

    -- u0_m0_wo0_wi0_r0_ra0_add_0_0(ADD,25)@12 + 1
    u0_m0_wo0_wi0_r0_ra0_add_0_0_a <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_r0_ra0_count0_q);
    u0_m0_wo0_wi0_r0_ra0_add_0_0_b <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_r0_ra0_count1_lutreg_q);
    u0_m0_wo0_wi0_r0_ra0_add_0_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra0_add_0_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_wi0_r0_ra0_add_0_0_o <= STD_LOGIC_VECTOR(UNSIGNED(u0_m0_wo0_wi0_r0_ra0_add_0_0_a) + UNSIGNED(u0_m0_wo0_wi0_r0_ra0_add_0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra0_add_0_0_q <= u0_m0_wo0_wi0_r0_ra0_add_0_0_o(7 downto 0);

    -- u0_m0_wo0_wi0_r0_ra0_resize(BITSELECT,26)@13
    u0_m0_wo0_wi0_r0_ra0_resize_in <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra0_add_0_0_q(5 downto 0));
    u0_m0_wo0_wi0_r0_ra0_resize_b <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra0_resize_in(5 downto 0));

    -- d_xIn_0_13(DELAY,109)@10 + 3
    d_xIn_0_13 : dspba_delay
    GENERIC MAP ( width => 12, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => xIn_0, xout => d_xIn_0_13_q, clk => clk, aclr => areset );

    -- d_in0_m0_wi0_wo0_assign_id1_q_13(DELAY,110)@10 + 3
    d_in0_m0_wi0_wo0_assign_id1_q_13 : dspba_delay
    GENERIC MAP ( width => 1, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => xIn_v, xout => d_in0_m0_wi0_wo0_assign_id1_q_13_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_wi0_r0_wa0(COUNTER,55)@13
    -- low=0, high=63, step=1, init=56
    u0_m0_wo0_wi0_r0_wa0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_wa0_i <= TO_UNSIGNED(56, 6);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_in0_m0_wi0_wo0_assign_id1_q_13_q = "1") THEN
                u0_m0_wo0_wi0_r0_wa0_i <= u0_m0_wo0_wi0_r0_wa0_i + 1;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_wa0_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_wa0_i, 6)));

    -- u0_m0_wo0_wi0_r0_memr0(DUALMEM,59)@13
    u0_m0_wo0_wi0_r0_memr0_ia <= STD_LOGIC_VECTOR(d_xIn_0_13_q);
    u0_m0_wo0_wi0_r0_memr0_aa <= u0_m0_wo0_wi0_r0_wa0_q;
    u0_m0_wo0_wi0_r0_memr0_ab <= u0_m0_wo0_wi0_r0_ra0_resize_b;
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

    -- u0_m0_wo0_sym_add0(ADD,69)@13 + 1
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

    -- u0_m0_wo0_mtree_mult1_1_im0(MULT,85)@14 + 2
    u0_m0_wo0_mtree_mult1_1_im0_a0 <= STD_LOGIC_VECTOR(u0_m0_wo0_sym_add0_q);
    u0_m0_wo0_mtree_mult1_1_im0_b0 <= STD_LOGIC_VECTOR(u0_m0_wo0_mtree_mult1_1_bs1_merged_bit_select_b);
    u0_m0_wo0_mtree_mult1_1_im0_reset <= areset;
    u0_m0_wo0_mtree_mult1_1_im0_component : lpm_mult
    GENERIC MAP (
        lpm_widtha => 13,
        lpm_widthb => 7,
        lpm_widthp => 20,
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

    -- u0_m0_wo0_mtree_mult1_1_align_8(BITSHIFT,93)@16
    u0_m0_wo0_mtree_mult1_1_align_8_qint <= u0_m0_wo0_mtree_mult1_1_im0_q & "00000000000000000";
    u0_m0_wo0_mtree_mult1_1_align_8_q <= u0_m0_wo0_mtree_mult1_1_align_8_qint(36 downto 0);

    -- u0_m0_wo0_mtree_mult1_1_bjA5(BITJOIN,90)@14
    u0_m0_wo0_mtree_mult1_1_bjA5_q <= GND_q & u0_m0_wo0_mtree_mult1_1_bs1_merged_bit_select_c;

    -- u0_m0_wo0_mtree_mult1_1_im3(MULT,88)@14 + 2
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

    -- u0_m0_wo0_mtree_mult1_1_result_add_0_0(ADD,95)@16 + 1
    u0_m0_wo0_mtree_mult1_1_result_add_0_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((37 downto 31 => u0_m0_wo0_mtree_mult1_1_im3_q(30)) & u0_m0_wo0_mtree_mult1_1_im3_q));
    u0_m0_wo0_mtree_mult1_1_result_add_0_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((37 downto 37 => u0_m0_wo0_mtree_mult1_1_align_8_q(36)) & u0_m0_wo0_mtree_mult1_1_align_8_q));
    u0_m0_wo0_mtree_mult1_1_result_add_0_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_1_result_add_0_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_1_result_add_0_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_1_result_add_0_0_a) + SIGNED(u0_m0_wo0_mtree_mult1_1_result_add_0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_1_result_add_0_0_q <= u0_m0_wo0_mtree_mult1_1_result_add_0_0_o(37 downto 0);

    -- u0_m0_wo0_cm1(LOOKUP,68)@13 + 1
    u0_m0_wo0_cm1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_cm1_q <= "000100100100110100000101";
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (u0_m0_wo0_ca1_q) IS
                WHEN "000000" => u0_m0_wo0_cm1_q <= "000100100100110100000101";
                WHEN "000001" => u0_m0_wo0_cm1_q <= "000100011010111101010110";
                WHEN "000010" => u0_m0_wo0_cm1_q <= "000011111110100110011001";
                WHEN "000011" => u0_m0_wo0_cm1_q <= "000011010011001011100000";
                WHEN "000100" => u0_m0_wo0_cm1_q <= "000010011101110111101100";
                WHEN "000101" => u0_m0_wo0_cm1_q <= "000001100100110100100111";
                WHEN "000110" => u0_m0_wo0_cm1_q <= "000000101110010010100011";
                WHEN "000111" => u0_m0_wo0_cm1_q <= "111111111111110001010111";
                WHEN "001000" => u0_m0_wo0_cm1_q <= "111111011101010010110100";
                WHEN "001001" => u0_m0_wo0_cm1_q <= "111111001000111101000111";
                WHEN "001010" => u0_m0_wo0_cm1_q <= "111111000010110001101010";
                WHEN "001011" => u0_m0_wo0_cm1_q <= "111111001000111000000110";
                WHEN "001100" => u0_m0_wo0_cm1_q <= "111111010111111011010001";
                WHEN "001101" => u0_m0_wo0_cm1_q <= "111111101011110001111011";
                WHEN "001110" => u0_m0_wo0_cm1_q <= "000000000000001100001011";
                WHEN "001111" => u0_m0_wo0_cm1_q <= "000000010001011101111000";
                WHEN "010000" => u0_m0_wo0_cm1_q <= "000000011100111111011111";
                WHEN "010001" => u0_m0_wo0_cm1_q <= "000000100001100000011110";
                WHEN "010010" => u0_m0_wo0_cm1_q <= "000000011111001001101111";
                WHEN "010011" => u0_m0_wo0_cm1_q <= "000000010111010000111100";
                WHEN "010100" => u0_m0_wo0_cm1_q <= "000000001100000000001101";
                WHEN "010101" => u0_m0_wo0_cm1_q <= "111111111111110111100001";
                WHEN "010110" => u0_m0_wo0_cm1_q <= "111111110101001101101100";
                WHEN "010111" => u0_m0_wo0_cm1_q <= "111111101101110110010001";
                WHEN "011000" => u0_m0_wo0_cm1_q <= "111111101010110000101011";
                WHEN "011001" => u0_m0_wo0_cm1_q <= "111111101100000010011100";
                WHEN "011010" => u0_m0_wo0_cm1_q <= "111111110000111100101010";
                WHEN "011011" => u0_m0_wo0_cm1_q <= "111111111000001010010010";
                WHEN "011100" => u0_m0_wo0_cm1_q <= "000000000000000100001010";
                WHEN "011101" => u0_m0_wo0_cm1_q <= "000000000111000110000100";
                WHEN "011110" => u0_m0_wo0_cm1_q <= "000000001100000001001100";
                WHEN "011111" => u0_m0_wo0_cm1_q <= "000000001110001000100010";
                WHEN "100000" => u0_m0_wo0_cm1_q <= "000000001101010101111000";
                WHEN "100001" => u0_m0_wo0_cm1_q <= "000000001010000110110001";
                WHEN "100010" => u0_m0_wo0_cm1_q <= "000000000101010011001011";
                WHEN "100011" => u0_m0_wo0_cm1_q <= "000000000000000000001011";
                WHEN "100100" => u0_m0_wo0_cm1_q <= "111111111011010001011011";
                WHEN "100101" => u0_m0_wo0_cm1_q <= "111111110111111100011101";
                WHEN "100110" => u0_m0_wo0_cm1_q <= "111111110110100000000101";
                WHEN "100111" => u0_m0_wo0_cm1_q <= "111111110111000000110101";
                WHEN "101000" => u0_m0_wo0_cm1_q <= "111111111001001010111111";
                WHEN "101001" => u0_m0_wo0_cm1_q <= "111111111100011000111001";
                WHEN "101010" => u0_m0_wo0_cm1_q <= "111111111111111100000100";
                WHEN "101011" => u0_m0_wo0_cm1_q <= "000000000011000111000001";
                WHEN "101100" => u0_m0_wo0_cm1_q <= "000000000101010101111010";
                WHEN "101101" => u0_m0_wo0_cm1_q <= "000000000110010100010000";
                WHEN "101110" => u0_m0_wo0_cm1_q <= "000000000101111111001110";
                WHEN "101111" => u0_m0_wo0_cm1_q <= "000000000100100100001101";
                WHEN "110000" => u0_m0_wo0_cm1_q <= "000000000010011100011010";
                WHEN "110001" => u0_m0_wo0_cm1_q <= "000000000000000110101110";
                WHEN "110010" => u0_m0_wo0_cm1_q <= "111111111110000001000111";
                WHEN "110011" => u0_m0_wo0_cm1_q <= "111111111100100011000011";
                WHEN "110100" => u0_m0_wo0_cm1_q <= "111111111011111001101101";
                WHEN "110101" => u0_m0_wo0_cm1_q <= "111111111100000110101000";
                WHEN "110110" => u0_m0_wo0_cm1_q <= "111111111101000000110111";
                WHEN "110111" => u0_m0_wo0_cm1_q <= "111111111110010111111001";
                WHEN OTHERS => -- unreachable
                               u0_m0_wo0_cm1_q <= (others => '-');
            END CASE;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_mtree_mult1_0_bs1_merged_bit_select(BITSELECT,108)@14
    u0_m0_wo0_mtree_mult1_0_bs1_merged_bit_select_b <= STD_LOGIC_VECTOR(u0_m0_wo0_cm1_q(23 downto 17));
    u0_m0_wo0_mtree_mult1_0_bs1_merged_bit_select_c <= STD_LOGIC_VECTOR(u0_m0_wo0_cm1_q(16 downto 0));

    -- u0_m0_wo0_symSuppress_1_seq(SEQUENCE,70)@12 + 1
    u0_m0_wo0_symSuppress_1_seq_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_symSuppress_1_seq_c : SIGNED(7 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_symSuppress_1_seq_c := "00000000";
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
                    u0_m0_wo0_symSuppress_1_seq_c := u0_m0_wo0_symSuppress_1_seq_c + 55;
                ELSE
                    u0_m0_wo0_symSuppress_1_seq_c := u0_m0_wo0_symSuppress_1_seq_c - 1;
                END IF;
                u0_m0_wo0_symSuppress_1_seq_q <= STD_LOGIC_VECTOR(u0_m0_wo0_symSuppress_1_seq_c(7 downto 7));
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_sym_add1(ADD,71)@13 + 1
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

    -- u0_m0_wo0_mtree_mult1_0_im0(MULT,96)@14 + 2
    u0_m0_wo0_mtree_mult1_0_im0_a0 <= STD_LOGIC_VECTOR(u0_m0_wo0_sym_add1_q);
    u0_m0_wo0_mtree_mult1_0_im0_b0 <= STD_LOGIC_VECTOR(u0_m0_wo0_mtree_mult1_0_bs1_merged_bit_select_b);
    u0_m0_wo0_mtree_mult1_0_im0_reset <= areset;
    u0_m0_wo0_mtree_mult1_0_im0_component : lpm_mult
    GENERIC MAP (
        lpm_widtha => 13,
        lpm_widthb => 7,
        lpm_widthp => 20,
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

    -- u0_m0_wo0_mtree_mult1_0_align_8(BITSHIFT,104)@16
    u0_m0_wo0_mtree_mult1_0_align_8_qint <= u0_m0_wo0_mtree_mult1_0_im0_q & "00000000000000000";
    u0_m0_wo0_mtree_mult1_0_align_8_q <= u0_m0_wo0_mtree_mult1_0_align_8_qint(36 downto 0);

    -- u0_m0_wo0_mtree_mult1_0_bjA5(BITJOIN,101)@14
    u0_m0_wo0_mtree_mult1_0_bjA5_q <= GND_q & u0_m0_wo0_mtree_mult1_0_bs1_merged_bit_select_c;

    -- u0_m0_wo0_mtree_mult1_0_im3(MULT,99)@14 + 2
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

    -- u0_m0_wo0_mtree_mult1_0_result_add_0_0(ADD,106)@16 + 1
    u0_m0_wo0_mtree_mult1_0_result_add_0_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((37 downto 31 => u0_m0_wo0_mtree_mult1_0_im3_q(30)) & u0_m0_wo0_mtree_mult1_0_im3_q));
    u0_m0_wo0_mtree_mult1_0_result_add_0_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((37 downto 37 => u0_m0_wo0_mtree_mult1_0_align_8_q(36)) & u0_m0_wo0_mtree_mult1_0_align_8_q));
    u0_m0_wo0_mtree_mult1_0_result_add_0_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_0_result_add_0_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_0_result_add_0_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_0_result_add_0_0_a) + SIGNED(u0_m0_wo0_mtree_mult1_0_result_add_0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_0_result_add_0_0_q <= u0_m0_wo0_mtree_mult1_0_result_add_0_0_o(37 downto 0);

    -- u0_m0_wo0_mtree_add0_0(ADD,74)@17 + 1
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
    u0_m0_wo0_mtree_add0_0_q <= u0_m0_wo0_mtree_add0_0_o(37 downto 0);

    -- u0_m0_wo0_accum(ADD,76)@18 + 1
    u0_m0_wo0_accum_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((43 downto 38 => u0_m0_wo0_mtree_add0_0_q(37)) & u0_m0_wo0_mtree_add0_0_q));
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
    u0_m0_wo0_accum_q <= u0_m0_wo0_accum_o(43 downto 0);

    -- GND(CONSTANT,0)@0
    GND_q <= "0";

    -- u0_m0_wo0_oseq(SEQUENCE,77)@17 + 1
    u0_m0_wo0_oseq_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_oseq_c : SIGNED(7 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_oseq_c := "00110111";
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
                    u0_m0_wo0_oseq_c := u0_m0_wo0_oseq_c + 55;
                ELSE
                    u0_m0_wo0_oseq_c := u0_m0_wo0_oseq_c - 1;
                END IF;
                u0_m0_wo0_oseq_q <= STD_LOGIC_VECTOR(u0_m0_wo0_oseq_c(7 downto 7));
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_oseq_gated(LOGICAL,78)@18
    u0_m0_wo0_oseq_gated_q <= u0_m0_wo0_oseq_q and d_u0_m0_wo0_compute_q_18_q;

    -- u0_m0_wo0_oseq_gated_reg(REG,79)@18 + 1
    u0_m0_wo0_oseq_gated_reg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_oseq_gated_reg_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_oseq_gated_reg_q <= STD_LOGIC_VECTOR(u0_m0_wo0_oseq_gated_q);
        END IF;
    END PROCESS;

    -- xOut(PORTOUT,84)@19 + 1
    xOut_v <= u0_m0_wo0_oseq_gated_reg_q;
    xOut_c <= STD_LOGIC_VECTOR("0000000" & GND_q);
    xOut_0 <= u0_m0_wo0_accum_q;

END normal;
