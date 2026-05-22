extends CanvasLayer

func _ready():
    var score_label = Label.new()
    score_label.name = "ScoreLabel"
    score_label.text = "Score: 0"
    score_label.position = Vector2(20, 20)
    score_label.add_theme_font_size_override("font_size", 24)
    score_label.add_theme_color_override("font_color", Color(1, 1, 1))
    add_child(score_label)

    var lives_label = Label.new()
    lives_label.name = "LivesLabel"
    lives_label.text = "Lives: 3"
    lives_label.position = Vector2(20, 50)
    lives_label.add_theme_font_size_override("font_size", 20)
    lives_label.add_theme_color_override("font_color", Color(1, 1, 1))
    add_child(lives_label)

    var win_label = Label.new()
    win_label.name = "WinLabel"
    win_label.text = ""
    win_label.position = Vector2(440, 300)
    win_label.add_theme_font_size_override("font_size", 48)
    win_label.add_theme_color_override("font_color", Color(1, 0.9, 0.2))
    win_label.visible = false
    add_child(win_label)

func update_score(s):
    $ScoreLabel.text = "Score: " + str(s)

func update_lives(l):
    $LivesLabel.text = "Lives: " + str(l)

func show_win():
    $WinLabel.text = "YOU WIN!"
    $WinLabel.visible = true
