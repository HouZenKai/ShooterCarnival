extends CanvasLayer

@onready var fade_rect: ColorRect = $FadeRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	fade_rect.modulate.a = 0.0
	visible = false

func fade_out():
	animation_player.play("fade_out")
	await animation_player.animation_finished
	visible = false

func fade_in():
	visible = true
	animation_player.play_backwards("fade_out")
	await animation_player.animation_finished

func transition_to_scene(scene_path: String) -> void:
	await fade_in()
	get_tree().change_scene_to_file(scene_path)
	fade_out()
