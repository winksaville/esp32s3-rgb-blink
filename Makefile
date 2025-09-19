# Makefile for Arduino CLI projects

# Require jq so we can detect port
JQ := $(shell command -v jq 2>/dev/null)
ifeq ($(JQ),)
$(error "jq not found, please install jq")
endif

# ----- user settings -----
CONFIG := ./arduino-cli.yaml
SKETCH := esp32s3-rgb-blink.ino
BUILD  := build
BAUD   ?= 115200
FQBN   ?= esp32:esp32:esp32s3

CLI    := arduino-cli --config-file $(CONFIG)

.PHONY: all init compile upload monitor clean

all: compile

init:
	$(CLI) config init
	$(CLI) config set network.connection_timeout 600s
	$(CLI) core update-index
	$(CLI) core install esp32:esp32
	$(CLI) lib install "Adafruit NeoPixel"

build/$(SKETCH).bin: $(SKETCH)
	$(CLI) compile -b $(FQBN) --build-path $(BUILD)

compile: build/$(SKETCH).bin

# Helper: resolve port (use PORT if set, else auto-detect), then run $(1)
define GET_PORT
	@P="$$( [ -n "$(PORT)" ] && printf "%s" "$(PORT)" \
	      || $(CLI) board list --format json | jq -r '.detected_ports[0]?.port.address // empty' )"; \
	test -n "$$P" || { echo "Error: no serial port detected. Set PORT=/dev/ttyXXX"; exit 1; }; \
	$(1)
endef

upload: compile
	$(call GET_PORT,$(CLI) upload -p "$$P" -b $(FQBN) --input-dir $(BUILD))

monitor:
	$(call GET_PORT,$(CLI) monitor -p "$$P" -c baudrate=$(BAUD))

clean:
	rm -rf $(BUILD)
