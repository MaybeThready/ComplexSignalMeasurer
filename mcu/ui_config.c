#include "ui_config.h"
#include "ui/ui.h"
#include "bsp/msp_sys.h"
#include <stdio.h>
#include "signal.h"

static UIApp ui;
static UIPage main_page;

const char* vmax_text_provider(char* buffer, size_t size)
{
    snprintf(buffer, size, "%.3f", signal_vmax);
    return buffer;
}

const char* vmin_text_provider(char* buffer, size_t size)
{
    snprintf(buffer, size, "%.3f", signal_vmin);
    return buffer;
}

const char* vpp_text_provider(char* buffer, size_t size)
{
    snprintf(buffer, size, "%.3f", signal_vpp);
    return buffer;
}

static void build_pages()
{
    ui_page_init(&main_page, "Debug");
    ui_page_add_dynamic_text(&main_page, "Vmax", vmax_text_provider);
    ui_page_add_dynamic_text(&main_page, "Vmin", vmin_text_provider);
    ui_page_add_dynamic_text(&main_page, "Vpp", vpp_text_provider);
}

void init_app_ui()
{
    UIKeys keys;

    build_pages();
    ui_keys_use_default_4x4(&keys);
    ui_init(&ui, &main_page, &keys);
}

void app_ui_update()
{
    ui_update(&ui, sys_tick);
}
