#pragma once
#include <stdbool.h>

void init_app_ui();
void app_ui_update();

extern bool is_fix_calibrate_on;
extern bool is_dyn_calibrate_on;
extern float calibrate_k;
extern float calibrate_b;
