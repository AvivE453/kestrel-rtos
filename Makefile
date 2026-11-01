CC = arm-none-eabi-gcc
CFLAGS = -mcpu=cortex-m3 -mthumb -std=c11 -Wall -Wextra -g -O0 -ffreestanding
LDFLAGS = -nostdlib -T link.ld

BUILD = build
OBJS = $(BUILD)/startup.o $(BUILD)/main.o $(BUILD)/uart.o

$(BUILD)/kernel.elf: $(OBJS) link.ld
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) -o $@

$(BUILD)/%.o: %.c
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: run debug check clean
run: $(BUILD)/kernel.elf
	qemu-system-arm -M mps2-an385 -nographic -kernel $(BUILD)/kernel.elf

debug: $(BUILD)/kernel.elf
	qemu-system-arm -M mps2-an385 -nographic -kernel $(BUILD)/kernel.elf -S -s

# The kernel never exits, so QEMU is stopped by timeout (exit code 124); any other code is a real failure.
check: $(BUILD)/kernel.elf
	timeout 3 qemu-system-arm -M mps2-an385 -display none -monitor none -serial file:$(BUILD)/uart.log -kernel $(BUILD)/kernel.elf; [ $$? -eq 124 ]
	grep -q "hello" $(BUILD)/uart.log
	@echo "check passed"

clean:
	rm -rf $(BUILD)
