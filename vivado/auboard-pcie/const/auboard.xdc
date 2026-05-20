#####################################################################################################################################################################################
## MASTER PIN MAPPING FILE: AUB-15P-DK-1-01-01-Master-XDC.txt
## BOARD REVISION: 1-01-01
## DATE: 10-28-2024
#####################################################################################################################################################################################

#####################################################################################################################################################################################
## AMD Artix UltraScale+ Part Number
#####################################################################################################################################################################################
##### "xcau15p-ffvb676-2-e"
#####################################################################################################################################################################################

#####################################################################################################################################################################################
## NOTE: THIS DOCUMENT IS ARRANGED BY BANK - 66 / 65 / 64 / 86 / 85 / 84 / MGT226 / MGT225 / MGT224 (IT IS NOT ARRANGED BY INTERFACE)
#####################################################################################################################################################################################

#####################################################################################################################################################################################
## SFP1 CTRL - BANK 65 - VOLTAGE 1.2V VCCO_64_65
#####################################################################################################################################################################################
#set_property PACKAGE_PIN N22        [get_ports "SFP1_TDIS"] ;       # Bank 65 - VCCO_64_65 - IO_L24N_T3U_N11_DOUT_CSO_B_65
#set_property IOSTANDARD LVCMOS12    [get_ports "SFP1_TDIS"] ;       # Bank 65 - VCCO_64_65 - IO_L24N_T3U_N11_DOUT_CSO_B_65

#set_property PACKAGE_PIN V26        [get_ports "SFP1_TFAULT"] ;     # Bank 65 - VCCO_64_65 - IO_L16N_T2U_N7_QBC_AD3N_A01_D17_65
#set_property IOSTANDARD LVCMOS12    [get_ports "SFP1_TFAULT"] ;     # Bank 65 - VCCO_64_65 - IO_L16N_T2U_N7_QBC_AD3N_A01_D17_65

#####################################################################################################################################################################################
## EMCCLK - BANK 65 - VOLTAGE 1.2V VCCO_64_65 (EXTERNAL CONFIGURATION CLOCK)
#####################################################################################################################################################################################
#set_property PACKAGE_PIN N21        [get_ports "CLK_150M"] ;      # Bank 65 - VCCO_64_65 - IO_L24P_T3U_N10_EMCCLK_65
#set_property IOSTANDARD LVCMOS12    [get_ports "CLK_150M"] ;      # Bank 65 - VCCO_64_65 - IO_L24P_T3U_N10_EMCCLK_65

#####################################################################################################################################################################################
## USER SWITCH - BANK 65 - VOLTAGE 1.2V VCCO_64_65 - PULLED DOWN WHEN SWITCH OFF (ACTIVE-HIGH with SWITCH ON)
#####################################################################################################################################################################################
#set_property PACKAGE_PIN P19        [get_ports "GPIO_SW1"] ;     # Bank 65 - VCCO_64_65 - IO_L23N_T3U_N9_PERSTN1_I2C_SDA_65  - Switch SW2(1:8)
#set_property PACKAGE_PIN N19        [get_ports "GPIO_SW2"] ;     # Bank 65 - VCCO_64_65 - IO_L23P_T3U_N8_I2C_SCLK_65         - Switch SW2(2:7)
#set_property PACKAGE_PIN P23        [get_ports "GPIO_SW3"] ;     # Bank 65 - VCCO_64_65 - IO_L22N_T3U_N7_DBC_AD0N_D05_65     - Switch SW2(3:6)
#set_property PACKAGE_PIN N23        [get_ports "GPIO_SW4"] ;     # Bank 65 - VCCO_64_65 - IO_L22P_T3U_N6_DBC_AD0P_D04_65     - Switch SW2(4:5)

