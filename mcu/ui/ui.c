#include "ui.h"

#include <stdio.h>
#include <string.h>

#define UI_FONT_ASCII       OLED_6X8_HALF
#define UI_FONT_CHINESE     OLED_8X8_FULL
#define UI_FONT_HEIGHT      8
#define UI_ROW_HEIGHT       12
#define UI_CONTENT_TOP      12
#define UI_VISIBLE_ROWS     4
#define UI_MARGIN           2
#define UI_ANIMATION_RATE   0.018f
#define UI_POPUP_WIDTH      112.0f
#define UI_POPUP_HEIGHT     40.0f
#define UI_NOTICE_DEFAULT_MS 1200U

static UIPageState *current_state(UIApp *ui)
{
    return (ui == NULL || ui->depth == 0U) ? NULL
                                            : &ui->stack[ui->depth - 1U];
}

static bool selectable(const UIItem *item)
{
    return item != NULL &&
           (item->type == UI_ITEM_ACTION || item->type == UI_ITEM_TOGGLE ||
            item->type == UI_ITEM_CHOICE || item->type == UI_ITEM_NUMBER ||
            item->type == UI_ITEM_LINK || item->type == UI_ITEM_CUSTOM);
}

static float approach(float value, float target, float amount)
{
    float distance = target - value;
    if (distance < 0.5f && distance > -0.5f) {
        return target;
    }
    if (amount > 1.0f) {
        amount = 1.0f;
    }
    return value + distance * amount;
}

static float animation_amount(const UIApp *ui)
{
    uint32_t delta = ui->now - ui->last_tick;
    float amount = UI_ANIMATION_RATE * (float)delta;
    return amount < 0.12f ? 0.12f : amount;
}

static UIItem *new_item(UIPage *page, UIItemType type, const char *label)
{
    UIItem *item;
    if (page == NULL || page->item_count >= UI_MAX_ITEMS) {
        return NULL;
    }
    item = &page->items[page->item_count++];
    memset(item, 0, sizeof(*item));
    item->type = type;
    item->label = label;
    return item;
}

void ui_page_init(UIPage *page, const char *title)
{
    if (page == NULL) {
        return;
    }
    memset(page, 0, sizeof(*page));
    page->title = title;
}

void ui_page_on_enter(UIPage *page, UIPageCallback callback)
{
    if (page != NULL) {
        page->on_enter = callback;
    }
}

void ui_page_on_leave(UIPage *page, UIPageCallback callback)
{
    if (page != NULL) {
        page->on_leave = callback;
    }
}

UIItem *ui_page_add_text(UIPage *page, const char *label, const char *text)
{
    UIItem *item = new_item(page, UI_ITEM_TEXT, label);
    if (item != NULL) {
        item->data.text.text = text;
    }
    return item;
}

UIItem *ui_page_add_dynamic_text(UIPage *page, const char *label,
                                 UITextProvider provider)
{
    UIItem *item = new_item(page, UI_ITEM_TEXT, label);
    if (item != NULL) {
        item->data.text.provider = provider;
    }
    return item;
}

UIItem *ui_page_add_action(UIPage *page, const char *label,
                           UICallback callback)
{
    UIItem *item = new_item(page, UI_ITEM_ACTION, label);
    if (item != NULL) {
        item->data.action.callback = callback;
    }
    return item;
}

UIItem *ui_page_add_toggle(UIPage *page, const char *label, bool *value,
                           UICallback changed)
{
    UIItem *item = new_item(page, UI_ITEM_TOGGLE, label);
    if (item != NULL) {
        item->data.toggle.value = value;
        item->data.toggle.changed = changed;
    }
    return item;
}

UIItem *ui_page_add_choice(UIPage *page, const char *label, uint8_t *value,
                           const char *const options[], uint8_t option_count,
                           UICallback changed)
{
    UIItem *item = new_item(page, UI_ITEM_CHOICE, label);
    if (item != NULL) {
        item->data.choice.value = value;
        item->data.choice.options = options;
        item->data.choice.count = option_count;
        item->data.choice.changed = changed;
    }
    return item;
}

UIItem *ui_page_add_number(UIPage *page, const char *label, double *value,
                           double minimum, double maximum, double step,
                           uint8_t decimals, const char *unit,
                           UICallback changed)
{
    return ui_page_add_number_typed(page, label, value, UI_NUMBER_DOUBLE,
                                    minimum, maximum, step, decimals, unit,
                                    changed);
}

