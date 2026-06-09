/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */
#include <stdio.h>
#include "xaxivdma.h"
#include "xparameters.h"
#include "xil_cache.h"
#include "xil_printf.h"
#include "xvtc.h"
#include "font8x8_basic.h"

#define FRAME_BUFFER_BASE 0x10000000

#define WIDTH   1280
#define HEIGHT  720
#define BYTES_PER_PIXEL 3

XAxiVdma vdma;
XVtc vtc;

u8 *frame = (u8 *)FRAME_BUFFER_BASE;

const uint8_t font_A[8] =
{
    0x3C,
    0x66,
    0xC3,
    0xC3,
    0xFF,
    0xC3,
    0xC3,
    0x00
};

void PutPixel(int x, int y,
              uint8_t r,
              uint8_t g,
              uint8_t b)
{
    int idx = (y * WIDTH + x) * 3;

    frame[idx + 0] = r;
    frame[idx + 1] = g;
    frame[idx + 2] = b;
}

void FillRect(int x,
              int y,
              int w,
              int h,
              uint8_t r,
              uint8_t g,
              uint8_t b)
{
    int xx, yy;

    for(yy = 0; yy < h; yy++)
    {
        for(xx = 0; xx < w; xx++)
        {
            PutPixel(x + xx,
                     y + yy,
                     r,g,b);
        }
    }
}

void DrawCharScaled(int startX,
                    int startY,
                    char c,
                    int scale)
{
    int row, col;

    for(row = 0; row < 8; row++)
    {
        uint8_t bits =
            font8x8_basic[(int)c][row];

        for(col = 0; col < 8; col++)
        {
            if(bits & (1 << col))
            {
                FillRect(
                    startX + col * scale,
                    startY + row * scale,
                    scale,
                    scale,
                    255,255,255
                );
            }
        }
    }
}

void DrawStringScaled(int x,
                      int y,
                      char *str,
                      int scale)
{
    while(*str)
    {
        DrawCharScaled(
            x,
            y,
            *str,
            scale
        );

        x += 8 * scale;

        str++;
    }
}

// void DrawChar(int x, int y, char c)
// {
//     int row, col;

//     for(row = 0; row < 8; row++)
//     {
//         uint8_t bits = font8x8_basic[(int)c][row];

//         for(col = 0; col < 8; col++)
//         {
//             if(bits & (1 << col))
//             {
//                 PutPixel(x + col,
//                          y + row,
//                          255,255,255);
//             }
//         }
//     }
// }

// void DrawString(int x, int y, char *str)
// {
//     while(*str)
//     {
//         DrawChar(x, y, *str);

//         x += 8;

//         str++;
//     }
// }

void FillFrame()
{
    int i;

    // black background
    for(i = 0; i < WIDTH * HEIGHT * 3; i++)
        frame[i] = 0;

    // DrawString(100,100,"HELLO FPGA");
    DrawStringScaled(100,100,"SCWOOK",1);
    DrawStringScaled(200,200,"Hello",2);
    DrawStringScaled(300,300,"FPGA",4);

    Xil_DCacheFlush();
}

int SetupVdma()
{
    XAxiVdma_Config *cfg;
    XAxiVdma_DmaSetup dmaCfg;

    cfg = XAxiVdma_LookupConfig(XPAR_AXI_VDMA_0_BASEADDR);

    if(!cfg)
        return XST_FAILURE;

    if(XAxiVdma_CfgInitialize(&vdma, cfg,
        cfg->BaseAddress) != XST_SUCCESS)
        return XST_FAILURE;

    memset(&dmaCfg, 0, sizeof(dmaCfg));

    dmaCfg.VertSizeInput = HEIGHT;
    dmaCfg.HoriSizeInput = WIDTH * BYTES_PER_PIXEL;
    dmaCfg.Stride = WIDTH * BYTES_PER_PIXEL;

    dmaCfg.FrameDelay = 0;
    dmaCfg.EnableCircularBuf = 1;
    dmaCfg.EnableSync = 0;
    dmaCfg.PointNum = 0;
    dmaCfg.EnableFrameCounter = 0;
    dmaCfg.FixedFrameStoreAddr = 0;

    if(XAxiVdma_DmaConfig(&vdma,
        XAXIVDMA_READ,
        &dmaCfg) != XST_SUCCESS)
        return XST_FAILURE;

    UINTPTR addr = FRAME_BUFFER_BASE;

    if(XAxiVdma_DmaSetBufferAddr(&vdma,
        XAXIVDMA_READ,
        &addr) != XST_SUCCESS)
        return XST_FAILURE;

    if(XAxiVdma_DmaStart(&vdma,
        XAXIVDMA_READ) != XST_SUCCESS)
        return XST_FAILURE;

    return XST_SUCCESS;
}

int SetupVtc()
{
    XVtc_Config *cfg;
    XVtc_Timing timing;

    cfg = XVtc_LookupConfig(XPAR_V_TC_0_BASEADDR);

    if(!cfg)
        return XST_FAILURE;

    XVtc_CfgInitialize(&vtc, cfg, cfg->BaseAddress);

    timing.HActiveVideo = 1280;
    timing.HFrontPorch  = 110;
    timing.HSyncWidth   = 40;
    timing.HBackPorch   = 220;
    timing.HSyncPolarity = 1;

    timing.VActiveVideo = 720;
    timing.V0FrontPorch = 5;
    timing.V0SyncWidth  = 5;
    timing.V0BackPorch  = 20;
    timing.VSyncPolarity = 1;

    timing.Interlaced = 0;

    XVtc_SetGeneratorTiming(&vtc, &timing);

    XVtc_EnableGenerator(&vtc);

    return XST_SUCCESS;
}

int main()
{
    xil_printf("HDMI Test Start\r\n");

    FillFrame();

    if(SetupVtc() != XST_SUCCESS)
    {
        xil_printf("VTC failed\r\n");
        return -1;
    }

    if(SetupVdma() != XST_SUCCESS)
    {
        xil_printf("VDMA failed\r\n");
        return -1;
    }

    xil_printf("HDMI Output Running\r\n");

    while(1);

    return 0;
}