#set_property IOSTANDARD LVCMOS12    [get_ports "GPIO_SW1"] ;     # Bank 65 - VCCO_64_65 - IO_L23N_T3U_N9_PERSTN1_I2C_SDA_65  - Switch SW2(1:8)
#set_property IOSTANDARD LVCMOS12    [get_ports "GPIO_SW2"] ;     # Bank 65 - VCCO_64_65 - IO_L23P_T3U_N8_I2C_SCLK_65         - Switch SW2(2:7)
#set_property IOSTANDARD LVCMOS12    [get_ports "GPIO_SW3"] ;     # Bank 65 - VCCO_64_65 - IO_L22N_T3U_N7_DBC_AD0N_D05_65     - Switch SW2(3:6)
#set_property IOSTANDARD LVCMOS12    [get_ports "GPIO_SW4"] ;     # Bank 65 - VCCO_64_65 - IO_L22P_T3U_N6_DBC_AD0P_D04_65     - Switch SW2(4:5)

#####################################################################################################################################################################################
## USER PUSH BUTTONS - BANK 65 - VOLTAGE 1.2V VCCO_64_65 - PULLED DOWN BY DEFAULT (ACTIVE-HIGH with BUTTON PRESS)
#####################################################################################################################################################################################
#set_property PACKAGE_PIN R21        [get_ports "reset_0"] ;     # Bank 65 - VCCO_64_65 - IO_L21N_T3L_N5_AD8N_D07_65 - Push Button PB4
#set_property PACKAGE_PIN R20        [get_ports "GPIO_PB2"] ;     # Bank 65 - VCCO_64_65 - IO_L21P_T3L_N4_AD8P_D06_65 - Push Button PB5
#set_property PACKAGE_PIN P21        [get_ports "GPIO_PB3"] ;     # Bank 65 - VCCO_64_65 - IO_L20N_T3L_N3_AD1N_D09_65 - Push Button PB6
#set_property PACKAGE_PIN P20        [get_ports "GPIO_PB4"] ;     # Bank 65 - VCCO_64_65 - IO_L20P_T3L_N2_AD1P_D08_65 - Push Button PB7

#set_property IOSTANDARD LVCMOS12    [get_ports "reset_0"] ;     # Bank 65 - VCCO_64_65 - IO_L21N_T3L_N5_AD8N_D07_65 - Push Button PB4
#set_property IOSTANDARD LVCMOS12    [get_ports "GPIO_PB2"] ;     # Bank 65 - VCCO_64_65 - IO_L21P_T3L_N4_AD8P_D06_65 - Push Button PB5
#set_property IOSTANDARD LVCMOS12    [get_ports "GPIO_PB3"] ;     # Bank 65 - VCCO_64_65 - IO_L20N_T3L_N3_AD1N_D09_65 - Push Button PB6
#set_property IOSTANDARD LVCMOS12    [get_ports "GPIO_PB4"] ;     # Bank 65 - VCCO_64_65 - IO_L20P_T3L_N2_AD1P_D08_65 - Push Button PB7


#####################################################################################################################################################################################
## RGB LED - BANK 65 - VOLTAGE 1.2V VCCO_64_65 - PULLED DOWN BY DEFAULT (ACTIVE-HIGH with GPIO CONTROL)
#####################################################################################################################################################################################
#set_property PACKAGE_PIN U26        [get_ports "led"] ;     # Bank 65 - VCCO_64_65 - IO_L16P_T2U_N6_QBC_AD3P_A00_D16_65 - RGB LED D36 (RED)
#set_property PACKAGE_PIN P24        [get_ports "LED_RGB_G2"] ;     # Bank 65 - VCCO_64_65 - IO_L15N_T2L_N5_AD11N_A03_D19_65    - RGB LED D36 (GREEN)
#set_property PACKAGE_PIN N24        [get_ports "LED_RGB_B2"] ;     # Bank 65 - VCCO_64_65 - IO_L15P_T2L_N4_AD11P_A02_D18_65    - RGB LED D36 (BLUE)

#set_property IOSTANDARD LVCMOS12    [get_ports "led"] ;     # Bank 65 - VCCO_64_65 - IO_L16P_T2U_N6_QBC_AD3P_A00_D16_65 - RGB LED D36 (RED)
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
#set_property PACKAGE_PIN AE21       [get_ports "CLK_IN1_D_0_clk_n"] ;     # Bank 65 - VCCO_64_65 - IO_L11N_T1U_N9_GC_64
#set_property PACKAGE_PIN AD21       [get_ports "CLK_IN1_D_0_clk_p"] ;     # Bank 65 - VCCO_64_65 - IO_L11P_T1U_N8_GC_64

