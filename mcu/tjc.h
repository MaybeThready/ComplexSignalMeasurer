#pragma once

#include "bsp/uart.h"

extern uint8_t tjc_current_data;
extern uint8_t tjc_frame_end_cnt;

extern volatile uint8_t switch_period_data;

extern volatile bool switch_to_wave_flag;
extern volatile bool switch_to_fft_flag;
extern volatile bool switch_period_flag;
extern volatile bool curve_ready_flag;
extern volatile bool curve_end_flag;

void tjc_send_byte(uint8_t data);
void tjc_send_bytes(uint8_t* data, size_t size);
void tjc_send_string(const char* str);

void tjc_parse_uart(uint8_t data);
