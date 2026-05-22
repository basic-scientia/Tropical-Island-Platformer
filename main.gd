extends Node2D

const SCREEN_W = 1280
const SCREEN_H = 720
const GROUND_Y = 650

var player = null
var hud = null

func _ready():
    _setup_inputs()
    _create_background()
    _create_ground()
    _create_platforms()
    _create_player()
    _create_enemies()
    _create_fruits()
    _create_hud()
    _create_clouds()
    _create_touch_controls()

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
    sky.size = Vector2(SCREEN_W, SCREEN_H)
    sky.position = Vector2.ZERO
    sky.z_index = -10
    add_child(sky)

    var sea = ColorRect.new()
    sea.color = Color(0.1, 0.5, 0.7)
    sea.size = Vector2(SCREEN_W, SCREEN_H - GROUND_Y + 10)
    sea.position = Vector2(0, GROUND_Y - 10)
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
    collision.position = Vector2(0, 0)
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
    return plat

func _create_platforms():
    _create_platform(250, 590, 140)
    _create_platform(550, 560, 120)
    _create_platform(150, 510, 100)
    _create_platform(450, 440, 130)
    _create_platform(750, 480, 140)
    _create_platform(300, 370, 110)
    _create_platform(600, 330, 130)
    _create_platform(950, 400, 120)
    _create_platform(150, 280, 90)
    _create_platform(500, 240, 100)
    _create_platform(800, 280, 110)
    _create_platform(1050, 200, 100)
    _create_platform(700, 150, 90)
    _create_platform(1100, 300, 120)
    _create_platform(120, 420, 100)

func _create_player():
    player = CharacterBody2D.new()
    player.set_script(preload("res://player.gd"))
    player.position = Vector2(80, 500)

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
    return enemy

func _create_enemies():
    _create_enemy_at(250, 570)
    _create_enemy_at(750, 460)
    _create_enemy_at(950, 380)
    _create_enemy_at(850, 260)

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
    return fruit

func _on_fruit_collected():
    if player:
        player.score += 10
        player.score_changed.emit(player.score)

func _create_fruits():
    _create_fruit_at(280, 560)
    _create_fruit_at(580, 530)
    _create_fruit_at(200, 480)
    _create_fruit_at(500, 410)
    _create_fruit_at(820, 450)
    _create_fruit_at(350, 340)
    _create_fruit_at(650, 300)
    _create_fruit_at(1000, 370)
    _create_fruit_at(200, 250)
    _create_fruit_at(550, 210)
    _create_fruit_at(850, 250)
    _create_fruit_at(1100, 170)
    _create_fruit_at(750, 120)
    _create_fruit_at(170, 390)

func _create_clouds():
    for i in 5:
        var cloud = Node2D.new()
        cloud.set_script(preload("res://cloud.gd"))
        add_child(cloud)

func _create_hud():
    hud = preload("res://hud.gd").new()
    add_child(hud)

func _create_touch_controls():
    var tc = preload("res://touch_controls.gd").new()
    add_child(tc)
