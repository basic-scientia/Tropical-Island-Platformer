extends Area2D

enum Type { COCONUT, BANANA, PINEAPPLE }
var fruit_type = Type.COCONUT
var base_y = 0
var time = 0

signal collected

func _ready():
    add_to_group("fruit")
    base_y = global_position.y
    fruit_type = randi() % 3
    body_entered.connect(_on_body_entered)

func _draw():
    match fruit_type:
        Type.COCONUT:
            draw_circle(Vector2.ZERO, 10, Color(0.5, 0.35, 0.15))
            draw_circle(Vector2(-3, -3), 3, Color(0.4, 0.25, 0.1))
        Type.BANANA:
            draw_circle(Vector2(0, 0), 10, Color(0.95, 0.85, 0.1))
            draw_circle(Vector2(-3, -3), 4, Color(0.9, 0.75, 0.05))
        Type.PINEAPPLE:
            draw_circle(Vector2(0, 2), 10, Color(0.9, 0.6, 0.1))
            draw_circle(Vector2(0, -8), 6, Color(0.2, 0.7, 0.1))

func _process(delta):
    time += delta * 2
    global_position.y = base_y + sin(time) * 8

func _on_body_entered(body):
    if body.is_in_group("player"):
        collected.emit()
        queue_free()

func _on_area_entered(area):
    pass
