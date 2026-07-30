// Dedicated ADC clock PLL.
//
// A single Cyclone IV PLL cannot produce both 100 MHz and 10.24 MHz exactly
// from the 50 MHz board oscillator because both outputs must share one VCO.
// This second PLL allows an exact 128/625 output ratio for the ADC clock.
// The fitter implements it with a 1.28 GHz VCO and an output divide-by-125.
`timescale 1 ps / 1 ps

module pll_adc
(
    input inclk0,
    output c0,
    output locked
);
    wire [4:0] pll_clocks;
    wire [1:0] pll_inputs = {1'b0, inclk0};

    assign c0 = pll_clocks[0];

    altpll altpll_component
    (
        .inclk(pll_inputs),
        .clk(pll_clocks),
        .activeclock(),
        .areset(1'b0),
        .clkbad(),
        .clkena({6{1'b1}}),
        .clkloss(),
        .clkswitch(1'b0),
        .configupdate(1'b0),
        .enable0(),
        .enable1(),
        .extclk(),
        .extclkena({4{1'b1}}),
        .fbin(1'b1),
        .fbmimicbidir(),
        .fbout(),
        .fref(),
        .icdrclk(),
        .locked(locked),
        .pfdena(1'b1),
        .phasecounterselect({4{1'b1}}),
        .phasedone(),
        .phasestep(1'b1),
        .phaseupdown(1'b1),
        .pllena(1'b1),
        .scanaclr(1'b0),
        .scanclk(1'b0),
        .scanclkena(1'b1),
        .scandata(1'b0),
        .scandataout(),
        .scandone(),
        .scanread(1'b0),
        .scanwrite(1'b0),
        .sclkout0(),
        .sclkout1(),
        .vcooverrange(),
        .vcounderrange()
    );

    defparam
        altpll_component.bandwidth_type = "AUTO",
        altpll_component.clk0_divide_by = 625,
        altpll_component.clk0_duty_cycle = 50,
        altpll_component.clk0_multiply_by = 128,
        altpll_component.clk0_phase_shift = "0",
        altpll_component.compensate_clock = "CLK0",
        altpll_component.inclk0_input_frequency = 20000,
        altpll_component.intended_device_family = "Cyclone IV E",
        altpll_component.lpm_hint = "CBX_MODULE_PREFIX=pll_adc",
        altpll_component.lpm_type = "altpll",
        altpll_component.operation_mode = "NORMAL",
        altpll_component.pll_type = "AUTO",
        altpll_component.port_activeclock = "PORT_UNUSED",
        altpll_component.port_areset = "PORT_UNUSED",
        altpll_component.port_clkbad0 = "PORT_UNUSED",
        altpll_component.port_clkbad1 = "PORT_UNUSED",
        altpll_component.port_clkloss = "PORT_UNUSED",
        altpll_component.port_clkswitch = "PORT_UNUSED",
        altpll_component.port_configupdate = "PORT_UNUSED",
        altpll_component.port_fbin = "PORT_UNUSED",
        altpll_component.port_inclk0 = "PORT_USED",
        altpll_component.port_inclk1 = "PORT_UNUSED",
        altpll_component.port_locked = "PORT_USED",
        altpll_component.port_pfdena = "PORT_UNUSED",
        altpll_component.port_phasecounterselect = "PORT_UNUSED",
        altpll_component.port_phasedone = "PORT_UNUSED",
        altpll_component.port_phasestep = "PORT_UNUSED",
        altpll_component.port_phaseupdown = "PORT_UNUSED",
        altpll_component.port_pllena = "PORT_UNUSED",
        altpll_component.port_scanaclr = "PORT_UNUSED",
        altpll_component.port_scanclk = "PORT_UNUSED",
        altpll_component.port_scanclkena = "PORT_UNUSED",
        altpll_component.port_scandata = "PORT_UNUSED",
        altpll_component.port_scandataout = "PORT_UNUSED",
        altpll_component.port_scandone = "PORT_UNUSED",
        altpll_component.port_scanread = "PORT_UNUSED",
        altpll_component.port_scanwrite = "PORT_UNUSED",
        altpll_component.port_clk0 = "PORT_USED",
        altpll_component.port_clk1 = "PORT_UNUSED",
        altpll_component.port_clk2 = "PORT_UNUSED",
        altpll_component.port_clk3 = "PORT_UNUSED",
        altpll_component.port_clk4 = "PORT_UNUSED",
        altpll_component.port_clk5 = "PORT_UNUSED",
        altpll_component.port_clkena0 = "PORT_UNUSED",
        altpll_component.port_clkena1 = "PORT_UNUSED",
        altpll_component.port_clkena2 = "PORT_UNUSED",
        altpll_component.port_clkena3 = "PORT_UNUSED",
        altpll_component.port_clkena4 = "PORT_UNUSED",
        altpll_component.port_clkena5 = "PORT_UNUSED",
        altpll_component.port_extclk0 = "PORT_UNUSED",
        altpll_component.port_extclk1 = "PORT_UNUSED",
        altpll_component.port_extclk2 = "PORT_UNUSED",
        altpll_component.port_extclk3 = "PORT_UNUSED",
        altpll_component.width_clock = 5;
endmodule
