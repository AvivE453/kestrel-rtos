# Kestrel

A small preemptive real-time kernel for ARM Cortex-M, written from scratch in C11.
It runs on the `mps2-an385` board (Cortex-M3) emulated by QEMU.

## Status

Stage 0 of 7 is done: the board boots bare-metal and prints over UART.

- Vector table and `Reset_Handler` in C: initial stack pointer, `.data` copied from flash to RAM, `.bss` zeroed, then `main`
- Hand-written linker script for the board's memory map
- Polling driver for the CMSDK APB UART

Next: SysTick timer, fault handler, and a small `kprintf`; then context switching and a priority-based
preemptive scheduler.

## Requirements

- [Arm GNU Toolchain](https://gitlab.arm.com/tooling/gnu-toolchains-for-arm) (`arm-none-eabi-gcc`, `arm-none-eabi-gdb`), tested with 15.3.rel2
- QEMU with Arm system emulation (`qemu-system-arm`), tested with xPack QEMU Arm 9.2.4
- GNU Make

## Build and run

```sh
make          # build build/kernel.elf
make run      # boot it in QEMU; exit with Ctrl+A, then X
```

Expected output:

```
hello
```

## Debug

```sh
make debug                          # terminal 1: QEMU halted before the first instruction, GDB server on :1234
arm-none-eabi-gdb build/kernel.elf  # terminal 2
(gdb) target remote :1234
```

## Layout

| File        | Purpose                                                       |
|-------------|---------------------------------------------------------------|
| `startup.c` | Vector table and `Reset_Handler`                               |
| `link.ld`   | Memory regions and section placement                           |
| `uart.c/h`  | UART0 driver                                                   |
| `main.c`    | Application entry point                                        |

## Memory map (mps2-an385)

| Region | Address      | Size | Holds                                    |
|--------|--------------|------|------------------------------------------|
| FLASH  | `0x00000000` | 4 MB | Vector table, code, read-only data, `.data` initial values |
| RAM    | `0x20000000` | 4 MB | `.data`, `.bss`, stack (top at `0x20400000`) |
| UART0  | `0x40004000` | 4 KB | CMSDK APB UART registers                  |

## References

- Arm DUI 0552A, *Cortex-M3 Devices Generic User Guide*
- Arm DDI 0403E, *ARMv7-M Architecture Reference Manual*
- Arm DAI 0385D, *AN385: Cortex-M3 SMM on V2M-MPS2*
- Arm DDI 0479D, *Cortex-M System Design Kit Technical Reference Manual*
