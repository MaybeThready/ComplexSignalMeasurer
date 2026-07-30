/*
 * 自动生成的 Vpp 校准模型
 * 模型：分频率增益线性插值
 * 源数据 SHA-256：3f4c64bfcce58cd3287d1a69967bd25a779079ac4eaa94953506514ee1db7136
 * 有效范围：Vpp 8.777~224.76 mV，
 *           f 10~500 kHz
 *
 * 结点间使用线性插值。范围外未经验证；调用者应先执行范围检查。
 */
#ifndef CB_CALIBRATION_MODEL_H
#define CB_CALIBRATION_MODEL_H

#include <stdbool.h>

#define CB_VOLTAGE_MIN_MV (8.777000000e+00f)
#define CB_VOLTAGE_MAX_MV (2.247600000e+02f)
#define CB_FREQUENCY_MIN_KHZ (1.000000000e+01f)
#define CB_FREQUENCY_MAX_KHZ (5.000000000e+02f)
#define CB_GAIN_KNOT_COUNT (7u)

static const float CB_FREQUENCY_KNOTS_KHZ[CB_GAIN_KNOT_COUNT] = {
    1.000000000e+01f, 5.000000000e+01f, 1.000000000e+02f, 2.000000000e+02f, 3.000000000e+02f, 4.000000000e+02f, 5.000000000e+02f
};
static const float CB_GAIN_KNOTS[CB_GAIN_KNOT_COUNT] = {
    1.124280255e+00f, 1.119371013e+00f, 1.113909770e+00f, 1.135043035e+00f, 1.135075191e+00f, 1.124366549e+00f, 1.112324084e+00f
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
            const float span = CB_FREQUENCY_KNOTS_KHZ[i] -
                               CB_FREQUENCY_KNOTS_KHZ[i - 1u];
            const float alpha = (frequency_khz -
                                 CB_FREQUENCY_KNOTS_KHZ[i - 1u]) / span;
            return CB_GAIN_KNOTS[i - 1u] +
                   alpha * (CB_GAIN_KNOTS[i] - CB_GAIN_KNOTS[i - 1u]);
        }
    }
    return CB_GAIN_KNOTS[CB_GAIN_KNOT_COUNT - 1u];
}

static inline float cb_calibrate_vpp_mv(float vpp_mv, float frequency_khz)
{
    return vpp_mv * cb_interpolated_gain(frequency_khz);
}

/*
 * 该等效瞬时值形式只校正幅度增益。
 * 校准表没有验证相位、直流偏置或逐采样点波形失真。
 */
static inline float cb_calibrate_sample_mv(float vin_mv, float frequency_khz)
{
    return vin_mv * cb_interpolated_gain(frequency_khz);
}

#endif /* CB_CALIBRATION_MODEL_H */
