# EEZ Studio Template Configuration for LVGL 9.40

## For EEZ Studio Project Maintainers

If you want to fix the code generation at the source (so generated code works immediately), 
modify your EEZ Studio templates as follows:

### Template Files to Modify

Templates are usually located in:
- Windows: `%APPDATA%\eez-studio\templates\`
- Linux/Mac: `~/.config/eez-studio/templates/`
- Or in your `.eez-project` file

### Changes Needed

#### 1. Flow C++ Template (flow-cpp.mustache or similar)

**Find this pattern:**
```cpp
lv_obj_get_style_opa({{object}}, 0)
```

**Replace with:**
```cpp
lv_obj_get_style_opa({{object}}, LV_PART_MAIN)
```

#### 2. Animation Callback Template

**Find:**
```cpp
static int32_t anim_callback_get_opacity(lv_anim_t * a) { 
    return lv_obj_get_style_opa((lv_obj_t *)a->user_data, 0); 
}
```

**Replace with:**
```cpp
static int32_t anim_callback_get_opacity(lv_anim_t * a) { 
    return lv_obj_get_style_opa((lv_obj_t *)a->user_data, LV_PART_MAIN); 
}
```

#### 3. Style Getter Template

**Find:**
```cpp
int32_t opa = (int32_t)lv_obj_get_style_opa(obj, 0);
```

**Replace with:**
```cpp
int32_t opa = (int32_t)lv_obj_get_style_opa(obj, LV_PART_MAIN);
```

### Alternative: Version-Aware Templates

Make templates work with both old and new LVGL:

```cpp
#if LVGL_VERSION_MAJOR >= 9
    #define LV_STYLE_PART LV_PART_MAIN
#else
    #define LV_STYLE_PART 0
#endif

// Then use:
lv_obj_get_style_opa(obj, LV_STYLE_PART)
```

### After Modifying Templates

1. Restart EEZ Studio
2. Regenerate your project
3. Code should now compile without errors

## Contributing to EEZ Studio

If you're an EEZ Studio contributor, consider submitting a PR with these changes:

1. Fork https://github.com/eez-open/studio
2. Update templates in `packages/project-editor/flow/component-templates/`
3. Test with LVGL 9.40
4. Submit PR with title: "Fix LVGL 9.40 compatibility - lv_obj_get_style_opa requires lv_part_t"

## See Also

- [Quick Fix Guide](../QUICK_FIX.md)
- [Full Migration Guide](../LVGL_9.40_MIGRATION.md)
- [EEZ Studio GitHub](https://github.com/eez-open/studio)
