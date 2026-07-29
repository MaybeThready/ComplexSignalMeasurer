#include "ti_msp_dl_config.h"
#include "bsp/msp_sys.h"
#include "bsp/keyboard.h"
#include "bsp/oled/oled_driver.h"
#include "ui_config.h"

int main()
{
    SYSCFG_DL_init();
    init_sys();
    init_oled();
    init_keyboard();
    init_app_ui();

    while (1)
    {
        keyboard_update();
        app_ui_update();
    }

    return 0;
}
