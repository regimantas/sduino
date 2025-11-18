// Test file for EEZ Studio LVGL 9.40 compatibility fix
// This file contains the problematic patterns from the error message

#include "lvgl.h"

// Function from line 3837 of the error message
static int32_t anim_callback_get_opacity(lv_anim_t * a) { 
    return lv_obj_get_style_opa((lv_obj_t *)a->user_data, 0); 
}

// Function similar to line 4404 of the error message
void objGetStyleOpa(lv_obj_t *obj) {
    int32_t opa = (int32_t)lv_obj_get_style_opa(obj, 0);
}

// Additional test cases
void test_various_spacing() {
    lv_obj_t *obj = NULL;
    
    // Test with different spacing
    lv_obj_get_style_opa(obj, 0);
    lv_obj_get_style_opa(obj,0);
    lv_obj_get_style_opa( obj , 0 );
    lv_obj_get_style_opa(obj,  0);
    
    // Nested calls
    int result = (int)lv_obj_get_style_opa(obj, 0);
}
