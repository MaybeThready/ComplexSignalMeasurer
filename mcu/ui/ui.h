/**
 * @file ui.h
 * @brief Animated OLED UI with a small page-builder API.
 *
 * Typical use:
 *   ui_page_init(&page, "Main");
 *   ui_page_add_toggle(&page, "Output", &enabled, on_changed);
 *   ui_page_add_number(&page, "Voltage", &voltage, 0, 5, .1, 1, "V", on_changed);
 *   ui_init(&app, &page, &keys);
 */
#pragma once

#include "../bsp/keyboard.h"
#include "../bsp/oled/oled.h"
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define UI_MAX_ITEMS       12U
#define UI_STACK_DEPTH      8U
#define UI_TEXT_BUFFER_SIZE 32U

typedef struct UIApp UIApp;
typedef struct UIPage UIPage;
typedef struct UIItem UIItem;

typedef void (*UICallback)(UIApp *ui, UIItem *item);
typedef void (*UIPageCallback)(UIApp *ui, UIPage *page);
typedef const char *(*UITextProvider)(char *buffer, size_t size);
typedef void (*UICustomDraw)(UIApp *ui, int16_t x, int16_t y,
                             int16_t width, int16_t height);

typedef enum {
    UI_ITEM_TEXT,
    UI_ITEM_ACTION,
    UI_ITEM_TOGGLE,
    UI_ITEM_CHOICE,
    UI_ITEM_NUMBER,
    UI_ITEM_LINK,
    UI_ITEM_SEPARATOR,
    UI_ITEM_CUSTOM
} UIItemType;

/**
 * @brief Storage type bound to a number item.
 */
typedef enum {
    UI_NUMBER_INT8,
    UI_NUMBER_UINT8,
    UI_NUMBER_INT16,
    UI_NUMBER_UINT16,
    UI_NUMBER_INT32,
    UI_NUMBER_UINT32,
    UI_NUMBER_FLOAT,
    UI_NUMBER_DOUBLE
} UINumberType;

typedef struct {
    Key *up;
    Key *down;
    Key *left;
    Key *right;
    Key *ok;
    Key *back;
    Key *scroll_up;
    Key *scroll_down;
    Key *start_number_input;
    Key *digits[10];
    Key *decimal;
} UIKeys;

struct UIItem {
    UIItemType type;
    const char *label;
    union {
        struct { const char *text; UITextProvider provider; } text;
        struct { UICallback callback; } action;
        struct { bool *value; UICallback changed; } toggle;
        struct {
            uint8_t *value;
            const char *const *options;
            uint8_t count;
            UICallback changed;
        } choice;
        struct {
            void *value;
            UINumberType type;
            double minimum;
            double maximum;
            double step;
            uint8_t decimals;
            const char *unit;
            UICallback changed;
        } number;
        struct { UIPage *page; } link;
        struct { UICustomDraw draw; UICallback activate; } custom;
    } data;
};

struct UIPage {
    const char *title;
    UIItem items[UI_MAX_ITEMS];
    uint8_t item_count;
    UIPageCallback on_enter;
    UIPageCallback on_leave;
};

typedef struct {
    UIPage *page;
    uint8_t selected;
    uint8_t scroll;
} UIPageState;

struct UIApp {
    UIKeys keys;
    UIPageState stack[UI_STACK_DEPTH];
    uint8_t depth;

    UIPage *outgoing_page;
    float page_x;
    float outgoing_x;
    bool page_animating;

    float cursor_y;
    float cursor_target_y;
    bool cursor_ready;

    bool editor_open;
    bool editor_closing;
    float popup_width;
    float popup_height;
    double edit_number;
    uint8_t edit_choice;
    uint8_t previous_choice;
    float choice_slide;
    char number_input[20];
    uint8_t number_input_length;
    bool number_typing;

    const char *notice;
    uint32_t notice_until;
    uint32_t now;
    uint32_t last_tick;
    char text_buffer[UI_TEXT_BUFFER_SIZE];
};

