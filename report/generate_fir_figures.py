"""Reproduce the figures used by the two FIR reports."""

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
from scipy.signal import freqz


ROOT = Path(__file__).resolve().parents[1]
REPORT = Path(__file__).resolve().parent
FS_IN = 10_240_000.0
DECIMATION = 10
FS_OUT = FS_IN / DECIMATION


def load_coefficients() -> np.ndarray:
    return np.loadtxt(ROOT / "fir_coef.txt", delimiter=",")


def response_figure(h: np.ndarray) -> None:
    f, response = freqz(h, worN=262_144, fs=FS_IN)
    db = 20 * np.log10(np.maximum(np.abs(response), 1e-15))

    fig, axes = plt.subplots(2, 1, figsize=(9, 7), constrained_layout=True)
    axes[0].plot(f / 1e6, db, linewidth=0.9)
    axes[0].axvspan(0, 0.6, alpha=0.12, color="tab:green", label="passband")
    axes[0].axvspan(0.9, FS_IN / 2e6, alpha=0.10, color="tab:red",
                    label="stopband")
    axes[0].axvline(FS_OUT / 2e6, color="tab:orange", linestyle="--",
                    label="output Nyquist (512 kHz)")
    axes[0].set(xlabel="Input frequency (MHz)", ylabel="Magnitude (dB)",
                ylim=(-150, 5), title="Quantized FIR magnitude response")
    axes[0].grid(True, alpha=0.25)
    axes[0].legend(loc="upper right")

    mask = f <= 0.65e6
    axes[1].plot(f[mask] / 1e3, db[mask], linewidth=1)
    axes[1].axvline(512, color="tab:orange", linestyle="--")
    axes[1].axvline(600, color="tab:green", linestyle=":")
    axes[1].set(xlabel="Input frequency (kHz)", ylabel="Magnitude (dB)",
                title="Passband detail")
    axes[1].grid(True, alpha=0.25)
    fig.savefig(REPORT / "fir_frequency_response.png", dpi=180)
    plt.close(fig)


def coefficient_figure(h: np.ndarray) -> None:
    n = np.arange(h.size)
    fig, ax = plt.subplots(figsize=(9, 4.5), constrained_layout=True)
    ax.stem(n, h, linefmt="C0-", markerfmt="C0.", basefmt="k-")
    ax.axvline((h.size - 1) / 2, color="tab:red", linestyle="--",
               label="symmetry center n=111")
    ax.set(xlabel="Tap index n", ylabel="h[n]",
           title="223 quantized, symmetric FIR coefficients")
    ax.grid(True, alpha=0.25)
    ax.legend()
    fig.savefig(REPORT / "fir_coefficients.png", dpi=180)
    plt.close(fig)


def alias_figure() -> None:
    f = np.linspace(0, FS_IN / 2, 6000)
    folded = np.abs((f + FS_OUT / 2) % FS_OUT - FS_OUT / 2)
    fig, ax = plt.subplots(figsize=(9, 4.5), constrained_layout=True)
    ax.plot(f / 1e6, folded / 1e3, linewidth=1)
    ax.axvspan(0.9, FS_IN / 2e6, alpha=0.10, color="tab:red",
               label="specified FIR stopband")
    ax.axvspan(0.512, 0.6, alpha=0.20, color="tab:orange",
               label="depends on input-spectrum guarantee")
    ax.set(xlabel="Input frequency before decimation (MHz)",
           ylabel="Aliased output frequency (kHz)",
           title="Frequency folding caused by decimation by 10",
           ylim=(0, FS_OUT / 2e3))
    ax.grid(True, alpha=0.25)
    ax.legend(loc="lower right")
    fig.savefig(REPORT / "fir_alias_mapping.png", dpi=180)
    plt.close(fig)


def main() -> None:
    h = load_coefficients()
    response_figure(h)
    coefficient_figure(h)
    alias_figure()


if __name__ == "__main__":
    main()
