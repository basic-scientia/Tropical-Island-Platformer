extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const GRAVITY = 1400.0
const SIZE = Vector2(24, 36)

var lives = 3
var score = 0
var invincible = false
var facing_right = true

signal lives_changed(new_lives)
signal score_changed(new_score)

func _ready():
    add_to_group("player")

func _draw():
    var c = Color(0.2, 0.6, 1.0) if not invincible else Color(1, 1, 1, 0.5)
    draw_rect(Rect2(-SIZE.x/2, -SIZE.y, SIZE.x, SIZE.y), c)
    draw_circle(Vector2(0, -SIZE.y - 6), 8, Color(1.0, 0.8, 0.6))
    draw_circle(Vector2(-4, -SIZE.y - 8), 2, Color(0, 0, 0))
    draw_circle(Vector2(4, -SIZE.y - 8), 2, Color(0, 0, 0))

func _physics_process(delta):
    if not is_on_floor():
        velocity.y += GRAVITY * delta

    var direction = Input.get_axis("move_left", "move_right")
    if direction:
        velocity.x = direction * SPEED
        facing_right = direction > 0
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    move_and_slide()
    queue_redraw()

    for i in get_slide_collision_count():
        var col = get_slide_collision(i)
        if col.get_collider().is_in_group("enemy"):
            if col.get_normal().y < -0.3:
                col.get_collider().die()
                velocity.y = -350.0
                score += 20
                score_changed.emit(score)
            elif not invincible:
                take_damage()

    if global_position.y > 900:
        take_damage()

func take_damage():
    if invincible:
        return
    lives -= 1
    lives_changed.emit(lives)
    if lives <= 0:
        await get_tree().create_timer(0.5).timeout
        get_tree().reload_current_scene()
    else:
        invincible = true
        await get_tree().create_timer(2.0).timeout
        invincible = false