/**
 * @brief Initialize an empty page.
 *
 * This function clears all existing rows and callbacks in the page. Add rows
 * in display order after initialization.
 *
 * @param page Page object to initialize.
 * @param title Page title. The string must remain valid for the page lifetime.
 */
void ui_page_init(UIPage *page, const char *title);

/**
 * @brief Register the callback invoked when a page becomes visible.
 *
 * @param page Target page.
 * @param callback Callback function, or NULL to remove the callback.
 */
void ui_page_on_enter(UIPage *page, UIPageCallback callback);

/**
 * @brief Register the callback invoked before a page is hidden.
 *
 * @param page Target page.
 * @param callback Callback function, or NULL to remove the callback.
 */
void ui_page_on_leave(UIPage *page, UIPageCallback callback);

/**
 * @brief Add a static read-only text row.
 *
 * @param page Page receiving the row.
 * @param label Text displayed on the left.
 * @param text Text displayed on the right.
 * @return Pointer to the created item, or NULL if the page is full.
 *
 * @note Both strings must remain valid for the page lifetime.
 */
UIItem *ui_page_add_text(UIPage *page, const char *label, const char *text);

/**
 * @brief Add a read-only row whose value is generated during rendering.
 *
 * @param page Page receiving the row.
 * @param label Text displayed on the left.
 * @param provider Function that writes and returns the current value text.
 * @return Pointer to the created item, or NULL if the page is full.
 */
UIItem *ui_page_add_dynamic_text(UIPage *page, const char *label,
                                 UITextProvider provider);

/**
 * @brief Add an action row.
 *
 * The callback is invoked when the user presses the confirm key.
 *
 * @param page Page receiving the row.
 * @param label Row label.
 * @param callback Action callback, or NULL for a selectable no-op row.
 * @return Pointer to the created item, or NULL if the page is full.
 */
UIItem *ui_page_add_action(UIPage *page, const char *label,
                           UICallback callback);

/**
 * @brief Add a boolean toggle row.
 *
 * @param page Page receiving the row.
 * @param label Row label.
 * @param value Bound boolean variable.
 * @param changed Callback invoked after the value changes, or NULL.
 * @return Pointer to the created item, or NULL if the page is full.
 */
UIItem *ui_page_add_toggle(UIPage *page, const char *label, bool *value,
                           UICallback changed);

/**
 * @brief Add an animated multiple-choice editor.
 *
 * @param page Page receiving the row.
 * @param label Row and editor title.
 * @param value Bound option index.
 * @param options Array of option strings.
 * @param option_count Number of strings in options.
 * @param changed Callback invoked after a new option is confirmed, or NULL.
 * @return Pointer to the created item, or NULL if the page is full.
 *
 * @note The option array and strings must remain valid for the page lifetime.
 */
UIItem *ui_page_add_choice(UIPage *page, const char *label, uint8_t *value,
                           const char *const options[], uint8_t option_count,
                           UICallback changed);

/**
 * @brief Add a numeric editor.
 *
 * The editor supports step adjustment and direct digit/decimal input. Changes
 * are written to the bound variable only after confirmation.
 *
 * @param page Page receiving the row.
 * @param label Row and editor title.
 * @param value Bound numeric variable.
 * @param minimum Smallest accepted value.
 * @param maximum Largest accepted value.
 * @param step Amount added or subtracted by directional input.
 * @param decimals Number of decimal places used for display.
 * @param unit Optional suffix such as "V" or "Hz"; may be NULL.
 * @param changed Callback invoked after a new value is confirmed, or NULL.
 * @return Pointer to the created item, or NULL if the page is full.
 */
UIItem *ui_page_add_number(UIPage *page, const char *label, double *value,
                           double minimum, double maximum, double step,
                           uint8_t decimals, const char *unit,
                           UICallback changed);

