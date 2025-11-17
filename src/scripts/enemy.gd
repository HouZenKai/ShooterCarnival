extends Area2D

var initial_position: Vector2        = Vector2(0, -60)
@export var base_speed: int          = 95
@export var speed_variation_min: int = 5
@export var speed_variation_max: int = 25
@export var speed: int               = base_speed
var standby_time: Timer              = Timer.new()

func final_speed() -> int:
    return  base_speed + (randi() % (speed_variation_max - speed_variation_min + 1)) + speed_variation_min

func randomize_initial_position_x() -> void:
    var screen_width: int = 240
    initial_position.x = (randi() % screen_width - 16) + 8

func _init() -> void:
    randomize_initial_position_x()
    position = initial_position
    speed = 0
    standby_time.wait_time = randf_range(0.5, 2.5)
    standby_time.connect("timeout", _on_standby_timeout)
    standby_time.start()

func _on_standby_timeout() -> void:
    speed = final_speed()

func _ready() -> void:
    standby_time = Timer.new()
    standby_time.one_shot = true
    add_child(standby_time)
    _init()

func _process(delta: float) -> void:
    position.y += speed * delta
    if position.y > 360:
        _init()
