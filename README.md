# EEE4120F_YODA_DDS
This project implements a Direct Digital Synthesis (DDS) waveform generator on the Digilent Nexys A7 FPGA board using Verilog.

It generates periodic waveforms (Sine, Square, Triangle, Sawtooth) in real-time and displays relevant parameters on the 8-digit 7-segment display. Users can control the waveform type, frequency, and amplitude using on-board slide switches and push buttons.

---

## Features
- **Waveform Selection**  
  Supports Sine, Square, Triangle, and Sawtooth waves using internal LUTs.
- **Parameter Control**  
  Frequency and amplitude adjustable via 16-bit and 8-bit input values, respectively.
- **7-Segment Display Output**  
  Real-time display of waveform type and parameters using multiplexed 7-segment display logic.
- **PWM Output**  
  Outputs PWM from Pmod in the audio range.

---

## Technologies

- **Verilog HDL** – Verilog Hardware description language
- **Vivado** – Synthesis, implementation, and simulation
- **Nexys A7** – Artix-7 FPGA development board
- **XSIM** – Vivado simulation tool (testbench visualization)

---

## Author

Developed as part of EEE4120F: High Performance Embedded Systems 
University of Cape Town – Wave Makers

