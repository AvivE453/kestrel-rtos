CC = arm-none-eabi-gcc
CFLAGS = -mcpu=cortex-m3 -mthumb -std=c11 -Wall -Wextra -g -O0 -ffreestanding
LDFLAGS = -nostdlib -T link.ld

BUILD = build

$(BUILD)/kernel.elf: $(BUILD)/startup.o link.ld
	$(CC) $(CFLAGS) $(LDFLAGS) $(BUILD)/startup.o -o $(BUILD)/kernel.elf

$(BUILD)/startup.o: startup.c
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -c startup.c -o $(BUILD)/startup.o

.PHONY: debug clean
debug: $(BUILD)/kernel.elf
	qemu-system-arm -M mps2-an385 -nographic -kernel $(BUILD)/kernel.elf -S -s

clean:
	rm -rf $(BUILD)
