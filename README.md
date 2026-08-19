# fpga-test
FPGA code example and test

### vivado
- (Auboard 15P) auboard-dma-bram: microblaze dma test with bram
- (Auboard 15P) auboard-pcie: pcie interface test(https://www.hackster.io/adam-taylor/perfecting-pcie-with-auboard-8cabd5)
- (Auboard 15P) auboard-pcie-aurora: data transfer using pcie and aurora
   test_pattern.py: pattern data transfer test for debug
   test_file.py: file trasnfer test

- (Zybo Z7-20) zybo-hdmi-out: hdmi text output
- (Zybo Z7-20) zybo-hdmi-passthrough: hdmi in/out passthrough

- (Zedboard) zedboard-cls-daq: logic pulse counter for raon cls daq
    required ip: ip-dac-cn0531, ip-pulse-counter-saxi, ip-zedboard-oled

### vivado ip
- ip-dac-cn0531: analoge device cn0531 dac board
- ip-pulse-counter-saxi: pulse counter
- ip-zedboard-oled: zedboard on-board oled
