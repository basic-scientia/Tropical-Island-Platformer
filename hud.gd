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

    var win_label = Label.new()
    win_label.name = "WinLabel"
    win_label.text = ""
    win_label.position = Vector2(340, 260)
    win_label.add_theme_font_size_override("font_size", 48)
    win_label.add_theme_color_override("font_color", Color(1, 0.9, 0.2))
    win_label.visible = false
    win_label.z_index = 10
    add_child(win_label)

    var win_info = Label.new()
    win_info.name = "WinInfo"
    win_info.text = ""
    win_info.position = Vector2(400, 320)
    win_info.add_theme_font_size_override("font_size", 22)
    win_info.add_theme_color_override("font_color", Color(1, 1, 1))
    win_info.visible = false
    win_info.z_index = 10
    add_child(win_info)

func update_score(s):
    $ScoreLabel.text = "Score: " + str(s)

func update_lives(l):
    $LivesLabel.text = "Lives: " + str(l)

func update_time(t):
    $TimeLabel.text = "Time: " + str(snapped(t, 0.1)) + "s"

func show_win(time, score):
    $WinLabel.text = "YOU WIN!"
    $WinLabel.visible = true
    $WinInfo.text = "Time: " + str(snapped(time, 0.1)) + "s   Score: " + str(score)
    $WinInfo.visible = true
