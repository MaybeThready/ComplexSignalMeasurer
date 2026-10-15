# 信号测量仪

基于 FPGA 与 MSPM0 的信号采集、分析和显示项目。

FPGA 完成 ADC 数据采集、FIR 滤波与抽取，并通过 SPI 将采样数据发送给 MCU；MSPM0 对数据进行 FFT 分析，计算信号频率、幅值、峰峰值和有效值，并在 OLED 及串口屏上显示波形和频谱。

## 主要功能

- ADC 信号采集与 FIR 数字滤波
- 2048 点 FFT 频谱分析
- 测量频率、幅值、峰峰值和有效值
- 识别基波及主要谐波
- OLED 菜单与串口屏波形/频谱显示
- 支持测量结果校准

## 目录结构

```text
.
├── fpga/              # FPGA 工程（Quartus）
│   └── src/           # Verilog 源码
├── mcu/               # MSPM0 固件
│   ├── bsp/           # 板级驱动
│   ├── ui/            # OLED UI
│   └── keil/          # Keil 工程
├── usart_sig/         # 串口屏工程与资源
└── fir*_coef.txt      # FIR 滤波器系数
```

## 开发环境

- FPGA：Cyclone IV E（EP4CE6F17C8），Quartus Prime
- MCU：TI MSPM0G3519，Keil MDK + MSPM0 SDK 2.08
- MCU 工程：`mcu/keil/Demo.uvprojx`
- FPGA 工程：`fpga/main.qpf`

分别使用 Keil 和 Quartus 打开对应工程，编译后下载到 MCU 与 FPGA 即可。
