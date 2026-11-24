/*
 * Copyright (C) 2009 - 2019 Xilinx, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 */

#include <stdio.h>
#include <string.h>
#include <xil_types.h>

#include "lwip/err.h"
#include "lwip/tcp.h"
#if defined (__arm__) || defined (__aarch64__)
#include "xil_printf.h"
#endif

#include "xparameters.h"
#include "xparameters_ps.h"
#include "xil_io.h"
#include "sleep.h"
#include "xgpio.h"
#include "xil_exception.h"
#include "xscugic.h"
#include <stdio.h>

// #define READ_DONE_GPIO_DEVICE_ID    XPAR_AXI_GPIO_2_BASEADDR
// #define DATA_COUNT_GPIO_DEVICE_ID   XPAR_AXI_GPIO_3_BASEADDR
#define BRAM_BASE_ADDR              XPAR_AXI_BRAM_0_BASEADDRESS
#define BRAM_WORD_CAPACITY          4096
#define TDC_INTR_ID                 61U
// #define INTC_DEVICE_ID              XPAR_SCUGIC_SINGLE_DEVICE_ID

#define INTC_BASE_ADDR		        XPAR_SCUGIC_CPU_BASEADDR
#define INTC_DIST_BASE_ADDR	        XPAR_SCUGIC_DIST_BASEADDR

// #define TX_CHUNK_WORDS              128
// #define TX_CHUNK_BYTES              (TX_CHUNK_WORDS * 4)
#define COMMAND_BUFFER_SIZE         128

#define TDC_INTR_PRIORITY         0xA0
#define TDC_INTR_TRIGGER          0x03  // Rising Edge

#define GPIO_READ_DONE_CHANNEL      1
#define GPIO_TDC_RESET_CHANNEL      2

#define TCP_HEADER_SIZE             4
#define TCP_TX_CHUNK_SIZE           1024

static struct tcp_pcb *client_pcb = NULL;
// static char recv_buffer[1024];
// static int recv_len = 0;

XGpio gpioState;
XGpio gpioDataCount;
XScuGic Intc;

// u32 tdc_data[BRAM_WORD_CAPACITY];
// static uint8_t tx_buffer[TX_CHUNK_BYTES];

static char command[COMMAND_BUFFER_SIZE];
static uint32_t command_len = 0;

static volatile int data_ready = 0;

static u32 data_count = 0;
static u32 tdc_data[BRAM_WORD_CAPACITY];

static int tx_active = 0;

// static u32 tx_offset = 0;
static u32 tx_queued = 0;
static u32 tx_acked = 0;
static u32 tx_total = 0;

static u32 tx_header;

static void tdc_read_done(void)
{
    XGpio_DiscreteWrite(&gpioState, GPIO_READ_DONE_CHANNEL, 1);
    usleep(10);
    XGpio_DiscreteWrite(&gpioState, GPIO_READ_DONE_CHANNEL, 0);
}

static void tdc_start(void)
{
    XGpio_DiscreteWrite(&gpioState, GPIO_TDC_RESET_CHANNEL, 1);
    usleep(10);
    XGpio_DiscreteWrite(&gpioState, GPIO_TDC_RESET_CHANNEL, 0);
}

void process_tdc_interrupt(void)
{
    if (!data_ready)
        return;

    if (tx_active)
        return;

    data_ready = 0;

    data_count = XGpio_DiscreteRead(&gpioDataCount, 1);

    if (data_count > BRAM_WORD_CAPACITY)
        data_count = BRAM_WORD_CAPACITY;

    for ( u32  i = 0; i < data_count; i++) 
    {
        tdc_data[i] = Xil_In32(BRAM_BASE_ADDR + (i * 4));
    }

    tx_header = data_count;

    // tx_offset = 0;
    tx_queued = 0;
    tx_acked = 0;

    tx_total = TCP_HEADER_SIZE + data_count * sizeof(u32);
    tx_active = 1;
}

