import os
import mmap
import struct
import time
import hashlib

# ============================================================
# CONFIG
# ============================================================

DMA_BASE = 0x00020000
DESC_BASE    = 0x80000000

TX_BUF_BASE  = 0x81000000
RX_BUF_BASE  = 0x86000000

FILE_CHUNK_SIZE = 64 * 1024 * 1024
DMA_CHUNK_SIZE = 4 * 1024 * 1024

BD_SIZE = 64


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
# DESCRIPTOR MEMORY MAP
# ============================================================

MM2S_BD_BASE = DESC_BASE
S2MM_BD_BASE = DESC_BASE + 0x200000

# ============================================================
# OPEN DEVICES
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

# ============================================================
# REGISTER ACCESS
# ============================================================

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
# WAIT COMPLETE
# ============================================================

def wait_mm2s():
    while True:
        status = reg_read(MM2S_DMASR)

        print(f"MM2S STATUS : 0x{status:08X}")

        if status & 0x770:
            raise RuntimeError(
                f"MM2S ERROR : 0x{status:08X}"
            )
        #
        # IOC_Irq
        #

        if status & (1 << 12):
            break

        time.sleep(0.01)

def wait_s2mm():
    while True:
        status = reg_read(S2MM_DMASR)

        print(f"S2MM STATUS : 0x{status:08X}")

        if status & 0x770:
            raise RuntimeError(
                f"S2MM ERROR : 0x{status:08X}"
            )

        #
        # IOC_Irq
        #

        if status & (1 << 12):
            break

        time.sleep(0.01)

# ============================================================
# CREATE TEST DATA
# ============================================================

INPUT_FILE  = "sample.jpeg"
OUTPUT_FILE = "output.jpeg"

fin = open(INPUT_FILE, "rb")
fout = open(OUTPUT_FILE, "wb")

while True:
    tx_data = fin.read(FILE_CHUNK_SIZE)

    if len(tx_data) == 0:
        break

    TOTAL_SIZE = len(tx_data)
    NUM_BD = (TOTAL_SIZE + DMA_CHUNK_SIZE -1) // DMA_CHUNK_SIZE

    print("")
    print("==============================")
    print(f"TRANSFER SIZE : {TOTAL_SIZE}")
    print(f"NUM_BD        : {NUM_BD}")
    print("==============================")

    # ============================================================
    # WRITE TX BUFFER
    # ============================================================

    os.lseek(fd_h2c, TX_BUF_BASE, os.SEEK_SET)
    written = os.write(fd_h2c, tx_data)
    print(f"TX WRITE : {written}")

    # ============================================================
    # BUILD MM2S DESCRIPTORS
    # ============================================================

    for i in range(NUM_BD):
        bd = bytearray(BD_SIZE)
        bd_addr = MM2S_BD_BASE + (i * BD_SIZE)

        # next descriptor
        if i == (NUM_BD - 1):
            next_bd = 0
        else:
            next_bd = bd_addr + BD_SIZE

        struct.pack_into("<I", bd, 0x00, next_bd)
        struct.pack_into("<I", bd, 0x04, 0)


        # buffer address
        buf_addr = TX_BUF_BASE + (i * DMA_CHUNK_SIZE)

        struct.pack_into("<I", bd, 0x08, buf_addr)
        struct.pack_into("<I", bd, 0x0C, 0)

        # control
        remain = TOTAL_SIZE - (i * DMA_CHUNK_SIZE)
        length = min(DMA_CHUNK_SIZE, remain)
        control = length

        # SOF only first BD

        if i == 0:
            control |= (1 << 27)

        # EOF only last BD
        if i == (NUM_BD - 1):
            control |= (1 << 26)

        struct.pack_into("<I", bd, 0x18, control)

        # write descriptor

        os.lseek(fd_h2c, bd_addr, os.SEEK_SET)
        os.write(fd_h2c, bd)

    # ============================================================
    # BUILD S2MM DESCRIPTORS
    # ============================================================

    for i in range(NUM_BD):
        bd = bytearray(BD_SIZE)
        bd_addr = S2MM_BD_BASE + (i * BD_SIZE)

        # next descriptor

        if i == (NUM_BD - 1):
            next_bd = 0
        else:
            next_bd = bd_addr + BD_SIZE

        struct.pack_into("<I", bd, 0x00, next_bd)
        struct.pack_into("<I", bd, 0x04, 0)

        # buffer address
        buf_addr = RX_BUF_BASE + (i * DMA_CHUNK_SIZE)

        struct.pack_into("<I", bd, 0x08, buf_addr)
        struct.pack_into("<I", bd, 0x0C, 0)

        # receive length
        remain = TOTAL_SIZE - (i * DMA_CHUNK_SIZE)
        length = min(DMA_CHUNK_SIZE, remain)
        struct.pack_into("<I", bd, 0x18, length)

        # write descriptor
        os.lseek(fd_h2c, bd_addr, os.SEEK_SET)
        os.write(fd_h2c, bd)

    print("Descriptors written")

    # ============================================================
    # RESET DMA
    # ============================================================

    dma_reset()

    # ============================================================
    # START S2MM FIRST
    # ============================================================

    reg_write(S2MM_CURDESC + 0, S2MM_BD_BASE)
    reg_write(S2MM_CURDESC + 4, 0)

    reg_write(S2MM_DMACR, 0x1001)

    last_s2mm_bd = S2MM_BD_BASE + ((NUM_BD - 1) * BD_SIZE)

    reg_write(S2MM_TAILDESC + 0, last_s2mm_bd)
    reg_write(S2MM_TAILDESC + 4, 0)

    print("S2MM STARTED")

    # ============================================================
    # START MM2S
    # ============================================================

    reg_write(MM2S_CURDESC + 0, MM2S_BD_BASE)
    reg_write(MM2S_CURDESC + 4, 0)

    reg_write(MM2S_DMACR, 0x1001)

    last_mm2s_bd = MM2S_BD_BASE + ((NUM_BD - 1) * BD_SIZE)

    reg_write(MM2S_TAILDESC + 0, last_mm2s_bd)
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

    os.lseek(fd_c2h, RX_BUF_BASE, os.SEEK_SET)

    rx_data = os.read(fd_c2h, TOTAL_SIZE)

    print(f"RX SIZE : {len(rx_data)}")

    # ============================================================
    # SAVE OUTPUT
    # ============================================================
    fout.write(rx_data)

    print(f"Chunk received : {len(rx_data)} bytes")

print("output.bin saved")

fin.close()
fout.close()

# ============================================================
# COMPARE
# ============================================================

print("")
print("COMPARE START")
print("")

def md5_file(fname):
    md5 = hashlib.md5()

    with open(fname, "rb") as f:

        while True:
            data = f.read(1024*1024)

            if not data:
                break

            md5.update(data)

    return md5.hexdigest()

tx_md5 = md5_file(INPUT_FILE)
rx_md5 = md5_file(OUTPUT_FILE)

print("TX MD5 :", tx_md5)
print("RX MD5 :", rx_md5)

if tx_md5 == rx_md5:
    print("")
    print("===================================")
    print("AURORA LOOPBACK PASS")
    print("===================================")
else:
    print("")
    print("===================================")
    print("AURORA LOOPBACK FAIL")
    print("===================================")

# ============================================================
# CLOSE
# ============================================================

regs.close()

os.close(fd_user)
os.close(fd_h2c)
os.close(fd_c2h)
