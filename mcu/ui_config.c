#include "ui_config.h"
#include "ui/ui.h"
#include "bsp/msp_sys.h"
#include <stdio.h>

#define N_DATA (200)

static UIApp ui;
static UIPage calibrate_page;
static UIPage data_page;

bool is_fix_calibrate_on = true;
bool is_dyn_calibrate_on = false;

uint8_t current_data_index = 0;
float current_measurement = 0.0f;
float current_truth = 0.0f;
float calibrate_k = 1.0f;
float calibrate_b = 0.0f;
uint8_t calibrate_n = 0;

typedef struct
{
    float meas;
    float truth;
    bool enable;
} CalibrateData;

CalibrateData cbd[N_DATA] = { 0 };

static void add_data(UIApp* app, UIItem* item)
{
    if (current_data_index >= 0 && current_data_index < N_DATA)
    {
        cbd[current_data_index].enable = true;
        cbd[current_data_index].meas = current_measurement;
        cbd[current_data_index].truth = current_truth;
    }
}

static void delete_data(UIApp* app, UIItem* item)
{
    if (current_data_index >= 0 && current_data_index < N_DATA)
    {
        cbd[current_data_index].enable = false;
        cbd[current_data_index].meas = current_measurement;
        cbd[current_data_index].truth = current_truth;
    }
}

static const char* get_meas_text(char* buffer, size_t size)
{
    if (current_data_index >= 0 && current_data_index < N_DATA)
    {
        if (cbd[current_data_index].enable)
        {
            snprintf(buffer, size, "%.3fmV", cbd[current_data_index].meas);
            return buffer;
        }
    }

    snprintf(buffer, size, "--- mV");
    return buffer;
}

static const char* get_truth_text(char* buffer, size_t size)
{
    if (current_data_index >= 0 && current_data_index < N_DATA)
    {
        if (cbd[current_data_index].enable)
        {
            snprintf(buffer, size, "%.3fmV", cbd[current_data_index].truth);
            return buffer;
        }
    }

    snprintf(buffer, size, "--- mV");
    return buffer;
}

static void calculate_data(UIApp* app, UIItem* item)
{
    float sum_x = 0.0f;
    float sum_y = 0.0f;
    float sum_xy = 0.0f;
    float sum_x2 = 0.0f;
    calibrate_n = 0;
    for (size_t i = 0; i < N_DATA; i++)
    {
        if (cbd[i].enable)
        {
            calibrate_n++;
            sum_x += cbd[i].meas;
            sum_y += cbd[i].truth;
            sum_xy += cbd[i].meas * cbd[i].truth;
            sum_x2 += cbd[i].meas * cbd[i].meas;
        }
    }

    if (calibrate_n == 0)
    {
        calibrate_k = 1.0f;
        calibrate_b = 0.0f;
        return;
    }

    float mean_x = sum_x / calibrate_n;
    float mean_y = sum_y / calibrate_n;

    float k_div = sum_x2 - calibrate_n * mean_x * mean_x;
    if (fabs(k_div) < 0.00001)
    {
        calibrate_k = 1.0f;
        calibrate_b = 0.0f;
        return;
    }
    calibrate_k = (sum_xy - calibrate_n * mean_x * mean_y) / k_div;
    calibrate_b = mean_y - calibrate_k * mean_x;
}

static const char* get_n_text(char* buffer, size_t size)
{
    snprintf(buffer, size, "%d", calibrate_n);
    return buffer;
}

static const char* get_k_text(char* buffer, size_t size)
{
    snprintf(buffer, size, "%.3f", calibrate_k);
    return buffer;
}

static const char* get_b_text(char* buffer, size_t size)
{
    snprintf(buffer, size, "%.3f", calibrate_b);
    return buffer;
}

static void build_pages()
{
    ui_page_init(&data_page, "Calibrate Data");
    ui_page_add_number_typed(&data_page, "Data Index", &current_data_index, UI_NUMBER_UINT8, 0, N_DATA - 1, 1, 0, "", NULL);
    ui_page_add_dynamic_text(&data_page, "CMeas", get_meas_text);
    ui_page_add_dynamic_text(&data_page, "CTruth", get_truth_text);
    ui_page_add_number_typed(&data_page, "IMeas", &current_measurement, UI_NUMBER_FLOAT, 0.0f, 250.0f, 0.001f, 3, "mV", NULL);
    ui_page_add_number_typed(&data_page, "ITruth", &current_truth, UI_NUMBER_FLOAT, 0.0f, 250.0f, 0.001f, 3, "mV", NULL);
    ui_page_add_action(&data_page, "Add", add_data);
    ui_page_add_action(&data_page, "Delete", delete_data);

    ui_page_init(&calibrate_page, "Calibrate");
    ui_page_add_toggle(&calibrate_page, "Fix Calibrate", &is_fix_calibrate_on, NULL);
    ui_page_add_toggle(&calibrate_page, "Dynamic Calibrate", &is_dyn_calibrate_on, NULL);
    ui_page_add_dynamic_text(&calibrate_page, "Valid Data Cnt", get_n_text);
    ui_page_add_dynamic_text(&calibrate_page, "k", get_k_text);
    ui_page_add_dynamic_text(&calibrate_page, "b", get_b_text);
    ui_page_add_link(&calibrate_page, "Calibrate Data", &data_page);
    ui_page_add_action(&calibrate_page, "Calculate", calculate_data);
}

void init_app_ui()
{
    UIKeys keys;

    build_pages();
    ui_keys_use_default_4x4(&keys);
    ui_init(&ui, &calibrate_page, &keys);
}

void app_ui_update()
{
    ui_update(&ui, sys_tick);
}
