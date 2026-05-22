extends Node2D

const SCREEN_W = 1280
const SCREEN_H = 720
const GROUND_Y = 650
const LEVEL_W = 3000
const LEVEL_H = 3500

var player = null
var hud = null
var camera = null
var goal = null
var won = false
var game_started = false
var start_time = 0
var continue_cost = 30
var death_pos = Vector2()

func _ready():
    _setup_inputs()
    _create_background()
    _create_start_screen()
    _create_clouds()

func _process(delta):
    if game_started and player and camera:
        camera.position = camera.position.lerp(player.position, 8.0 * delta)
    if game_started and hud:
        var elapsed = (Time.get_ticks_msec() - start_time) / 1000.0
        hud.update_time(elapsed)

func _setup_inputs():
    if InputMap.has_action("move_left"):
        return
    var left = InputEventKey.new()
    left.keycode = KEY_A
    InputMap.add_action("move_left")
    InputMap.action_add_event("move_left", left)
    var left2 = InputEventKey.new()
    left2.keycode = KEY_LEFT
    InputMap.action_add_event("move_left", left2)
    var right = InputEventKey.new()
    right.keycode = KEY_D
    InputMap.add_action("move_right")
    InputMap.action_add_event("move_right", right)
    var right2 = InputEventKey.new()
    right2.keycode = KEY_RIGHT
    InputMap.action_add_event("move_right", right2)
    var jump = InputEventKey.new()
    jump.keycode = KEY_SPACE
    InputMap.add_action("jump")
    InputMap.action_add_event("jump", jump)
    var jump2 = InputEventKey.new()
    jump2.keycode = KEY_W
    InputMap.action_add_event("jump", jump2)
    var jump3 = InputEventKey.new()
    jump3.keycode = KEY_UP
    InputMap.action_add_event("jump", jump3)

func _create_background():
    var sky = ColorRect.new()
    sky.color = Color(0.53, 0.81, 0.98)
    sky.size = Vector2(LEVEL_W + 400, LEVEL_H + 400)
    sky.position = Vector2(-200, -200)
    sky.z_index = -10
    add_child(sky)
    var sea = ColorRect.new()
    sea.color = Color(0.1, 0.5, 0.7)
    sea.size = Vector2(LEVEL_W + 400, 100)
    sea.position = Vector2(-200, GROUND_Y + 40)
    sea.z_index = -9
    add_child(sea)
    var sun = Node2D.new()
    sun.position = Vector2(1100, 80)
    sun.set_script(preload("res://sun.gd"))
    sun.z_index = -8
    add_child(sun)

func _create_start_screen():
    var overlay = CanvasLayer.new()
    overlay.name = "StartScreen"

    var bg = ColorRect.new()
    bg.color = Color(0, 0, 0, 0.65)
    bg.size = Vector2(SCREEN_W, SCREEN_H)
    bg.position = Vector2.ZERO
    overlay.add_child(bg)

    var title = Label.new()
    title.text = "TROPICAL ISLAND"
    title.position = Vector2(340, 180)
    title.add_theme_font_size_override("font_size", 52)
    title.add_theme_color_override("font_color", Color(1, 0.9, 0.2))
    overlay.add_child(title)

    var sub = Label.new()
    sub.text = "PLATFORMER"
    sub.position = Vector2(495, 240)
    sub.add_theme_font_size_override("font_size", 28)
    sub.add_theme_color_override("font_color", Color(1, 1, 1))
    overlay.add_child(sub)

    var btn = Button.new()
    btn.text = "START"
    btn.position = Vector2(540, 340)
    btn.size = Vector2(200, 60)
    btn.add_theme_font_size_override("font_size", 30)
    btn.pressed.connect(_on_start_pressed)
    overlay.add_child(btn)

    var controls = Label.new()
    controls.text = "A/D - Move   SPACE/W - Jump   Double jump in air"
    controls.position = Vector2(380, 430)
    controls.add_theme_font_size_override("font_size", 14)
    controls.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
    overlay.add_child(controls)

    var scores_label = Label.new()
    scores_label.name = "ScoresList"
    scores_label.position = Vector2(430, 490)
    scores_label.add_theme_font_size_override("font_size", 16)
    scores_label.add_theme_color_override("font_color", Color(1, 0.9, 0.2))
    overlay.add_child(scores_label)

    add_child(overlay)
    _display_high_scores()

