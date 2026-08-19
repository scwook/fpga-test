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
#include <xiltimer.h>
#include <xtimer_config.h>

#include "lwip/err.h"
#include "lwip/tcp.h"
#include "lwip/tcpbase.h"
#if defined (__arm__) || defined (__aarch64__)
#include "xil_printf.h"
#endif

#include "xparameters.h"
#include "xil_io.h"
#include "sleep.h"
#include "xgpio.h"
#include "xspips.h"

// #include "latency.h"

XGpio gpioVolt;
XGpio gpioSet;
u32 pulse_counter_config = 0;

#define SAXI_PULSE_COUNT_OFFSET     0
#define SAXI_TRIGGER_DELAY_OFFSET   4
#define SAXI_TRIGGER_WIDTH_OFFSET   8
#define SAXI_PULSE_CONFIG_OFFSET    12

u32 voltage_offset = 0;

#define MESSAGE_SIZE 24

static struct tcp_pcb *client_pcb = NULL;
static char recv_buffer[1024];
static int recv_len = 0;

#define SPI_DEVICE_ID   XPAR_XSPIPS_0_BASEADDR
#define SPI_BYTE_COUNT  4

u8 spi_tx[SPI_BYTE_COUNT] = {0x80, 0x00, 0x00, 0x00};
u8 spi_rx[SPI_BYTE_COUNT] = {0x00, 0x00, 0x00, 0x00};

XSpiPs  SpiInstance;
XSpiPs_Config   *Config;

int transfer_data() {
	return 0;
}

void print_app_header()
{
#if (LWIP_IPV6==0)
	xil_printf("\n\r\n\r-----lwIP TCP echo server ------\n\r");
#else
	xil_printf("\n\r\n\r-----lwIPv6 TCP echo server ------\n\r");
#endif
	xil_printf("============= Command list =============\n\r");
	xil_printf("CLS:GetCount - Return pulse count\n\r");
	xil_printf("CLS:SetVolt - Set output voltage\n\r");
	xil_printf("CLS:SetTrgMode - Set count trigger mode(0: disable, 1:enable)\n\r");
	xil_printf("CLS:SetTrgWidth - Set trigger width in microsecond\n\r");
	xil_printf("CLS:SetTrgDelay - Set trigger delay in microsecond\n\r");
	xil_printf("CLS:SetClrCount - Clear pulse count\n\r");
	xil_printf("CLS:SetOffset - Clear pulse count\n\r");
    xil_printf("CLS:GetVolt - Get input voltage\n\r");
	xil_printf("========================================\n\r");
}

u32 get_adc(float voltage) {
    return (u32)((voltage + 5) * 104857.5 + voltage_offset);
}

void set_trigger_mode(uint8_t value) {
    pulse_counter_config = (pulse_counter_config & ~(1U << 1)) | ((value & 1U) << 1);
    Xil_Out32(XPAR_PULSE_COUNTER_SAXI_0_BASEADDR + SAXI_PULSE_CONFIG_OFFSET,  pulse_counter_config);
}

void set_trigger_width(u32 value) {
    Xil_Out32(XPAR_PULSE_COUNTER_SAXI_0_BASEADDR + SAXI_TRIGGER_WIDTH_OFFSET, value);

}

void set_trigger_delay(u32 value) {
    Xil_Out32(XPAR_PULSE_COUNTER_SAXI_0_BASEADDR + SAXI_TRIGGER_DELAY_OFFSET, value);

}

void set_clear() {
    pulse_counter_config = (pulse_counter_config & ~(1U << 0)) | ((1 & 1U) << 0);
    Xil_Out32(XPAR_PULSE_COUNTER_SAXI_0_BASEADDR + SAXI_PULSE_CONFIG_OFFSET,  pulse_counter_config);

    pulse_counter_config = (pulse_counter_config & ~(1U << 0)) | ((0 & 1U) << 0);
    Xil_Out32(XPAR_PULSE_COUNTER_SAXI_0_BASEADDR + SAXI_PULSE_CONFIG_OFFSET,  pulse_counter_config);
}

int init_spi() {
    int Status;

    Config = XSpiPs_LookupConfig(SPI_DEVICE_ID);
    if(Config == NULL) return XST_FAILURE;

    Status = XSpiPs_CfgInitialize(&SpiInstance, Config, Config->BaseAddress);
    if(Status != XST_SUCCESS) return XST_FAILURE;

    XSpiPs_SetOptions(&SpiInstance, XSPIPS_MASTER_OPTION | XSPIPS_FORCE_SSELECT_OPTION);
    XSpiPs_SetSlaveSelect(&SpiInstance, 0);

    XSpiPs_SetClkPrescaler(&SpiInstance, XSPIPS_CLK_PRESCALE_64);

    return XST_SUCCESS;
}

