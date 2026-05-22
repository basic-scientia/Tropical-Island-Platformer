extends Node2D

var speed = 10.0
var base_y = 0
var screen_w = 1280

func _ready():
    speed = 5.0 + randi() % 15
    position.x = randi() % screen_w
    base_y = position.y

func _draw():
    var c = Color(1, 1, 1, 0.8)
    draw_circle(Vector2(0, 0), 20, c)
    draw_circle(Vector2(25, -5), 25, c)
    draw_circle(Vector2(50, 0), 20, c)
    draw_circle(Vector2(25, 5), 18, c)

func _process(delta):
    position.x += speed * delta
    if position.x > screen_w + 80:
        position.x = -80
        position.y = base_y + randi() % 60 - 30
