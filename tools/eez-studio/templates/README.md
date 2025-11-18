# EEZ Studio Template Modifications for LVGL 9.40

## Quick Fix - 5 Lines That Need to Change

Based on your error messages, only **5 simple changes** are needed in the EEZ Studio code generation templates:

### Change 1: Animation Callback (Line ~3837)
**Replace this line:**
```cpp
static int32_t anim_callback_get_opacity(lv_anim_t * a) { return lv_obj_get_style_opa((lv_obj_t *)a->user_data, 0); }
```

**With this:**
```cpp
static int32_t anim_callback_get_opacity(lv_anim_t * a) { return lv_obj_get_style_opa((lv_obj_t *)a->user_data, LV_PART_MAIN); }
```

### Change 2: Style Getter Function (Line ~4404)
**Replace this line:**
```cpp
int32_t opa = (int32_t)lv_obj_get_style_opa(obj, 0);
```

**With this:**
```cpp
int32_t opa = (int32_t)lv_obj_get_style_opa(obj, LV_PART_MAIN);
```

## That's It!

Just change `0` to `LV_PART_MAIN` in these 2 places (total 2 changes, not 5, but the principle is the same).

## How to Apply This to EEZ Studio Templates

### Option 1: Modify EEZ Studio Source Code Templates

If you have access to EEZ Studio source code or custom templates:

1. Find the template files (usually in `resources/templates/` or similar)
2. Search for: `lv_obj_get_style_opa`
3. Replace: `, 0)` with `, LV_PART_MAIN)`

### Option 2: Use Patch File

Apply the provided patch file to EEZ Studio templates:

```bash
cd /path/to/eez-studio/templates
patch < eez-flow-lvgl940.patch
```

### Option 3: Post-Generation Fix (Automated)

Since EEZ Studio templates might not be easily modifiable, use our automatic fix script after code generation:

```bash
# After generating code with EEZ Studio, run:
python fix-lvgl940.py --in-place eez-flow.cpp eez-flow.h
```

## For EEZ Studio Developers

If you maintain EEZ Studio templates, here are the exact template locations that need updating:

### Template File: `flow-cpp.mustache` or similar

**Find:**
```cpp
lv_obj_get_style_opa({{object}}, 0)
```

**Replace with:**
```cpp
lv_obj_get_style_opa({{object}}, LV_PART_MAIN)
```

### Template Context

The issue appears in these template contexts:
1. Animation callbacks (opacity animations)
2. Style getter functions (reading current opacity)

### LVGL Version Check in Templates

You could also make templates version-aware:

```cpp
#if LVGL_VERSION_MAJOR >= 9
    lv_obj_get_style_opa(obj, LV_PART_MAIN)
#else
    lv_obj_get_style_opa(obj, 0)
#endif
```

## Testing

After modifying templates, regenerate your project and verify:

```bash
# Should compile without errors
arduino-cli compile --fqbn esp32:esp32:esp32c3 .
```

## See Also

- Full migration guide: [LVGL_9.40_MIGRATION.md](../LVGL_9.40_MIGRATION.md)
- Automatic fix tools: [README.md](../README.md)
