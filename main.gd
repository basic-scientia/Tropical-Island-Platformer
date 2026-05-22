extends Node2D

const SCREEN_W = 1280
const SCREEN_H = 720
const GROUND_Y = 650
const LEVEL_H = 3500

var player = null
var hud = null
var camera = null
var goal = null
var won = false

func _ready():
    _setup_inputs()
    _create_background()
    _create_ground()
    _create_platforms()
    _create_player()
    _create_camera()
    _create_enemies()
    _create_fruits()
    _create_goal()
    _create_hud()
    _create_clouds()
    _create_touch_controls()

func _process(delta):
    if player and camera:
        var target = player.position
        target.x = SCREEN_W / 2
        camera.position = camera.position.lerp(target, 8.0 * delta)

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
    sky.size = Vector2(SCREEN_W, LEVEL_H + 400)
    sky.position = Vector2(0, -200)
    sky.z_index = -10
    add_child(sky)
    var sea = ColorRect.new()
    sea.color = Color(0.1, 0.5, 0.7)
    sea.size = Vector2(SCREEN_W, 100)
    sea.position = Vector2(0, GROUND_Y + 40)
    sea.z_index = -9
    add_child(sea)
    var sun = Node2D.new()
    sun.position = Vector2(1100, 80)
    sun.set_script(preload("res://sun.gd"))
    sun.z_index = -8
    add_child(sun)

func _create_ground():
    var ground = StaticBody2D.new()
    ground.position = Vector2(0, GROUND_Y)
    var collision = CollisionShape2D.new()
    var shape = RectangleShape2D.new()
    shape.size = Vector2(SCREEN_W * 2, 40)
    collision.shape = shape
    collision.position = Vector2(SCREEN_W / 2, 20)
    ground.add_child(collision)
    var sand = ColorRect.new()
    sand.color = Color(0.76, 0.60, 0.42)
    sand.size = Vector2(SCREEN_W, 40)
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
    _create_platform(200, 590, 130)
    _create_platform(420, 540, 120)
    _create_platform(620, 490, 130)
    _create_platform(350, 440, 120)
    _create_platform(570, 390, 140)
    _create_platform(300, 340, 110)
    _create_platform(620, 290, 130)
    _create_platform(400, 250, 110)
    _create_platform(650, 210, 130)
    _create_platform(350, 160, 120)
    _create_platform(580, 110, 130)
    _create_platform(300, 70, 100)
    _create_platform(520, 40, 100)

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
    add_child(player)

func _on_player_lives_changed(lives):
    if hud:
        hud.update_lives(lives)

func _on_player_score_changed(score):
    if hud:
        hud.update_score(score)

func _create_camera():
    camera = Camera2D.new()
    camera.position_smoothing_enabled = true
    camera.position_smoothing_speed = 5.0
    camera.limit_left = 0
    camera.limit_right = SCREEN_W
    camera.limit_top = -100
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
    _create_enemy_at(620, 470)
    _create_enemy_at(570, 370)
    _create_enemy_at(620, 270)
    _create_enemy_at(400, 230)
    _create_enemy_at(650, 190)

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
    _create_fruit_at(250, 560)
    _create_fruit_at(470, 510)
    _create_fruit_at(680, 460)
    _create_fruit_at(400, 410)
    _create_fruit_at(620, 360)
    _create_fruit_at(350, 310)
    _create_fruit_at(680, 260)
    _create_fruit_at(450, 220)
    _create_fruit_at(700, 180)
    _create_fruit_at(400, 130)
    _create_fruit_at(630, 80)
    _create_fruit_at(350, 40)
    _create_fruit_at(570, 10)

func _create_goal():
    var area = Area2D.new()
    area.position = Vector2(570, 10)
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
        if hud:
            hud.show_win()
        await get_tree().create_timer(3.0).timeout
        get_tree().reload_current_scene()

func _create_clouds():
    for i in 12:
        var cloud = Node2D.new()
        cloud.set_script(preload("res://cloud.gd"))
        var y_offset = -(i * 280)
        add_child(cloud)
        cloud.position.y = y_offset

func _create_hud():
    hud = preload("res://hud.gd").new()
    add_child(hud)

func _create_touch_controls():
    var tc = preload("res://touch_controls.gd").new()
    add_child(tc)
