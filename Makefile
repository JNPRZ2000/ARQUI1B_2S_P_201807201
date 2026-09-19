AS = aarch64-linux-gnu-as
LD = aarch64-linux-gnu-ld
QEMU = qemu-aarch64

SRC_DIR = src
BUILD_DIR = build

OBJS = \
	$(BUILD_DIR)/main.o \
	$(BUILD_DIR)/io.o \
	$(BUILD_DIR)/operations.o

TARGET = calculadora

all: $(TARGET)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/main.o: $(SRC_DIR)/main.s | $(BUILD_DIR)
	$(AS) -g -o $@ $<

$(BUILD_DIR)/io.o: $(SRC_DIR)/io.s | $(BUILD_DIR)
	$(AS) -g -o $@ $<

$(BUILD_DIR)/operations.o: $(SRC_DIR)/operations.s | $(BUILD_DIR)
	$(AS) -g -o $@ $<

$(TARGET): $(OBJS)
	$(LD) -o $(TARGET) $(OBJS)

run: $(TARGET)
	$(QEMU) ./$(TARGET)

debug: $(TARGET)
	$(QEMU) -g 1234 ./$(TARGET)

clean:
	rm -rf $(BUILD_DIR) $(TARGET)

rebuild: clean all