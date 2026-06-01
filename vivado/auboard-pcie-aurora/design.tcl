
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2024.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# led_test

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcau15p-ffvb676-2-e
   set_property BOARD_PART avnet-tria:auboard_15p:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:xdma:4.1\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:aurora_8b10b:11.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:ddr4:2.2\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:axis_data_fifo:2.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
led_test\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set PCIE_REF [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 PCIE_REF ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $PCIE_REF

  set GT_DIFF_REFCLK1_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 GT_DIFF_REFCLK1_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
   ] $GT_DIFF_REFCLK1_0

  set ddr4_sdram [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_sdram ]

  set system_clock_300mhz [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 system_clock_300mhz ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $system_clock_300mhz


  # Create ports
  set PCIE_RST_N [ create_bd_port -dir I -type rst PCIE_RST_N ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $PCIE_RST_N
  set led_0 [ create_bd_port -dir O -from 3 -to 0 led_0 ]
  set PCIE_RX0_N [ create_bd_port -dir I -from 0 -to 0 PCIE_RX0_N ]
  set PCIE_RX0_P [ create_bd_port -dir I -from 0 -to 0 PCIE_RX0_P ]
  set PCIE_TX0_N [ create_bd_port -dir O -from 0 -to 0 PCIE_TX0_N ]
  set PCIE_TX0_P [ create_bd_port -dir O -from 0 -to 0 PCIE_TX0_P ]
  set user_lnk_up_0 [ create_bd_port -dir O user_lnk_up_0 ]
  set channel_up_0 [ create_bd_port -dir O channel_up_0 ]
  set rxn_0 [ create_bd_port -dir I -from 0 -to 0 rxn_0 ]
  set rxp_0 [ create_bd_port -dir I -from 0 -to 0 rxp_0 ]
  set txn_0 [ create_bd_port -dir O -from 0 -to 0 txn_0 ]
  set txp_0 [ create_bd_port -dir O -from 0 -to 0 txp_0 ]
  set phy_reset_out [ create_bd_port -dir I -type rst phy_reset_out ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $phy_reset_out

  # Create instance: xdma_0, and set properties
  set xdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_0 ]
  set_property -dict [list \
    CONFIG.PCIE_BOARD_INTERFACE {pci_express_x1} \
    CONFIG.SYS_RST_N_BOARD_INTERFACE {pcie_perstn} \
    CONFIG.axi_data_width {128_bit} \
    CONFIG.axil_master_64bit_en {true} \
    CONFIG.axilite_master_en {true} \
    CONFIG.axilite_master_size {256} \
    CONFIG.axist_bypass_en {false} \
    CONFIG.axisten_freq {125} \
    CONFIG.cfg_mgmt_if {false} \
    CONFIG.disable_gt_loc {false} \
    CONFIG.en_ext_ch_gt_drp {false} \
    CONFIG.en_pcie_drp {false} \
    CONFIG.functional_mode {DMA} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.parity_settings {None} \
    CONFIG.pcie_id_if {false} \
    CONFIG.pl_link_cap_max_link_speed {16.0_GT/s} \
    CONFIG.xdma_axi_intf_mm {AXI_Memory_Mapped} \
    CONFIG.xdma_axilite_slave {false} \
    CONFIG.xdma_rnum_chnl {1} \
    CONFIG.xdma_wnum_chnl {1} \
    CONFIG.xdma_wnum_rids {32} \
  ] $xdma_0


  # Create instance: util_ds_buf, and set properties
  set util_ds_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf ]
  set_property -dict [list \
    CONFIG.DIFF_CLK_IN_BOARD_INTERFACE {pcie_ref_clk_100MHz} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $util_ds_buf


  # Create instance: led_test_0, and set properties
  set block_name led_test
  set block_cell_name led_test_0
  if { [catch {set led_test_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $led_test_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: aurora_8b10b_0, and set properties
  set aurora_8b10b_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:aurora_8b10b:11.1 aurora_8b10b_0 ]
  set_property -dict [list \
    CONFIG.C_DRP_IF {false} \
    CONFIG.C_LANE_WIDTH {4} \
    CONFIG.C_LINE_RATE {6.25} \
    CONFIG.C_REFCLK_FREQUENCY {156.25} \
    CONFIG.C_REFCLK_SOURCE {MGTREFCLK1 of Quad X0Y2} \
    CONFIG.C_START_LANE {X0Y11} \
    CONFIG.C_START_QUAD {Quad_X0Y2} \
    CONFIG.C_USE_BYTESWAP {true} \
    CONFIG.SupportLevel {1} \
  ] $aurora_8b10b_0


  # Create instance: rst_design_1_156M, and set properties
  set rst_design_1_156M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_design_1_156M ]

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [list \
    CONFIG.c_addr_width {32} \
    CONFIG.c_include_mm2s {1} \
    CONFIG.c_include_s2mm {1} \
    CONFIG.c_include_sg {1} \
    CONFIG.c_m_axi_mm2s_data_width {32} \
    CONFIG.c_m_axi_s2mm_data_width {32} \
    CONFIG.c_m_axis_mm2s_tdata_width {32} \
    CONFIG.c_mm2s_burst_size {8} \
    CONFIG.c_s2mm_burst_size {8} \
    CONFIG.c_s_axis_s2mm_tdata_width {32} \
    CONFIG.c_sg_include_stscntrl_strm {0} \
    CONFIG.c_sg_length_width {26} \
  ] $axi_dma_0


  # Create instance: ddr4_0, and set properties
  set ddr4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_0 ]
  set_property -dict [list \
    CONFIG.C0_CLOCK_BOARD_INTERFACE {system_clock_300mhz} \
    CONFIG.C0_DDR4_BOARD_INTERFACE {ddr4_sdram} \
    CONFIG.RESET_BOARD_INTERFACE {phy_reset_out} \
  ] $ddr4_0


  # Create instance: phy_reset_out_inv_0, and set properties
  set phy_reset_out_inv_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 phy_reset_out_inv_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $phy_reset_out_inv_0


  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {2} \
    CONFIG.NUM_SI {4} \
  ] $smartconnect_1


  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property CONFIG.NUM_SI {1} $smartconnect_0


  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.C_ADV_TRIGGER {false} \
    CONFIG.C_DATA_DEPTH {1024} \
    CONFIG.C_EN_STRG_QUAL {0} \
    CONFIG.C_MON_TYPE {INTERFACE} \
    CONFIG.C_NUM_MONITOR_SLOTS {1} \
    CONFIG.C_SLOT {0} \
    CONFIG.C_SLOT_0_APC_EN {0} \
    CONFIG.C_SLOT_0_AXI_DATA_SEL {1} \
    CONFIG.C_SLOT_0_AXI_TRIG_SEL {1} \
    CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
    CONFIG.C_SLOT_1_APC_EN {0} \
    CONFIG.C_SLOT_1_AXI_DATA_SEL {1} \
    CONFIG.C_SLOT_1_AXI_TRIG_SEL {1} \
    CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
    CONFIG.C_TRIGOUT_EN {false} \
  ] $system_ila_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property CONFIG.C_OPERATION {not} $util_vector_logic_1


  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]
  set_property -dict [list \
    CONFIG.C_ADV_TRIGGER {false} \
    CONFIG.C_DATA_DEPTH {1024} \
    CONFIG.C_MON_TYPE {INTERFACE} \
    CONFIG.C_NUM_MONITOR_SLOTS {1} \
    CONFIG.C_SLOT_0_APC_EN {0} \
    CONFIG.C_SLOT_0_AXI_DATA_SEL {1} \
    CONFIG.C_SLOT_0_AXI_TRIG_SEL {1} \
    CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
    CONFIG.C_TRIGIN_EN {false} \
  ] $system_ila_1


  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {8192} \
    CONFIG.FIFO_MODE {1} \
    CONFIG.IS_ACLK_ASYNC {1} \
    CONFIG.SYNCHRONIZATION_STAGES {3} \
  ] $axis_data_fifo_0


  # Create instance: axis_data_fifo_1, and set properties
  set axis_data_fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_1 ]
  set_property -dict [list \
    CONFIG.FIFO_DEPTH {8192} \
    CONFIG.FIFO_MODE {1} \
    CONFIG.IS_ACLK_ASYNC {1} \
    CONFIG.SYNCHRONIZATION_STAGES {3} \
  ] $axis_data_fifo_1


  # Create instance: system_ila_2, and set properties
  set system_ila_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_2 ]
  set_property -dict [list \
    CONFIG.C_DATA_DEPTH {1024} \
    CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
  ] $system_ila_2


  # Create instance: system_ila_3, and set properties
  set system_ila_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_3 ]
  set_property CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} $system_ila_3


  # Create interface connections
  connect_bd_intf_net -intf_net GT_DIFF_REFCLK1_0_1 [get_bd_intf_ports GT_DIFF_REFCLK1_0] [get_bd_intf_pins aurora_8b10b_0/GT_DIFF_REFCLK1]
  connect_bd_intf_net -intf_net aurora_8b10b_0_USER_DATA_M_AXI_RX [get_bd_intf_pins aurora_8b10b_0/USER_DATA_M_AXI_RX] [get_bd_intf_pins axis_data_fifo_1/S_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets aurora_8b10b_0_USER_DATA_M_AXI_RX] [get_bd_intf_pins aurora_8b10b_0/USER_DATA_M_AXI_RX] [get_bd_intf_pins system_ila_3/SLOT_0_AXIS]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_dma_0_M_AXIS_MM2S] [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axi_dma_0_M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins smartconnect_1/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins smartconnect_1/S03_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_SG [get_bd_intf_pins axi_dma_0/M_AXI_SG] [get_bd_intf_pins smartconnect_1/S02_AXI]
  connect_bd_intf_net -intf_net axis_fifo_0_M_AXIS [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins aurora_8b10b_0/USER_DATA_S_AXI_TX]
connect_bd_intf_net -intf_net [get_bd_intf_nets axis_fifo_0_M_AXIS] [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins system_ila_1/SLOT_0_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets axis_fifo_0_M_AXIS]
  connect_bd_intf_net -intf_net axis_fifo_1_M_AXIS [get_bd_intf_pins axis_data_fifo_1/M_AXIS] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
connect_bd_intf_net -intf_net [get_bd_intf_nets axis_fifo_1_M_AXIS] [get_bd_intf_pins axis_data_fifo_1/M_AXIS] [get_bd_intf_pins system_ila_2/SLOT_0_AXIS]
  connect_bd_intf_net -intf_net ddr4_0_C0_DDR4 [get_bd_intf_ports ddr4_sdram] [get_bd_intf_pins ddr4_0/C0_DDR4]
  connect_bd_intf_net -intf_net pcie_ref_clk_100MHz_1 [get_bd_intf_ports PCIE_REF] [get_bd_intf_pins util_ds_buf/CLK_IN_D]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins smartconnect_1/M00_AXI] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI]
  connect_bd_intf_net -intf_net system_clock_300mhz_1 [get_bd_intf_ports system_clock_300mhz] [get_bd_intf_pins ddr4_0/C0_SYS_CLK]
  connect_bd_intf_net -intf_net xdma_0_M_AXI [get_bd_intf_pins xdma_0/M_AXI] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net xdma_0_M_AXI_LITE [get_bd_intf_pins xdma_0/M_AXI_LITE] [get_bd_intf_pins smartconnect_0/S00_AXI]

  # Create port connections
  connect_bd_net -net aurora_8b10b_0_channel_up  [get_bd_pins aurora_8b10b_0/channel_up] \
  [get_bd_ports channel_up_0]
  connect_bd_net -net aurora_8b10b_0_sys_reset_out  [get_bd_pins aurora_8b10b_0/sys_reset_out] \
  [get_bd_pins rst_design_1_156M/ext_reset_in]
  connect_bd_net -net aurora_8b10b_0_txn  [get_bd_pins aurora_8b10b_0/txn] \
  [get_bd_ports txn_0]
  connect_bd_net -net aurora_8b10b_0_txp  [get_bd_pins aurora_8b10b_0/txp] \
  [get_bd_ports txp_0]
  connect_bd_net -net aurora_8b10b_0_user_clk_out  [get_bd_pins aurora_8b10b_0/user_clk_out] \
  [get_bd_pins rst_design_1_156M/slowest_sync_clk] \
  [get_bd_pins system_ila_1/clk] \
  [get_bd_pins axis_data_fifo_0/m_axis_aclk] \
  [get_bd_pins axis_data_fifo_1/s_axis_aclk] \
  [get_bd_pins system_ila_3/clk]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk  [get_bd_pins ddr4_0/c0_ddr4_ui_clk] \
  [get_bd_pins smartconnect_1/aclk1] \
  [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk_sync_rst  [get_bd_pins ddr4_0/c0_ddr4_ui_clk_sync_rst] \
  [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net led_test_0_led  [get_bd_pins led_test_0/led] \
  [get_bd_ports led_0]
  connect_bd_net -net pci_exp_rxn_0_1  [get_bd_ports PCIE_RX0_N] \
  [get_bd_pins xdma_0/pci_exp_rxn]
  connect_bd_net -net pci_exp_rxp_0_1  [get_bd_ports PCIE_RX0_P] \
  [get_bd_pins xdma_0/pci_exp_rxp]
  connect_bd_net -net pcie_perstn_1  [get_bd_ports PCIE_RST_N] \
  [get_bd_pins xdma_0/sys_rst_n]
  connect_bd_net -net phy_reset_out_1  [get_bd_ports phy_reset_out] \
  [get_bd_pins phy_reset_out_inv_0/Op1]
  connect_bd_net -net phy_reset_out_inv_0_Res  [get_bd_pins phy_reset_out_inv_0/Res] \
  [get_bd_pins ddr4_0/sys_rst]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn  [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
  [get_bd_pins led_test_0/reset_n] \
  [get_bd_pins smartconnect_0/aresetn] \
  [get_bd_pins system_ila_0/resetn] \
  [get_bd_pins axi_dma_0/axi_resetn] \
  [get_bd_pins smartconnect_1/aresetn] \
  [get_bd_pins axis_data_fifo_0/s_axis_aresetn] \
  [get_bd_pins system_ila_2/resetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset  [get_bd_pins proc_sys_reset_0/peripheral_reset] \
  [get_bd_pins aurora_8b10b_0/gt_reset] \
  [get_bd_pins aurora_8b10b_0/reset]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn  [get_bd_pins proc_sys_reset_1/peripheral_aresetn] \
  [get_bd_pins ddr4_0/c0_ddr4_aresetn]
  connect_bd_net -net rst_design_1_156M_peripheral_aresetn  [get_bd_pins rst_design_1_156M/peripheral_aresetn] \
  [get_bd_pins system_ila_1/resetn] \
  [get_bd_pins axis_data_fifo_1/s_axis_aresetn] \
  [get_bd_pins system_ila_3/resetn]
  connect_bd_net -net rxn_0_1  [get_bd_ports rxn_0] \
  [get_bd_pins aurora_8b10b_0/rxn]
  connect_bd_net -net rxp_0_1  [get_bd_ports rxp_0] \
  [get_bd_pins aurora_8b10b_0/rxp]
  connect_bd_net -net util_ds_buf_IBUF_DS_ODIV2  [get_bd_pins util_ds_buf/IBUF_DS_ODIV2] \
  [get_bd_pins xdma_0/sys_clk]
  connect_bd_net -net util_ds_buf_IBUF_OUT  [get_bd_pins util_ds_buf/IBUF_OUT] \
  [get_bd_pins xdma_0/sys_clk_gt]
  connect_bd_net -net util_vector_logic_1_Res  [get_bd_pins util_vector_logic_1/Res] \
  [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net xdma_0_axi_aclk  [get_bd_pins xdma_0/axi_aclk] \
  [get_bd_pins led_test_0/clk] \
  [get_bd_pins axi_dma_0/s_axi_lite_aclk] \
  [get_bd_pins axi_dma_0/m_axi_sg_aclk] \
  [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] \
  [get_bd_pins smartconnect_1/aclk] \
  [get_bd_pins smartconnect_0/aclk] \
  [get_bd_pins system_ila_0/clk] \
  [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] \
  [get_bd_pins proc_sys_reset_0/slowest_sync_clk] \
  [get_bd_pins aurora_8b10b_0/init_clk_in] \
  [get_bd_pins axis_data_fifo_0/s_axis_aclk] \
  [get_bd_pins axis_data_fifo_1/m_axis_aclk] \
  [get_bd_pins system_ila_2/clk]
  connect_bd_net -net xdma_0_axi_aresetn  [get_bd_pins xdma_0/axi_aresetn] \
  [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net xdma_0_pci_exp_txn  [get_bd_pins xdma_0/pci_exp_txn] \
  [get_bd_ports PCIE_TX0_N]
  connect_bd_net -net xdma_0_pci_exp_txp  [get_bd_pins xdma_0/pci_exp_txp] \
  [get_bd_ports PCIE_TX0_P]
  connect_bd_net -net xdma_0_user_lnk_up  [get_bd_pins xdma_0/user_lnk_up] \
  [get_bd_ports user_lnk_up_0]

  # Create address segments
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x00020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_LITE] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_SG] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


