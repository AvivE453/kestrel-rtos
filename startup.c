#include <stdint.h>

extern uint32_t _estack;

void Reset_Handler(void)
{
    while (1)
    {
    }
}

const uint32_t vector_table[2] __attribute__((section(".vector_table"))) = {
    (uint32_t)&_estack,
    (uint32_t)Reset_Handler,
};