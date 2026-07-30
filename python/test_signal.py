#!/usr/bin/env python3
"""生成 G 题可直接照抄到信号源的配置卡、理想结果和分享压缩包。"""

from __future__ import annotations

import argparse
import base64
import csv
import io
import json
import math
import zipfile
from dataclasses import asdict, dataclass
from pathlib import Path

import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt

FS_HZ = 10_000_000
RECORD_S = 0.002  # 2 ms，FFT 分辨率 500 Hz


@dataclass(frozen=True)
class Tone:
    order: int
    vpp_mv: float  # 信号源配置值
    role: str = "被测"

    @property
    def peak_mv(self) -> float:
        return self.vpp_mv / 2


@dataclass(frozen=True)
class Case:
    case_id: str
    title: str
    kind: str
    f1_hz: float
    tones: tuple[Tone, ...]
    note: str


def all_cases() -> tuple[Case, ...]:
    # 所有相位固定为 0°。最后一例的 H8 是带外干扰，不属于被测 ub。
    return (
        Case("01_ua_classic", "经典组合：H3 + H4", "ua", 10_500,
             (Tone(1, 120), Tone(3, 40), Tone(4, 30)),
             "对应题面举例，基频为 10.5 kHz。"),
        Case("02_ua_low", "ua 低幅度：H2", "ua", 50_000,
             (Tone(1, 90), Tone(2, 25)),
             "总波形 Upp 约 101 mV，贴近 ua 下限。"),
        Case("03_ua_h8_edge", "ua 频率上限：H8", "ua", 25_000,
             (Tone(1, 195), Tone(8, 55)),
             "H8 恰好为 200 kHz，总 Upp 接近 250 mV。"),
        Case("04_ua_adjacent", "相邻谱线：H2 + H3", "ua", 60_000,
             (Tone(1, 120), Tone(2, 50), Tone(3, 35)),
             "检验相邻谱线根数和幅值比例。"),
        Case("05_ub_low", "ub 低幅度：H7", "ub", 62_500,
             (Tone(1, 45), Tone(7, 10)),
             "总波形 Upp 约 51 mV，贴近 ub 下限。"),
        Case("06_ub_double_edge", "ub 幅度/频率上限：H5 + H8", "ub", 62_500,
             (Tone(1, 180), Tone(5, 40), Tone(8, 45)),
             "H8=500 kHz，总 Upp 约 249 mV。"),
        Case("07_ub_weak", "弱谱线：H4 + H6", "ub", 40_000,
             (Tone(1, 140), Tone(4, 8), Tone(6, 6)),
             "弱谐波幅值为 4 mV、3 mV，适合检查小谱线识别。"),
        Case("08_ub_interference", "H8 模拟 1 MHz 干扰", "ub+uJ", 125_000,
             (Tone(1, 130), Tone(2, 35), Tone(3, 20), Tone(8, 200, "干扰")),
             "受信号源限制，用同基频 H8 产生 1 MHz、200 mVpp 干扰；"
             "期望测量值只针对 H1+H2+H3 构成的 ub。"),
        Case("09_ua_single_h5", "单谐波专项：H5", "ua", 40_000,
             (Tone(1, 130), Tone(5, 25)),
             "H5 恰好为 200 kHz，用于 ua 单根五次谐波识别。"),
        Case("10_ua_h2_h7", "跨距组合：H2 + H7", "ua", 25_000,
             (Tone(1, 110), Tone(2, 30), Tone(7, 20)),
             "同时包含近端 H2 与远端 H7，检查频谱相对位置。"),
        Case("11_ua_odd_h3_h5", "奇次组合：H3 + H5", "ua", 20_000,
             (Tone(1, 160), Tone(3, 30), Tone(5, 20)),
             "三个奇次分量，适合检查非正弦对称波形与真有效值。"),
        Case("12_ua_h6", "单谐波专项：H6", "ua", 30_000,
             (Tone(1, 105), Tone(6, 18)),
             "H6=180 kHz，中低幅值 ua 单谐波案例。"),
        Case("13_ua_h2_h6", "偶次组合：H2 + H6", "ua", 30_000,
             (Tone(1, 145), Tone(2, 32), Tone(6, 22)),
             "两根偶次谐波，检查波形正负峰不对称时的 Upp。"),
        Case("14_ua_weak_h7", "ua 弱七次谐波", "ua", 20_000,
             (Tone(1, 118), Tone(7, 8)),
             "H7 谱线幅值仅 4 mV，接近题目允许的 ±5 mV 误差。"),
        Case("15_ub_h2_h4", "ub 偶次组合：H2 + H4", "ub", 100_000,
             (Tone(1, 100), Tone(2, 40), Tone(4, 25)),
             "H4=400 kHz，覆盖 ub 中高频偶次谱线。"),
        Case("16_ub_h3_h6", "ub 高频组合：H3 + H6", "ub", 80_000,
             (Tone(1, 160), Tone(3, 35), Tone(6, 25)),
             "H6=480 kHz，贴近 ub 的 500 kHz 频率上限。"),
        Case("17_ub_h4_h7", "ub 宽间隔组合：H4 + H7", "ub", 70_000,
             (Tone(1, 70), Tone(4, 15), Tone(7, 10)),
             "H7=490 kHz；低幅度下检查宽间隔谱线。"),
        Case("18_ub_single_h3", "单谐波专项：H3", "ub", 150_000,
             (Tone(1, 95), Tone(3, 30)),
             "高基频案例，H3=450 kHz。"),
        Case("19_ub_single_h4", "单谐波专项：H4", "ub", 120_000,
             (Tone(1, 200), Tone(4, 35)),
             "较高幅度与 H4=480 kHz 的组合。"),
        Case("20_ub_interference_1p2m", "H8 模拟 1.2 MHz 干扰", "ub+uJ", 150_000,
             (Tone(1, 105), Tone(2, 30), Tone(3, 18), Tone(8, 200, "干扰")),
             "第二组抗干扰案例：H8=1.2 MHz、200 mVpp；"
             "期望读数只针对 H1+H2+H3。"),
    )


