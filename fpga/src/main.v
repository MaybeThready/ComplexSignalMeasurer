module main
(
    input clk_50M, rstn,
    input [11:0] adc_code,
    output clk_20M,
    output [11:0] filtered_code,
    output cs, dout, sclk
);
    wire clk_100M, clk_1p024M;
    pll pll_inst(
        .inclk0(clk_50M),
        .c0(clk_100M),
        .c1(clk_20M),
        .c2(clk_1p024M)
    );

    wire adc_valid;
    wire [11:0] signed_adc_code;
    ADC adc(
        .clk_100M(clk_100M),
        .clk_20M(clk_20M),
        .rstn(rstn),
        .adc_code_in(adc_code),
        .adc_code_out(signed_adc_code),
        .adc_valid(adc_valid)
    );

    wire [11:0] signed_filtered_adc_code;
    wire filtered_valid;
    fir fir_inst(
        .clk(clk_100M),
        .reset_n(rstn),
        .ast_sink_data(signed_adc_code),
        .ast_sink_valid(adc_valid),
        .ast_sink_error(2'b00),
        .ast_source_data(signed_filtered_adc_code),
        .ast_source_valid(filtered_valid),
        .ast_source_error()
    );

    reg [11:0] r_signed_filtered_adc_code;
    always @(posedge clk_100M or negedge rstn)
    begin
        if (!rstn)
        begin
            r_signed_filtered_adc_code <= 12'd0;
        end
        else
        begin
            if (filtered_valid)
            begin
                r_signed_filtered_adc_code <= signed_filtered_adc_code;
            end
            else
            begin
                r_signed_filtered_adc_code <= r_signed_filtered_adc_code;
            end
        end
    end

    assign filtered_code = {
        ~r_signed_filtered_adc_code[11],
        r_signed_filtered_adc_code[10:0]
    };

    wire clk_1p024M_posedge;
    PosedgeDetector pdt1p024(
        .clk(clk_100M),
        .rstn(rstn),
        .signal_sync(clk_1p024M),
        .signal_posedge(clk_1p024M_posedge)
    );

    reg [11:0] r_filtered_code;
    reg spi_start;
    always @(posedge clk_100M or negedge rstn)
    begin
        if (!rstn)
        begin
            r_filtered_code <= 12'd0;
            spi_start <= 1'b0;
        end
        else
        begin
            if (clk_1p024M_posedge)
            begin
                r_filtered_code <= filtered_code;
                spi_start <= 1'b1;
            end
            else
            begin
                r_filtered_code <= r_filtered_code;
                spi_start <= 1'b0;
            end
        end
    end

    SPI spi(
        .clk_100M(clk_100M),
        .rstn(rstn),
        .start(spi_start),
        .d_in(r_filtered_code),
        .cs(cs),
        .d_out(dout),
        .sclk(sclk)
    );

endmodule

module ADC
(
    input clk_100M, clk_20M, rstn,
    input [11:0] adc_code_in,
    output [11:0] adc_code_out,
    output adc_valid
);
    wire clk_20M_negedge;
    NegedgeDetector ndt(
        .clk(clk_100M),
        .rstn(rstn),
        .signal_sync(clk_20M),
        .signal_negedge(clk_20M_negedge)
    );

    reg [11:0] r_adc_code;
    reg r_adc_valid;
    always @(posedge clk_100M or negedge rstn)
    begin
        if (!rstn)
        begin
            r_adc_code <= 12'd0;
            r_adc_valid <= 1'b0;
        end
        else
        begin
            if (clk_20M_negedge)
            begin
                r_adc_code <= adc_code_in;
                r_adc_valid <= 1'b1;
            end
            else
            begin
                r_adc_code <= r_adc_code;
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
    input clk_100M, rstn, start,
    input [11:0] d_in,
    output cs, d_out, sclk
);
    // MCU uses SPI mode 0: SCLK idles low, data changes on falling edges
    // and is sampled on rising edges. 100 MHz / 4 gives a 25 MHz SCLK.
    reg [11:0] tx_data;
    reg [3:0] bit_idx;
    reg divider;
    reg busy;
    reg r_cs, r_dout, r_sclk;

    always @(posedge clk_100M or negedge rstn)
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
            // Each SCLK half-period lasts two 100 MHz clock cycles.
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

    assign cs = r_cs;
    assign d_out = r_dout;
    assign sclk = r_sclk;
endmodule