UIItem *ui_page_add_number_typed(UIPage *page, const char *label, void *value,
                                 UINumberType type, double minimum,
                                 double maximum, double step,
                                 uint8_t decimals, const char *unit,
                                 UICallback changed)
{
    UIItem *item;
    if (value == NULL || type > UI_NUMBER_DOUBLE) {
        return NULL;
    }
    item = new_item(page, UI_ITEM_NUMBER, label);
    if (item != NULL) {
        item->data.number.value = value;
        item->data.number.type = type;
        item->data.number.minimum = minimum;
        item->data.number.maximum = maximum;
        item->data.number.step = step;
        item->data.number.decimals = decimals;
        item->data.number.unit = unit;
        item->data.number.changed = changed;
    }
    return item;
}

bool ui_number_get_value(const UIItem *item, double *value)
{
    if (item == NULL || value == NULL || item->type != UI_ITEM_NUMBER ||
        item->data.number.value == NULL) {
        return false;
    }
    switch (item->data.number.type) {
    case UI_NUMBER_INT8:   *value = *(int8_t *)item->data.number.value; break;
    case UI_NUMBER_UINT8:  *value = *(uint8_t *)item->data.number.value; break;
    case UI_NUMBER_INT16:  *value = *(int16_t *)item->data.number.value; break;
    case UI_NUMBER_UINT16: *value = *(uint16_t *)item->data.number.value; break;
    case UI_NUMBER_INT32:  *value = *(int32_t *)item->data.number.value; break;
    case UI_NUMBER_UINT32: *value = *(uint32_t *)item->data.number.value; break;
    case UI_NUMBER_FLOAT:  *value = *(float *)item->data.number.value; break;
    case UI_NUMBER_DOUBLE: *value = *(double *)item->data.number.value; break;
    default: return false;
    }
    return true;
}

static void number_set_value(UIItem *item, double value)
{
    double rounded;
    if (item == NULL || item->data.number.value == NULL) {
        return;
    }
    rounded = value < 0.0 ? value - 0.5 : value + 0.5;
    switch (item->data.number.type) {
    case UI_NUMBER_INT8:   *(int8_t *)item->data.number.value = (int8_t)rounded; break;
    case UI_NUMBER_UINT8:  *(uint8_t *)item->data.number.value = (uint8_t)rounded; break;
    case UI_NUMBER_INT16:  *(int16_t *)item->data.number.value = (int16_t)rounded; break;
    case UI_NUMBER_UINT16: *(uint16_t *)item->data.number.value = (uint16_t)rounded; break;
    case UI_NUMBER_INT32:  *(int32_t *)item->data.number.value = (int32_t)rounded; break;
    case UI_NUMBER_UINT32: *(uint32_t *)item->data.number.value = (uint32_t)rounded; break;
    case UI_NUMBER_FLOAT:  *(float *)item->data.number.value = (float)value; break;
    case UI_NUMBER_DOUBLE: *(double *)item->data.number.value = value; break;
    default: break;
    }
}

UIItem *ui_page_add_link(UIPage *page, const char *label, UIPage *target)
{
    UIItem *item = new_item(page, UI_ITEM_LINK, label);
    if (item != NULL) {
        item->data.link.page = target;
    }
    return item;
}

UIItem *ui_page_add_separator(UIPage *page)
{
    return new_item(page, UI_ITEM_SEPARATOR, NULL);
}

UIItem *ui_page_add_custom(UIPage *page, const char *label,
                           UICustomDraw draw, UICallback activate)
{
    UIItem *item = new_item(page, UI_ITEM_CUSTOM, label);
    if (item != NULL) {
        item->data.custom.draw = draw;
        item->data.custom.activate = activate;
    }
    return item;
}

static void select_first(UIPageState *state)
{
    uint8_t i;
    state->selected = 0U;
    state->scroll = 0U;
    for (i = 0U; i < state->page->item_count; ++i) {
        if (selectable(&state->page->items[i])) {
            state->selected = i;
            return;
        }
    }
}