#set_property IOSTANDARD DIFF_SSTL12 [get_ports "CLK_IN1_D_0_clk_n"] ;     # Bank 65 - VCCO_64_65 - IO_L11N_T1U_N9_GC_64
#set_property IOSTANDARD DIFF_SSTL12 [get_ports "CLK_IN1_D_0_clk_p"] ;     # Bank 65 - VCCO_64_65 - IO_L11P_T1U_N8_GC_64

#create_clock -period 3.333 -name sys_clk_300 [get_ports clk_in1_d_clk_p];

#####################################################################################################################################################################################
## U57 PROGRAMMABLE USER CLOCK INPUT - BANK 85 - VOLTAGE 3.3V
#####################################################################################################################################################################################
#set_property PACKAGE_PIN D11        [get_ports "HD_CLK_P"] ;     # Bank 85 - VCCO_85 - IO_L8P_HDGC_85
#set_property PACKAGE_PIN D10        [get_ports "HD_CLK_N"] ;     # Bank 85 - VCCO_85 - IO_L8N_HDGC_85

#set_property IOSTANDARD LVDS_25     [get_ports "HD_CLK_P"] ;     # Bank 85 - VCCO_85 - IO_L8P_HDGC_85
#set_property IOSTANDARD LVDS_25     [get_ports "HD_CLK_N"] ;     # Bank 85 - VCCO_85 - IO_L8N_HDGC_85

#####################################################################################################################################################################################
## MAIN I2C INTERFACE - BANK 85 - VOLTAGE - 3.3V
#####################################################################################################################################################################################
#set_property PACKAGE_PIN D9         [get_ports "I2C_SCL"] ;     # Bank 85 - VCCO_85 - IO_L9P_AD11P_85
#set_property IOSTANDARD LVCMOS33    [get_ports "I2C_SDA"] ;     # Bank 85 - VCCO_85 - IO_L9N_AD11N_85

#set_property IOSTANDARD LVCMOS33    [get_ports "I2C_SCL"] ;     # Bank 85 - VCCO_85 - IO_L9P_AD11P_85
#set_property PACKAGE_PIN C9         [get_ports "I2C_SDA"] ;     # Bank 85 - VCCO_85 - IO_L9P_AD11P_85

#####################################################################################################################################################################################
## U57 PROGRAMMABLE CLOCK GENERATOR and U58 CLOCK CFG EEPROM I2C INTERFACE - BANK 85 - VOLTAGE - 3.3V
#####################################################################################################################################################################################
#set_property PACKAGE_PIN B9         [get_ports "SCL_SCLK"] ;    # Bank 85 - VCCO_85 - IO_L10P_AD10P_85
#set_property PACKAGE_PIN A9         [get_ports "SDA_nCS"] ;     # Bank 85 - VCCO_85 - IO_L10N_AD10N_85

#set_property IOSTANDARD LVCMOS33    [get_ports "SCL_SCLK"] ;    # Bank 85 - VCCO_85 - IO_L10P_AD10P_85
#set_property IOSTANDARD LVCMOS33    [get_ports "SDA_nCS"] ;     # Bank 85 - VCCO_85 - IO_L10N_AD10N_85

#####################################################################################################################################################################################
## MISC Signals - PCIe Reset Active Low / FMC TRST_L Active Low / FMC PRSNT_M2C_L / SFP1_LOS  - BANK 85 - VOLTAGE - 3.3V
#####################################################################################################################################################################################
set_property PACKAGE_PIN E11        [get_ports "PCIE_RST_N"] ;  # Bank 85 - VCCO_85 - IO_L7P_HDGC_85
#set_property PACKAGE_PIN F9         [get_ports "TRST_L"] ;      # Bank 85 - VCCO_85 - IO_L6N_HDGC_85
#set_property PACKAGE_PIN F10        [get_ports "PRSNT_M2C_L"] ; # Bank 85 - VCCO_85 - IO_L6P_HDGC_85
#set_property PACKAGE_PIN E10        [get_ports "SFP1_LOS"] ;    # Bank 85 - VCCO_85 - IO_L7N_HDGC_85