def wave(t: np.ndarray, f1: float, tones: tuple[Tone, ...]) -> np.ndarray:
    """所有分量相位均为 0°，返回 mV。"""
    return sum((x.peak_mv * np.sin(2 * np.pi * x.order * f1 * t)
                for x in tones), start=np.zeros_like(t))


def metrics(f1: float, tones: tuple[Tone, ...]) -> tuple[float, float]:
    t = np.linspace(0, 1 / f1, 1_000_000, endpoint=False)
    y = wave(t, f1, tones)
    rms = math.sqrt(sum(x.peak_mv**2 for x in tones) / 2)
    return float(np.ptp(y)), rms


def measured_tones(case: Case) -> tuple[Tone, ...]:
    return tuple(x for x in case.tones if x.role == "被测")


def validate(case: Case) -> None:
    measured = measured_tones(case)
    assert 2 <= len(measured) <= 3
    assert measured[0].order == 1
    assert all(1 <= x.order <= 8 for x in case.tones)
    assert all(x.order * case.f1_hz <= 500_000 for x in measured)
    if case.kind == "ua":
        assert all(x.order * case.f1_hz <= 200_000 for x in measured)
    vpp, _ = metrics(case.f1_hz, measured)
    lower = 100 if case.kind == "ua" else 50
    assert lower <= vpp <= 250
    interference = tuple(x for x in case.tones if x.role == "干扰")
    if interference:
        assert len(interference) == 1
        assert interference[0].vpp_mv == 200
        assert interference[0].order * case.f1_hz >= 1_000_000


def plot_as_data_uri(case: Case) -> str:
    measured = measured_tones(case)
    period = 1 / case.f1_hz
    t3 = np.linspace(0, 3 * period, 3000, endpoint=False)
    clean = wave(t3, case.f1_hz, measured)

    fig, ax = plt.subplots(1, 2, figsize=(11, 3.6), constrained_layout=True)
    ax[0].plot(t3 * 1e6, clean, color="#137c8b", lw=1.5)
    ax[0].set(xlabel="Time (us)", ylabel="Voltage (mV)",
              title="Expected waveform: 3 periods")
    ax[0].grid(alpha=.22)

    frequencies = [x.order * case.f1_hz / 1000 for x in measured]
    amplitudes = [x.peak_mv for x in measured]
    ax[1].vlines(frequencies, 0, amplitudes, color="#e76f51", lw=4)
    ax[1].scatter(frequencies, amplitudes, color="#e76f51", s=28)
    ax[1].set(xlabel="Frequency (kHz)", ylabel="Peak amplitude (mV)",
              title="Expected measured spectrum",
              ylim=(0, max(amplitudes) * 1.2))
    ax[1].grid(alpha=.22)
    buffer = io.BytesIO()
    fig.savefig(buffer, format="png", dpi=135, facecolor="white")
    plt.close(fig)
    return "data:image/png;base64," + base64.b64encode(buffer.getvalue()).decode()


