/*
 * 自动生成的 Vpp 校准模型
 * 模型：分频率增益+平滑幅值修正
 * 源数据 SHA-256：dc4ae18421309b45fb73d346e3d1ddeabbb1733eec36d99b5a75ffdae910d9a9
 * 有效范围：Vpp 8.731~223.7 mV，
 *           f 10~500 kHz
 * 接口与旧版保持一致；signal.c 可直接替换使用。
 */
#ifndef CB_CALIBRATION_MODEL_H
#define CB_CALIBRATION_MODEL_H

#include <stdbool.h>

#define CB_VOLTAGE_MIN_MV (8.731000000e+00f)
#define CB_VOLTAGE_MAX_MV (2.237000000e+02f)
#define CB_FREQUENCY_MIN_KHZ (1.000000000e+01f)
#define CB_FREQUENCY_MAX_KHZ (5.000000000e+02f)
#define CB_VOLTAGE_SCALE_MV (2.237000000e+02f)
#define CB_GAIN_KNOT_COUNT (11u)
#define CB_AMPLITUDE_CUBIC (8.731524980e-03f)
#define CB_AMPLITUDE_QUINTIC (-7.059006573e-03f)

static const float CB_FREQUENCY_KNOTS_KHZ[CB_GAIN_KNOT_COUNT] = {
    1.000000000e+01f, 5.000000000e+01f, 1.000000000e+02f, 1.500000000e+02f, 2.000000000e+02f, 2.500000000e+02f, 3.000000000e+02f, 3.500000000e+02f, 4.000000000e+02f, 4.500000000e+02f, 5.000000000e+02f
};
static const float CB_GAIN_KNOTS[CB_GAIN_KNOT_COUNT] = {
    1.126374237e+00f, 1.121635492e+00f, 1.115918491e+00f, 1.134152455e+00f, 1.136755701e+00f, 1.138114705e+00f, 1.137063499e+00f, 1.133487491e+00f, 1.127361753e+00f, 1.120261915e+00f, 1.116261863e+00f
};

static inline bool cb_calibration_in_range(float vpp_mv, float frequency_khz)
{
    return vpp_mv >= CB_VOLTAGE_MIN_MV &&
           vpp_mv <= CB_VOLTAGE_MAX_MV &&
           frequency_khz >= CB_FREQUENCY_MIN_KHZ &&
           frequency_khz <= CB_FREQUENCY_MAX_KHZ;
}

static inline float cb_interpolated_gain(float frequency_khz)
{
    unsigned int i;
    if (frequency_khz <= CB_FREQUENCY_KNOTS_KHZ[0]) {
        return CB_GAIN_KNOTS[0];
    }
    if (frequency_khz >= CB_FREQUENCY_KNOTS_KHZ[CB_GAIN_KNOT_COUNT - 1u]) {
        return CB_GAIN_KNOTS[CB_GAIN_KNOT_COUNT - 1u];
    }
    for (i = 1u; i < CB_GAIN_KNOT_COUNT; ++i) {
        if (frequency_khz <= CB_FREQUENCY_KNOTS_KHZ[i]) {
            const float alpha = (frequency_khz - CB_FREQUENCY_KNOTS_KHZ[i - 1u]) /
                                (CB_FREQUENCY_KNOTS_KHZ[i] - CB_FREQUENCY_KNOTS_KHZ[i - 1u]);
            return CB_GAIN_KNOTS[i - 1u] +
                   alpha * (CB_GAIN_KNOTS[i] - CB_GAIN_KNOTS[i - 1u]);
        }
    }
    return CB_GAIN_KNOTS[CB_GAIN_KNOT_COUNT - 1u];
}

static inline float cb_calibrate_vpp_mv(float vpp_mv, float frequency_khz)
{
    const float z = vpp_mv / CB_VOLTAGE_SCALE_MV;
    const float z2 = z * z;
    const float gain = cb_interpolated_gain(frequency_khz) +
                       CB_AMPLITUDE_CUBIC * z2 +
                       CB_AMPLITUDE_QUINTIC * z2 * z2;
    return vpp_mv * gain;
}

static inline float cb_calibrate_sample_mv(float vin_mv, float frequency_khz)
{
    const float q = (2.0f * vin_mv) / CB_VOLTAGE_SCALE_MV;
    const float q2 = q * q;
    const float gain = cb_interpolated_gain(frequency_khz) +
                       CB_AMPLITUDE_CUBIC * q2 +
                       CB_AMPLITUDE_QUINTIC * q2 * q2;
    return vin_mv * gain;
}

#endif /* CB_CALIBRATION_MODEL_H */
