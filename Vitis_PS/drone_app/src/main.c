#include <stdio.h>
#include "xil_printf.h"
#include "xil_io.h"
#include "sleep.h"

#define DRONE_BASE_ADDR 0x40000000U
#define REG_STATUS_OFFSET 0x00U
#define REG_MAGIC_OFFSET 0x04U

int main(){

    u32 magic = Xil_In32(DRONE_BASE_ADDR + REG_MAGIC_OFFSET);
    xil_printf("Magic register (0x04): 0x%08X", magic);

    if (magic == 0x1234ABCD){
        xil_printf("AXI-WORKS!\r\n");
    } else {
        xil_printf("AXI-DONT_WORK!\r\n");
    }
    
    while (1) {

        u32 status = Xil_In32(DRONE_BASE_ADDR + REG_STATUS_OFFSET);
        
        u32 id1 = (status >> 0) & 0xF;
        u32 id2 = (status >> 4) & 0xF;
        u32 id3 = (status >> 8) & 0xF;
        u32 id4 = (status >> 12) & 0xF;

        u32 flag1 = (status >> 16) & 0x1;
        u32 flag2 = (status >> 17) & 0x1;
        u32 flag3 = (status >> 18) & 0x1;
        u32 flag4 = (status >> 19) & 0x1;
        u32 drone = (status >> 20) & 0x1;

        xil_printf("RAW: 0x%08X | DRONE: %u | FLAGS: %u%u%u%u | IDs: [%u, %u, %u, %u]\r\n",
                   status, drone, flag4, flag3, flag2, flag1, id1, id2, id3, id4);

        sleep(1);
    }

    
};