#pragma once

#include "ti_msp_dl_config.h"

#define N_SAMPLES (2048)
#define N_HARMONICS (3)

#define MIN_INPUT_VAL (-125.0f)
#define MAX_INPUT_VAL (+125.0f)
#define MAX_VPP (MAX_INPUT_VAL - MIN_INPUT_VAL)

#define UART_X_PIXELS (800)
#define PI (3.14159265)

typedef struct
{
    bool valid;
    uint8_t order;
    float freq;
    float amp;
} Harmonic;

extern uint16_t signal_adc_code[N_SAMPLES];
extern float signal_samples[N_SAMPLES];

extern float signal_vmax;
extern float signal_vmin;
extern float signal_vpp;
extern float signal_vrms;

extern Harmonic signal_harmonics[N_HARMONICS];

extern uint8_t signal_uart_wave[UART_X_PIXELS];
extern uint8_t signal_uart_spectrum[UART_X_PIXELS];

void init_signal();
void signal_update_result();
void signal_generate_wave(uint8_t period_cnt);
void signal_generate_spectrum();
