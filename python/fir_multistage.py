from pathlib import Path

import numpy as np
from scipy.signal import freqz, remez


ROOT = Path(__file__).resolve().parents[1]
COEFFICIENT_WIDTH = 18
RESPONSE_POINTS = 262_144


def measure(
    coefficients: np.ndarray,
    sample_rate: float,
    passband_edge: float,
    stopband_edge: float,
) -> tuple[float, float]:
    frequencies, response = freqz(
        coefficients,
        worN=RESPONSE_POINTS,
        fs=sample_rate,
    )
    magnitude_db = 20.0 * np.log10(np.maximum(np.abs(response), 1e-15))
    passband = magnitude_db[frequencies <= passband_edge]
    stopband = magnitude_db[frequencies >= stopband_edge]
    return float(passband.max() - passband.min()), float(stopband.max())


def design_stage(
    *,
    sample_rate: int,
    passband_edge: int,
    stopband_edge: int,
    fractional_width: int,
    ripple_db: float = 0.04,
    attenuation_db: float = 85.0,
) -> tuple[np.ndarray, np.ndarray, float, float]:
    passband_deviation = (
        (10 ** (ripple_db / 20.0) - 1.0)
        / (10 ** (ripple_db / 20.0) + 1.0)
    )
    stopband_deviation = 10 ** (-attenuation_db / 20.0)
    scale = 1 << fractional_width
    minimum = -(1 << (COEFFICIENT_WIDTH - 1))
    maximum = (1 << (COEFFICIENT_WIDTH - 1)) - 1

    for numtaps in range(7, 302, 2):
        try:
            floating = remez(
                numtaps,
                [0.0, passband_edge, stopband_edge, sample_rate / 2.0],
                [1.0, 0.0],
                weight=[1.0 / passband_deviation, 1.0 / stopband_deviation],
                fs=sample_rate,
                maxiter=100,
                grid_density=32,
            )
        except ValueError:
            continue

        integers = np.rint(floating * scale)
        if integers.min() < minimum or integers.max() > maximum:
            continue
        integers = integers.astype(np.int64)
        quantized = integers.astype(np.float64) / scale
        ripple, stop_peak = measure(
            quantized,
            sample_rate,
            passband_edge,
            stopband_edge,
        )
        if ripple <= ripple_db and stop_peak <= -attenuation_db:
            return integers, quantized, ripple, stop_peak

    raise RuntimeError("No fixed-point FIR solution found below 302 taps.")


def save_bank(filename: str, coefficients: np.ndarray) -> Path:
    path = ROOT / filename
    np.savetxt(
        path,
        coefficients[np.newaxis, :],
        fmt="%d",
        delimiter=", ",
    )
    return path


def main() -> None:
    # Stage 1: 20 MS/s -> decimate by 4 -> 5 MS/s.
    # Frequencies from 4 MHz upward could alias below 1 MHz after this stage,
    # so stage 1 starts its stopband at 4 MHz.
    stage1 = design_stage(
        sample_rate=20_000_000,
        passband_edge=500_000,
        stopband_edge=4_000_000,
        fractional_width=19,
    )

    # Stage 2: 5 MS/s -> decimate by 2 -> 2.5 MS/s.
    # This stage provides the required 500 kHz / 1 MHz transition.
    stage2 = design_stage(
        sample_rate=5_000_000,
        passband_edge=500_000,
        stopband_edge=1_000_000,
        fractional_width=18,
    )

    stage1_path = save_bank("fir_stage1_coef.txt", stage1[0])
    stage2_path = save_bank("fir_stage2_coef.txt", stage2[0])

    print("Stage 1: 20 MS/s -> 5 MS/s, decimation=4")
    print(
        f"  taps={stage1[0].size}, frac=19, "
        f"ripple={stage1[2]:.6f} dB, stop={stage1[3]:.6f} dB"
    )
    print(f"  coefficients={stage1_path}")
    print("Stage 2: 5 MS/s -> 2.5 MS/s, decimation=2")
    print(
        f"  taps={stage2[0].size}, frac=18, "
        f"ripple={stage2[2]:.6f} dB, stop={stage2[3]:.6f} dB"
    )
    print(f"  coefficients={stage2_path}")
    print(f"Combined passband ripple <= {stage1[2] + stage2[2]:.6f} dB")


if __name__ == "__main__":
    main()
