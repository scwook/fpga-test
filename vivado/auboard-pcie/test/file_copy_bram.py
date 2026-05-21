import os
import sys
import struct

def xdma_test():
    h2c_device = "/dev/xdma0_h2c_0"
    c2h_device = "/dev/xdma0_c2h_0"
    
    # FPGA 내부 Base Address (Vivado Address Editor에서 지정한 주소)
    fpga_address = 0x00000000 
    
    # 송신할 데이터 생성 (정수 1024개 = 4096 Bytes)
    data_count = 1024
    send_data = list(range(data_count))
    send_bytes = struct.pack(f'<{data_count}I', *send_data)
    
    f_write = None
    f_read = None
    
    try:
        # 1. Host -> FPGA 데이터 쓰기 (os.open은 정수를 반환하므로 with 없이 제어)
        f_write = os.open(h2c_device, os.O_WRONLY)
        os.lseek(f_write, fpga_address, os.SEEK_SET)
        os.write(f_write, send_bytes)
        print("➔ FPGA 내부 메모리로 데이터 전송 완료.")

        # 2. FPGA -> Host 데이터 읽기
        f_read = os.open(c2h_device, os.O_RDONLY)
        os.lseek(f_read, fpga_address, os.SEEK_SET)
        recv_bytes = os.read(f_read, len(send_bytes))
        print("⬅ FPGA 내부 메모리로부터 데이터 수신 완료.")
        
        # 바이트 데이터를 다시 정수형 리스트로 복원
        recv_data = struct.unpack(f'<{data_count}I', recv_bytes)
        
        # 3. 데이터 검증
        if send_data == list(recv_data):
            print("★ Python PCIe DMA 데이터 통신 성공! 데이터 완벽 일치 ★")
        else:
            print("⚠ 데이터가 일치하지 않습니다. 값을 확인하세요.")
            
    except PermissionError:
        print("에러: 디바이스 접근 권한이 없습니다. 'sudo python3 ...'로 실행하세요.")
    except Exception as e:
        print(f"오류 발생: {e}")
        
    finally:
        # 4. 자원 자율 해제 (안전을 위해 오픈된 파일 핸들을 확실히 닫아줍니다)
        if f_write is not None:
            os.close(f_write)
        if f_read is not None:
            os.close(f_read)

if __name__ == "__main__":
    xdma_test()
