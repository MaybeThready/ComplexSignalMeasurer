#include "ti_msp_dl_config.h"
#include "bsp/msp_sys.h"
#include "bsp/oled/oled.h"
#include "bsp/keyboard.h"
#include "ui_config.h"
#include "signal.h"

uint16_t adc_buffer[2][N_SAMPLES] = { 0 };
uint8_t dma_buffer_idx = 0;

volatile bool dma_done = false;

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

int main()
{
    SYSCFG_DL_init();
    init_sys();
    init_oled();
    init_keyboard();
    init_app_ui();

    DL_SPI_clearInterruptStatus(
        ADC_SPI_INST, DL_SPI_INTERRUPT_DMA_DONE_RX);
    NVIC_ClearPendingIRQ(ADC_SPI_INST_INT_IRQN);
    reset_dma();
    NVIC_EnableIRQ(ADC_SPI_INST_INT_IRQN);

    init_signal();

    while (1)
    {
        if (dma_done)
        {
            dma_done = false;
            int_dma_done();
        }
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
