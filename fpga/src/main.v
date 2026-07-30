module main
(
    input clk_50M, rstn,
    input [11:0] adc_code,
    output clk_adc,
    output [11:0] filtered_code,
    output cs, dout, sclk
);
    wire clk_proc;
    wire pll_proc_locked;
    wire pll_adc_locked;
    pll pll_inst(
        .inclk0(clk_50M),
        .c0(clk_proc),
        .c1(),
        .c2(),
        .locked(pll_proc_locked)
    );
    pll_adc pll_adc_inst(
        .inclk0(clk_50M),
        .c0(clk_adc),
        .locked(pll_adc_locked)
    );

    // Assert internal resets immediately if either PLL loses lock, then
    // release them synchronously in each clock domain.
    wire clocks_ready_n;
    wire proc_rstn;
    wire adc_rstn;
    assign clocks_ready_n = rstn && pll_proc_locked && pll_adc_locked;
    ResetReleaseSync proc_reset_sync(
        .clk(clk_proc),
        .async_reset_n(clocks_ready_n),
        .reset_n(proc_rstn)
    );
    ResetReleaseSync adc_reset_sync(
        .clk(clk_adc),
        .async_reset_n(clocks_ready_n),
        .reset_n(adc_rstn)
    );

    wire adc_valid;
    wire [11:0] signed_adc_code;
    ADC adc(
        .clk_proc(clk_proc),
        .clk_adc(clk_adc),
        .proc_rstn(proc_rstn),
        .adc_rstn(adc_rstn),
        .adc_code_in(adc_code),
        .adc_code_out(signed_adc_code),
        .adc_valid(adc_valid)
    );

    wire [11:0] signed_filtered_adc_code;
    wire filtered_valid;
    fir_decim10 fir_inst(
        .clk(clk_proc),
        .reset_n(proc_rstn),
        .ast_sink_data(signed_adc_code),
        .ast_sink_valid(adc_valid),
        .ast_sink_error(2'b00),
        .ast_source_data(signed_filtered_adc_code),
        .ast_source_valid(filtered_valid),
        .ast_source_error()
    );

    wire [11:0] filtered_code_now;
    assign filtered_code_now = {
        ~signed_filtered_adc_code[11],
        signed_filtered_adc_code[10:0]
    };

    // The FIR output valid rate is 10.24 MS/s / 10 = 1.024 MS/s.
    // Buffer one sample so SPI always sees stable data on its start edge.
    reg [11:0] spi_pending_data;
    reg spi_pending_valid;
    (* preserve *) reg spi_overflow;

    wire spi_ready;
    wire spi_launch;
    assign spi_launch = spi_pending_valid && spi_ready;
    assign filtered_code = spi_pending_data;

    always @(posedge clk_proc or negedge proc_rstn)
    begin
        if (!proc_rstn)
        begin
            spi_pending_data <= 12'd0;
            spi_pending_valid <= 1'b0;
            spi_overflow <= 1'b0;
        end
        else
        begin
            case ({filtered_valid, spi_launch})
            2'b00:
            begin
                // No new sample and no SPI transfer.
            end

            2'b01:
            begin
                spi_pending_valid <= 1'b0;
            end

            2'b10:
            begin
                if (!spi_pending_valid)
                begin
                    spi_pending_data <= filtered_code_now;
                    spi_pending_valid <= 1'b1;
                end
                else
                begin
                    // Sticky diagnostic: SPI failed to consume a sample.
                    spi_overflow <= 1'b1;
                end
            end

            2'b11:
            begin
                // SPI consumes the old value while this nonblocking update
                // places the new FIR result into the pending register.
                spi_pending_data <= filtered_code_now;
                spi_pending_valid <= 1'b1;
            end

            default:
            begin
                spi_pending_valid <= 1'b0;
            end
            endcase
        end
    end

    SPI spi(
        .clk_proc(clk_proc),
        .rstn(proc_rstn),
        .start(spi_launch),
        .d_in(spi_pending_data),
        .ready(spi_ready),
        .cs(cs),
        .d_out(dout),
        .sclk(sclk)
    );

endmodule

module ResetReleaseSync
(
    input clk, async_reset_n,
    output reset_n
);
    (* preserve *) reg [1:0] reset_pipe;
    always @(posedge clk or negedge async_reset_n)
    begin
        if (!async_reset_n)
        begin
            reset_pipe <= 2'b00;
        end
        else
        begin
            reset_pipe <= {reset_pipe[0], 1'b1};
        end
    end

    assign reset_n = reset_pipe[1];
endmodule

module ADC
(
    input clk_proc, clk_adc, proc_rstn, adc_rstn,
    input [11:0] adc_code_in,
    output [11:0] adc_code_out,
    output adc_valid
);
    // Capture the parallel bus in its source clock domain.  The toggle changes
    // with the captured word and crosses into clk_proc through two flip-flops;
    // by the time the change is detected, adc_code_latched has been stable for
    // at least two processing clocks (bundled-data CDC).
    reg [11:0] adc_code_latched;
    reg adc_sample_toggle;
    always @(negedge clk_adc or negedge adc_rstn)
    begin
        if (!adc_rstn)
        begin
            adc_code_latched <= 12'd0;
            adc_sample_toggle <= 1'b0;
        end
        else
        begin
            adc_code_latched <= adc_code_in;
            adc_sample_toggle <= ~adc_sample_toggle;
        end
    end

    wire adc_sample_toggle_sync;
    SignalSync #(
        .INITIAL_VALUE(1'b0)
    ) adc_toggle_synchronizer(
        .clk(clk_proc),
        .rstn(proc_rstn),
        .signal(adc_sample_toggle),
        .signal_sync(adc_sample_toggle_sync)
    );

    reg adc_sample_toggle_prev;
    reg [11:0] r_adc_code;
    reg r_adc_valid;
    always @(posedge clk_proc or negedge proc_rstn)
    begin
        if (!proc_rstn)
        begin
            adc_sample_toggle_prev <= 1'b0;
            r_adc_code <= 12'd0;
            r_adc_valid <= 1'b0;
        end
        else
        begin
            adc_sample_toggle_prev <= adc_sample_toggle_sync;
            if (adc_sample_toggle_sync != adc_sample_toggle_prev)
            begin
                r_adc_code <= adc_code_latched;
                r_adc_valid <= 1'b1;
            end
            else
            begin
                r_adc_valid <= 1'b0;
            end
        end
    end

    assign adc_code_out = {
        ~r_adc_code[11],
        r_adc_code[10:0]
    };
    assign adc_valid = r_adc_valid;
endmodule

module SPI
(
    input clk_proc, rstn, start,
    input [11:0] d_in,
    output ready, cs, d_out, sclk
);
    // MCU uses SPI mode 0: SCLK idles low, data changes on falling edges
    // and is sampled on rising edges. 100 MHz / 4 gives a 25 MHz
    // SCLK, so every 12-bit frame completes within one 1.024 MS/s period.
    reg [11:0] tx_data;
    reg [3:0] bit_idx;
    reg divider;
    reg busy;
    reg r_cs, r_dout, r_sclk;

    always @(posedge clk_proc or negedge rstn)
    begin
        if (!rstn)
        begin
            tx_data <= 12'd0;
            bit_idx <= 4'd0;
            divider <= 1'b0;
            busy <= 1'b0;
            r_cs <= 1'b1;
            r_dout <= 1'b0;
            r_sclk <= 1'b0;
        end
        else if (!busy)
        begin
            divider <= 1'b0;
            r_cs <= 1'b1;
            r_dout <= 1'b0;
            r_sclk <= 1'b0;

            if (start)
            begin
                tx_data <= d_in;
                bit_idx <= 4'd11;
                busy <= 1'b1;
                r_cs <= 1'b0;
                // Mode 0 requires the first bit to be stable before the
                // first rising (sampling) edge.
                r_dout <= d_in[11];
            end
        end
        else
        begin
            // Each SCLK half-period lasts two processing-clock cycles.
            divider <= ~divider;
            if (divider)
            begin
                if (!r_sclk)
                begin
                    // Leading (rising) edge: the MCU samples the current bit.
                    r_sclk <= 1'b1;
                end
                else
                begin
                    // Trailing (falling) edge: advance to the next data bit.
                    r_sclk <= 1'b0;
                    if (bit_idx == 4'd0)
                    begin
                        busy <= 1'b0;
                        r_cs <= 1'b1;
                    end
                    else
                    begin
                        bit_idx <= bit_idx - 1'b1;
                        r_dout <= tx_data[bit_idx - 1'b1];
                    end
                end
            end
        end
    end

    assign ready = ~busy;
    assign cs = r_cs;
    assign d_out = r_dout;
    assign sclk = r_sclk;
endmodule