static void update_cursor_target(UIApp *ui)
{
    UIPageState *state = current_state(ui);
    if (state != NULL && state->selected >= state->scroll &&
        state->selected < state->scroll + UI_VISIBLE_ROWS) {
        ui->cursor_target_y =
            (float)(UI_CONTENT_TOP +
                    (state->selected - state->scroll) * UI_ROW_HEIGHT - 1);
        if (!ui->cursor_ready) {
            ui->cursor_y = ui->cursor_target_y;
            ui->cursor_ready = true;
        }
    }
}

void ui_init(UIApp *ui, UIPage *home, const UIKeys *keys)
{
    if (ui == NULL) {
        return;
    }
    memset(ui, 0, sizeof(*ui));
    if (keys != NULL) {
        ui->keys = *keys;
    }
    if (home != NULL) {
        ui->stack[0].page = home;
        ui->depth = 1U;
        select_first(&ui->stack[0]);
        update_cursor_target(ui);
        if (home->on_enter != NULL) {
            home->on_enter(ui, home);
        }
    }
}

void ui_keys_use_default_4x4(UIKeys *keys)
{
    uint8_t digit;
    if (keys == NULL) {
        return;
    }
    memset(keys, 0, sizeof(*keys));
    keys->up = &keyboard_keys[0][1];       /* 2 */
    keys->down = &keyboard_keys[2][1];     /* 8 */
    keys->left = &keyboard_keys[1][0];     /* 4 */
    keys->right = &keyboard_keys[1][2];    /* 6 */
    keys->ok = &keyboard_keys[3][3];       /* D */
    keys->back = &keyboard_keys[0][3];     /* A */
    keys->scroll_up = &keyboard_keys[1][3];   /* B */
    keys->scroll_down = &keyboard_keys[2][3]; /* C */
    keys->start_number_input = &keyboard_keys[3][2]; /* # */
    keys->decimal = &keyboard_keys[3][0];  /* * */
    for (digit = 1U; digit <= 9U; ++digit) {
        uint8_t index = digit - 1U;
        keys->digits[digit] = &keyboard_keys[index / 3U][index % 3U];
    }
    keys->digits[0] = &keyboard_keys[3][1];
}

static void move_selection(UIApp *ui, int8_t direction)
{
    UIPageState *state = current_state(ui);
    uint8_t tries;
    int16_t next;
    if (state == NULL || state->page->item_count == 0U) {
        return;
    }
    next = state->selected;
    for (tries = 0U; tries < state->page->item_count; ++tries) {
        next += direction;
        if (next < 0) {
            next = state->page->item_count - 1;
        } else if (next >= state->page->item_count) {
            next = 0;
        }
        if (selectable(&state->page->items[next])) {
            state->selected = (uint8_t)next;
            if (state->selected < state->scroll) {
                state->scroll = state->selected;
            } else if (state->selected >= state->scroll + UI_VISIBLE_ROWS) {
                state->scroll = state->selected - UI_VISIBLE_ROWS + 1U;
            }
            update_cursor_target(ui);
            return;
        }
    }
}

static void scroll_page(UIApp *ui, int8_t direction)
{
    UIPageState *state = current_state(ui);
    uint8_t maximum;
    if (state == NULL || state->page->item_count <= UI_VISIBLE_ROWS) {
        return;
    }
    maximum = state->page->item_count - UI_VISIBLE_ROWS;
    if (direction < 0 && state->scroll > 0U) {
        --state->scroll;
    } else if (direction > 0 && state->scroll < maximum) {
        ++state->scroll;
    }
    update_cursor_target(ui);
}

bool ui_open(UIApp *ui, UIPage *page)
{
    UIPageState *state;
    UIPage *old_page;
    if (ui == NULL || page == NULL || ui->depth >= UI_STACK_DEPTH ||
        ui->page_animating || ui->editor_open) {
        return false;
    }
    state = current_state(ui);
    old_page = state == NULL ? NULL : state->page;
    if (old_page != NULL && old_page->on_leave != NULL) {
        old_page->on_leave(ui, old_page);
    }
    ui->outgoing_page = old_page;
    ui->outgoing_x = 0.0f;
    state = &ui->stack[ui->depth++];
    state->page = page;
    select_first(state);
    ui->page_x = OLED_WIDTH;
    ui->page_animating = true;
    ui->cursor_ready = false;
    update_cursor_target(ui);
    if (page->on_enter != NULL) {
        page->on_enter(ui, page);
    }
    return true;
}

