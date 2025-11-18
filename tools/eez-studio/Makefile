# Makefile for EEZ Studio LVGL 9.40 Compatibility
# 
# This Makefile provides convenient targets for fixing EEZ Studio generated code.
# Include this in your project's Makefile or use standalone.

# Default source files (can be overridden)
EEZ_SOURCES ?= eez-flow.cpp eez-flow.h

# Script to use (Python or Bash)
FIX_SCRIPT ?= fix-lvgl940.py

# Python or bash command
ifeq ($(FIX_SCRIPT),fix-lvgl940.sh)
    FIX_CMD = ./$(FIX_SCRIPT)
else
    FIX_CMD = python3 $(FIX_SCRIPT)
endif

.PHONY: help fix fix-backup test clean

help:
	@echo "EEZ Studio LVGL 9.40 Compatibility Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  fix          - Fix EEZ Studio generated files (no backup)"
	@echo "  fix-backup   - Fix files with backup (.bak files created)"
	@echo "  test         - Run test to verify the fix script works"
	@echo "  clean        - Remove backup files"
	@echo ""
	@echo "Variables:"
	@echo "  EEZ_SOURCES  - Files to fix (default: eez-flow.cpp eez-flow.h)"
	@echo "  FIX_SCRIPT   - Script to use (default: fix-lvgl940.py)"
	@echo ""
	@echo "Examples:"
	@echo "  make fix"
	@echo "  make fix-backup"
	@echo "  make fix EEZ_SOURCES='eez-flow.cpp eez-flow.h eez-actions.cpp'"

fix:
	@echo "Fixing EEZ Studio generated code..."
	$(FIX_CMD) --in-place --no-backup $(EEZ_SOURCES)

fix-backup:
	@echo "Fixing EEZ Studio generated code (with backup)..."
ifeq ($(FIX_SCRIPT),fix-lvgl940.sh)
	$(FIX_CMD) --backup $(EEZ_SOURCES)
else
	$(FIX_CMD) --in-place $(EEZ_SOURCES)
endif

test:
	@echo "Running test..."
	@cp test_input.cpp test_input_test.cpp
	$(FIX_CMD) --in-place --no-backup test_input_test.cpp
	@echo "Comparing results..."
	@if diff -q test_input.cpp test_input_test.cpp > /dev/null; then \
		echo "ERROR: No changes were made!"; \
		rm test_input_test.cpp; \
		exit 1; \
	else \
		echo "SUCCESS: File was modified correctly"; \
		rm test_input_test.cpp; \
	fi

clean:
	@echo "Removing backup files..."
	rm -f *.bak
	rm -f test_input_test.cpp
	@echo "Done"

.DEFAULT_GOAL := help
