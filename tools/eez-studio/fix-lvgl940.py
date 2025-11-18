#!/usr/bin/env python3
"""
EEZ Studio LVGL 9.40 Compatibility Fixer

This script fixes compatibility issues in EEZ Studio generated code for LVGL 9.40.
The main issue is that lv_obj_get_style_opa() now requires an lv_part_t enum 
instead of an integer.

Usage:
    python fix-lvgl940.py <file.cpp> [<file.h>...]
    python fix-lvgl940.py --in-place <file.cpp> [<file.h>...]
"""

import sys
import re
import argparse
from pathlib import Path


def fix_lvgl940_compatibility(content):
    """
    Fix LVGL 9.40 compatibility issues in the given content.
    
    Replaces:
    - lv_obj_get_style_opa(..., 0) with lv_obj_get_style_opa(..., LV_PART_MAIN)
    """
    changes_made = 0
    
    # Fix lv_obj_get_style_opa calls with integer 0 as second parameter
    # Pattern matches: lv_obj_get_style_opa(anything, 0)
    pattern = r'lv_obj_get_style_opa\s*\(\s*([^,]+),\s*0\s*\)'
    replacement = r'lv_obj_get_style_opa(\1, LV_PART_MAIN)'
    
    new_content, count = re.subn(pattern, replacement, content)
    changes_made += count
    
    if changes_made > 0:
        print(f"  Made {changes_made} replacement(s)")
    
    return new_content, changes_made


def process_file(filepath, in_place=False, backup=True):
    """Process a single file."""
    print(f"Processing {filepath}...")
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"  Error reading file: {e}")
        return False
    
    new_content, changes_made = fix_lvgl940_compatibility(content)
    
    if changes_made == 0:
        print("  No changes needed")
        return True
    
    if in_place:
        # Create backup if requested
        if backup:
            backup_path = str(filepath) + '.bak'
            try:
                with open(backup_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"  Backup saved to {backup_path}")
            except Exception as e:
                print(f"  Warning: Could not create backup: {e}")
        
        # Write the fixed content
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"  File updated successfully")
            return True
        except Exception as e:
            print(f"  Error writing file: {e}")
            return False
    else:
        # Print to stdout
        print("\n" + "="*60)
        print(f"Fixed content for {filepath}:")
        print("="*60)
        print(new_content)
        print("="*60 + "\n")
        return True


def main():
    parser = argparse.ArgumentParser(
        description='Fix EEZ Studio generated code for LVGL 9.40 compatibility',
        epilog='Example: python fix-lvgl940.py --in-place eez-flow.cpp eez-flow.h'
    )
    parser.add_argument('files', nargs='+', help='Files to process')
    parser.add_argument('-i', '--in-place', action='store_true',
                        help='Modify files in place (default: print to stdout)')
    parser.add_argument('--no-backup', action='store_true',
                        help='Do not create backup files when using --in-place')
    
    args = parser.parse_args()
    
    success = True
    for filepath in args.files:
        path = Path(filepath)
        if not path.exists():
            print(f"Error: File not found: {filepath}")
            success = False
            continue
        
        if not process_file(path, args.in_place, not args.no_backup):
            success = False
    
    return 0 if success else 1


if __name__ == '__main__':
    sys.exit(main())
