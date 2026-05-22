extends Node2D

const SCREEN_W = 1280
const SCREEN_H = 720
const GROUND_Y = 650
const LEVEL_W = 4000
const LEVEL_H = 4000

var player = null
var hud = null
var camera = null
var goal = null
var won = false
var game_started = false
var start_time = 0
var continue_cost = 50
var death_pos = Vector2()
var current_level = 0
var level_objects = []

var levels = [


	{
		"start": Vector2(80, 633),
		"goal": Vector2(700, 30),
		"goal_label": "DONKEY",
		"platforms": [
			[200, 590, 140],
			[420, 550, 130],
			[280, 500, 110],
			[520, 460, 140],
			[350, 410, 110],
			[630, 370, 130],
			[480, 320, 100],
			[740, 280, 130],
			[580, 230, 90],
			[800, 190, 110],
			[650, 140, 80],
			[850, 100, 100],
			[700, 60, 80]
		],
		"enemies": [
			[420, 530],
			[520, 440],
			[630, 350],
			[740, 260],
			[800, 170],
			[850, 80]
		],
		"fruits": [
			[250, 560],
			[470, 520],
			[330, 470],
			[570, 430],
			[400, 380],
			[680, 340],
			[530, 290],
			[790, 250],
			[630, 200],
			[850, 160],
			[700, 110],
			[900, 70]
		]
	},
	{
		"start": Vector2(80, 633),
		"goal": Vector2(2300, 30),
		"goal_label": "META",
		"platforms": [
			[100, 590, 120], [350, 540, 130], [600, 570, 120],
			[200, 480, 110], [500, 430, 130], [750, 470, 120],
			[950, 510, 120], [300, 370, 110], [600, 340, 130],
			[900, 380, 120], [1200, 420, 130], [500, 270, 110],
			[800, 250, 130], [1100, 290, 120], [1400, 330, 130],
			[700, 180, 110], [1000, 160, 130], [1300, 200, 120],
			[1600, 250, 130], [900, 100, 110], [1200, 80, 120],
			[1500, 120, 130], [1800, 160, 120], [1100, 20, 110],
			[1400, 40, 130], [1700, 70, 120], [2000, 100, 130],
			[2300, 130, 120]
		],
		"enemies": [
			[350, 520], [750, 450], [1200, 400], [500, 410],
			[900, 360], [1400, 310], [800, 230], [1300, 180],
			[1600, 230], [1000, 140], [1500, 100], [1800, 140],
			[1400, 20], [2000, 80]
		],
		"fruits": [
			[150, 560], [400, 510], [650, 540], [250, 450],
			[550, 400], [800, 440], [1000, 480], [350, 340],
			[650, 310], [950, 350], [1250, 390], [550, 240],
			[850, 220], [1150, 260], [1450, 300], [750, 150],
			[1050, 130], [1350, 170], [1650, 220], [950, 70],
			[1250, 50], [1550, 90], [1850, 130], [1150, 0],
			[1450, 10], [1750, 40], [2050, 70]
		]
	},
	{
		"start": Vector2(80, 633),
		"goal": Vector2(2800, 20),
		"goal_label": "META",
		"platforms": [
			[100, 590, 110], [350, 530, 120], [550, 570, 110],
			[700, 510, 120], [200, 460, 100], [450, 400, 120],
			[650, 440, 110], [900, 480, 120], [300, 340, 100],
			[550, 300, 120], [800, 340, 110], [1050, 380, 120],
			[1250, 420, 110], [450, 230, 100], [700, 200, 120],
			[950, 240, 110], [1200, 280, 120], [1450, 330, 110],
			[600, 140, 100], [850, 110, 120], [1100, 150, 110],
			[1350, 190, 120], [1600, 240, 110], [750, 50, 100],
			[1000, 20, 120], [1250, 60, 110], [1500, 100, 120],
			[1750, 150, 110], [2000, 190, 120], [1200, -10, 100],
			[1450, 10, 110], [1700, 40, 120], [1950, 80, 110],
			[2200, 120, 120], [2450, 160, 110], [2000, 30, 100],
			[2250, 50, 120], [2500, 80, 110], [2750, 110, 120],
			[2800, 60, 100]
		],
		"enemies": [
			[350, 510], [700, 490], [450, 380], [900, 460],
			[550, 280], [1050, 360], [1250, 400], [700, 180],
			[1200, 260], [1450, 310], [850, 90], [1350, 170],
			[1600, 220], [1000, 0], [1500, 80], [1750, 130],
			[2000, 170], [1450, -10], [1950, 60], [2500, 60]
		],
		"fruits": [
			[150, 560], [400, 500], [600, 540], [750, 480],
			[250, 430], [500, 370], [700, 410], [950, 450],
			[350, 310], [600, 270], [850, 310], [1100, 350],
			[1300, 390], [500, 200], [750, 170], [1000, 210],
			[1250, 250], [1500, 300], [650, 110], [900, 80],
			[1150, 120], [1400, 160], [1650, 210], [800, 20],
			[1050, -10], [1300, 30], [1550, 70], [1800, 120],
			[2050, 160], [1250, -30], [1500, -10], [1750, 10],
			[2000, 50], [2250, 90], [2500, 130], [2050, 10],
			[2300, 30], [2550, 60], [2800, -10], [2850, 30]
		]
	}
]

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
	current_level = 0
	continue_cost = 50
	var start = get_node_or_null("StartScreen")
	if start:
		start.queue_free()
	_create_ground()
	_create_player()
	_create_camera()
	_build_level(0)
	_create_hud()
	_create_touch_controls()