void process_tdc_tcp_tx(void)
{
    err_t err;
    u16_t sndbuf;
    u32 chunk_size;
    u8 tx_buffer[TCP_TX_CHUNK_SIZE];

    if (!tx_active)
        return;

    if (client_pcb == NULL)
        return;

    if (tx_queued >= tx_total)
        return;

    sndbuf = tcp_sndbuf(client_pcb);

    // Check send buffer
    if (sndbuf == 0)
        return;

    chunk_size = tx_total - tx_queued;

    if (chunk_size > sndbuf)
        chunk_size = sndbuf;

    if (chunk_size > TCP_TX_CHUNK_SIZE)
        chunk_size = TCP_TX_CHUNK_SIZE;

    u32 pos = tx_queued;
    u32 copied = 0;

    // 1. Count 헤더
    if (pos < TCP_HEADER_SIZE) {

        u32 n = TCP_HEADER_SIZE - pos;

        if (n > chunk_size)
            n = chunk_size;

        memcpy(tx_buffer, ((u8 *)&tx_header) + pos, n);

        copied += n;
        pos += n;
    }

    // 2. 실제 데이터
    if (copied < chunk_size) {

        u32 data_pos = pos - TCP_HEADER_SIZE;
        u32 n = chunk_size - copied;

        memcpy(tx_buffer + copied, ((u8 *)tdc_data) + data_pos, n);

        copied += n;
    }

    // TCP 송신 큐에 복사
    err = tcp_write(client_pcb, tx_buffer, copied,TCP_WRITE_FLAG_COPY);

    if (err == ERR_MEM)
        return;

    if (err != ERR_OK) {
        xil_printf("tcp_write error: %d\r\n", err);
        return;
    }

    tx_queued += copied;

    // 실제 전송 요청
    tcp_output(client_pcb);
}

static err_t recv_callback(void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err)
{
    uint16_t offset = 0;XGpio_DiscreteRead(&gpioDataCount, 1);
    uint8_t ch;

    if (p == NULL)
    {
        xil_printf("TCP client disconnected\r\n");

        tcp_arg(pcb, NULL);
        tcp_recv(pcb, NULL);
        tcp_sent(pcb, NULL);
        tcp_err(pcb, NULL);

        tcp_close(pcb);

        client_pcb = NULL;
        command_len = 0;

        tx_active = 0;
        // tx_index = 0;
        tx_acked = 0;

        return ERR_OK;
    }

    if (err != ERR_OK)
    {
        pbuf_free(p);
        return err;
    }

    while (offset < p->tot_len)
    {
        if (pbuf_copy_partial(p, &ch, 1, offset) != 1)
            break;

        offset++;

        if (ch == '\n')
        {
            command[command_len] = '\0';

            if (command_len > 0 &&
                command[command_len - 1] == '\r')
            {
                command[command_len - 1] = '\0';
                command_len--;
            }

            xil_printf("Received command: %s\r\n", command);

            if (strcmp(command, "START") == 0)
            {
                tdc_start();
            }

            command_len = 0;
        }
        else
        {
            if (command_len < COMMAND_BUFFER_SIZE - 1)
            {
                command[command_len++] = ch;
            }
            else
            {
                xil_printf("Command too long\r\n");
                command_len = 0;

                while (offset < p->tot_len)
                {
                    if (pbuf_copy_partial(p, &ch, 1, offset) != 1)
                        break;

                    offset++;

                    if (ch == '\n')
                        break;
                }
            }
        }
    }

    tcp_recved(pcb, p->tot_len);
    pbuf_free(p);

    return ERR_OK;
}

static err_t sent_callback(void *arg, struct tcp_pcb *pcb, u16_t len)
{
    tx_acked += len;

    // 모든 데이터가 ACK되었는지 확인
    if (tx_queued == tx_total && tx_acked >= tx_total) {

        xil_printf("TDC TCP transmission completed\r\n");

        tx_active = 0;

        // PL 측정 재개
        tdc_read_done();

        // return ERR_OK;
    }

    // 송신 버퍼에 여유가 생겼으므로 다음 데이터 전송
    // process_tdc_tcp_tx();

    return ERR_OK;
}

static void err_callback(void *arg, err_t err) {
    xil_printf("Connection aborted, err=%d\n\r", err);
    client_pcb = NULL;
    tx_active = 0;
    // tx_index = 0;
    tx_acked = 0;
    tx_queued = 0;

    tdc_read_done();
}

