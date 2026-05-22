extends CanvasLayer

func _ready():
	var score_label = Label.new()
	score_label.name = "ScoreLabel"
	score_label.text = "Score: 0"
	score_label.position = Vector2(20, 20)
	score_label.add_theme_font_size_override("font_size", 22)
	score_label.add_theme_color_override("font_color", Color(1, 1, 1))
	add_child(score_label)

	var lives_label = Label.new()
	lives_label.name = "LivesLabel"
	lives_label.text = "Lives: 3"
	lives_label.position = Vector2(20, 46)
	lives_label.add_theme_font_size_override("font_size", 18)
	lives_label.add_theme_color_override("font_color", Color(1, 1, 1))
	add_child(lives_label)

	var time_label = Label.new()
	time_label.name = "TimeLabel"
	time_label.text = "Time: 0.0s"
	time_label.position = Vector2(20, 70)
	time_label.add_theme_font_size_override("font_size", 16)
	time_label.add_theme_color_override("font_color", Color(0.8, 0.9, 1))
	add_child(time_label)

	var level_label = Label.new()
	level_label.name = "LevelLabel"
	level_label.text = ""
	level_label.position = Vector2(1130, 20)
	level_label.add_theme_font_size_override("font_size", 20)
	level_label.add_theme_color_override("font_color", Color(1, 1, 0.8))
	add_child(level_label)

	var overlay_label = Label.new()
	overlay_label.name = "OverlayLabel"
	overlay_label.text = ""
	overlay_label.position = Vector2(340, 260)
	overlay_label.add_theme_font_size_override("font_size", 44)
	overlay_label.add_theme_color_override("font_color", Color(1, 0.9, 0.2))
	overlay_label.visible = false
	overlay_label.z_index = 10
	add_child(overlay_label)

	var info_label = Label.new()
	info_label.name = "InfoLabel"
	info_label.text = ""
	info_label.position = Vector2(400, 320)
	info_label.add_theme_font_size_override("font_size", 22)
	info_label.add_theme_color_override("font_color", Color(1, 1, 1))
	info_label.visible = false
	info_label.z_index = 10
	add_child(info_label)

func update_score(s):
	$ScoreLabel.text = "Score: " + str(s)

func update_lives(l):
	$LivesLabel.text = "Lives: " + str(l)

func update_time(t):
	$TimeLabel.text = "Time: " + str(snapped(t, 0.1)) + "s"

func update_level(cur, total):
	$LevelLabel.text = "Level " + str(cur) + "/" + str(total)

func show_level_complete(level, total):
	$OverlayLabel.text = "Level " + str(level) + " Complete!"
	$OverlayLabel.visible = true
	$InfoLabel.text = "Prepare for next level..."
	$InfoLabel.visible = true
	await get_tree().create_timer(1.5).timeout
	$OverlayLabel.visible = false
	$InfoLabel.visible = false

func show_game_complete(time, score):
	$OverlayLabel.text = "GAME COMPLETE!"
	$OverlayLabel.visible = true
	$InfoLabel.text = "Time: " + str(snapped(time, 0.1)) + "s   Score: " + str(score) + "\nThanks for playing!"
	$InfoLabel.visible = true
