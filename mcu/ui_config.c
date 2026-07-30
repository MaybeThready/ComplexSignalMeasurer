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

const char* vrms_text_provider(char* buffer, size_t size)
{
    snprintf(buffer, size, "%.3f", signal_vrms);
    return buffer;
}

const char* h1_text_provider(char* buffer, size_t size)
{
    if (signal_harmonics[0].valid)
    {
        snprintf(buffer, size, "%d,%.1f,%.1f", signal_harmonics[0].order, signal_harmonics[0].freq, signal_harmonics[0].amp);
    }
    else
    {
        snprintf(buffer, size, "N/A");
    }
    return buffer;
}

const char* h2_text_provider(char* buffer, size_t size)
{
    if (signal_harmonics[1].valid)
    {
        snprintf(buffer, size, "%d,%.1f,%.1f", signal_harmonics[1].order, signal_harmonics[1].freq, signal_harmonics[1].amp);
    }
    else
    {
        snprintf(buffer, size, "N/A");
    }
    return buffer;
}

const char* h3_text_provider(char* buffer, size_t size)
{
    if (signal_harmonics[2].valid)
    {
        snprintf(buffer, size, "%d,%.1f,%.1f", signal_harmonics[2].order, signal_harmonics[2].freq, signal_harmonics[2].amp);
    }
    else
    {
        snprintf(buffer, size, "N/A");
    }
    return buffer;
}

static void build_pages()
{
    ui_page_init(&main_page, "Debug");
    ui_page_add_dynamic_text(&main_page, "Vmax", vmax_text_provider);
    ui_page_add_dynamic_text(&main_page, "Vmin", vmin_text_provider);
    ui_page_add_dynamic_text(&main_page, "Vpp", vpp_text_provider);
    ui_page_add_dynamic_text(&main_page, "Vrms", vrms_text_provider);
    ui_page_add_dynamic_text(&main_page, "H1", h1_text_provider);
    ui_page_add_dynamic_text(&main_page, "H2", h2_text_provider);
    ui_page_add_dynamic_text(&main_page, "H3", h3_text_provider);
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