func _display_high_scores():
    var list = _load_scores()
    var label = $StartScreen/ScoresList
    if list.is_empty():
        label.text = ""
    else:
        var text = "HIGH SCORES:\n"
        for i in range(min(list.size(), 5)):
            text += "  " + str(i + 1) + ".  " + list[i] + "\n"
        label.text = text

func _load_scores():
    var arr = []
    var file = FileAccess.open("user://scores.dat", FileAccess.READ)
    if file:
        while not file.eof_reached():
            var line = file.get_line().strip_edges()
            if line != "":
                arr.append(line)
        file.close()
    return arr

func _save_score(score, time_str):
    var entry = "Score: " + str(score) + "  Time: " + time_str
    var existing = _load_scores()
    existing.append(entry)
    var file = FileAccess.open("user://scores.dat", FileAccess.WRITE)
    if file:
        for e in existing:
            file.store_line(e)
        file.close()

func _on_start_pressed():
    game_started = true
    start_time = Time.get_ticks_msec()
    var start = get_node_or_null("StartScreen")
    if start:
        start.queue_free()
    _create_ground()
    _create_platforms()
    _create_player()
    _create_camera()
    _create_enemies()
    _create_fruits()
    _create_goal()
    _create_hud()
    _create_touch_controls()

func _create_ground():
    var ground = StaticBody2D.new()
    ground.position = Vector2(0, GROUND_Y)
    var collision = CollisionShape2D.new()
    var shape = RectangleShape2D.new()
    shape.size = Vector2(LEVEL_W + 400, 40)
    collision.shape = shape
    collision.position = Vector2((LEVEL_W + 400) / 2, 20)
    ground.add_child(collision)
    var sand = ColorRect.new()
    sand.color = Color(0.76, 0.60, 0.42)
    sand.size = Vector2(LEVEL_W + 400, 40)
    sand.position = Vector2(0, 0)
    ground.add_child(sand)
    add_child(ground)

func _create_platform(x, y, w, h = 20):
    var plat = StaticBody2D.new()
    plat.position = Vector2(x, y)
    var collision = CollisionShape2D.new()
    var shape = RectangleShape2D.new()
    shape.size = Vector2(w, h)
    collision.shape = shape
    plat.add_child(collision)
    var visual = ColorRect.new()
    visual.color = Color(0.4, 0.28, 0.1)
    visual.size = Vector2(w, h)
    visual.position = Vector2(-w/2, -h/2)
    plat.add_child(visual)
    var top = ColorRect.new()
    top.color = Color(0.3, 0.55, 0.15)
    top.size = Vector2(w, 4)
    top.position = Vector2(-w/2, -h/2)
    plat.add_child(top)
    add_child(plat)

func _create_platforms():
    _create_platform(150, 590, 140)
    _create_platform(400, 540, 130)
    _create_platform(650, 570, 130)
    _create_platform(250, 490, 110)
    _create_platform(550, 440, 140)
    _create_platform(850, 490, 130)
    _create_platform(400, 380, 120)
    _create_platform(700, 350, 140)
    _create_platform(1050, 410, 130)
    _create_platform(550, 290, 120)
    _create_platform(900, 280, 140)
    _create_platform(1250, 330, 120)
    _create_platform(700, 220, 110)
    _create_platform(1050, 200, 130)
    _create_platform(1400, 250, 120)
    _create_platform(850, 140, 110)
    _create_platform(1150, 110, 130)
    _create_platform(1500, 160, 120)
    _create_platform(1000, 60, 120)
    _create_platform(1300, 40, 110)
    _create_platform(1600, 70, 100)