bool ui_back(UIApp *ui)
{
    UIPage *old_page;
    UIPage *new_page;
    if (ui == NULL || ui->depth <= 1U || ui->page_animating ||
        ui->editor_open) {
        return false;
    }
    old_page = current_state(ui)->page;
    if (old_page->on_leave != NULL) {
        old_page->on_leave(ui, old_page);
    }
    ui->outgoing_page = old_page;
    ui->outgoing_x = 0.0f;
    --ui->depth;
    new_page = current_state(ui)->page;
    ui->page_x = -OLED_WIDTH;
    ui->page_animating = true;
    ui->cursor_ready = false;
    update_cursor_target(ui);
    if (new_page->on_enter != NULL) {
        new_page->on_enter(ui, new_page);
    }
    return true;
}

static UIItem *selected_item(UIApp *ui)
{
    UIPageState *state = current_state(ui);
    return state == NULL || state->selected >= state->page->item_count
               ? NULL : &state->page->items[state->selected];
}

static bool pressed(Key *key)
{
    return key != NULL && key->signal_event == KEY_PRESS;
}

static void open_editor(UIApp *ui, UIItem *item)
{
    if (item->type == UI_ITEM_CHOICE && item->data.choice.value != NULL &&
        item->data.choice.count > 0U) {
        ui->edit_choice = *item->data.choice.value;
        ui->previous_choice = ui->edit_choice;
    } else if (item->type == UI_ITEM_NUMBER &&
               item->data.number.value != NULL) {
        (void)ui_number_get_value(item, &ui->edit_number);
    } else {
        return;
    }
    ui->editor_open = true;
    ui->editor_closing = false;
    ui->popup_width = 0.0f;
    ui->popup_height = 0.0f;
    ui->choice_slide = 0.0f;
    ui->number_typing = false;
    ui->number_input_length = 0U;
    ui->number_input[0] = '\0';
}

static void close_editor(UIApp *ui, bool commit)
{
    UIItem *item = selected_item(ui);
    UICallback changed = NULL;
    if (item == NULL) {
        return;
    }
    if (commit) {
        if (item->type == UI_ITEM_CHOICE) {
            *item->data.choice.value = ui->edit_choice;
            changed = item->data.choice.changed;
        } else if (item->type == UI_ITEM_NUMBER) {
            number_set_value(item, ui->edit_number);
            changed = item->data.number.changed;
        }
    }
    ui->editor_closing = true;
    if (changed != NULL) {
        changed(ui, item);
    }
}

static void change_editor(UIApp *ui, UIItem *item, int8_t direction)
{
    if (item->type == UI_ITEM_CHOICE) {
        int16_t next;
        if (ui->choice_slide != 0.0f) {
            return;
        }
        ui->previous_choice = ui->edit_choice;
        next = (int16_t)ui->edit_choice + direction;
        if (next < 0) {
            next = item->data.choice.count - 1;
        } else if (next >= item->data.choice.count) {
            next = 0;
        }
        ui->edit_choice = (uint8_t)next;
        ui->choice_slide = direction > 0 ? UI_POPUP_WIDTH : -UI_POPUP_WIDTH;
    } else if (item->type == UI_ITEM_NUMBER) {
        ui->edit_number += direction * item->data.number.step;
        if (ui->edit_number < item->data.number.minimum) {
            ui->edit_number = item->data.number.minimum;
        } else if (ui->edit_number > item->data.number.maximum) {
            ui->edit_number = item->data.number.maximum;
        }
    }
}

static double parse_number(const char *text)
{
    double value = 0.0;
    double fraction = 0.1;
    bool after_decimal = false;
    while (*text != '\0') {
        if (*text == '.') {
            after_decimal = true;
        } else if (*text >= '0' && *text <= '9') {
            if (after_decimal) {
                value += (*text - '0') * fraction;
                fraction *= 0.1;
            } else {
                value = value * 10.0 + (*text - '0');
            }
        }
        ++text;
    }
    return value;
}

