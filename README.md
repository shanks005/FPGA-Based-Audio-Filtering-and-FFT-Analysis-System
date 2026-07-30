# FPGA-Based Audio Filtering and FFT Analysis

An FPGA-oriented digital signal-processing system that reads fixed-point audio samples from memory, computes the spectrum of the raw signal, filters the audio using an FIR filter, and computes a second FFT for spectral comparison.

The project demonstrates an end-to-end workflow from audio preparation and HDL generation to Vivado synthesis, implementation, timing analysis, power estimation, and device-utilization analysis.

## System architecture

![Stage-wise block diagram of the FPGA audio-processing system](https://github.com/shanks005/FPGA-Based-Audio-Filtering-and-FFT-Analysis-System/blob/main/FPGA_PROJ.png)

The processing chain has two parallel analysis paths:

1. **Raw-audio path:** memory-fed audio samples are passed directly to the first FFT block.
2. **Filtered-audio path:** the same samples are processed by the FIR filter and then passed to the second FFT block.

Both FFT blocks produce real and imaginary outputs for frequency-domain analysis.

## Key features

- Signed 16-bit, fixed-point audio samples loaded from a memory-initialization file
- Address counter and valid-signal generation for sequential sample delivery
- FIR filtering with multiple coefficients
- FFT analysis before and after filtering
- Complex FFT outputs containing real and imaginary components
- Vivado-based timing, power, BRAM, DSP, LUT, and register analysis
- Hardware-oriented data path suitable for extension to real-time audio acquisition

## Processing flow

```text
Audio source
    |
Scaling and fixed-point quantization
    |
16-bit sample memory
    |
Sample feeder and valid-signal generator
    |------------------------|
    |                        |
Raw-audio FFT            FIR filter
                             |
                         Filtered-audio FFT
    |                        |
    |------------------------|
       Spectrum comparison
```

## Reported implementation results

| Metric | Reported value |
|---|---:|
| Critical-path delay | 10.948 ns |
| Estimated maximum clock frequency | 91.34 MHz |
| Setup timing status | Met |
| Hold timing status | Met |
| Total on-chip power | 129.793 W |
| Dynamic power | 129.002 W |
| Static power | 0.791 W |
| Slice LUTs | 11,846 / 63,400 (18.69%) |
| Slice registers | 20,039 / 126,800 (15.80%) |
| DSP slices | 87 / 240 (36.25%) |
| Block RAM tiles | 9 / 135 (6.67%) |

> [!NOTE]
> The architecture diagram labels the system clock as 100 MHz, while the reported 10.948 ns critical path corresponds to approximately 91.34 MHz. A 100 MHz hardware target therefore requires the timing constraints and final implementation report to be checked carefully. The quoted power is a Vivado estimate and depends strongly on the selected FPGA, clocking, I/O settings, and switching-activity assumptions.

## FFT results

### Raw input spectrum

![Normalized FFT spectrum of the raw audio input](https://github.com/shanks005/FPGA-Based-Audio-Filtering-and-FFT-Analysis-System/blob/main/FFT_before.png)

The unfiltered input contains several dominant spectral components together with lower-magnitude frequency content.

### Filtered-output FFT

![FFT output after FIR filtering](https://github.com/shanks005/FPGA-Based-Audio-Filtering-and-FFT-Analysis-System/blob/main/filtered-audio-fft.jpeg)

The two FFT paths make it possible to compare the original and filtered spectra and evaluate attenuation of unwanted components.

## Resource-utilization snapshots

### Overall logic utilization

![Vivado LUT and register utilization report](https://github.com/shanks005/FPGA-Based-Audio-Filtering-and-FFT-Analysis-System/blob/main/Device_utilization%20(1).png)

### DSP utilization

![Vivado DSP utilization report](https://github.com/shanks005/FPGA-Based-Audio-Filtering-and-FFT-Analysis-System/blob/main/dsp_utilization%20(1).png)

### Block RAM utilization

![Vivado BRAM utilization report](https://github.com/shanks005/FPGA-Based-Audio-Filtering-and-FFT-Analysis-System/blob/main/memory_utilization%20(1).png)

## Typical tool flow

1. Import or generate the source audio in MATLAB.
2. Scale and quantize the samples to signed 16-bit fixed-point values.
3. Export the samples to a `.mem` file.
4. Feed samples to the FPGA processing chain using a ROM, address counter, and sample-valid strobe.
5. Simulate the raw FFT, FIR filter, and filtered FFT paths.
6. Generate or integrate the HDL modules.
7. Run Vivado synthesis and implementation.
8. Inspect timing, estimated power, and resource-utilization reports.
9. Export the FFT results and compare the spectra before and after filtering.

## Repository layout

```text
.
â”œâ”€â”€ README.md
â”œâ”€â”€ assets/
â”‚   â”œâ”€â”€ bram-utilization.png
â”‚   â”œâ”€â”€ device-utilization.png
â”‚   â”œâ”€â”€ dsp-utilization.png
â”‚   â”œâ”€â”€ filtered-audio-fft.png
â”‚   â”œâ”€â”€ power-report.png
â”‚   â”œâ”€â”€ raw-audio-fft.png
â”‚   â””â”€â”€ system-architecture.png
â””â”€â”€ docs/
    â””â”€â”€ FPGA_Mini_Project.pdf
```

The current package documents the completed design and its results. HDL, MATLAB, memory-initialization, Vivado-project, constraints, and testbench files can be added under dedicated source directories when they are available.

## Documentation

The complete project report is available here:

[Open the FPGA mini-project report](docs/FPGA_Mini_Project.pdf)

## Future development

- Replace memory-fed samples with real-time audio input
- Stream results to a host over UART or Ethernet
- Add real-time playback of filtered audio
- Integrate higher-order or adaptive filters
- Pipeline or restructure critical paths for a higher clock rate
- Optimize the FFT architecture for lower DSP and memory utilization
- Extend the design into a complete FPGA-based spectrum analyzer

## Contributors

- Ashwin Shankar
- Nikita Nayak
- Shadan Jawed
- Rhea Sinha
- Aditya Kini

## References

1. AMD/Xilinx, *Vivado Design Suite User Guide: Power Analysis and Optimization (UG907)*.
2. MathWorks, *HDL Coder Documentation: Generating HDL Code from Simulink*.
3. A. V. Oppenheim and R. W. Schafer, *Discrete-Time Signal Processing*.
