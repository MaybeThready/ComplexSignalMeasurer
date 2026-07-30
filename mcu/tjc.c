#include "tjc.h"

uint8_t tjc_current_data = 0;
uint8_t tjc_frame_end_cnt = 0;

volatile uint8_t switch_period_data = 1;

volatile bool switch_to_wave_flag = false;
volatile bool switch_to_fft_flag = false;
volatile bool switch_period_flag = false;
volatile bool curve_ready_flag = false;
volatile bool curve_end_flag = false;

void tjc_send_byte(uint8_t data)
{
    DL_UART_transmitDataBlocking(UART_INST, data);
}

void tjc_send_bytes(uint8_t* data, size_t size)
{
    for (size_t i = 0; i < size; i++)
    {
        DL_UART_transmitDataBlocking(UART_INST, data[i]);
    }
}

void tjc_send_string(const char* str)
{
    while (*str)
    {
        tjc_send_byte((uint8_t)*str++);
    }
    tjc_send_byte(0xFF);
    tjc_send_byte(0xFF);
    tjc_send_byte(0xFF);
}

void tjc_parse_uart(uint8_t data)
{
    if (data != 0xFF)
    {
        tjc_current_data = data;
        tjc_frame_end_cnt = 0;
    }
    else
    {
        if (tjc_frame_end_cnt < 2)
        {
            tjc_frame_end_cnt += 1;
        }
        else
        {
            tjc_frame_end_cnt = 0;
            switch (tjc_current_data)
            {
            case 0x30:
                switch_to_wave_flag = true;
                switch_to_fft_flag = false;
                break;

            case 0x31:
                switch_to_wave_flag = false;
                switch_to_fft_flag = true;
                break;

            case 0x40:
            case 0x41:
            case 0x42:
                switch_period_data = tjc_current_data - 0x3F;
                switch_period_flag = true;
                break;

            case 0xFD:
                curve_end_flag = true;
                break;

            case 0xFE:
                curve_ready_flag = true;
                break;

            default:
                break;
            }
        }
    }
}