func _create_player():
    player = CharacterBody2D.new()
    player.set_script(preload("res://player.gd"))
    player.position = Vector2(80, 580)
    var collision = CollisionShape2D.new()
    var shape = RectangleShape2D.new()
    shape.size = Vector2(20, 34)
    collision.shape = shape
    player.add_child(collision)
    player.lives_changed.connect(_on_player_lives_changed)
    player.score_changed.connect(_on_player_score_changed)
    player.death_occurred.connect(_on_death_occurred)
    add_child(player)

func _on_player_lives_changed(lives):
    if hud:
        hud.update_lives(lives)

func _on_player_score_changed(score):
    if hud:
        hud.update_score(score)

func _on_death_occurred(lives_left, pos):
    death_pos = pos
    _show_death_screen()

func _show_death_screen():
    var overlay = CanvasLayer.new()
    overlay.name = "DeathScreen"

    var bg = ColorRect.new()
    bg.color = Color(0, 0, 0, 0.65)
    bg.size = Vector2(SCREEN_W, SCREEN_H)
    bg.position = Vector2.ZERO
    overlay.add_child(bg)

    var msg = Label.new()
    msg.text = "YOU DIED"
    msg.position = Vector2(480, 220)
    msg.add_theme_font_size_override("font_size", 44)
    msg.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
    overlay.add_child(msg)

    var can_afford = player and player.score >= continue_cost

    var continue_btn = Button.new()
    continue_btn.text = "Continue here  (-" + str(continue_cost) + " pts)"
    continue_btn.position = Vector2(440, 320)
    continue_btn.size = Vector2(400, 55)
    continue_btn.add_theme_font_size_override("font_size", 22)
    continue_btn.disabled = not can_afford
    continue_btn.pressed.connect(_on_death_continue)
    overlay.add_child(continue_btn)

    var restart_btn = Button.new()
    restart_btn.text = "Return to start"
    restart_btn.position = Vector2(440, 390)
    restart_btn.size = Vector2(400, 55)
    restart_btn.add_theme_font_size_override("font_size", 22)
    restart_btn.pressed.connect(_on_death_restart)
    overlay.add_child(restart_btn)

    if not can_afford:
        var sorry = Label.new()
        sorry.text = "Not enough points to continue!"
        sorry.position = Vector2(450, 300)
        sorry.add_theme_font_size_override("font_size", 16)
        sorry.add_theme_color_override("font_color", Color(1, 0.6, 0.6))
        overlay.add_child(sorry)

    add_child(overlay)

func _on_death_continue():
    if player and player.score >= continue_cost:
        player.score -= continue_cost
        continue_cost += 10
        player.score_changed.emit(player.score)
        player.respawn(death_pos)
    var ds = get_node_or_null("DeathScreen")
    if ds:
        ds.queue_free()

func _on_death_restart():
    if player:
        player.score = 0
        continue_cost = 30
        player.score_changed.emit(player.score)
        player.respawn(Vector2(80, 580))
    var ds = get_node_or_null("DeathScreen")
    if ds:
        ds.queue_free()

func _create_camera():
    camera = Camera2D.new()
    camera.position_smoothing_enabled = true
    camera.position_smoothing_speed = 5.0
    camera.limit_left = -200
    camera.limit_right = LEVEL_W + 200
    camera.limit_top = -200
    camera.limit_bottom = LEVEL_H
    add_child(camera)
    camera.make_current()

func _create_enemy_at(x, y):
    var enemy = CharacterBody2D.new()
    enemy.set_script(preload("res://enemy.gd"))
    enemy.position = Vector2(x, y)
    var collision = CollisionShape2D.new()
    var shape = RectangleShape2D.new()
    shape.size = Vector2(28, 18)
    collision.shape = shape
    enemy.add_child(collision)
    add_child(enemy)