static bool process_number_key(UIApp *ui, UIItem *item)
{
    uint8_t digit;
    char input = '\0';
    bool has_decimal;

    if (item->type != UI_ITEM_NUMBER || !ui->number_typing) {
        return false;
    }
    for (digit = 0U; digit <= 9U; ++digit) {
        if (pressed(ui->keys.digits[digit])) {
            input = (char)('0' + digit);
            break;
        }
    }
    if (input == '\0' && pressed(ui->keys.decimal)) {
        has_decimal = strchr(ui->number_input, '.') != NULL;
        if (!has_decimal) {
            input = '.';
        }
    }
    if (input == '\0') {
        return false;
    }
    if (ui->number_input_length == 0U && input == '.') {
        ui->number_input[ui->number_input_length++] = '0';
    }
    if (ui->number_input_length < sizeof(ui->number_input) - 1U) {
        ui->number_input[ui->number_input_length++] = input;
        ui->number_input[ui->number_input_length] = '\0';
        ui->edit_number = parse_number(ui->number_input);
        if (ui->edit_number > item->data.number.maximum) {
            ui->edit_number = item->data.number.maximum;
        }
    }
    return true;
}

static void process_input(UIApp *ui)
{
    UIItem *item;
    if (ui->page_animating || ui->editor_closing) {
        return;
    }
    item = selected_item(ui);
    if (item == NULL) {
        return;
    }
    if (ui->editor_open) {
        if (item->type == UI_ITEM_NUMBER &&
            pressed(ui->keys.start_number_input)) {
            ui->number_typing = !ui->number_typing;
            if (ui->number_typing) {
                ui->number_input_length = 0U;
                ui->number_input[0] = '\0';
            }
            return;
        } else if (process_number_key(ui, item)) {
            return;
        } else if (pressed(ui->keys.left) || pressed(ui->keys.down)) {
            ui->number_typing = false;
            change_editor(ui, item, -1);
        } else if (pressed(ui->keys.right) || pressed(ui->keys.up)) {
            ui->number_typing = false;
            change_editor(ui, item, 1);
        } else if (pressed(ui->keys.ok)) {
            close_editor(ui, true);
        } else if (pressed(ui->keys.back)) {
            close_editor(ui, false);
        }
        return;
    }
    if (pressed(ui->keys.up)) {
        move_selection(ui, -1);
    } else if (pressed(ui->keys.down)) {
        move_selection(ui, 1);
    } else if (pressed(ui->keys.scroll_up)) {
        scroll_page(ui, -1);
    } else if (pressed(ui->keys.scroll_down)) {
        scroll_page(ui, 1);
    } else if (pressed(ui->keys.back)) {
        (void)ui_back(ui);
    } else if (pressed(ui->keys.left) || pressed(ui->keys.right)) {
        if (item->type == UI_ITEM_CHOICE || item->type == UI_ITEM_NUMBER) {
            open_editor(ui, item);
            change_editor(ui, item, pressed(ui->keys.right) ? 1 : -1);
        }
    } else if (pressed(ui->keys.ok)) {
        switch (item->type) {
        case UI_ITEM_ACTION:
            if (item->data.action.callback != NULL) {
                item->data.action.callback(ui, item);
            }
            break;
        case UI_ITEM_TOGGLE:
            if (item->data.toggle.value != NULL) {
                *item->data.toggle.value = !*item->data.toggle.value;
                if (item->data.toggle.changed != NULL) {
                    item->data.toggle.changed(ui, item);
                }
            }
            break;
        case UI_ITEM_CHOICE:
        case UI_ITEM_NUMBER:
            open_editor(ui, item);
            break;
        case UI_ITEM_LINK:
            (void)ui_open(ui, item->data.link.page);
            break;
        case UI_ITEM_CUSTOM:
            if (item->data.custom.activate != NULL) {
                item->data.custom.activate(ui, item);
            }
            break;
        default:
            break;
        }
    }
}

static uint16_t text_width(const char *text)
{
    return text == NULL ? 0U : (uint16_t)(strlen(text) * UI_FONT_ASCII);
}

static void draw_text(int16_t x, int16_t y, const char *text)
{
    if (text != NULL) {
        oled_show_mix_string(x, y, text, UI_FONT_CHINESE, UI_FONT_ASCII);
    }
}

