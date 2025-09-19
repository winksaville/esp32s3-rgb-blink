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
DTO    ?= 100ms
LFRMT  ?=                # pass "--json" to get JSON output
PORT   ?=                # optional: set to /dev/ttyUSB0 to skip auto-detect

CLI := arduino-cli --config-file "$(CONFIG)"

.PHONY: help init compile list upload monitor clean c u m l cl
.DEFAULT_GOAL := help

help:
	@echo "Targets:"; \
	awk 'BEGIN{FS=":.*## "} \
	  /^[A-Za-z0-9_.-]+:.*## / && $$2 != "alias" { order[++n]=$$1; desc[$$1]=$$2; next } \
	  /^[A-Za-z0-9_.-]+:.*##alias/ { split($$0,p,":"); al=p[1]; sub(":","",al); sub(/^[ \t]*/,"",p[2]); split(p[2],deps," "); tgt=deps[1]; alias[tgt]=al } \
	  END{ for(i=1;i<=n;i++){ name=order[i]; \
	    if(name in alias) printf "  %-14s %s\n", name " (" alias[name] ")", desc[name]; \
	    else               printf "  %-14s %s\n", name, desc[name]; \
	  }}' $(MAKEFILE_LIST)

init: ## One-time: init config, install core + libs
	$(CLI) config init
	$(CLI) config set network.connection_timeout 600s
	$(CLI) core update-index
	$(CLI) core install "esp32:esp32"
	$(CLI) lib install "Adafruit NeoPixel"

$(BUILD)/$(SKETCH).bin: $(SKETCH)
	$(CLI) compile -b "$(FQBN)" --build-path "$(BUILD)"

compile: $(BUILD)/$(SKETCH).bin ## Compile if sketch changed
c: compile ##alias

# Helper: resolve port (use PORT if set, else auto-detect), then run $(1)
define GET_PORT
	@P="$$( [ -n "$(PORT)" ] && printf "%s" "$(PORT)" \
	      || $(CLI) board list --discovery-timeout "$(DTO)" --json | jq -r '.detected_ports[0]?.port.address // empty' )"; \
	test -n "$$P" || { echo "Error: no serial port detected. Set PORT=/dev/ttyXXX"; exit 1; }; \
	$(1)
endef

list: ## List connected boards
	$(CLI) board list $(LFRMT) --discovery-timeout "$(DTO)"
l: list ##alias

upload: compile ## Upload the built sketch
	$(call GET_PORT,$(CLI) upload -p "$$P" -b "$(FQBN)" --input-dir "$(BUILD)")
u: upload ##alias

monitor: ## Open serial monitor
	$(call GET_PORT,$(CLI) monitor -p "$$P" -c baudrate="$(BAUD)")
m: monitor ##alias

clean: ## Remove build artifacts
	rm -rf -- "$(BUILD)"
cl: clean ##alias
