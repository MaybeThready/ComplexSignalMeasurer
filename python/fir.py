from pathlib import Path

import numpy as np
from scipy.signal import freqz, remez


# Filter requirements
SAMPLE_RATE_HZ = 20_000_000
DECIMATION_FACTOR = 8
OUTPUT_SAMPLE_RATE_HZ = SAMPLE_RATE_HZ // DECIMATION_FACTOR
PASSBAND_EDGE_HZ = 500_000
STOPBAND_EDGE_HZ = 1_000_000
PASSBAND_RIPPLE_DB = 0.1
STOPBAND_ATTENUATION_DB = 80.0

# Resource-constrained target for EP4CE6:
# 149 symmetric taps -> 75 unique multiplications.
# At 100 MHz / 20 MS/s, five clocks are available per input sample, so the
# FIR II implementation can time-share exactly 15 DSP multipliers.
DESIGN_PASSBAND_RIPPLE_DB = 0.1
DESIGN_STOPBAND_ATTENUATION_DB = 82.0
MAX_TAPS = 149

# Cyclone IV FIR II coefficient format
COEFFICIENT_WIDTH = 18
COEFFICIENT_FRACTIONAL_WIDTH = 20
FREQ_RESPONSE_POINTS = 262_144
OUTPUT_FILE = Path(__file__).resolve().parents[1] / "fir_coef.txt"


def measure_response(coefficients: np.ndarray) -> tuple[float, float, float]:
    """Return passband ripple, passband peak and stopband peak in dB."""
    frequencies, response = freqz(
        coefficients,
        worN=FREQ_RESPONSE_POINTS,
        fs=SAMPLE_RATE_HZ,
    )
    magnitude_db = 20.0 * np.log10(np.maximum(np.abs(response), 1e-15))

    passband = magnitude_db[frequencies <= PASSBAND_EDGE_HZ]
    stopband = magnitude_db[frequencies >= STOPBAND_EDGE_HZ]
    ripple_db = float(passband.max() - passband.min())
    return ripple_db, float(passband.max()), float(stopband.max())


def quantize_coefficients(
    coefficients: np.ndarray,
) -> tuple[np.ndarray, np.ndarray]:
    """Quantize coefficients into signed 18-bit integers with 20 frac bits."""
    scale = 1 << COEFFICIENT_FRACTIONAL_WIDTH
    minimum = -(1 << (COEFFICIENT_WIDTH - 1))
    maximum = (1 << (COEFFICIENT_WIDTH - 1)) - 1
    integers = np.clip(
        np.rint(coefficients * scale),
        minimum,
        maximum,
    ).astype(np.int64)
    return integers, integers.astype(np.float64) / scale


def design_filter() -> tuple[np.ndarray, np.ndarray]:
    passband_deviation = (
        (10 ** (PASSBAND_RIPPLE_DB / 20.0) - 1.0)
        / (10 ** (PASSBAND_RIPPLE_DB / 20.0) + 1.0)
    )
    stopband_deviation = 10 ** (-STOPBAND_ATTENUATION_DB / 20.0)

    bands = [
        0.0,
        PASSBAND_EDGE_HZ,
        STOPBAND_EDGE_HZ,
        SAMPLE_RATE_HZ / 2.0,
    ]
    weights = [1.0 / passband_deviation, 1.0 / stopband_deviation]

    # Search for the shortest odd-tap symmetric FIR that still meets the
    # requirements after fixed-point coefficient quantization.
    for numtaps in range(31, MAX_TAPS + 1, 2):
        try:
            floating_coefficients = remez(
                numtaps,
                bands,
                [1.0, 0.0],
                weight=weights,
                fs=SAMPLE_RATE_HZ,
                maxiter=100,
                grid_density=32,
            )
        except ValueError:
            continue

        integer_coefficients, quantized_coefficients = quantize_coefficients(
            floating_coefficients
        )
        ripple_db, _, stopband_max_db = measure_response(quantized_coefficients)

        if (
            ripple_db <= DESIGN_PASSBAND_RIPPLE_DB
            and stopband_max_db <= -DESIGN_STOPBAND_ATTENUATION_DB
        ):
            return integer_coefficients, quantized_coefficients

    raise RuntimeError(
        f"No solution up to {MAX_TAPS} taps; check the filter requirements."
    )


def main() -> None:
    integer_coefficients, quantized_coefficients = design_filter()
    ripple_db, passband_max_db, stopband_max_db = measure_response(
        quantized_coefficients
    )

    # FIR II fractional format: one line is one coefficient bank.
    np.savetxt(
        OUTPUT_FILE,
        quantized_coefficients[np.newaxis, :],
        fmt="%.12g",
        delimiter=", ",
    )

    print(f"Input sample rate     : {SAMPLE_RATE_HZ / 1e6:.3f} MHz")
    print(f"Decimation factor     : {DECIMATION_FACTOR}")
    print(f"Output sample rate    : {OUTPUT_SAMPLE_RATE_HZ / 1e6:.3f} MHz")
    print(f"Passband edge         : {PASSBAND_EDGE_HZ / 1e3:.3f} kHz")
    print(f"Stopband edge         : {STOPBAND_EDGE_HZ / 1e3:.3f} kHz")
    print(f"Number of taps        : {integer_coefficients.size}")
    print(f"Coefficient width     : {COEFFICIENT_WIDTH} bits")
    print(f"Coefficient frac bits : {COEFFICIENT_FRACTIONAL_WIDTH}")
    print(f"Quantized ripple      : {ripple_db:.6f} dB")
    print(f"Quantized pass peak   : {passband_max_db:.6f} dB")
    print(f"Quantized stop peak   : {stopband_max_db:.6f} dB")
    print(f"Coefficient file      : {OUTPUT_FILE}")
    print(
        "FIR II settings       : 1 bank, Signed Fractional Binary, "
        f"Fractional Width={COEFFICIENT_FRACTIONAL_WIDTH}, Scaling=None"
    )


if __name__ == "__main__":
    main()