static const char *item_value(UIApp *ui, UIItem *item)
{
    uint8_t index;
    switch (item->type) {
    case UI_ITEM_TEXT:
        return item->data.text.provider == NULL
                   ? item->data.text.text
                   : item->data.text.provider(ui->text_buffer,
                                              sizeof(ui->text_buffer));
    case UI_ITEM_TOGGLE:
        return item->data.toggle.value != NULL && *item->data.toggle.value
                   ? "ON" : "OFF";
    case UI_ITEM_CHOICE:
        if (item->data.choice.value == NULL || item->data.choice.count == 0U) {
            return "";
        }
        index = *item->data.choice.value;
        return index < item->data.choice.count
                   ? item->data.choice.options[index] : "";
    case UI_ITEM_NUMBER:
        if (item->data.number.value != NULL) {
            double number = 0.0;
            (void)ui_number_get_value(item, &number);
            (void)snprintf(ui->text_buffer, sizeof(ui->text_buffer), "%.*f%s",
                           item->data.number.decimals,
                           number,
                           item->data.number.unit == NULL
                               ? "" : item->data.number.unit);
            return ui->text_buffer;
        }
        return "";
    case UI_ITEM_ACTION:
    case UI_ITEM_LINK:
        return ">";
    default:
        return "";
    }
}

static void draw_page(UIApp *ui, UIPage *page, const UIPageState *state,
                      int16_t offset, bool active)
{
    uint8_t row;
    uint8_t index;
    int16_t y;
    UIItem *item;
    const char *value;
    int16_t value_x;

    draw_text(offset + 6, 0, page->title);
    oled_draw_rectangle(offset, 0, 3, UI_FONT_HEIGHT, true);
    oled_draw_line(offset, 10, offset + OLED_WIDTH - 1, 10);

    for (row = 0U; row < UI_VISIBLE_ROWS; ++row) {
        index = state->scroll + row;
        if (index >= page->item_count) {
            break;
        }
        item = &page->items[index];
        y = UI_CONTENT_TOP + row * UI_ROW_HEIGHT;
        if (item->type == UI_ITEM_SEPARATOR) {
            oled_draw_line(offset + UI_MARGIN, y + 4,
                           offset + OLED_WIDTH - UI_MARGIN - 1, y + 4);
        } else if (item->type == UI_ITEM_CUSTOM &&
                   item->data.custom.draw != NULL) {
            item->data.custom.draw(ui, offset + UI_MARGIN, y,
                                   OLED_WIDTH - UI_MARGIN * 2,
                                   UI_FONT_HEIGHT);
        } else {
            draw_text(offset + UI_MARGIN, y, item->label);
            value = item_value(ui, item);
            value_x = offset + OLED_WIDTH - UI_MARGIN - text_width(value);
            if (value_x > offset + 40) {
                draw_text(value_x, y, value);
            }
        }
    }
    if (active && ui->cursor_ready &&
        state->selected < page->item_count &&
        state->selected >= state->scroll &&
        state->selected < state->scroll + UI_VISIBLE_ROWS &&
        selectable(&page->items[state->selected])) {
        oled_reverse_area(offset, (int16_t)ui->cursor_y, OLED_WIDTH,
                          UI_FONT_HEIGHT + 2);
    }
    if (state->scroll > 0U) {
        oled_draw_triangle(offset + OLED_WIDTH - 4, 13,
                           offset + OLED_WIDTH - 1, 13,
                           offset + OLED_WIDTH - 2, 11, true);
    }
    if (state->scroll + UI_VISIBLE_ROWS < page->item_count) {
        oled_draw_triangle(offset + OLED_WIDTH - 4, 60,
                           offset + OLED_WIDTH - 1, 60,
                           offset + OLED_WIDTH - 2, 63, true);
    }
}