set_property IOSTANDARD LVCMOS33    [get_ports "PCIE_RST_N"]    # Bank 85 - VCCO_85 - IO_L7P_HDGC_85
#set_property IOSTANDARD LVCMOS33    [get_ports "TRST_L"] ;      # Bank 85 - VCCO_85 - IO_L6N_HDGC_85
#set_property IOSTANDARD LVCMOS33    [get_ports "PRSNT_M2C_L"]   # Bank 85 - VCCO_85 - IO_L6P_HDGC_85
#set_property IOSTANDARD LVCMOS33    [get_ports "SFP1_LOS"] ;    # Bank 85 - VCCO_85 - IO_L7N_HDGC_85

#####################################################################################################################################################################################
## MIKROE CLICK INTERFACE - BANK 85 - VOLTAGE 3.3V
#####################################################################################################################################################################################
##### MikroE Click SPI ####
#set_property PACKAGE_PIN G9         [get_ports "CLICK_SPI_MOSI"] ;      # Bank 85 - VCCO_85 - IO_L5N_HDGC_85  - CLICK SITE J20-6
#set_property PACKAGE_PIN G10        [get_ports "CLICK_SPI_MISO"] ;      # Bank 85 - VCCO_85 - IO_L5P_HDGC_85  - CLICK SITE J20-5
#set_property PACKAGE_PIN G11        [get_ports "CLICK_SPI_SCK"] ;       # Bank 85 - VCCO_85 - IO_L4N_AD12N_85 - CLICK SITE J20-4
#set_property PACKAGE_PIN H11        [get_ports "CLICK_SPI_CS0"] ;       # Bank 85 - VCCO_85 - IO_L4P_AD12P_85 - CLICK SITE J20-3
#set_property PACKAGE_PIN H9         [get_ports "CLICK_SPI_CS1_AN"] ;    # Bank 85 - VCCO_85 - IO_L3N_AD13N_85 - CLICK A/D CONVERTER U27-5

#set_property IOSTANDARD LVCMOS33    [get_ports "CLICK_SPI_MOSI"] ;      # Bank 85 - VCCO_85 - IO_L5N_HDGC_85  - CLICK SITE J20-6
#set_property IOSTANDARD LVCMOS33    [get_ports "CLICK_SPI_MISO"] ;      # Bank 85 - VCCO_85 - IO_L5P_HDGC_85  - CLICK SITE J20-5
#set_property IOSTANDARD LVCMOS33    [get_ports "CLICK_SPI_SCK"] ;       # Bank 85 - VCCO_85 - IO_L4N_AD12N_85 - CLICK SITE J20-4
#set_property IOSTANDARD LVCMOS33    [get_ports "CLICK_SPI_CS0"] ;       # Bank 85 - VCCO_85 - IO_L4P_AD12P_85 - CLICK SITE J20-3
#set_property IOSTANDARD LVCMOS33    [get_ports "CLICK_SPI_CS1_AN"] ;    # Bank 85 - VCCO_85 - IO_L3N_AD13N_85 - CLICK A/D CONVERTER U27-5

##### MikroE Click UART ####
#set_property PACKAGE_PIN J11        [get_ports "CLICK_UART_TX"] ;       # Bank 85 - VCCO_85 - IO_L2N_AD14N_85 - CLICK SITE J21-4
#set_property PACKAGE_PIN J10        [get_ports "CLICK_UART_RX"] ;       # Bank 85 - VCCO_85 - IO_L2P_AD14P_85 - CLICK SITE J21-3

#set_property IOSTANDARD LVCMOS33    [get_ports "CLICK_UART_TX"] ;       # Bank 85 - VCCO_85 - IO_L2N_AD14N_85 - CLICK SITE J21-4
#set_property IOSTANDARD LVCMOS33    [get_ports "CLICK_UART_RX"] ;       # Bank 85 - VCCO_85 - IO_L2P_AD14P_85 - CLICK SITE J21-3

