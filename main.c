#include "uart.h"

int main(void)
{
    uart_init();
    uart_puts("hello\r\n");

    while (1)
    {
    }
}
