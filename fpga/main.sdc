# 50 MHz board oscillator.  PLL output clocks are derived from this clock.
create_clock -name clk_50M -period 20.000 [get_ports {clk_50M}]
derive_pll_clocks
derive_clock_uncertainty

# rstn is an asynchronous board-level reset.
set_false_path -from [get_ports {rstn}]

# The ADC-domain sample toggle is deliberately synchronized into the
# processing-clock domain.  Only the first synchronizer stage is an
# asynchronous timing boundary; the second stage remains timed normally.
set_false_path -to [get_registers {*|adc_toggle_synchronizer|signal_buff1}]

# adc_code is captured on the falling edge of the forwarded ADC clock.  The
# converter's clock-to-output delay and board skew are hardware-specific and
# must be checked against the available 48.828 ns half-cycle.
set_false_path -from [get_ports {adc_code[*]}]

# The source-domain data register changes with the sample toggle.  Toggle
# synchronization delays the destination capture by at least two 100 MHz
# clocks; constrain the bundled-data path to arrive well inside that window.
set_max_delay \
    -from [get_registers {*|adc_code_latched*}] \
    -to [get_registers {*|r_adc_code*}] \
    15.000