def result(case: Case) -> dict:
    measured = measured_tones(case)
    vpp, rms = metrics(case.f1_hz, measured)
    input_vpp, input_rms = metrics(case.f1_hz, case.tones)
    return {
        "id": case.case_id,
        "title": case.title,
        "type": case.kind,
        "note": case.note,
        "fundamental_hz": case.f1_hz,
        "period_us": 1e6 / case.f1_hz,
        "source_settings": [
            {"harmonic": f"H{x.order}", "order": x.order,
             "frequency_hz": x.order * case.f1_hz,
             "vpp_mv": x.vpp_mv, "phase_deg": 0, "role": x.role}
            for x in case.tones
        ],
        "expected": {
            "vpp_mv": vpp,
            "true_rms_mv": rms,
            "fundamental_hz": case.f1_hz,
            "spectrum": [
                {"harmonic": f"H{x.order}", "frequency_hz": x.order * case.f1_hz,
                 "amplitude_peak_mv": x.peak_mv}
                for x in measured
            ],
        },
        "whole_input_reference": {"vpp_mv": input_vpp, "true_rms_mv": input_rms},
    }


def fmt(x: float) -> str:
    return f"{x:.3f}".rstrip("0").rstrip(".")


def build_html(results: list[dict], images: dict[str, str]) -> str:
    quick_rows, sections = [], []
    for r in results:
        settings = "；".join(
            f"{x['harmonic']}={fmt(x['vpp_mv'])} mVpp"
            + ("（干扰）" if x["role"] == "干扰" else "")
            for x in r["source_settings"])
        quick_rows.append(
            f"<tr><td>{r['id']}</td><td>{r['type']}</td>"
            f"<td>{fmt(r['fundamental_hz']/1000)}</td><td>{settings}</td>"
            f"<td>{fmt(r['expected']['vpp_mv'])}</td>"
            f"<td>{fmt(r['expected']['true_rms_mv'])}</td></tr>")
        source_rows = "".join(
            f"<tr class=\"{'noise' if x['role']=='干扰' else ''}\"><td>{x['harmonic']}</td>"
            f"<td>{fmt(x['frequency_hz']/1000)}</td><td>{fmt(x['vpp_mv'])}</td>"
            f"<td>0</td><td>{x['role']}</td></tr>" for x in r["source_settings"])
        spectrum_rows = "".join(
            f"<tr><td>{x['harmonic']}</td><td>{fmt(x['frequency_hz']/1000)}</td>"
            f"<td>{fmt(x['amplitude_peak_mv'])}</td></tr>"
            for x in r["expected"]["spectrum"])
        warning = ""
        if r["type"] == "ub+uJ":
            warning = """<div class="warning"><b>关键：</b>H8 只用于模拟 uJ。
装置应抑制这根 1 MHz 谱线，Upp、Urms 和频谱期望值均只按 H1+H2+H3 计算。</div>"""
        sections.append(f"""<section>
<h2>{r['id']} · {r['title']}</h2><p class="note">{r['note']}</p>
<div class="columns"><div><h3>① 信号源直接配置</h3>
<p><b>基频：</b>{fmt(r['fundamental_hz']/1000)} kHz　
<b>所有谐波相位：</b>0°</p>
<table><tr><th>分量</th><th>实际频率/kHz</th><th>输入值/mVpp</th><th>相位/°</th><th>用途</th></tr>
{source_rows}</table></div><div><h3>② 装置理想读数</h3>
<div class="readout"><span>Upp<b>{fmt(r['expected']['vpp_mv'])} mV</b></span>
<span>真 Urms<b>{fmt(r['expected']['true_rms_mv'])} mV</b></span>
<span>基频<b>{fmt(r['fundamental_hz']/1000)} kHz</b></span></div>
<table><tr><th>谱线</th><th>频率/kHz</th><th>幅值（峰值）/mV</th></tr>{spectrum_rows}</table>
</div></div>{warning}<img src="{images[r['id']]}" alt="{r['id']} 波形与频谱"></section>""")

    return f"""<!doctype html><html lang="zh-CN"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1"><title>G题测试信号配置手册</title>
<style>
:root{{--ink:#19324a;--blue:#137c8b;--paper:#fff;--soft:#f3f7f8;--line:#cfdbdf;--hot:#c4492d}}
*{{box-sizing:border-box}}body{{margin:0;background:#edf2f3;color:#24323d;font:15px/1.55 "Microsoft YaHei",system-ui,sans-serif}}
main{{max-width:1200px;margin:auto;background:var(--paper);padding:38px 48px;box-shadow:0 0 35px #b9c6ca}}
h1{{margin:0;color:var(--ink);font-size:34px}}.subtitle{{color:#55717b;margin:4px 0 24px}}
h2{{color:var(--ink);border-left:6px solid var(--blue);padding-left:12px;margin-top:34px}}
h3{{color:var(--blue);margin-bottom:8px}}.rule,.warning{{padding:13px 16px;border-radius:7px;background:#e9f5f5}}
.warning{{background:#fff0e9;border:1px solid #efb29f;color:#71301f;margin-top:14px}}
table{{width:100%;border-collapse:collapse;margin:10px 0 16px;font-size:14px}}
th{{background:var(--ink);color:white}}th,td{{padding:7px 9px;border:1px solid var(--line);text-align:center}}
.noise td{{background:#fff0e9;color:var(--hot);font-weight:700}}section{{page-break-before:always;border-top:1px solid var(--line)}}
.columns{{display:grid;grid-template-columns:1.08fr .92fr;gap:28px}}.note{{color:#5c717b}}
.readout{{display:flex;gap:8px;flex-wrap:wrap}}.readout span{{background:var(--soft);padding:8px 12px;border-radius:6px}}
.readout b{{display:block;color:var(--blue);font-size:19px}}img{{width:100%;display:block;margin-top:10px}}
.small{{font-size:13px;color:#667}}code{{background:#edf2f3;padding:2px 5px}}
@media(max-width:800px){{main{{padding:22px 14px}}.columns{{grid-template-columns:1fr}}table{{font-size:12px}}th,td{{padding:5px}}}}
@media print{{body{{background:white}}main{{box-shadow:none;max-width:none;padding:10mm}}}}
</style></head><body><main>
<h1>G题 · 周期信号测试配置手册</h1>
<p class="subtitle">信号源 Vpp 配置 → 装置理想读数｜单文件离线版</p>
<div class="rule"><b>统一约定：</b>信号源中每个分量填写 <b>峰峰值 Vpp</b>，所有相位均为
<b>0°</b>。装置频谱显示的“幅值”是<b>峰值</b>，所以数值恒为对应分量 Vpp÷2。
总信号 Upp 不是各分量 Vpp 简单相加，而是合成波形最大值减最小值。Urms 为真有效值。</div>
<h2>快速配置总表</h2>
<table><tr><th>案例</th><th>类型</th><th>基频/kHz</th><th>信号源谐波 Vpp 配置</th>
<th>期望 Upp/mV</th><th>期望 Urms/mV</th></tr>{''.join(quick_rows)}</table>
<p class="small">采样数据统一为 {FS_HZ/1e6:g} MSa/s、2 ms（20,000 点），对应 500 Hz 频率分辨率。</p>
{''.join(sections)}
</main></body></html>"""