func _create_ground():
	var ground = StaticBody2D.new()
	ground.name = "Ground"
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(700, 40)
	collision.shape = shape
	collision.position = Vector2(350, 20)
	ground.add_child(collision)
	var sand = ColorRect.new()
	sand.color = Color(0.76, 0.60, 0.42)
	sand.size = Vector2(700, 40)
	sand.position = Vector2(0, 0)
	ground.add_child(sand)
	add_child(ground)

func _create_platform(x, y, w, h):
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
	return plat

func _build_level(idx):
	_clear_level()
	var data = levels[idx]
	for p in data.platforms:
		level_objects.append(_create_platform(p[0], p[1], p[2], 20))
	for e in data.enemies:
		level_objects.append(_create_enemy_at(e[0], e[1]))
	for f in data.fruits:
		level_objects.append(_create_fruit_at(f[0], f[1]))
	goal = _create_goal_at(data.goal.x, data.goal.y, data.goal_label)
	level_objects.append(goal)
	if player:
		player.position = data.start
		player.velocity = Vector2.ZERO
	if hud:
		hud.update_level(idx + 1, len(levels))

func _clear_level():
	for obj in level_objects:
		if is_instance_valid(obj):
			obj.queue_free()
	level_objects.clear()
	goal = null

func _create_player():
	player = CharacterBody2D.new()
	player.set_script(preload("res://player.gd"))
	player.position = Vector2(80, 633)
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
		continue_cost += 20
		player.score_changed.emit(player.score)
		player.respawn(death_pos)
	var ds = get_node_or_null("DeathScreen")
	if ds:
		ds.queue_free()

func _on_death_restart():
	_clear_level()
	if player:
		player.queue_free()
		player = null
	if camera:
		camera.queue_free()
		camera = null
	if hud:
		hud.queue_free()
		hud = null
	var ground = get_node_or_null("Ground")
	if ground:
		ground.queue_free()
	var tc = get_node_or_null("TouchControls")
	if tc:
		tc.queue_free()
	var clouds = get_tree().get_nodes_in_group("clouds")
	for c in clouds:
		c.queue_free()

	game_started = false
	won = false
	continue_cost = 50

	var ds = get_node_or_null("DeathScreen")
	if ds:
		ds.queue_free()

	_create_start_screen()
	_create_clouds()

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
	return enemy

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

func _create_goal_at(x, y, label_text):
	var area = Area2D.new()
	area.position = Vector2(x, y)
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
	label.text = label_text
	label.position = Vector2(-15, -75)
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color(1, 1, 1))
	area.add_child(label)
	add_child(area)
	return area

func _on_goal_body_entered(body):
	if body == player and not won:
		current_level += 1
		if current_level >= len(levels):
			won = true
			var elapsed = (Time.get_ticks_msec() - start_time) / 1000.0
			var time_str = str(snapped(elapsed, 0.1)) + "s"
			_save_score(player.score, time_str)
			if hud:
				hud.show_game_complete(elapsed, player.score)
			await get_tree().create_timer(5.0).timeout
			get_tree().reload_current_scene()
		else:
			if hud:
				hud.show_level_complete(current_level, len(levels))
			await get_tree().create_timer(2.0).timeout
			_build_level(current_level)

func _create_clouds():
	for i in 20:
		var cloud = Node2D.new()
		cloud.add_to_group("clouds")
		cloud.set_script(preload("res://cloud.gd"))
		add_child(cloud)
		cloud.position = Vector2(randi() % LEVEL_W, -(randi() % LEVEL_H))

func _create_hud():
	hud = preload("res://hud.gd").new()
	add_child(hud)

func _create_touch_controls():
	var tc = preload("res://touch_controls.gd").new()
	tc.name = "TouchControls"
	add_child(tc)
