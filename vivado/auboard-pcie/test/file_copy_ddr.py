import os
import sys
import hashlib

def pcie_large_file_transfer(input_filename, output_filename):
    h2c_device = "/dev/xdma0_h2c_0"
    c2h_device = "/dev/xdma0_c2h_0"
    fpga_base_address = 0x00000000  # Vivado Address Editor상의 시작 주소
    
    # [핵심] 4KB(4096 Bytes)씩 쪼개서 이송 (안정성 최적화 크기)
    CHUNK_SIZE = 4096 

    if not os.path.exists(input_filename):
        print(f"에러: {input_filename} 파일이 없습니다.")
        return

    # 1. 파일 읽기
    with open(input_filename, "rb") as f:
        file_data = f.read()
    file_size = len(file_data)
    print(f"[*] 대용량 파일 로드 완료: {input_filename} ({file_size} Bytes / {file_size/(1024*1024):.2f} MB)")

    f_write = None
    f_read = None

    try:
        # 2. Host -> FPGA 분할 송신 (Write)
        print("\n[1] FPGA로 안전 분할 송신 중...")
        f_write = os.open(h2c_device, os.O_WRONLY)
        
        offset = 0
        while offset < file_size:
            # 보낼 조각 크기 계산 (마지막 조각 처리 포함)
            current_chunk_size = min(CHUNK_SIZE, file_size - offset)
            chunk = file_data[offset : offset + current_chunk_size]
            
            # FPGA 내부 주소를 순차적으로 이동하며 쓰기
            os.lseek(f_write, fpga_base_address + offset, os.SEEK_SET)
            os.write(f_write, chunk)
            
            offset += current_chunk_size
        print(f"➔ FPGA로 {offset} Bytes 송신 완료.")

        # 3. FPGA -> Host 분할 수신 (Read)
        print("\n[2] FPGA로부터 안전 분할 수신 중...")
        f_read = os.open(c2h_device, os.O_RDONLY)
        
        recv_buffer = bytearray()
        offset = 0
        while offset < file_size:
            current_chunk_size = min(CHUNK_SIZE, file_size - offset)
            
            # FPGA 내부 주소를 순차적으로 이동하며 읽기
            os.lseek(f_read, fpga_base_address + offset, os.SEEK_SET)
            chunk = os.read(f_read, current_chunk_size)
            
            if not chunk:
                print("⚠ 중간에 데이터를 읽지 못했습니다!")
                break
                
            recv_buffer.extend(chunk)
            offset += len(chunk)
        print(f"⬅ FPGA로부터 {len(recv_buffer)} Bytes 수신 완료.")

        # 4. 파일 저장
        with open(output_filename, "wb") as f_out:
            f_out.write(recv_buffer)
        print(f"[*] 복사본 파일 생성 완료: {output_filename}")

        # 5. 무결성 검증 (MD5 해시 비교)
        orig_hash = hashlib.md5(file_data).hexdigest()
        recv_hash = hashlib.md5(recv_buffer).hexdigest()

        print("\n=== 결과 검증 ===")
        print(f"원본 파일 MD5: {orig_hash}")
        print(f"복사 파일 MD5: {recv_hash}")

        if orig_hash == recv_hash:
            print("★ [성공] 2.7MB 대용량 이미지 분할 통신 완벽 성공! ★")
        else:
            print("⚠ [주의] 여전히 데이터가 다릅니다.")
            print("이 경우 Vivado Address Editor에서 XDMA에 매핑된 메모리 영역(Range)이 4MB 이상으로 잡혀있는지 꼭 확인하셔야 합니다.")

    except PermissionError:
        print("에러: 권한이 없습니다. 'sudo python3 ...'으로 실행하세요.")
    except Exception as e:
        print(f"오류 발생: {e}")
    finally:
        if f_write is not None:
            os.close(f_write)
        if f_read is not None:
            os.close(f_read)

if __name__ == "__main__":
    # 파일명을 본인의 2.7MB 이미지 파일명으로 변경하여 테스트하세요.
    pcie_large_file_transfer("sample.jpeg", "sample_copied.jpeg")