##### MikroE Click Reset Output from AUBoard and Input to Click ####
#set_property PACKAGE_PIN K10        [get_ports "CLICK_RST"] ;           # Bank 85 - VCCO_85 - IO_L1P_AD15P_85 - CLICK SITE J20-2
#set_property IOSTANDARD LVCMOS33    [get_ports "CLICK_RST"] ;           # Bank 85 - VCCO_85 - IO_L1P_AD15P_85 - CLICK SITE J20-2

##### MikroE Click PWM ####
#set_property PACKAGE_PIN J9         [get_ports "CLICK_PWM"] ;           # Bank 85 - VCCO_85 - IO_L3P_AD13P_85 - CLICK SITE J21-1
#set_property IOSTANDARD LVCMOS33    [get_ports "CLICK_PWM"] ;           # Bank 85 - VCCO_85 - IO_L3P_AD13P_85 - CLICK SITE J21-1

##### MikroE Click Interrupt ####
#set_property PACKAGE_PIN K9         [get_ports "CLICK_INT"] ;           # Bank 85 - VCCO_85 - IO_L1N_AD15N_85 - CLICK SITE J21-2
#set_property IOSTANDARD LVCMOS33    [get_ports "CLICK_INT"] ;           # Bank 85 - VCCO_85 - IO_L1N_AD15N_85 - CLICK SITE J21-2

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
#set_property PACKAGE_PIN AE15       [get_ports "user_lnk_up_0"] ;    # Bank 84 - VCCO_0_84 - IO_L3N_AD9N_84  - RGB LED D35 (RED)
set_property PACKAGE_PIN AD15       [get_ports "user_lnk_up_0"] ;    # Bank 84 - VCCO_0_84 - IO_L3P_AD9P_84  - RGB LED D35 (GREEN)
#set_property PACKAGE_PIN AF13       [get_ports "LED_RGB_B1"] ;    # Bank 84 - VCCO_0_84 - IO_L2N_AD10N_84 - RGB LED D35 (BLUE)

#set_property IOSTANDARD LVCMOS18    [get_ports "user_lnk_up_0"] ;    # Bank 84 - VCCO_0_84 - IO_L3N_AD9N_84  - RGB LED D35 (RED)
set_property IOSTANDARD LVCMOS18    [get_ports "user_lnk_up_0"] ;    # Bank 84 - VCCO_0_84 - IO_L3P_AD9P_84  - RGB LED D35 (GREEN)
#set_property IOSTANDARD LVCMOS18    [get_ports "LED_RGB_B1"] ;    # Bank 84 - VCCO_0_84 - IO_L2N_AD10N_84 - RGB LED D35 (BLUE)

#####################################################################################################################################################################################
## GTHs - QUAD 226 - GTHs MAPPED TO HDMI AND SFP CONNECTOR
#####################################################################################################################################################################################
#set_property PACKAGE_PIN M1       [get_ports "HDMI_RX0_N"] ;            #  QUAD226 - MGTHRXN0_226
#set_property PACKAGE_PIN M2       [get_ports "HDMI_RX0_P"] ;            #  QUAD226 - MGTHRXP0_226

#set_property PACKAGE_PIN K1       [get_ports "HDMI_RX1_N"] ;            #  QUAD226 - MGTHRXN1_226
#set_property PACKAGE_PIN K2       [get_ports "HDMI_RX1_P"] ;            #  QUAD226 - MGTHRXP1_226

#set_property PACKAGE_PIN H1       [get_ports "HDMI_RX2_N"] ;            #  QUAD226 - MGTHRXN2_226
#set_property PACKAGE_PIN H2       [get_ports "HDMI_RX2_P"] ;            #  QUAD226 - MGTHRXP2_226

#set_property PACKAGE_PIN F1       [get_ports "rxn_0"] ;              #  QUAD226 - MGTHRXN3_226
#set_property PACKAGE_PIN F2       [get_ports "rxp_0"] ;              #  QUAD226 - MGTHRXP3_226

#set_property PACKAGE_PIN N4       [get_ports "HDMI_TX0_N"] ;            #  QUAD226 - MGTHTXN0_226
#set_property PACKAGE_PIN N5       [get_ports "HDMI_TX0_P"] ;            #  QUAD226 - MGTHTXP0_226

