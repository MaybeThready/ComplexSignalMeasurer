# Animated OLED UI

这个版本保留菜单滑动、光标缓动、编辑弹窗缩放和选择项滑动动效，同时将应用接口简化为页面构建器。

## 心智模型

用户只需要记住三件事：

1. `ui_page_init()` 创建页面。
2. `ui_page_add_*()` 按显示顺序添加内容。
3. `ui_keys_use_default_4x4()` 使用模板键盘布局。
4. `ui_init()` 启动，主循环调用 `ui_update()`。

例如，一个设置页面只需要：

```c
ui_page_init(&settings, "Settings");
ui_page_add_toggle(&settings, "Output", &output_enabled, changed);
ui_page_add_number(&settings, "Voltage", &voltage,
                   0.0, 5.0, 0.1, 1, "V", changed);
ui_page_add_link(&main_page, "Settings", &settings);
```

不需要菜单项数组、嵌套 `base`、联合体初始化、父页面设置或手工管理焦点。

## 可添加内容

- `ui_page_add_text`：静态只读文本
- `ui_page_add_dynamic_text`：动态文本
- `ui_page_add_action`：动作
- `ui_page_add_toggle`：开关
- `ui_page_add_choice`：枚举选择
- `ui_page_add_number`：范围数值
- `ui_page_add_link`：子页面
- `ui_page_add_separator`：分隔线
- `ui_page_add_custom`：自定义行

这些函数返回 `UIItem *`。大多数应用可以忽略返回值；需要保存某个项目句柄时再使用它。

## 内置动效

- 进入子页面时，新页面从右侧进入，旧页面向左退出。
- 返回时执行反向页面滑动。
- 光标在菜单项之间平滑移动。
- 数值和枚举编辑器以缩放弹窗打开、关闭。
- 枚举选项左右切换时带方向滑动。

动效由 `ui_update()` 驱动，不阻塞主循环。

## 编辑规则

- 上/下移动菜单焦点。
- 确认进入编辑，编辑后再次确认提交。
- 左/右可直接进入编辑并减小/增大。
- 数值编辑器支持 `0`～`9` 和小数点直接输入。
- `B` / `C`：不改变焦点，手动向上 / 向下滚动页面。
- Number 编辑时左 / 右执行步进减小 / 增加。
- Number 编辑时按 `#` 进入或退出数字直输模式。
- 编辑时返回会取消修改；浏览时返回上级页面。
- 数值自动限制在指定范围内。

完整示例见 [ui_config.c](../ui_config.c)。

## Number 类型、单位与回调取值

常用 `double` 可以使用 `ui_page_add_number()`。其他类型使用
`ui_page_add_number_typed()`，支持有符号/无符号 8、16、32 位整数以及
`float`、`double`。

```c
static uint16_t samples = 128;

ui_page_add_number_typed(
    &signal_page, "Samples", &samples, UI_NUMBER_UINT16,
    16, 4096, 16, 0, "pts", samples_changed
);
```

单位由倒数第二个参数指定，传 `NULL` 表示无单位。

回调可以直接访问原变量，也可以使用统一读取接口：

```c
static void samples_changed(UIApp *ui, UIItem *item)
{
    double value;
    if (ui_number_get_value(item, &value)) {
        /* value 是已经确认并写回的数据 */
    }
}
```

## 时间单位

`ui_update()` 的 `now` 和 `ui_notify()` 的显示时长都使用毫秒。模板中的
`sys_tick` 每 1 ms 自增，因此可以直接传给 `ui_update()`。

```c
ui_notify(&ui, "Saved", 600); /* 显示 600 ms */
ui_notify(&ui, "Ready", 0);   /* 使用默认的 1200 ms */
```