static void draw_editor(UIApp *ui, UIItem *item)
{
    int16_t width = (int16_t)ui->popup_width;
    int16_t height = (int16_t)ui->popup_height;
    int16_t x = (OLED_WIDTH - width) / 2;
    int16_t y = (OLED_HEIGHT - height) / 2;
    int16_t text_y;
    const char *option;

    if (width <= 0 || height <= 0) {
        return;
    }
    oled_clear_area(x, y, width, height);
    oled_draw_rounded_rectangle(x, y, width, height, 2, false);
    if (width < 50 || height < 20) {
        return;
    }
    draw_text(x + 5, y + 3, item->label);
    oled_draw_line(x + 3, y + 12, x + width - 4, y + 12);
    text_y = y + 20;
    if (item->type == UI_ITEM_CHOICE) {
        option = item->data.choice.options[ui->edit_choice];
        oled_show_mix_string_area(
            x + 11, text_y, width - 22, UI_FONT_HEIGHT,
            x + (width - text_width(option)) / 2 +
                (int16_t)ui->choice_slide,
            text_y, option, UI_FONT_CHINESE, UI_FONT_ASCII);
        if (ui->choice_slide != 0.0f) {
            option = item->data.choice.options[ui->previous_choice];
            oled_show_mix_string_area(
                x + 11, text_y, width - 22, UI_FONT_HEIGHT,
                x + (width - text_width(option)) / 2 +
                    (int16_t)ui->choice_slide +
                    (ui->choice_slide > 0 ? -width : width),
                text_y, option, UI_FONT_CHINESE, UI_FONT_ASCII);
        }
        draw_text(x + 5, text_y, "<");
        draw_text(x + width - 10, text_y, ">");
    } else {
        if (ui->number_typing) {
            (void)snprintf(ui->text_buffer, sizeof(ui->text_buffer), "%s%s",
                           ui->number_input,
                           item->data.number.unit == NULL
                               ? "" : item->data.number.unit);
        } else {
            (void)snprintf(ui->text_buffer, sizeof(ui->text_buffer), "%.*f%s",
                           item->data.number.decimals, ui->edit_number,
                           item->data.number.unit == NULL
                               ? "" : item->data.number.unit);
        }
        draw_text(x + (width - text_width(ui->text_buffer)) / 2,
                  text_y, ui->text_buffer);
        draw_text(x + 5, text_y, "-");
        draw_text(x + width - 10, text_y, "+");
    }
}

static void draw_notice(UIApp *ui)
{
    int16_t width;
    int16_t x;
    if (ui->notice == NULL) {
        return;
    }
    width = text_width(ui->notice) + 10;
    if (width > OLED_WIDTH - 4) {
        width = OLED_WIDTH - 4;
    }
    x = (OLED_WIDTH - width) / 2;
    oled_clear_area(x, 25, width, 16);
    oled_draw_rounded_rectangle(x, 25, width, 16, 2, false);
    draw_text(x + 5, 29, ui->notice);
}

static void update_animations(UIApp *ui)
{
    float amount = animation_amount(ui);
    if (ui->page_animating) {
        bool entering_from_right = ui->page_x > 0.0f;
        ui->page_x = approach(ui->page_x, 0.0f, amount);
        ui->outgoing_x = approach(
            ui->outgoing_x,
            entering_from_right ? -OLED_WIDTH : OLED_WIDTH, amount);
        if (ui->page_x == 0.0f) {
            ui->page_animating = false;
            ui->outgoing_page = NULL;
        }
    }
    ui->cursor_y = approach(ui->cursor_y, ui->cursor_target_y, amount);
    if (ui->editor_open) {
        float target_width = ui->editor_closing ? 0.0f : UI_POPUP_WIDTH;
        float target_height = ui->editor_closing ? 0.0f : UI_POPUP_HEIGHT;
        ui->popup_width = approach(ui->popup_width, target_width, amount);
        ui->popup_height = approach(ui->popup_height, target_height, amount);
        if (ui->editor_closing && ui->popup_width == 0.0f) {
            ui->editor_open = false;
            ui->editor_closing = false;
        }
    }
    ui->choice_slide = approach(ui->choice_slide, 0.0f, amount);
}

void ui_update(UIApp *ui, uint32_t now)
{
    UIPageState *state;
    UIPageState outgoing_state;
    if (ui == NULL) {
        return;
    }
    ui->last_tick = ui->now;
    ui->now = now;
    if (ui->notice != NULL && (int32_t)(now - ui->notice_until) >= 0) {
        ui->notice = NULL;
    }
    process_input(ui);
    update_animations(ui);
    oled_clear();
    state = current_state(ui);
    if (ui->outgoing_page != NULL) {
        outgoing_state = ui->page_x > 0.0f
                             ? ui->stack[ui->depth - 2U]
                             : ui->stack[ui->depth];
        draw_page(ui, ui->outgoing_page, &outgoing_state,
                  (int16_t)ui->outgoing_x, false);
    }
    if (state != NULL) {
        draw_page(ui, state->page, state, (int16_t)ui->page_x, true);
    }
    if (ui->editor_open) {
        draw_editor(ui, selected_item(ui));
    }
    draw_notice(ui);
    oled_refresh();
}

void ui_notify(UIApp *ui, const char *message, uint32_t duration_ms)
{
    if (ui != NULL) {
        ui->notice = message;
        ui->notice_until =
            ui->now + (duration_ms == 0U ? UI_NOTICE_DEFAULT_MS
                                         : duration_ms);
    }
}