#set_property PACKAGE_PIN L4       [get_ports "HDMI_TX1_N"] ;            #  QUAD226 - MGTHTXN1_226
#set_property PACKAGE_PIN L5       [get_ports "HDMI_TX1_P"] ;            #  QUAD226 - MGTHTXP1_226

#set_property PACKAGE_PIN J4       [get_ports "HDMI_TX2_N"] ;            #  QUAD226 - MGTHTXN2_226
#set_property PACKAGE_PIN J5       [get_ports "HDMI_TX2_P"] ;            #  QUAD226 - MGTHTXP2_226

#set_property PACKAGE_PIN G4       [get_ports "txn_0"] ;              #  QUAD226 - MGTHTXN3_226
#set_property PACKAGE_PIN G5       [get_ports "txp_0"] ;              #  QUAD226 - MGTHTXP3_226

#set_property PACKAGE_PIN P6       [get_ports "HDMI_CLK_8T49N241_N"] ;   #  QUAD226 - MGTREFCLK0N_226
#set_property PACKAGE_PIN P7       [get_ports "HDMI_CLK_8T49N241_N"] ;   #  QUAD226 - MGTREFCLK0P_226

#set_property PACKAGE_PIN M6       [get_ports "HDMI_RCLKOUT_N"] ;        #  QUAD226 - MGTREFCLK1N_226
#set_property PACKAGE_PIN M7       [get_ports "HDMI_RCLKOUT_P"] ;        #  QUAD226 - MGTREFCLK1P_226

#####################################################################################################################################################################################
## GTHs - QUAD 225 - GTHs MAPPED TO FMC CONNECTOR
#####################################################################################################################################################################################
#set_property PACKAGE_PIN Y1       [get_ports "GTH_225_RX0_N"] ;   #  QUAD225 - MGTHRXN0_225
#set_property PACKAGE_PIN Y2       [get_ports "GTH_225_RX0_P"] ;   #  QUAD225 - MGTHRXP0_225

#set_property PACKAGE_PIN V1       [get_ports "GTH_225_RX1_N"] ;   #  QUAD225 - MGTHRXN1_225
#set_property PACKAGE_PIN V2       [get_ports "GTH_225_RX1_P"] ;   #  QUAD225 - MGTHRXP1_225

#set_property PACKAGE_PIN T1       [get_ports "GTH_225_RX2_N"] ;   #  QUAD225 - MGTHRXN2_225
#set_property PACKAGE_PIN T2       [get_ports "GTH_225_RX2_P"] ;   #  QUAD225 - MGTHRXP2_225

#set_property PACKAGE_PIN P1       [get_ports "GTH_225_RX3_N"] ;   #  QUAD225 - MGTHRXN3_225
#set_property PACKAGE_PIN P2       [get_ports "GTH_225_RX3_P"] ;   #  QUAD225 - MGTHRXP3_225

#set_property PACKAGE_PIN AA4      [get_ports "GTH_225_TX0_N"] ;   #  QUAD225 - MGTHTXN0_225
#set_property PACKAGE_PIN AA5      [get_ports "GTH_225_TX0_P"] ;   #  QUAD225 - MGTHTXP0_225

#set_property PACKAGE_PIN W4       [get_ports "GTH_225_TX1_N"] ;   #  QUAD225 - MGTHTXN1_225
#set_property PACKAGE_PIN W5       [get_ports "GTH_225_TX1_P"] ;   #  QUAD225 - MGTHTXP1_225

#set_property PACKAGE_PIN U4       [get_ports "GTH_225_TX2_N"] ;   #  QUAD225 - MGTHTXN2_225
#set_property PACKAGE_PIN U5       [get_ports "GTH_225_TX2_P"] ;   #  QUAD225 - MGTHTXP2_225

#set_property PACKAGE_PIN R4       [get_ports "GTH_225_TX3_N"] ;   #  QUAD225 - MGTHTXN3_225
#set_property PACKAGE_PIN R5       [get_ports "GTH_225_TX3_P"] ;   #  QUAD225 - MGTHTXP3_225