/**
 * @brief Add a number editor bound to a value of an explicit C data type.
 *
 * Integer bindings are rounded when a value is committed. The configured
 * minimum and maximum should also fit in the selected storage type.
 *
 * @param page Page receiving the row.
 * @param label Row and editor title.
 * @param value Pointer to the bound variable.
 * @param type Type of the variable pointed to by value.
 * @param minimum Smallest accepted value.
 * @param maximum Largest accepted value.
 * @param step Amount added or subtracted by step input.
 * @param decimals Number of decimal places used for display.
 * @param unit Optional suffix such as "V", "mA" or "Hz"; may be NULL.
 * @param changed Callback invoked after a new value is confirmed, or NULL.
 * @return Pointer to the created item, or NULL for invalid input/full page.
 */
UIItem *ui_page_add_number_typed(UIPage *page, const char *label, void *value,
                                 UINumberType type, double minimum,
                                 double maximum, double step,
                                 uint8_t decimals, const char *unit,
                                 UICallback changed);

/**
 * @brief Read a number item's current bound value in a common format.
 *
 * This is intended for change callbacks that do not want to know the bound C
 * type. It reads the committed value, not the editor's temporary value.
 *
 * @param item Number item received by a callback.
 * @param value Receives the value converted to double.
 * @return true on success; false if item is not a valid number item.
 */
bool ui_number_get_value(const UIItem *item, double *value);

/**
 * @brief Add a row that opens another page.
 *
 * @param page Page receiving the row.
 * @param label Row label.
 * @param target Page opened when the row is confirmed.
 * @return Pointer to the created item, or NULL if the page is full.
 */
UIItem *ui_page_add_link(UIPage *page, const char *label, UIPage *target);

/**
 * @brief Add a non-selectable horizontal separator.
 *
 * @param page Page receiving the separator.
 * @return Pointer to the created item, or NULL if the page is full.
 */
UIItem *ui_page_add_separator(UIPage *page);

/**
 * @brief Add a user-rendered selectable row.
 *
 * @param page Page receiving the row.
 * @param label Logical label available through the returned UIItem.
 * @param draw Row drawing callback.
 * @param activate Callback invoked on confirmation, or NULL.
 * @return Pointer to the created item, or NULL if the page is full.
 */
UIItem *ui_page_add_custom(UIPage *page, const char *label,
                           UICustomDraw draw, UICallback activate);

/**
 * @brief Initialize the UI application and display its home page.
 *
 * @param ui UI application context.
 * @param home Home page.
 * @param keys Semantic key mapping. Its contents are copied by this function.
 */
void ui_init(UIApp *ui, UIPage *home, const UIKeys *keys);

/**
 * @brief Fill a key map for the template project's 4x4 matrix keyboard.
 *
 * The mapping uses 2/8 for navigation, 4/6 for adjustment, D for confirm,
 * A for back, 0-9 for numeric input and '*' as the decimal point.
 *
 * @param keys Key map to initialize.
 */
void ui_keys_use_default_4x4(UIKeys *keys);

/**
 * @brief Process input, advance animations and refresh the display.
 *
 * Call this once per main-loop iteration after keyboard_update().
 *
 * @param ui UI application context.
 * @param now Current monotonic time in milliseconds.
 */
void ui_update(UIApp *ui, uint32_t now);

/**
 * @brief Open a page with a forward slide animation.
 *
 * @param ui UI application context.
 * @param page Page to open.
 * @return true if navigation started; false for invalid input, a full page
 *         stack, or while another navigation/editor animation is active.
 */
bool ui_open(UIApp *ui, UIPage *page);

/**
 * @brief Return to the previous page with a reverse slide animation.
 *
 * @param ui UI application context.
 * @return true if navigation started; false when already on the home page or
 *         while another navigation/editor animation is active.
 */
bool ui_back(UIApp *ui);

/**
 * @brief Show a temporary notification over the current page.
 *
 * Calling this again replaces the currently displayed notification.
 *
 * @param ui UI application context.
 * @param message Notification text. It must remain valid until the notification
 *                expires or is replaced.
 * @param duration_ms Display duration in milliseconds. Pass 0 to use the
 *                    library default duration.
 */
void ui_notify(UIApp *ui, const char *message, uint32_t duration_ms);

#ifdef __cplusplus
}
#endif
