# EEZ Studio LVGL 9.40 Compatibility Tools

This directory contains tools to fix compatibility issues between EEZ Studio generated code and LVGL 9.40.

## Problem

EEZ Studio generates code for LVGL that may not be compatible with LVGL 9.40 and newer versions. The main issues are:

1. **lv_obj_get_style_opa() API change**: In LVGL 9.40, the second parameter changed from accepting integers to requiring `lv_part_t` enum values.

### Error Example

```
error: invalid conversion from 'int' to 'lv_part_t' [-fpermissive]
lv_obj_get_style_opa((lv_obj_t *)a->user_data, 0);
                                                 ^
```

## Solution

### Automatic Fix Script

Use the `fix-lvgl940.py` Python script to automatically fix generated code files.

#### Usage

Three script versions are available:
- **Python** (`fix-lvgl940.py`): Cross-platform, most features
- **Bash** (`fix-lvgl940.sh`): Linux/Mac, simple and fast
- **Windows Batch** (`fix-lvgl940.bat`): Windows native

**Python version:**
```bash
# Preview changes (print to stdout)
python fix-lvgl940.py eez-flow.cpp eez-flow.h

# Fix files in-place (creates .bak backups)
python fix-lvgl940.py --in-place eez-flow.cpp eez-flow.h

# Fix files without creating backups
python fix-lvgl940.py --in-place --no-backup eez-flow.cpp eez-flow.h
```

**Bash version (Linux/Mac):**
```bash
# Fix files without backup
./fix-lvgl940.sh eez-flow.cpp eez-flow.h

# Fix files with backup
./fix-lvgl940.sh --backup eez-flow.cpp eez-flow.h
```

**Windows Batch version:**
```cmd
REM Fix files without backup
fix-lvgl940.bat eez-flow.cpp eez-flow.h

REM Fix files with backup
fix-lvgl940.bat --backup eez-flow.cpp eez-flow.h
```

**Using Makefile:**
```bash
# Fix with defaults (eez-flow.cpp eez-flow.h)
make fix

# Fix with backup
make fix-backup

# Fix specific files
make fix EEZ_SOURCES="eez-flow.cpp eez-flow.h eez-actions.cpp"
```

#### What it fixes

The script automatically replaces:
- `lv_obj_get_style_opa(obj, 0)` → `lv_obj_get_style_opa(obj, LV_PART_MAIN)`

### Manual Fix

If you prefer to fix the code manually, replace all occurrences of:

```cpp
lv_obj_get_style_opa(obj, 0)
```

with:

```cpp
lv_obj_get_style_opa(obj, LV_PART_MAIN)
```

#### Common locations in EEZ-generated code:

1. In animation callback functions (e.g., `anim_callback_get_opacity`)
2. In style getter functions (e.g., `objGetStyleOpa`)

## LVGL Part Types

In LVGL 9.40, you must use one of these part types instead of integer `0`:

- `LV_PART_MAIN` - The main part (default, most common)
- `LV_PART_SCROLLBAR` - The scrollbar
- `LV_PART_INDICATOR` - Indicator part
- `LV_PART_KNOB` - Knob part
- `LV_PART_SELECTED` - Selected part
- `LV_PART_ITEMS` - Items part
- `LV_PART_CURSOR` - Cursor part

For most EEZ Studio generated code, `LV_PART_MAIN` is the correct choice.

## Integration with Build Process

### Arduino IDE

After generating code with EEZ Studio:

1. Run the fix script on the generated files
2. Compile your Arduino project

```bash
cd your_arduino_project
python /path/to/fix-lvgl940.py --in-place eez-flow.cpp eez-flow.h
```

### PlatformIO

You can add a pre-build script to automatically fix generated files:

```ini
# platformio.ini
[env:myenv]
extra_scripts = pre:fix_eez_code.py
```

Create `fix_eez_code.py`:
```python
Import("env")
import subprocess

# Run the fix script
subprocess.run(["python", "tools/eez-studio/fix-lvgl940.py", 
                "--in-place", "--no-backup",
                "src/eez-flow.cpp", "src/eez-flow.h"])
```

## References

- [LVGL Documentation](https://docs.lvgl.io/)
- [EEZ Studio](https://github.com/eez-open/studio)
- [LVGL v9 Migration Guide](https://docs.lvgl.io/master/integration/framework/arduino.html)

## Contributing

If you find additional compatibility issues or have improvements to the fix script, please submit a pull request or open an issue.
