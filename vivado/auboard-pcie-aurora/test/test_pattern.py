import os
import mmap
import struct
import time

# ============================================================
# CONFIG
# ============================================================

DMA_BASE = 0x00020000

TX_DESC_ADDR = 0x80000000
RX_DESC_ADDR = 0x80010000

TX_BUF_ADDR  = 0x81000000
RX_BUF_ADDR  = 0x82000000

CHUNK_SIZE = 1024 * 1024
#CHUNK_SIZE = 1024
# ============================================================
# AXI DMA REGISTERS
# ============================================================

MM2S_DMACR    = 0x00
MM2S_DMASR    = 0x04
MM2S_CURDESC  = 0x08
MM2S_TAILDESC = 0x10

S2MM_DMACR    = 0x30
S2MM_DMASR    = 0x34
S2MM_CURDESC  = 0x38
S2MM_TAILDESC = 0x40

# ============================================================
# OPEN XDMA DEVICES
# ============================================================

fd_user = os.open("/dev/xdma0_user", os.O_RDWR | os.O_SYNC)
fd_h2c  = os.open("/dev/xdma0_h2c_0", os.O_RDWR | os.O_SYNC)
fd_c2h  = os.open("/dev/xdma0_c2h_0", os.O_RDWR | os.O_SYNC)

# ============================================================
# MAP DMA REGS
# ============================================================

regs = mmap.mmap(
    fd_user,
    0x10000,
    mmap.MAP_SHARED,
    mmap.PROT_READ | mmap.PROT_WRITE,
    offset=DMA_BASE
)

def reg_write(offset, value):

    regs[offset:offset+4] = struct.pack("<I", value)

def reg_read(offset):

    return struct.unpack("<I", regs[offset:offset+4])[0]

# ============================================================
# DMA RESET
# ============================================================

def dma_reset():

    reg_write(MM2S_DMACR, 0x4)
    reg_write(S2MM_DMACR, 0x4)

    time.sleep(0.1)

    reg_write(MM2S_DMASR, 0xFFFFFFFF)
    reg_write(S2MM_DMASR, 0xFFFFFFFF)

# ============================================================
# WAIT
# ============================================================

def wait_mm2s():

    while True:

        status = reg_read(MM2S_DMASR)

        print(f"MM2S STATUS : 0x{status:08X}")

        if status & 0x770:
            raise RuntimeError("MM2S ERROR")

        if (status >> 1) & 1:
            break

        time.sleep(0.1)

def wait_s2mm():

    while True:

        status = reg_read(S2MM_DMASR)

        print(f"S2MM STATUS : 0x{status:08X}")

        if status & 0x770:
            raise RuntimeError("S2MM ERROR")

        if (status >> 1) & 1:
            break

        time.sleep(0.1)

# ============================================================
# CREATE TEST PATTERN
# ============================================================

# 0x00, 0x01, 0x02, ..., 0xFF 까지 반복되는 카운터 패턴
tx_data = bytearray()

# CHUNK_SIZE 만큼 증가하는 데이터를 생성
for i in range(CHUNK_SIZE):
    # 0~255 사이의 값을 순차적으로 저장
    tx_data.append(i % 256)

print(f"TX SIZE : {len(tx_data)}")

# ============================================================
# WRITE TX BUFFER
# ============================================================

os.lseek(fd_h2c, TX_BUF_ADDR, os.SEEK_SET)

written = os.write(fd_h2c, tx_data)

print(f"TX WRITE : {written}")

# ============================================================
# BUILD MM2S BD
# ============================================================

mm2s_bd = bytearray(64)

# next desc
struct.pack_into("<I", mm2s_bd, 0x00, 0)
struct.pack_into("<I", mm2s_bd, 0x04, 0)

# buffer addr
struct.pack_into("<I", mm2s_bd, 0x08, TX_BUF_ADDR)
struct.pack_into("<I", mm2s_bd, 0x0C, 0)

# control
control = len(tx_data)

control |= (1 << 27)  # SOF
control |= (1 << 26)  # EOF

struct.pack_into("<I", mm2s_bd, 0x18, control)

# ============================================================
# BUILD S2MM BD
# ============================================================

s2mm_bd = bytearray(64)

# next desc
struct.pack_into("<I", s2mm_bd, 0x00, 0)
struct.pack_into("<I", s2mm_bd, 0x04, 0)

# buffer addr
struct.pack_into("<I", s2mm_bd, 0x08, RX_BUF_ADDR)
struct.pack_into("<I", s2mm_bd, 0x0C, 0)

# control
struct.pack_into("<I", s2mm_bd, 0x18, len(tx_data))

# ============================================================
# WRITE DESCRIPTORS
# ============================================================

os.lseek(fd_h2c, TX_DESC_ADDR, os.SEEK_SET)
os.write(fd_h2c, mm2s_bd)

os.lseek(fd_h2c, RX_DESC_ADDR, os.SEEK_SET)
os.write(fd_h2c, s2mm_bd)

print("Descriptors written")

# ============================================================
# RESET DMA
# ============================================================

dma_reset()

# ============================================================
# START S2MM FIRST
# ============================================================

reg_write(S2MM_CURDESC + 0, RX_DESC_ADDR)
reg_write(S2MM_CURDESC + 4, 0)

reg_write(S2MM_DMACR, 0x1001)

reg_write(S2MM_TAILDESC + 0, RX_DESC_ADDR)
reg_write(S2MM_TAILDESC + 4, 0)

print("S2MM STARTED")

# ============================================================
# START MM2S
# ============================================================

reg_write(MM2S_CURDESC + 0, TX_DESC_ADDR)
reg_write(MM2S_CURDESC + 4, 0)

reg_write(MM2S_DMACR, 0x1001)

reg_write(MM2S_TAILDESC + 0, TX_DESC_ADDR)
reg_write(MM2S_TAILDESC + 4, 0)

print("MM2S STARTED")

# ============================================================
# WAIT COMPLETE
# ============================================================

wait_mm2s()
print("MM2S COMPLETE")

wait_s2mm()
print("S2MM COMPLETE")

# ============================================================
# READ RX BUFFER
# ============================================================

os.lseek(fd_c2h, RX_BUF_ADDR, os.SEEK_SET)

rx_data = os.read(fd_c2h, len(tx_data))

print(f"RX SIZE : {len(rx_data)}")

# ============================================================
# SAVE RX
# ============================================================

with open("output.bin", "wb") as f:

    f.write(rx_data)

print("output.bin saved")

# ============================================================
# COMPARE
# ============================================================

print("")
print("COMPARE START")
print("")

mismatch = False

for i in range(len(tx_data)):

    if tx_data[i] != rx_data[i]:

        mismatch = True

        print(f"MISMATCH @ {i}")
        print(f"TX : 0x{tx_data[i]:02X}")
        print(f"RX : 0x{rx_data[i]:02X}")

        #
        # 주변 데이터 dump
        #

        start = max(0, i - 16)
        end   = min(len(tx_data), i + 16)

        print("")
        print("TX DUMP")

        for j in range(start, end):

            print(f"{tx_data[j]:02X}", end=" ")

        print("")
        print("")

        print("RX DUMP")

        for j in range(start, end):

            print(f"{rx_data[j]:02X}", end=" ")

        print("")
        print("")

        break

if not mismatch:

    print("===================================")
    print("AURORA LOOPBACK PASS")
    print("===================================")

# ============================================================
# CLOSE
# ============================================================

regs.close()

os.close(fd_user)
os.close(fd_h2c)
os.close(fd_c2h)
