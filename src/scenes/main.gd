extends Node2D

# Parallax background configuration constants
# These values are based on the viewport size and desired parallax effect

# Viewport dimensions (Godot default: 1152x648)
# Using 1143x672 to create seamless tiling with slight overlap
# This prevents visual gaps when scrolling
const PARALLAX_REPEAT_WIDTH := 1143
const PARALLAX_REPEAT_HEIGHT := 672

# Scroll scale determines how fast layers move relative to camera
# Lower values = slower movement = appears further away
const BACKGROUND_SCROLL_SCALE := 0.3  # Far background moves slowest
const STARS_SCROLL_SCALE := 0.5       # Stars layer moves at medium speed

# Autoscroll speed in pixels per second (vertical scrolling)
# Creates continuous downward movement for space shooter feel
const BACKGROUND_AUTOSCROLL_SPEED := 20.0  # Slow drift for far background
const STARS_AUTOSCROLL_SPEED := 30.0       # Faster drift for mid-ground stars

func _ready() -> void:
	# Apply constants to BackgroundLayer
	var background_layer := $BackgroundLayer as Parallax2D
	background_layer.scroll_scale = Vector2(BACKGROUND_SCROLL_SCALE, BACKGROUND_SCROLL_SCALE)
	background_layer.repeat_size = Vector2(PARALLAX_REPEAT_WIDTH, PARALLAX_REPEAT_HEIGHT)
	background_layer.autoscroll = Vector2(0, BACKGROUND_AUTOSCROLL_SPEED)
	
	# Apply constants to StarsLayer
	var stars_layer := $StarsLayer as Parallax2D
	stars_layer.scroll_scale = Vector2(STARS_SCROLL_SCALE, STARS_SCROLL_SCALE)
	stars_layer.repeat_size = Vector2(PARALLAX_REPEAT_WIDTH, PARALLAX_REPEAT_HEIGHT)
	stars_layer.autoscroll = Vector2(0, STARS_AUTOSCROLL_SPEED)