int read_ai(uint16_t *adc_value) {
    int Status;

    Status = XSpiPs_PolledTransfer(&SpiInstance, spi_tx, spi_rx, SPI_BYTE_COUNT);
    
    if(Status != XST_SUCCESS) return XST_FAILURE;

    *adc_value = ((uint16_t)spi_rx[2] << 8) | spi_rx[3];

    return XST_SUCCESS;
}

err_t recv_callback(void *arg, struct tcp_pcb *tpcb,
                               struct pbuf *p, err_t err)
{
	/* do not read the packet if we are not in ESTABLISHED state */
	if (!p) {
        xil_printf("Client disconnected\r\n");

		tcp_close(tpcb);
		tcp_recv(tpcb, NULL);
        client_pcb = NULL;
        recv_len = 0;
		return ERR_OK;
	}

    if ((unsigned long)(p->len + recv_len) >= sizeof(recv_buffer)) {
        recv_len = 0;
        printf("Buffer overflow, clearing\n");
    }

    memcpy(recv_buffer + recv_len, p->payload, p->len);
    recv_len += p->len;

	// /* indicate that the packet has been received */
	tcp_recved(tpcb, p->len);

    pbuf_free(p);

    while(recv_len >= MESSAGE_SIZE) {
        char msg[MESSAGE_SIZE + 1];
        memcpy(msg, recv_buffer, MESSAGE_SIZE);
        msg[MESSAGE_SIZE] = '\0';
        
        char cmd[32];
        char val[32];

        memset(cmd, 0, sizeof(cmd));
        memset(val, 0, sizeof(val));

        char *space = strchr(msg, ' ');
        if(space) {
            size_t cmd_len = space - msg;
            strncpy(cmd, msg, cmd_len);
            cmd[cmd_len] = '\0';
            strncpy(val, space + 1, sizeof(val) -1);
        } else {
            strncpy(cmd, msg, sizeof(cmd) - 1);
        }

        // xil_printf("command: %s", cmd);
        char count_reply[32];
        char voltage_reply[32];

        if(strcmp(cmd, "CLS:GetCount") == 0) {
            u32 pulse_count;
            pulse_count = Xil_In32(XPAR_PULSE_COUNTER_SAXI_0_BASEADDR + SAXI_PULSE_COUNT_OFFSET);
            // sprintf(buffer, "%" PRIu32, pulse_count);            
    		// err = tcp_write(tpcb, (void *)buffer, strlen(buffer), 1);
            snprintf(count_reply, sizeof(count_reply), "%d", pulse_count);

            // xil_printf("command: %s %d\r\n", comm1, pulse_count);
            // printf("command: %s %lu\r\n", comm1, (unsigned long)pulse_count);
            if (tcp_sndbuf(tpcb) >= strlen(count_reply)) {
                tcp_write(tpcb, count_reply, strlen(count_reply), TCP_WRITE_FLAG_COPY);
                tcp_output(tpcb);

                // XTime_GetTime(&t_tx_ready);

                // double latency_us = 1.0 * (t_tx_ready - t_rx_start);
                // printf("latency = %f us \r\n", latency_us);

            } else {
                xil_printf("no space in tcp_sndbuf\r\n");
            }

        } else if (strcmp(cmd, "CLS:SetVolt") == 0) {
            // float voltage = atof(val);
            u32 adc_value = 0;
            adc_value = get_adc(atof(val));
            XGpio_DiscreteWrite(&gpioVolt, 1, adc_value);

            // Trigger voltage output process mode
            XGpio_DiscreteWrite(&gpioSet, 1, 0x01);
            usleep(10);

            // Return to output wait mode
            XGpio_DiscreteWrite(&gpioSet, 1, 0x00);

        } else if (strcmp(cmd, "CLS:SetTrgMode") == 0) {
            unsigned trigger_mode = atoi(val);
            set_trigger_mode(trigger_mode);

        } else if (strcmp(cmd, "CLS:SetTrgWidth") == 0) {
            // 1 clock = 10ns
            // 100 clock = 1us
            // 100000 clock = 1ms
            u32 trigger_width = (u32)(atof(val) * 100);
            set_trigger_width(trigger_width);

        } else if (strcmp(cmd, "CLS:SetTrgDelay") == 0) {
            // 1 clock = 10ns
            // 100 clock = 1us
            // 100000 clock = 1ms
            u32 trigger_delay = (u32)(atof(val) * 100);
            set_trigger_delay(trigger_delay);

        } else if (strcmp(cmd, "CLS:SetClrCount") == 0) {
            set_clear();

        } else if (strcmp(cmd, "CLS:SetOffset") == 0) {
            voltage_offset = atoi(val);

        } else if(strcmp(cmd, "CLS:GetVolt") == 0) {
            int Status;
            uint16_t adc_val;
            float voltage;

            Status = read_ai(&adc_val);

            if(Status == XST_SUCCESS) {
                voltage = ((float)adc_val) * 24.576 / 65535 - 12.288;

            } else {
                voltage = -999;

            }

            snprintf(voltage_reply, sizeof(voltage_reply), "%f", voltage);
            
            // xil_printf("command: %s %d\r\n", comm1, pulse_count);
            // printf("command: %s %lu\r\n", comm1, (unsigned long)pulse_count);
            if (tcp_sndbuf(tpcb) >= strlen(voltage_reply)) {
                tcp_write(tpcb, voltage_reply, strlen(voltage_reply), TCP_WRITE_FLAG_COPY);
                tcp_output(tpcb);

            } else {
                xil_printf("no space in tcp_sndbuf\r\n");
            }

        } else {
            xil_printf("command error: %s\r\n", cmd);
        }

        memmove(recv_buffer, recv_buffer + MESSAGE_SIZE, recv_len - MESSAGE_SIZE);
        recv_len -= MESSAGE_SIZE;
    }



