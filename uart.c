#include <stdint.h>

#include "uart.h"

/* CMSDK APB UART: base address from AN385 Table 3-4, registers from DDI0479D Table 4-7 */
#define UART0_BASE 0x40004000u

#define UART0_DATA (*(volatile uint32_t *)(UART0_BASE + 0x000))
#define UART0_STATE (*(volatile uint32_t *)(UART0_BASE + 0x004))
#define UART0_CTRL (*(volatile uint32_t *)(UART0_BASE + 0x008))
#define UART0_BAUDDIV (*(volatile uint32_t *)(UART0_BASE + 0x010))

#define UART_STATE_TX_FULL (1u << 0)
#define UART_CTRL_TX_EN (1u << 0)

void uart_init(void)
{
    UART0_BAUDDIV = 16;
    UART0_CTRL = UART_CTRL_TX_EN;
}

void uart_putc(char c)
{
    while (UART0_STATE & UART_STATE_TX_FULL)
    {
    }

    UART0_DATA = (uint32_t)c;
}

void uart_puts(const char *s)
{
    while (*s != '\0')
    {
        uart_putc(*s);
        s++;
    }
}
