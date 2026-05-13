set_property PACKAGE_PIN R21 [get_ports reset_0]
#set_property PACKAGE_PIN R20        [get_ports "GPIO_PB2"] ;     # Bank 65 - VCCO_64_65 - IO_L21P_T3L_N4_AD8P_D06_65 - Push Button PB5
#set_property PACKAGE_PIN P21        [get_ports "GPIO_PB3"] ;     # Bank 65 - VCCO_64_65 - IO_L20N_T3L_N3_AD1N_D09_65 - Push Button PB6
#set_property PACKAGE_PIN P20        [get_ports "GPIO_PB4"] ;     # Bank 65 - VCCO_64_65 - IO_L20P_T3L_N2_AD1P_D08_65 - Push Button PB7

set_property IOSTANDARD LVCMOS12 [get_ports reset_0]
#set_property IOSTANDARD LVCMOS12    [get_ports "GPIO_PB2"] ;     # Bank 65 - VCCO_64_65 - IO_L21P_T3L_N4_AD8P_D06_65 - Push Button PB5
#set_property IOSTANDARD LVCMOS12    [get_ports "GPIO_PB3"] ;     # Bank 65 - VCCO_64_65 - IO_L20N_T3L_N3_AD1N_D09_65 - Push Button PB6
#set_property IOSTANDARD LVCMOS12    [get_ports "GPIO_PB4"] ;     # Bank 65 - VCCO_64_65 - IO_L20P_T3L_N2_AD1P_D08_65 - Push Button PB7


#####################################################################################################################################################################################
## RGB LED - BANK 65 - VOLTAGE 1.2V VCCO_64_65 - PULLED DOWN BY DEFAULT (ACTIVE-HIGH with GPIO CONTROL)
#####################################################################################################################################################################################
set_property PACKAGE_PIN U26        [get_ports "pll_not_locked_out_0"] ;     # Bank 65 - VCCO_64_65 - IO_L16P_T2U_N6_QBC_AD3P_A00_D16_65 - RGB LED D36 (RED)
#set_property PACKAGE_PIN P24        [get_ports "LED_RGB_G2"] ;     # Bank 65 - VCCO_64_65 - IO_L15N_T2L_N5_AD11N_A03_D19_65    - RGB LED D36 (GREEN)
#set_property PACKAGE_PIN N24        [get_ports "LED_RGB_B2"] ;     # Bank 65 - VCCO_64_65 - IO_L15P_T2L_N4_AD11P_A02_D18_65    - RGB LED D36 (BLUE)

set_property IOSTANDARD LVCMOS12    [get_ports "pll_not_locked_out_0"] ;     # Bank 65 - VCCO_64_65 - IO_L16P_T2U_N6_QBC_AD3P_A00_D16_65 - RGB LED D36 (RED)
#set_property IOSTANDARD LVCMOS12    [get_ports "LED_RGB_G2"] ;     # Bank 65 - VCCO_64_65 - IO_L15N_T2L_N5_AD11N_A03_D19_65    - RGB LED D36 (GREEN)
#set_property IOSTANDARD LVCMOS12    [get_ports "LED_RGB_B2"] ;     # Bank 65 - VCCO_64_65 - IO_L15P_T2L_N4_AD11P_A02_D18_65    - RGB LED D36 (BLUE)


#####################################################################################################################################################################################
## SYSTEM RESET - BANK 65 - VOLTAGE 1.2V VCCO_64_65 - PULLED-UP BY DEFAULT (ACTIVE-LOW with RESET PUSH BUTTON - PB3)
#####################################################################################################################################################################################
#set_property PACKAGE_PIN V19        [get_ports "phy_reset_out"] ;     # Bank 65 - VCCO_64_65 - IO_L1N_T0L_N1_DBC_RS1_65 - PUSH BUTTON PB3
#set_property IOSTANDARD LVCMOS12    [get_ports "phy_reset_out"] ;     # Bank 65 - VCCO_64_65 - IO_L1N_T0L_N1_DBC_RS1_65 - PUSH BUTTON PB3

