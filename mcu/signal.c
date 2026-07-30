#include "signal.h"
#include "arm_math.h"

#define SAMPLE_RATE (1024.0f) // kHz
#define NOISE_GATE (3.0f)

uint16_t signal_adc_code[N_SAMPLES] = { 0 };
float signal_samples[N_SAMPLES] = { 0 };
float signal_windowed_samples[N_SAMPLES] = { 0 };
float signal_fft_complex_result[N_SAMPLES] = { 0 };
float signal_fft_amp_result[N_SAMPLES / 2] = { 0 };
float hanning_window[N_SAMPLES] = { 0 };

float signal_vmax = 0.0f;
float signal_vmin = 0.0f;

float signal_vpp = 0.0f;
float signal_vrms = 0.0f;

Harmonic signal_harmonics[N_HARMONICS] = { 0 };
float harmonic_freqs[N_HARMONICS] = { 0 };
float harmonic_amp[N_HARMONICS] = { 0 };

uint8_t signal_uart_wave[UART_X_PIXELS] = { 0 };
uint8_t signal_uart_spectrum[UART_X_PIXELS] = { 0 };

arm_rfft_fast_instance_f32 rfftf32;

float get_index_freq(size_t index)
{
    return index * SAMPLE_RATE / N_SAMPLES;
}

void init_signal()
{
    arm_rfft_fast_init_f32(&rfftf32, N_SAMPLES);
    arm_hanning_f32(hanning_window, N_SAMPLES);
}

int32_t find_valid_harmonic(bool ignore_gate)
{
    int32_t max_idx = 0;
    for (int32_t i = 1; i < N_SAMPLES / 2; i++)
    {
        if (signal_fft_amp_result[i] > signal_fft_amp_result[max_idx])
        {
            max_idx = i;
        }
    }

    if (signal_fft_amp_result[max_idx] < NOISE_GATE && !ignore_gate)
    {
        return -1;
    }
    return max_idx;
}

void delete_peak(int32_t index, int32_t window_size)
{
    for (int32_t i = index - window_size / 2; i <= index + window_size / 2; i++)
    {
        if (i >= 0 && i < N_SAMPLES / 2)
        {
            signal_fft_amp_result[i] = 0.0f;
        }
    }
}

void signal_update_result()
{
    // 数据归一化、加窗
    float tmp;
    for (size_t i = 0; i < N_SAMPLES; i++)
    {
        tmp = signal_adc_code[i] / 4095.0f * MAX_VPP + MIN_INPUT_VAL;
        signal_samples[i] = tmp;
        signal_windowed_samples[i] = tmp * hanning_window[i];
    }

    // FFT变换
    arm_rfft_fast_f32(&rfftf32, signal_windowed_samples, signal_fft_complex_result, 0);
    arm_scale_f32(signal_fft_complex_result, 1.0f / N_SAMPLES, signal_fft_complex_result, N_SAMPLES);

    // 幅度计算
    arm_cmplx_mag_f32(signal_fft_complex_result, signal_fft_amp_result, N_SAMPLES / 2);
    arm_scale_f32(signal_fft_amp_result, 4.0f, signal_fft_amp_result, N_SAMPLES / 2);

    // 去直流
    delete_peak(0, 5);

    // 计算谐波
    int32_t harmonic_idx;
    size_t harmonic_cnt;
    for (harmonic_cnt = 0; harmonic_cnt < N_HARMONICS; harmonic_cnt++)
    {
        harmonic_idx = find_valid_harmonic(harmonic_cnt == 0);
        if (harmonic_idx != -1)
        {
            harmonic_freqs[harmonic_cnt] = get_index_freq((size_t)harmonic_idx);
            harmonic_amp[harmonic_cnt] = signal_fft_amp_result[harmonic_idx];
            delete_peak(harmonic_idx, 5);
        }
        else
        {
            break;
        }
    }    

    // 排序
    float tmp_freq;
    float tmp_amp;
    for (size_t i = 0; i < harmonic_cnt - 1; i++)
    {
        for (size_t j = 0; j < harmonic_cnt - 1 - i; j++)
        {
            if (harmonic_freqs[j] > harmonic_freqs[j + 1])
            {
                tmp_freq = harmonic_freqs[j];
                tmp_amp = harmonic_amp[j];

                harmonic_freqs[j] = harmonic_freqs[j + 1];
                harmonic_amp[j] = harmonic_amp[j + 1];

                harmonic_freqs[j + 1] = tmp_freq;
                harmonic_amp[j + 1] = tmp_amp;
            }
        }
    }

    // 整理谐波数据并计算RMS
    float base_freq = harmonic_freqs[0];
    signal_vrms = 0.0f;
    for (size_t i = 0; i < N_HARMONICS; i++)
    {
        if (i < harmonic_cnt)
        {
            signal_harmonics[i].valid = true;
            signal_harmonics[i].order = (uint8_t)round(harmonic_freqs[i] / base_freq);
            // signal_harmonics[i].freq = base_freq * signal_harmonics[i].order;
            signal_harmonics[i].freq = harmonic_freqs[i];
            signal_harmonics[i].amp = harmonic_amp[i];
            signal_vrms += signal_harmonics[i].amp * signal_harmonics[i].amp / 2.0f;
        }
        else
        {
            signal_harmonics[i].valid = false;
        }
    }
    signal_vrms = sqrt(signal_vrms);
}

void signal_generate_wave(uint8_t period_cnt)
{
    float base_freq = signal_harmonics[0].freq;  // kHz
    float wave_period = 1.0f / base_freq;  // ms
    float time_step = period_cnt * wave_period / (UART_X_PIXELS - 1);  // 绘制N个点只需步进N-1次

    float t = 0.0f;
    float tmp = 0.0f;
    signal_vmax = 0.0f;
    signal_vmin = 0.0f;
    for (size_t i = 0; i < UART_X_PIXELS; i++)
    {
        tmp = 0.0f;
        for (size_t j = 0; j < N_HARMONICS; j++)
        {
            if (signal_harmonics[j].valid)
            {
                tmp += signal_harmonics[j].amp * arm_sin_f32(2 * PI * signal_harmonics[j].freq * t);
            }
        }

        tmp = (tmp - MIN_INPUT_VAL) / MAX_VPP * 254.0f;
        tmp = tmp < 0.0f ? 0.0f : (tmp > 254.0f ? 254.0f : tmp);

        if (tmp > signal_vmax)
        {
            signal_vmax = tmp;
        }
        if (tmp < signal_vmin)
        {
            signal_vmin = tmp;
        }

        signal_uart_wave[i] = (uint8_t)tmp;
        t += time_step;
    }
    signal_vpp = signal_vmax - signal_vmin;
}

void signal_generate_spectrum()
{
    for (size_t i = 0; i < UART_X_PIXELS; i++)
    {
        signal_uart_spectrum[i] = 0;
    }

    int32_t index;
    float tmp;
    for (size_t i = 0; i < N_HARMONICS; i++)
    {
        if (signal_harmonics[i].valid)
        {
            index = (int32_t)(2.0f * signal_harmonics[i].freq / SAMPLE_RATE * (UART_X_PIXELS - 1));
            index = index < 0 ? 0 : (index >= UART_X_PIXELS ? UART_X_PIXELS - 1 : index);

            tmp = 2.0f * signal_harmonics[i].amp / MAX_VPP * 254.0f;
            tmp = tmp < 0.0f ? 0.0f : (tmp > 254.0f ? 254.0f : tmp);

            signal_uart_spectrum[index] = tmp;
        }
    }
}
