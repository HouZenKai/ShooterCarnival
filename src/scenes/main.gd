extends Node2D

# Parallax background configuration constants
# These values are based on the viewport size and desired parallax effect

# Viewport dimensions (Godot default: 1152x648)
# Repeat size based on background sprite dimensions (272x160) scaled by 4.235294
# Slight reduction in repeat height to create overlap and prevent seams
const PARALLAX_REPEAT_WIDTH := 1152  # 272 * 4.235294 ≈ 1152 (matches viewport width)
const PARALLAX_REPEAT_HEIGHT := 676  # Slightly less than 678 to create overlap

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
	# Apply constants to BackgroundLayer
	background_layer.scroll_scale = Vector2(BACKGROUND_SCROLL_SCALE, BACKGROUND_SCROLL_SCALE)
	background_layer.repeat_size = Vector2(PARALLAX_REPEAT_WIDTH, PARALLAX_REPEAT_HEIGHT)
	background_layer.autoscroll = Vector2(0, BACKGROUND_AUTOSCROLL_SPEED)
	background_layer.ignore_camera_scroll = true
	
	# Apply constants to StarsLayer
	stars_layer.scroll_scale = Vector2(STARS_SCROLL_SCALE, STARS_SCROLL_SCALE)
	stars_layer.repeat_size = Vector2(PARALLAX_REPEAT_WIDTH, PARALLAX_REPEAT_HEIGHT)
	stars_layer.autoscroll = Vector2(0, STARS_AUTOSCROLL_SPEED)
	stars_layer.ignore_camera_scroll = true

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
		background_base_y_offset += BACKGROUND_AUTOSCROLL_SPEED * delta
		stars_base_y_offset += STARS_AUTOSCROLL_SPEED * delta
		
		# Apply combined offset: autoscroll base + player-relative parallax
		# This makes both effects work additively
		background_layer.scroll_offset.x = -player_offset_x * BACKGROUND_SCROLL_SCALE
		background_layer.scroll_offset.y = background_base_y_offset - (player_offset_y * BACKGROUND_SCROLL_SCALE)
		
		stars_layer.scroll_offset.x = -player_offset_x * STARS_SCROLL_SCALE
		stars_layer.scroll_offset.y = stars_base_y_offset - (player_offset_y * STARS_SCROLL_SCALE)
