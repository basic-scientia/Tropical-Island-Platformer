extends CanvasLayer

func _ready():
    if not DisplayServer.is_touchscreen_available():
        hide()
        process_mode = PROCESS_MODE_DISABLED
        return

    _make_btn("move_left", "◀", Vector2(80, 620), Vector2(100, 80))
    _make_btn("move_right", "▶", Vector2(200, 620), Vector2(100, 80))
    _make_btn("jump", "▲", Vector2(1100, 620), Vector2(120, 90))

func _make_btn(action, label, pos, size):
    var btn = Button.new()
    btn.text = label
    btn.position = pos - size / 2
    btn.size = size
    btn.add_theme_font_size_override("font_size", 36)
    var bg = Color(1, 1, 1, 0.25)
    btn.add_theme_stylebox_override("normal", _make_style(bg))
    btn.add_theme_stylebox_override("pressed", _make_style(Color(1, 1, 1, 0.5)))
    btn.add_theme_color_override("font_color", Color(1, 1, 1, 0.8))

    if action == "jump":
        btn.button_down.connect(func():
            Input.action_press(action))
        btn.button_up.connect(func():
            Input.action_release(action))
    else:
        btn.button_down.connect(func():
            Input.action_press(action, 1.0))
        btn.button_up.connect(func():
            Input.action_release(action))

    add_child(btn)

func _make_style(c):
    var s = StyleBoxFlat.new()
    s.bg_color = c
    s.corner_radius_top_left = 12
    s.corner_radius_top_right = 12
    s.corner_radius_bottom_left = 12
    s.corner_radius_bottom_right = 12
    s.content_margin_left = 8
    s.content_margin_right = 8
    s.content_margin_top = 8
    s.content_margin_bottom = 8
    return s