	// /* echo back the payload */
	// /* in this case, we assume that the payload is < TCP_SND_BUF */
	// if (tcp_sndbuf(tpcb) > p->len) {
	// 	err = tcp_write(tpcb, p->payload, p->len, 1);
	// } else
	// 	xil_printf("no space in tcp_sndbuf\n\r");

	// /* free the received pbuf */
	// pbuf_free(p);

	return ERR_OK;
}

void err_callback(void *arg, err_t err) {
    xil_printf("Connection aborted, err=%d\n\r", err);
    client_pcb = NULL;
}

err_t accept_callback(void *arg, struct tcp_pcb *newpcb, err_t err)
{

    if(client_pcb != NULL) {
        tcp_abort(newpcb);
        xil_printf("Rejcting new client, already connected\r\n");

        return ERR_ABRT;
    }

    client_pcb = newpcb;

	/* set the receive callback for this connection */
	tcp_recv(newpcb, recv_callback);
    tcp_err(newpcb, err_callback);
	/* just use an integer number indicating the connection id as the
	   callback argument */
	// tcp_arg(newpcb, (void*)(UINTPTR)connection);

	/* increment for subsequent accepted connections */
	// connection++;

    xil_printf("Client connected\r\n");

	return ERR_OK;
}


int start_application()
{
	struct tcp_pcb *pcb;
	err_t err;
	unsigned port = 9000;

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

   // CN0531 Board GPIO interface init
    int xStatus = 0;
    xStatus = XGpio_Initialize(&gpioVolt, XPAR_AXI_GPIO_0_BASEADDR);
    if(XST_SUCCESS != xStatus) {
        printf("Failed to initialize GPIO 0");
        return XST_FAILURE;
    }
    xil_printf("GPIO 0 init\n\r");

    xStatus = XGpio_Initialize(&gpioSet, XPAR_AXI_GPIO_1_BASEADDR);
    if(XST_SUCCESS != xStatus) {
        printf("Failed to initialize GPIO 1");
        return XST_FAILURE;
    }
    print("GPIO 1 init\n\r");

    XGpio_SetDataDirection(&gpioVolt, 1, 0x0);
    print("Set GPIO 0 Direction write\n\r");

    XGpio_SetDataDirection(&gpioSet, 1, 0x0);
    print("Set GPIO 1 Direction write\n\r");

    // Pulse counter SAXI interface init
    u32 trigger_delay = 0;
    Xil_Out32(XPAR_PULSE_COUNTER_SAXI_0_BASEADDR + SAXI_TRIGGER_DELAY_OFFSET, trigger_delay);
    xil_printf("Set trigger delay: %d\n\r", trigger_delay);

    u32 trigger_width = 0;
    Xil_Out32(XPAR_PULSE_COUNTER_SAXI_0_BASEADDR + SAXI_TRIGGER_WIDTH_OFFSET, trigger_width);
    xil_printf("Set trigger width: %d\n\r", trigger_width);

    u32 config = 0;
    unsigned clear = 0;
    unsigned trigger_mode = 0;
    config |= (clear << 0);
    config |= (trigger_mode << 1);

    Xil_Out32(XPAR_PULSE_COUNTER_SAXI_0_BASEADDR + SAXI_PULSE_CONFIG_OFFSET,  config);
    xil_printf("Set config :0x%08X\n\r", config);

    // SPI init for MAXREFDES5 analog input board
    xStatus = init_spi();
    if(xStatus != XST_SUCCESS) {
        xil_printf("SPI init fail\n\r");
        return XST_FAILURE;
    }
    xil_printf("SPI init\n\r");

    xil_printf("CLS DAQ initialize complete\n\r");

	return 0;
}