#####################################################################################################################################################################################
## SYSTEM CLOCK 300MHZ - BANK 64 - VOLTAGE 1.2V VCCO_64_65
#####################################################################################################################################################################################
set_property PACKAGE_PIN AD21 [get_ports CLK_IN1_D_0_clk_p]
set_property PACKAGE_PIN AE21 [get_ports CLK_IN1_D_0_clk_n]

set_property IOSTANDARD DIFF_SSTL12 [get_ports CLK_IN1_D_0_clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports CLK_IN1_D_0_clk_p]

#####################################################################################################################################################################################
## RED LEDs - BANK 85 - VOLTAGE 3.3V
#####################################################################################################################################################################################
set_property PACKAGE_PIN A10        [get_ports "led_0[0]"] ;    # Bank 85 - VCCO_85 - IO_L11N_AD9N_85 - RED LED D31
set_property PACKAGE_PIN B10        [get_ports "led_0[1]"] ;    # Bank 85 - VCCO_85 - IO_L11P_AD9P_85 - RED LED D32
set_property PACKAGE_PIN B11        [get_ports "led_0[2]"] ;    # Bank 85 - VCCO_85 - IO_L12N_AD8N_85 - RED LED D33
set_property PACKAGE_PIN C11        [get_ports "led_0[3]"] ;    # Bank 85 - VCCO_85 - IO_L12P_AD8P_85 - RED LED D34

set_property IOSTANDARD LVCMOS33    [get_ports "led_0[0]"] ;    # Bank 85 - VCCO_85 - IO_L11N_AD9N_85 - RED LED D31
set_property IOSTANDARD LVCMOS33    [get_ports "led_0[1]"] ;    # Bank 85 - VCCO_85 - IO_L11P_AD9P_85 - RED LED D32
set_property IOSTANDARD LVCMOS33    [get_ports "led_0[2]"] ;    # Bank 85 - VCCO_85 - IO_L12N_AD8N_85 - RED LED D33
set_property IOSTANDARD LVCMOS33    [get_ports "led_0[3]"] ;    # Bank 85 - VCCO_85 - IO_L12P_AD8P_85 - RED LED D34

#####################################################################################################################################################################################
## RGB LED - BANK 84 - VOLTAGE 1.8V VCCO_0_84 - PULLED DOWN BY DEFAULT (ACTIVE-HIGH with GPIO CONTROL)
#####################################################################################################################################################################################
set_property PACKAGE_PIN AE15       [get_ports "channel_up_0"] ;    # Bank 84 - VCCO_0_84 - IO_L3N_AD9N_84  - RGB LED D35 (RED)
#set_property PACKAGE_PIN AD15       [get_ports "LED_RGB_G1"] ;    # Bank 84 - VCCO_0_84 - IO_L3P_AD9P_84  - RGB LED D35 (GREEN)
#set_property PACKAGE_PIN AF13       [get_ports "LED_RGB_B1"] ;    # Bank 84 - VCCO_0_84 - IO_L2N_AD10N_84 - RGB LED D35 (BLUE)

set_property IOSTANDARD LVCMOS18    [get_ports "channel_up_0"] ;    # Bank 84 - VCCO_0_84 - IO_L3N_AD9N_84  - RGB LED D35 (RED)
#set_property IOSTANDARD LVCMOS18    [get_ports "LED_RGB_G1"] ;    # Bank 84 - VCCO_0_84 - IO_L3P_AD9P_84  - RGB LED D35 (GREEN)
#set_property IOSTANDARD LVCMOS18    [get_ports "LED_RGB_B1"] ;    # Bank 84 - VCCO_0_84 - IO_L2N_AD10N_84 - RGB LED D35 (BLUE)

set_property PACKAGE_PIN F2 [get_ports {rxp_0[0]}];
set_property PACKAGE_PIN F1 [get_ports {rxn_0[0]}];
set_property PACKAGE_PIN G5 [get_ports {txp_0[0]}];
set_property PACKAGE_PIN G4 [get_ports {txn_0[0]}];

set_property PACKAGE_PIN Y6 [get_ports GT_DIFF_REFCLK1_0_clk_n];
set_property PACKAGE_PIN Y7 [get_ports GT_DIFF_REFCLK1_0_clk_p];