func _create_enemies():
    _create_enemy_at(250, 570)
    _create_enemy_at(650, 550)
    _create_enemy_at(550, 420)
    _create_enemy_at(850, 470)
    _create_enemy_at(700, 330)
    _create_enemy_at(1050, 390)
    _create_enemy_at(900, 260)
    _create_enemy_at(1250, 310)
    _create_enemy_at(1050, 180)
    _create_enemy_at(1400, 230)
    _create_enemy_at(1150, 90)

func _create_fruit_at(x, y):
    var fruit = Area2D.new()
    fruit.set_script(preload("res://fruit.gd"))
    fruit.position = Vector2(x, y)
    var collision = CollisionShape2D.new()
    var shape = CircleShape2D.new()
    shape.radius = 12
    collision.shape = shape
    fruit.add_child(collision)
    fruit.collected.connect(_on_fruit_collected)
    add_child(fruit)

func _on_fruit_collected():
    if player:
        player.score += 10
        player.score_changed.emit(player.score)

func _create_fruits():
    _create_fruit_at(200, 560)
    _create_fruit_at(450, 510)
    _create_fruit_at(700, 540)
    _create_fruit_at(300, 460)
    _create_fruit_at(600, 410)
    _create_fruit_at(900, 460)
    _create_fruit_at(450, 350)
    _create_fruit_at(750, 320)
    _create_fruit_at(1100, 380)
    _create_fruit_at(600, 260)
    _create_fruit_at(950, 250)
    _create_fruit_at(1300, 300)
    _create_fruit_at(750, 190)
    _create_fruit_at(1100, 170)
    _create_fruit_at(1450, 220)
    _create_fruit_at(900, 110)
    _create_fruit_at(1200, 80)
    _create_fruit_at(1550, 130)
    _create_fruit_at(1050, 30)
    _create_fruit_at(1350, 10)

func _create_goal():
    var area = Area2D.new()
    area.position = Vector2(1700, 50)
    var collision = CollisionShape2D.new()
    var shape = RectangleShape2D.new()
    shape.size = Vector2(60, 80)
    collision.shape = shape
    area.add_child(collision)
    area.body_entered.connect(_on_goal_body_entered)
    var pole = ColorRect.new()
    pole.color = Color(0.9, 0.9, 0.9)
    pole.size = Vector2(4, 60)
    pole.position = Vector2(-2, -60)
    area.add_child(pole)
    var flag = ColorRect.new()
    flag.color = Color(1, 0.15, 0.15)
    flag.size = Vector2(30, 20)
    flag.position = Vector2(2, -60)
    area.add_child(flag)
    var label = Label.new()
    label.text = "META"
    label.position = Vector2(-15, -75)
    label.add_theme_font_size_override("font_size", 14)
    label.add_theme_color_override("font_color", Color(1, 1, 1))
    area.add_child(label)
    goal = area
    add_child(area)

func _on_goal_body_entered(body):
    if body == player and not won:
        won = true
        var elapsed = (Time.get_ticks_msec() - start_time) / 1000.0
        var time_str = str(snapped(elapsed, 0.1)) + "s"
        _save_score(player.score, time_str)
        if hud:
            hud.show_win(elapsed, player.score)
        await get_tree().create_timer(4.0).timeout
        get_tree().reload_current_scene()

func _create_clouds():
    for i in 20:
        var cloud = Node2D.new()
        cloud.set_script(preload("res://cloud.gd"))
        add_child(cloud)
        cloud.position = Vector2(randi() % LEVEL_W, -(randi() % LEVEL_H))

func _create_hud():
    hud = preload("res://hud.gd").new()
    add_child(hud)

func _create_touch_controls():
    var tc = preload("res://touch_controls.gd").new()
    add_child(tc)
