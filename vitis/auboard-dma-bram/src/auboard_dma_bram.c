#include "xaxidma.h"
#include "xparameters.h"
#include "xil_printf.h"

#define BRAM_BASE       0xC0000000 
#define MAX_PKT_LEN     0x40    // 출력을 확인하기 위해 길이를 64바이트로 조정
#define DMA_DEVICE_ID   XPAR_AXI_DMA_0_BASEADDR

XAxiDma AxiDma;

// 데이터를 16진수로 보기 좋게 출력하는 함수
void PrintBuffer(const char* Label, u8* BufferPtr, int Length) {
    xil_printf("--- %s ---\r\n", Label);
    for (int i = 0; i < Length; i++) {
        xil_printf("%02X ", BufferPtr[i]);
        if ((i + 1) % 16 == 0) { // 16바이트마다 줄바꿈
            xil_printf("\r\n");
        }
    }
    xil_printf("\r\n");
}

int main() {
    int Status;
    u8 *TxPtr = (u8 *)(BRAM_BASE);
    u8 *RxPtr = (u8 *)(BRAM_BASE + 0x2000); 

    xil_printf("\r\n--- DMA Data Print Test Start ---\r\n");

    // 1. DMA 초기화
    XAxiDma_Config *CfgPtr = XAxiDma_LookupConfig(DMA_DEVICE_ID);
    if (!CfgPtr) return XST_FAILURE;
    Status = XAxiDma_CfgInitialize(&AxiDma, CfgPtr);
    if (Status != XST_SUCCESS) return XST_FAILURE;

    // 2. 데이터 초기화 (Tx에는 값 채우고, Rx는 0으로 초기화)
    for(int i = 0; i < MAX_PKT_LEN; i++) {
        TxPtr[i] = (u8)(i + 0x10); // 0x10, 0x11... 등의 값 채움
        RxPtr[i] = 0x00;
    }

    // 3. 전송 전 데이터 출력
    PrintBuffer("TX Data Before Transfer", TxPtr, MAX_PKT_LEN);
    PrintBuffer("RX Data Before Transfer (Empty)", RxPtr, MAX_PKT_LEN);

    // 4. DMA 전송 시작
    Status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)RxPtr, MAX_PKT_LEN, XAXIDMA_DEVICE_TO_DMA);
    Status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)TxPtr, MAX_PKT_LEN, XAXIDMA_DMA_TO_DEVICE);

    // 5. 완료 대기
    int timeout = 0;
    while (XAxiDma_Busy(&AxiDma, XAXIDMA_DMA_TO_DEVICE) || XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA)) {
        if (++timeout > 10000000) {
            xil_printf("Timeout Occurred!\r\n");
            break;
        }
    }

    // 6. 전송 후 결과 데이터 출력
    xil_printf("Transfer Finished!\r\n");
    PrintBuffer("RX Data After Transfer (Received)", RxPtr, MAX_PKT_LEN);

    // 7. 간단한 검증 로직
    int ErrorCount = 0;
    for(int i = 0; i < MAX_PKT_LEN; i++) {
        if (RxPtr[i] != TxPtr[i]) {
            ErrorCount++;
        }
    }

    if (ErrorCount == 0) {
        xil_printf("SUCCESS: Data matches exactly!\r\n");
    } else {
        xil_printf("FAILURE: %d errors found.\r\n", ErrorCount);
    }

    return XST_SUCCESS;
}