#set_property PACKAGE_PIN V6       [get_ports "MGTREFCLK0_N"] ;   #  QUAD225 - MGTREFCLK0N_225
#set_property PACKAGE_PIN V7       [get_ports "MGTREFCLK0_P"] ;   #  QUAD225 - MGTREFCLK0P_225

#set_property PACKAGE_PIN T6       [get_ports "MGTREFCLK1_N"] ;   #  QUAD225 - MGTREFCLK1N_225
#set_property PACKAGE_PIN T7       [get_ports "MGTREFCLK1_P"] ;   #  QUAD225 - MGTREFCLK1P_225

#####################################################################################################################################################################################
## GTHs - QUAD 224
#####################################################################################################################################################################################
set_property PACKAGE_PIN AF1      [get_ports "PCIE_RX0_N"] ;   #  QUAD224 - MGTHRXN0_224
set_property PACKAGE_PIN AF2      [get_ports "PCIE_RX0_P"] ;   #  QUAD224 - MGTHRXP0_224

#set_property PACKAGE_PIN AE3      [get_ports "PCIE_RX1_N"] ;   #  QUAD224 - MGTHRXN1_224
#set_property PACKAGE_PIN AE4      [get_ports "PCIE_RX1_P"] ;   #  QUAD224 - MGTHRXP1_224

#set_property PACKAGE_PIN AD1      [get_ports "PCIE_RX2_N"] ;   #  QUAD224 - MGTHRXN2_224
#set_property PACKAGE_PIN AD2      [get_ports "PCIE_RX2_P"] ;   #  QUAD224 - MGTHRXP2_224
#set_property PACKAGE_PIN AB1      [get_ports "PCIE_RX3_N"] ;   #  QUAD224 - MGTHRXN3_224
#set_property PACKAGE_PIN AB2      [get_ports "PCIE_RX3_P"] ;   #  QUAD224 - MGTHRXP3_224

set_property PACKAGE_PIN AF6      [get_ports "PCIE_TX0_N"] ;   #  QUAD224 - MGTHTXN0_224
set_property PACKAGE_PIN AF7      [get_ports "PCIE_TX0_P"] ;   #  QUAD224 - MGTHTXP0_224

#set_property PACKAGE_PIN AE8      [get_ports "PCIE_TX1_N"] ;   #  QUAD224 - MGTHTXN1_224
#set_property PACKAGE_PIN AE9      [get_ports "PCIE_TX1_P"] ;   #  QUAD224 - MGTHTXP1_224

#set_property PACKAGE_PIN AD6      [get_ports "PCIE_TX2_N"] ;   #  QUAD224 - MGTHTXN2_224
#set_property PACKAGE_PIN AD7      [get_ports "PCIE_TX2_P"] ;   #  QUAD224 - MGTHTXP2_224

#set_property PACKAGE_PIN AC4      [get_ports "PCIE_TX3_N"] ;   #  QUAD224 - MGTHTXN3_224
#set_property PACKAGE_PIN AC5      [get_ports "PCIE_TX3_P"] ;   #  QUAD224 - MGTHTXP3_224

set_property PACKAGE_PIN AB6      [get_ports "PCIE_REF_clk_n"] ;   #  QUAD224 - MGTREFCLK0N_224
set_property PACKAGE_PIN AB7      [get_ports "PCIE_REF_clk_p"] ;   #  QUAD224 - MGTREFCLK0P_224

#set_property PACKAGE_PIN Y6       [get_ports "GT_DIFF_REFCLK1_0_clk_n"] ;   #  QUAD224 - MGTREFCLK1N_224
#set_property PACKAGE_PIN Y7       [get_ports "GT_DIFF_REFCLK1_0_clk_p"] ;   #  QUAD224 - MGTREFCLK1P_224

#create_clock -period 3.333 -name sys_clk [get_ports SYS_DIFF_0_clk_p];
#create_clock -period 6.400 -name gt_ref_clk [get_ports GT_DIFF_REFCLK1_0_clk_p];

#set_property C_CLK_INPUT_FREQ_HZ 156250000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]