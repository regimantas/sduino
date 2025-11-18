// EEZ Studio Template Patch for LVGL 9.40 Compatibility
// 
// This file contains the corrected template snippets for EEZ Studio
// to generate LVGL 9.40 compatible code.
//
// INSTRUCTIONS:
// These template changes should be applied to your EEZ Studio project templates.
// Location: EEZ Studio > Settings > Templates or in your project's .eez-project file

// =============================================================================
// ANIMATION CALLBACK TEMPLATE - CORRECTED FOR LVGL 9.40
// =============================================================================

// OLD (Broken in LVGL 9.40):
// static int32_t anim_callback_get_opacity(lv_anim_t * a) { 
//     return lv_obj_get_style_opa((lv_obj_t *)a->user_data, 0); 
// }

// NEW (Works with LVGL 9.40):
static int32_t anim_callback_get_opacity(lv_anim_t * a) { 
    return lv_obj_get_style_opa((lv_obj_t *)a->user_data, LV_PART_MAIN); 
}

// =============================================================================
// STYLE GETTER FUNCTION TEMPLATE - CORRECTED FOR LVGL 9.40
// =============================================================================

// OLD (Broken in LVGL 9.40):
// void objGetStyleOpa(FlowState *flowState, unsigned int componentIndex, 
//                     const ListOfAssetsPtr<Property> &properties, uint32_t propertyIndex) {
//     lv_obj_t *obj = (lv_obj_t *)getLvglObjectFromIndex(componentIndex);
//     int32_t opa = (int32_t)lv_obj_get_style_opa(obj, 0);
//     // ...
// }

// NEW (Works with LVGL 9.40):
void objGetStyleOpa(FlowState *flowState, unsigned int componentIndex, 
                    const ListOfAssetsPtr<Property> &properties, uint32_t propertyIndex) {
    lv_obj_t *obj = (lv_obj_t *)getLvglObjectFromIndex(componentIndex);
    int32_t opa = (int32_t)lv_obj_get_style_opa(obj, LV_PART_MAIN);
    // ...
}

// =============================================================================
// GENERIC TEMPLATE PATTERN
// =============================================================================
// Replace ALL occurrences of:
//   lv_obj_get_style_opa(..., 0)
// With:
//   lv_obj_get_style_opa(..., LV_PART_MAIN)
//
// This applies to any template that uses lv_obj_get_style_opa()
// =============================================================================
