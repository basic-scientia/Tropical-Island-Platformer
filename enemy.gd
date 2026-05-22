extends CharacterBody2D

const SPEED = 60.0
const GRAVITY = 1400.0

var direction = -1
var patrol_left = 0
var patrol_right = 0

func _ready():
    add_to_group("enemy")
    patrol_left = global_position.x - 60
    patrol_right = global_position.x + 60

func _draw():
    var body_color = Color(0.9, 0.2, 0.1)
    draw_rect(Rect2(-16, -12, 32, 20), body_color)
    draw_circle(Vector2(-10, -12), 6, body_color)
    draw_circle(Vector2(10, -12), 6, body_color)
    draw_circle(Vector2(-6, -14), 2, Color(0, 0, 0))
    draw_circle(Vector2(6, -14), 2, Color(0, 0, 0))

func _physics_process(delta):
    if not is_on_floor():
        velocity.y += GRAVITY * delta

    velocity.x = direction * SPEED
    move_and_slide()
    queue_redraw()

    if global_position.x <= patrol_left:
        direction = 1
    elif global_position.x >= patrol_right:
        direction = -1

    if not is_on_floor():
        direction *= -1

func die():
    queue_free()
