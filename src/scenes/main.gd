extends Node2D

@export var max_enemies: int = 30
var enemy: PackedScene = preload("res://scenes/enemies/enemy.tscn")

## Pause menu scene - instanced when game loads
var pause_menu_scene: PackedScene = preload("res://scenes/ui/pause_menu.tscn")
var pause_menu: CanvasLayer = null


# Parallax background configuration constants
# These values are based on the viewport size and desired parallax effect

# Viewport dimensions (Godot default: 1152x648)
# Background sprite dimensions: 272x160 (blue-back.png, blue-stars.png)
# Scaled by 4.235294 to cover viewport: 272 * 4.235294 ≈ 1152, 160 * 4.235294 ≈ 678
const PARALLAX_REPEAT_WIDTH := 1152  # Matches viewport width for seamless tiling
const PARALLAX_REPEAT_HEIGHT := 676  # Slightly less than 678 to create overlap and prevent seams

# Scroll scale determines how fast layers move relative to player movement
# Lower values = slower movement = appears further away
const BACKGROUND_SCROLL_SCALE := 0.3  # Far background moves slowest
const STARS_SCROLL_SCALE := 0.5       # Stars layer moves at medium speed

# Autoscroll speed in pixels per second (vertical scrolling)
# Creates continuous downward movement for classic arcade shooter feel
const BACKGROUND_AUTOSCROLL_SPEED := 20.0  # Slow downward drift for far background
const STARS_AUTOSCROLL_SPEED := 30.0       # Faster downward drift for mid-ground stars

@onready var background_layer := $BackgroundLayer as Parallax2D
@onready var stars_layer := $StarsLayer as Parallax2D
@onready var player := $Player

# Track the base vertical offset for additive parallax
var background_base_y_offset: float = 0.0
var stars_base_y_offset: float = 0.0

func _ready() -> void:
	# Instance and add the pause menu
	pause_menu = pause_menu_scene.instantiate()
	add_child(pause_menu)
	
	# Apply constants to BackgroundLayer
	background_layer.scroll_scale = Vector2(BACKGROUND_SCROLL_SCALE, BACKGROUND_SCROLL_SCALE)
	background_layer.repeat_size = Vector2(PARALLAX_REPEAT_WIDTH, PARALLAX_REPEAT_HEIGHT)
	background_layer.ignore_camera_scroll = true
	
	# Apply constants to StarsLayer
	stars_layer.scroll_scale = Vector2(STARS_SCROLL_SCALE, STARS_SCROLL_SCALE)
	stars_layer.repeat_size = Vector2(PARALLAX_REPEAT_WIDTH, PARALLAX_REPEAT_HEIGHT)
	stars_layer.ignore_camera_scroll = true
	game_start_async()

func _process(delta: float) -> void:
	# Update parallax layers to respond to player movement
	# This creates depth while maintaining auto-scroll
	if player:
		# Calculate offset based on player's position relative to screen center
		var viewport_center_x: float = get_viewport_rect().size.x / 2.0
		var viewport_center_y: float = get_viewport_rect().size.y / 2.0
		var player_offset_x: float = player.position.x - viewport_center_x
		var player_offset_y: float = player.position.y - viewport_center_y
		
		# Update base offsets with autoscroll speed (additive)
		# Wrap offsets using modulo to prevent floating-point precision issues in long sessions
		background_base_y_offset = fmod(background_base_y_offset + BACKGROUND_AUTOSCROLL_SPEED * delta, PARALLAX_REPEAT_HEIGHT)
		stars_base_y_offset = fmod(stars_base_y_offset + STARS_AUTOSCROLL_SPEED * delta, PARALLAX_REPEAT_HEIGHT)
		
		# Apply combined offset: autoscroll base + player-relative parallax
		# This makes both effects work additively
		background_layer.scroll_offset.x = -player_offset_x * BACKGROUND_SCROLL_SCALE
		background_layer.scroll_offset.y = background_base_y_offset - (player_offset_y * BACKGROUND_SCROLL_SCALE)
		
		stars_layer.scroll_offset.x = -player_offset_x * STARS_SCROLL_SCALE
		stars_layer.scroll_offset.y = stars_base_y_offset - (player_offset_y * STARS_SCROLL_SCALE)


func game_start_async() -> void:
	# Spawn initial enemies over multiple frames to avoid frame drops
	var x = 0
	for _i in max_enemies:
		var enemy_instance = enemy.instantiate()
		enemy_instance.setup(Vector2(x, 16))
		x += 18
		add_child(enemy_instance)
		await get_tree().process_frame


func _input(event: InputEvent) -> void:
	# Handle pause toggle with ESC/ui_cancel
	if event.is_action_pressed("ui_cancel"):
		if pause_menu and not pause_menu.is_open:
			pause_menu.open_menu()