def write_package(out: Path, results: list[dict], html_doc: str) -> Path:
    out.mkdir(parents=True, exist_ok=True)
    report = out / "G题_测试信号配置与理想结果.html"
    report.write_text(html_doc, encoding="utf-8")
    (out / "配置与理想值.json").write_text(
        json.dumps(results, ensure_ascii=False, indent=2), encoding="utf-8")

    with (out / "信号源快速配置.csv").open("w", newline="", encoding="utf-8-sig") as f:
        w = csv.writer(f)
        w.writerow(["案例", "类型", "基频_kHz", "分量", "频率_kHz", "信号源_Vpp_mV",
                    "相位_deg", "用途", "期望谱线峰值_mV"])
        for r in results:
            expected = {x["harmonic"]: x["amplitude_peak_mv"]
                        for x in r["expected"]["spectrum"]}
            for x in r["source_settings"]:
                w.writerow([r["id"], r["type"], r["fundamental_hz"]/1000,
                            x["harmonic"], x["frequency_hz"]/1000, x["vpp_mv"], 0,
                            x["role"], expected.get(x["harmonic"], "应抑制")])

    data = {}
    t = np.arange(round(FS_HZ * RECORD_S)) / FS_HZ
    for case in all_cases():
        data[f"{case.case_id}_time_s"] = t
        data[f"{case.case_id}_input_mV"] = wave(t, case.f1_hz, case.tones)
        data[f"{case.case_id}_expected_mV"] = wave(t, case.f1_hz, measured_tones(case))
    np.savez_compressed(out / "全部案例采样数据.npz", **data)

    package = out / "G题_测试信号资料包.zip"
    with zipfile.ZipFile(package, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for name in ("G题_测试信号配置与理想结果.html", "信号源快速配置.csv",
                     "配置与理想值.json", "全部案例采样数据.npz"):
            z.write(out / name, arcname=name)
    return package


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path,
                        default=Path(__file__).with_name("test_signal_output"))
    args = parser.parse_args()
    cases = all_cases()
    for case in cases:
        validate(case)
    results = [result(x) for x in cases]
    images = {x.case_id: plot_as_data_uri(x) for x in cases}
    package = write_package(args.output.resolve(), results, build_html(results, images))
    print(f"已生成 {len(cases)} 个案例")
    print(f"单文件报告：{package.parent / 'G题_测试信号配置与理想结果.html'}")
    print(f"分享压缩包：{package} ({package.stat().st_size / 1024:.1f} KiB)")


if __name__ == "__main__":
    main()
