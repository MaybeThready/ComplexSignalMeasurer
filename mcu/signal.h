#pragma once

#include "ti_msp_dl_config.h"

#define N_SAMPLES (2048)

#define MIN_INPUT_VAL (-125.0f)
#define MAX_INPUT_VAL (+125.0f)
#define MAX_VPP (MAX_INPUT_VAL - MIN_INPUT_VAL)

extern uint16_t signal_adc_code[N_SAMPLES];
extern float signal_samples[N_SAMPLES];

extern float signal_vmax;
extern float signal_vmin;
extern float signal_vpp;
extern float signal_vrms;

void signal_update_result();
