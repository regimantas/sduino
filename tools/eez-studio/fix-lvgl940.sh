#!/bin/bash
# EEZ Studio LVGL 9.40 Compatibility Fixer (Bash version)
# 
# This script fixes compatibility issues in EEZ Studio generated code for LVGL 9.40.
# The main issue is that lv_obj_get_style_opa() now requires an lv_part_t enum 
# instead of an integer.
#
# Usage:
#   ./fix-lvgl940.sh <file.cpp> [<file.h>...]
#   ./fix-lvgl940.sh --backup <file.cpp> [<file.h>...]

set -e

# Default: no backup
BACKUP=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

show_help() {
    cat << EOF
EEZ Studio LVGL 9.40 Compatibility Fixer

Usage: $0 [OPTIONS] <file1> [file2 ...]

Options:
    -b, --backup    Create backup files before modifying (.bak extension)
    -h, --help      Show this help message

Example:
    $0 eez-flow.cpp eez-flow.h
    $0 --backup eez-flow.cpp eez-flow.h

What it fixes:
    lv_obj_get_style_opa(obj, 0) → lv_obj_get_style_opa(obj, LV_PART_MAIN)
EOF
}

# Parse arguments
FILES=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--backup)
            BACKUP=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            FILES+=("$1")
            shift
            ;;
    esac
done

# Check if files were provided
if [ ${#FILES[@]} -eq 0 ]; then
    echo -e "${RED}Error: No files specified${NC}"
    show_help
    exit 1
fi

# Process each file
TOTAL_CHANGES=0
for file in "${FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}Error: File not found: $file${NC}"
        continue
    fi
    
    echo -e "${YELLOW}Processing $file...${NC}"
    
    # Create backup if requested
    if [ "$BACKUP" = true ]; then
        cp "$file" "$file.bak"
        echo -e "${GREEN}  Backup saved to $file.bak${NC}"
    fi
    
    # Count changes
    CHANGES=$(grep -c "lv_obj_get_style_opa.*,\s*0\s*)" "$file" 2>/dev/null || true)
    
    if [ "$CHANGES" -gt 0 ]; then
        # Fix the file using sed
        # Pattern: lv_obj_get_style_opa(..., 0) → lv_obj_get_style_opa(..., LV_PART_MAIN)
        sed -i.tmp 's/lv_obj_get_style_opa(\([^,]*\),\s*0\s*)/lv_obj_get_style_opa(\1, LV_PART_MAIN)/g' "$file"
        rm -f "$file.tmp"
        
        echo -e "${GREEN}  Made $CHANGES replacement(s)${NC}"
        TOTAL_CHANGES=$((TOTAL_CHANGES + CHANGES))
    else
        echo -e "  No changes needed"
    fi
done

echo ""
if [ $TOTAL_CHANGES -gt 0 ]; then
    echo -e "${GREEN}✓ Successfully fixed $TOTAL_CHANGES instance(s) across ${#FILES[@]} file(s)${NC}"
else
    echo -e "${YELLOW}No changes were needed${NC}"
fi
