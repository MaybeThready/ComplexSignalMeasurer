#include "ui_config.h"
#include "ui/ui.h"
#include "bsp/msp_sys.h"

static UIApp ui;
static UIPage main_page;

static void build_pages()
{
    ui_page_init(&main_page, "Main");
    ui_page_add_text(&main_page, "Device", "MSPM0G3519");
    ui_page_add_text(&main_page, "Library", "OpenTD");
    ui_page_add_text(&main_page, "Version", "26.7");
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
