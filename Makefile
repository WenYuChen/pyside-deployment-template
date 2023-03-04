# Determine working directory.
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(patsubst %/,%,$(dir $(MAKEFILE_PATH)))

# Define source and output directories.
SOURCE_DIR := $(CURRENT_DIR)/src
BUILD_DIR := $(CURRENT_DIR)/build/tmp
BINARY_DIR := $(CURRENT_DIR)/build

# Define application info.
APP_NAME := PySide-GUI
STARTUP_SCRIPT := $(SOURCE_DIR)/gui.py
APP_LOGO := $(SOURCE_DIR)/res/img/logo.ico
NSI_SCRIPT := $(CURRENT_DIR)/script/nsis/gen_installer.nsi

# NSIS Commands.
NSIS := C:/Program Files (x86)/NSIS/makensis.exe

# Pyinstaller.
RESTRUCTURE_SCRIPT := $(CURRENT_DIR)/script/pyinstaller/restructure_bin.bat
RUNTIME_HOOK := $(CURRENT_DIR)/script/pyinstaller/runtime_hooker.py


define rm_build
	@if exist $(BUILD_DIR) rmdir /s /q "$(BUILD_DIR)"
endef

define rm_exe
	@if exist $(APP_OUTPUT_DIR) rmdir /s /q "$(APP_OUTPUT_DIR)"
endef


.PHONY: all

all: application

application:
	@echo [MAKEFILE] **********  Start building application: $(APP_NAME)  **********

	@echo [MAKEFILE] Initialize parameters.
	$(eval APP_OUTPUT_DIR := $(BINARY_DIR)/$(APP_NAME))
	$(eval SPEC_PATH := $(BUILD_DIR)/$(APP_NAME).spec)
	@echo [MAKEFILE] Done.

	@echo [MAKEFILE] Clean up old builds.
	$(call rm_build)
	$(call rm_exe)
	@echo [MAKEFILE] Done.

	@echo [MAKEFILE] Generate spec.
	pyi-makespec $(STARTUP_SCRIPT) \
		--noconsole \
		--specpath $(BUILD_DIR) \
		--name $(APP_NAME) \
		--icon $(APP_LOGO) \
		--runtime-hook $(RUNTIME_HOOK) \
		--add-data $(SOURCE_DIR)/res;res \
		--add-data $(SOURCE_DIR)/setting.ini;. \
		--add-data $(SOURCE_DIR)/VERSION.txt;.
	@echo [MAKEFILE] Done.

	@echo [MAKEFILE] Generate executable with pyinstaller.
	pyinstaller $(SPEC_PATH) \
		--clean \
		--noconfirm \
		--distpath $(BINARY_DIR) \
		--workpath $(BUILD_DIR)
	@echo [MAKEFILE] Done.

	@echo [MAKEFILE] Restructure executable.
	echo $(APP_OUTPUT_DIR)
	$(RESTRUCTURE_SCRIPT) "$(APP_OUTPUT_DIR)"
	@echo [MAKEFILE] Done.

	@echo [MAKEFILE] Clean up temperary files.
	$(call rm_build)
	@echo [MAKEFILE] Done.

	@echo [MAKEFILE] Generate installer with NSIS.
	$(NSIS) /INPUTCHARSET UTF8 $(NSI_SCRIPT)
	@echo [MAKEFILE] Done.

	@echo [MAKEFILE] **********  Application: $(APP_NAME) built.  **********
