extends Node2D

var speed = 10.0
var base_y = 0

func _ready():
    speed = 5.0 + randi() % 15
    base_y = position.y

func _draw():
    var c = Color(1, 1, 1, 0.8)
    draw_circle(Vector2(0, 0), 20, c)
    draw_circle(Vector2(25, -5), 25, c)
    draw_circle(Vector2(50, 0), 20, c)
    draw_circle(Vector2(25, 5), 18, c)

func _process(delta):
    position.x += speed * delta
    if position.x > 3200:
        position.x = -100
        position.y = base_y + randi() % 60 - 30
