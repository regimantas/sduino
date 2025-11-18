// Example of FIXED EEZ Studio generated code for LVGL 9.40
// This shows the corrected version after running fix-lvgl940.py

#include "lvgl.h"

namespace eez {
namespace flow {

// Animation callback - FIXED VERSION
// Before: lv_obj_get_style_opa((lv_obj_t *)a->user_data, 0)
// After:  lv_obj_get_style_opa((lv_obj_t *)a->user_data, LV_PART_MAIN)
static int32_t anim_callback_get_opacity(lv_anim_t * a) { 
    return lv_obj_get_style_opa((lv_obj_t *)a->user_data, LV_PART_MAIN); 
}

// Style getter function - FIXED VERSION
// Before: lv_obj_get_style_opa(obj, 0)
// After:  lv_obj_get_style_opa(obj, LV_PART_MAIN)
void objGetStyleOpa(void* flowState, unsigned int componentIndex, 
                    void* properties, uint32_t propertyIndex) {
    lv_obj_t *obj = (lv_obj_t *)getLvglObjectFromIndex(componentIndex);
    int32_t opa = (int32_t)lv_obj_get_style_opa(obj, LV_PART_MAIN);
    // ... rest of the function
}

} // namespace flow
} // namespace eez
