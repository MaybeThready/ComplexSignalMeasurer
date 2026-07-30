#include "signal.h"

uint16_t signal_adc_code[N_SAMPLES] = { 0 };
float signal_samples[N_SAMPLES] = { 0 };

float signal_vmax = 0.0f;
float signal_vmin = 0.0f;

float signal_vpp = 0.0f;
float signal_vrms = 0.0f;

void signal_update_result()
{
    // 数据归一化与峰峰值计算
    signal_vmax = signal_samples[0];
    signal_vmin = signal_samples[0];
    float tmp;
    for (size_t i = 0; i < N_SAMPLES; i++)
    {
        tmp = signal_adc_code[i] / 4095.0f * MAX_VPP + MIN_INPUT_VAL;
        if (tmp < signal_vmin)
        {
            signal_vmin = tmp;
        }
        else if (tmp > signal_vmax)
        {
            signal_vmax = tmp;
        }
        signal_samples[i] = tmp;
    }
    signal_vpp = signal_vmax - signal_vmin;
}
