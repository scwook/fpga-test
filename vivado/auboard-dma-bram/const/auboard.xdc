set_property PACKAGE_PIN AD21 [get_ports CLK_IN1_D_0_clk_p]
set_property PACKAGE_PIN AE21 [get_ports CLK_IN1_D_0_clk_n]

set_property IOSTANDARD DIFF_SSTL12 [get_ports CLK_IN1_D_0_clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports CLK_IN1_D_0_clk_p]

#create_clock -period 3.333 -name sys_clk_300 [get_ports clk_in1_d_clk_p];


set_property PACKAGE_PIN R21 [get_ports reset_0]
set_property IOSTANDARD LVCMOS12 [get_ports reset_0]

set_property PACKAGE_PIN A10        [get_ports "led_0[0]"] ;    # Bank 85 - VCCO_85 - IO_L11N_AD9N_85 - RED LED D31
set_property PACKAGE_PIN B10        [get_ports "led_0[1]"] ;    # Bank 85 - VCCO_85 - IO_L11P_AD9P_85 - RED LED D32
set_property PACKAGE_PIN B11        [get_ports "led_0[2]"] ;    # Bank 85 - VCCO_85 - IO_L12N_AD8N_85 - RED LED D33
set_property PACKAGE_PIN C11        [get_ports "led_0[3]"] ;    # Bank 85 - VCCO_85 - IO_L12P_AD8P_85 - RED LED D34

set_property IOSTANDARD LVCMOS33    [get_ports "led_0[0]"] ;    # Bank 85 - VCCO_85 - IO_L11N_AD9N_85 - RED LED D31
set_property IOSTANDARD LVCMOS33    [get_ports "led_0[1]"] ;    # Bank 85 - VCCO_85 - IO_L11P_AD9P_85 - RED LED D32
set_property IOSTANDARD LVCMOS33    [get_ports "led_0[2]"] ;    # Bank 85 - VCCO_85 - IO_L12N_AD8N_85 - RED LED D33
set_property IOSTANDARD LVCMOS33    [get_ports "led_0[3]"] ;    # Bank 85 - VCCO_85 - IO_L12P_AD8P_85 - RED LED D34

set_property PACKAGE_PIN AE15       [get_ports "led_resetn"] ;    # Bank 84 - VCCO_0_84 - IO_L3N_AD9N_84  - RGB LED D35 (RED)
#set_property PACKAGE_PIN AD15       [get_ports "LED_RGB_G1"] ;    # Bank 84 - VCCO_0_84 - IO_L3P_AD9P_84  - RGB LED D35 (GREEN)
#set_property PACKAGE_PIN AF13       [get_ports "LED_RGB_B1"] ;    # Bank 84 - VCCO_0_84 - IO_L2N_AD10N_84 - RGB LED D35 (BLUE)

set_property IOSTANDARD LVCMOS18    [get_ports "led_resetn"] ;    # Bank 84 - VCCO_0_84 - IO_L3N_AD9N_84  - RGB LED D35 (RED)
#set_property IOSTANDARD LVCMOS18    [get_ports "LED_RGB_G1"] ;    # Bank 84 - VCCO_0_84 - IO_L3P_AD9P_84  - RGB LED D35 (GREEN)
#set_property IOSTANDARD LVCMOS18    [get_ports "LED_RGB_B1"] ;    # Bank 84 - VCCO_0_84 - IO_L2N_AD10N_84 - RGB LED D35 (BLUE)