#include "ti_msp_dl_config.h"
#include "bsp/msp_sys.h"
#include "bsp/oled/oled.h"
#include "bsp/keyboard.h"
#include "bsp/uart.h"
#include "ui_config.h"
#include "signal.h"
#include "tjc.h"
#include <stdio.h>

#define UART_TIMEOUT_TICK (1000)  // ms
#define UART_REFRESH_INTERVAL_TICK (100)

uint16_t adc_buffer[2][N_SAMPLES] = { 0 };
uint8_t dma_buffer_idx = 0;

volatile bool dma_done = false;

uint8_t uart_update_stage = 0;  // 0-处理简单事件并发送数据；1-等待透传开始，并传输数据点；2-等待透传结束

bool is_wave_mode = true;
uint8_t period_cnt = 1;
uint32_t start_sys_tick = 0;

static void reset_dma()
{
    DL_DMA_disableChannel(DMA, DMA_CH0_CHAN_ID);
    DL_DMA_setSrcAddr(DMA, DMA_CH0_CHAN_ID, (uint32_t)&ADC_SPI_INST->RXDATA);
    DL_DMA_setDestAddr(DMA, DMA_CH0_CHAN_ID, (uint32_t)&adc_buffer[dma_buffer_idx][0]);
    DL_DMA_setTransferSize(DMA, DMA_CH0_CHAN_ID, N_SAMPLES);
    DL_DMA_enableChannel(DMA, DMA_CH0_CHAN_ID);
}

void int_dma_done()
{
    dma_buffer_idx = 1 - dma_buffer_idx;
    reset_dma();

    for (size_t i = 0; i < N_SAMPLES; i++)
    {
        signal_adc_code[i] = adc_buffer[1 - dma_buffer_idx][i];
    }

    signal_update_result();
}

void uart_update()
{
    if (uart_update_stage == 0)
    {
        if (switch_to_wave_flag)
        {
            switch_to_wave_flag = false;
            is_wave_mode = true;
        }
        if (switch_to_fft_flag)
        {
            switch_to_fft_flag = false;
            is_wave_mode = false;
        }
        if (switch_period_flag)
        {
            switch_period_flag = false;
            period_cnt = switch_period_data;
        }

        if (sys_tick - start_sys_tick < UART_REFRESH_INTERVAL_TICK)
        {
            return;
        }

        // 发送数据
        char buffer[40] = { 0 };
        if (is_wave_mode)
        {
            snprintf(buffer, 40, "main.t2.txt=\"%.3fmV\"", signal_vpp);
            tjc_send_string(buffer);

            snprintf(buffer, 40, "main.t4.txt=\"%.3fmV\"", signal_vrms);
            tjc_send_string(buffer);

            snprintf(buffer, 40, "main.t6.txt=\"%.3fkHz\"", signal_harmonics[0].freq);
            tjc_send_string(buffer);

            snprintf(buffer, 40, "addt main.s0.id,0,800");
            tjc_send_string(buffer);
        }
        else
        {
            snprintf(buffer, 40, "FFT.t1.txt=\"%.3fkHz\"", signal_harmonics[0].freq);
            tjc_send_string(buffer);
            snprintf(buffer, 40, "FFT.t2.txt=\"%.3fmV\"", signal_harmonics[0].amp);
            tjc_send_string(buffer);

            if (signal_harmonics[1].valid)
            {
                snprintf(buffer, 40, "FFT.t4.txt=\"f%d:  \"", signal_harmonics[1].order);
                tjc_send_string(buffer);
                snprintf(buffer, 40, "FFT.t5.txt=\"%.3fkHz\"", signal_harmonics[1].freq);
                tjc_send_string(buffer);
                snprintf(buffer, 40, "FFT.t6.txt=\"%.3fmV\"", signal_harmonics[1].amp);
                tjc_send_string(buffer);
            }
            else
            {
                snprintf(buffer, 40, "FFT.t4.txt=\"fn:  \"");
                tjc_send_string(buffer);
                snprintf(buffer, 40, "FFT.t5.txt=\"--- kHz\"");
                tjc_send_string(buffer);
                snprintf(buffer, 40, "FFT.t6.txt=\"--- mV\"");
                tjc_send_string(buffer);
            }

            if (signal_harmonics[2].valid)
            {
                snprintf(buffer, 40, "FFT.t7.txt=\"f%d:  \"", signal_harmonics[2].order);
                tjc_send_string(buffer);
                snprintf(buffer, 40, "FFT.t8.txt=\"%.3fkHz\"", signal_harmonics[2].freq);
                tjc_send_string(buffer);
                snprintf(buffer, 40, "FFT.t9.txt=\"%.3fmV\"", signal_harmonics[2].amp);
                tjc_send_string(buffer);
            }
            else
            {
                snprintf(buffer, 40, "FFT.t7.txt=\"fn:  \"");
                tjc_send_string(buffer);
                snprintf(buffer, 40, "FFT.t8.txt=\"--- kHz\"");
                tjc_send_string(buffer);
                snprintf(buffer, 40, "FFT.t9.txt=\"--- mV\"");
                tjc_send_string(buffer);
            }

            snprintf(buffer, 40, "addt FFT.s0.id,0,800");
            tjc_send_string(buffer);
        }

        uart_update_stage = 1;
        start_sys_tick = sys_tick;
    }
    else if (uart_update_stage == 1)
    {
        if (curve_ready_flag)
        {
            curve_ready_flag = false;

            if (is_wave_mode)
            {
                signal_generate_wave(period_cnt);
                tjc_send_bytes(signal_uart_wave, 800);
            }
            else
            {
                signal_generate_spectrum();
                tjc_send_bytes(signal_uart_spectrum, 800);
            }

            uart_update_stage = 2;
            start_sys_tick = sys_tick;
        }
        else if (sys_tick - start_sys_tick > UART_TIMEOUT_TICK)
        {
            tjc_send_byte(0x00);
            tjc_send_byte(0xFF);
            tjc_send_byte(0xFF);
            tjc_send_byte(0xFF);
            uart_update_stage = 0;
        }
    }
    else if (uart_update_stage == 2)
    {
        if (curve_end_flag)
        {
            curve_end_flag = false;
            uart_update_stage = 0;
            start_sys_tick = sys_tick;
        }
        else if (sys_tick - start_sys_tick > UART_TIMEOUT_TICK)
        {
            tjc_send_byte(0x00);
            tjc_send_byte(0xFF);
            tjc_send_byte(0xFF);
            tjc_send_byte(0xFF);
            uart_update_stage = 0;
        }
    }
}

int main()
{
    SYSCFG_DL_init();
    init_sys();
    init_oled();
    init_keyboard();
    init_uart();
    init_app_ui();

    uart_recieve_callback = tjc_parse_uart;

    DL_SPI_clearInterruptStatus(
        ADC_SPI_INST, DL_SPI_INTERRUPT_DMA_DONE_RX);
    NVIC_ClearPendingIRQ(ADC_SPI_INST_INT_IRQN);
    reset_dma();
    NVIC_EnableIRQ(ADC_SPI_INST_INT_IRQN);

    init_signal();

    start_sys_tick = sys_tick;
    
    while (1)
    {
        if (dma_done)
        {
            dma_done = false;
            int_dma_done();
        }
        uart_update();
        keyboard_update();
        app_ui_update();
    }

    return 0;
}

void ADC_SPI_INST_IRQHandler()
{
    switch (DL_SPI_getPendingInterrupt(ADC_SPI_INST))
    {
    case DL_SPI_IIDX_DMA_DONE_RX:
        dma_done = true;
        break;

    default:
        break;
    }
}