static err_t accept_callback(void *arg, struct tcp_pcb *newpcb, err_t err)
{
    if(client_pcb != NULL) {
        tcp_abort(newpcb);
        xil_printf("Rejcting new client, already connected\r\n");

        return ERR_ABRT;
    }

    client_pcb = newpcb;

	/* set the receive callback for this connection */
	tcp_recv(newpcb, recv_callback);
    tcp_sent(newpcb, sent_callback);
    tcp_err(newpcb, err_callback);
	/* just use an integer number indicating the connection id as the
	   callback argument */
	// tcp_arg(newpcb, (void*)(UINTPTR)connection);

	/* increment for subsequent accepted connections */
	// connection++;

    xil_printf("TDC client connected\r\n");

	return ERR_OK;
}

static void TdcInterruptHandler(void *CallbackRef)
{
    data_ready = 1;
}

static int SetupInterrupt(void)
{
    // Disable interrupt
    XScuGic_DisableIntr(INTC_DIST_BASE_ADDR,TDC_INTR_ID);

    // Set raising edge detection
    XScuGic_SetPriTrigTypeByDistAddr(INTC_DIST_BASE_ADDR,TDC_INTR_ID,TDC_INTR_PRIORITY,TDC_INTR_TRIGGER);
   
    // Set callback funcgtion
    XScuGic_RegisterHandler(INTC_BASE_ADDR,TDC_INTR_ID,(Xil_InterruptHandler)TdcInterruptHandler,NULL);
    
    // Enable interrupt
    XScuGic_EnableIntr(INTC_DIST_BASE_ADDR,TDC_INTR_ID);

    return XST_SUCCESS;
}

int start_tdc_application()
{
	struct tcp_pcb *pcb;
	err_t err;
	unsigned port = 9001;

    int xStatus = 0;

    xStatus = XGpio_Initialize(&gpioState, XPAR_AXI_GPIO_2_BASEADDR);
    if(XST_SUCCESS != xStatus) {
        printf("Failed to initialize GPIO 2");
        return XST_FAILURE;
    }
    print("GPIO 2 init\n\r");

    xStatus = XGpio_Initialize(&gpioDataCount, XPAR_AXI_GPIO_3_BASEADDR);
    if(XST_SUCCESS != xStatus) {
        printf("Failed to initialize GPIO 3");
        return XST_FAILURE;
    }

    print("GPIO 3 init\n\r");

    XGpio_SetDataDirection(&gpioState, GPIO_READ_DONE_CHANNEL, 0x0);
    XGpio_SetDataDirection(&gpioState, GPIO_TDC_RESET_CHANNEL, 0x0);

    print("Set GPIO 2 Direction write\n\r");

    XGpio_SetDataDirection(&gpioDataCount, 1, 0xFFFF);
    print("Set GPIO 3 Direction write\n\r");

    // Read done init
    XGpio_DiscreteWrite(&gpioState, GPIO_READ_DONE_CHANNEL, 0);

    // Interrupt initialization
    if (SetupInterrupt() != XST_SUCCESS)
    {
        xil_printf("Interrupt initialization failed\r\n");
        return XST_FAILURE;
    }


	/* create new TCP PCB structure */
	pcb = tcp_new_ip_type(IPADDR_TYPE_ANY);
	if (!pcb) {
		xil_printf("Error creating PCB. Out of Memory\n\r");
		return -1;
	}

	/* bind to specified @port */
	err = tcp_bind(pcb, IP_ANY_TYPE, port);
	if (err != ERR_OK) {
		xil_printf("Unable to bind to port %d: err = %d\n\r", port, err);
		return -2;
	}

	/* we do not need any arguments to callback functions */
	tcp_arg(pcb, NULL);

	/* listen for connections */
	pcb = tcp_listen(pcb);
	if (!pcb) {
		xil_printf("Out of memory while tcp_listen\n\r");
		return -3;
	}

	/* specify callback to use for incoming connections */
	tcp_accept(pcb, accept_callback);

	xil_printf("TCP echo server started @ port %d\n\r", port);
    xil_printf("TDC initialize complete\n\r");

	return 0;
}
