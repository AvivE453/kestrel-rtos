#include <stdint.h>

extern uint32_t _estack;
extern uint32_t _sdata;
extern uint32_t _sidata;
extern uint32_t _edata;
extern uint32_t _sbss;
extern uint32_t _ebss;

int main(void);

static void copy_data(void)
{
    uint32_t *src = &_sidata;
    uint32_t *dst = &_sdata;

    while (dst < &_edata)
    {
        *dst = *src;
        dst++;
        src++;
    }
}

static void zero_bss(void)
{
    uint32_t *dst = &_sbss;

    while (dst < &_ebss)
    {
        *dst = 0;
        dst++;
    }
}

void Reset_Handler(void)
{
    copy_data();
    zero_bss();
    main();

    while (1)
    {
    }
}

const uint32_t vector_table[2] __attribute__((section(".vector_table"))) = {
    (uint32_t)&_estack,
    (uint32_t)Reset_Handler,
};