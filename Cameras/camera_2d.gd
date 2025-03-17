extends Camera2D

func _ready():
	var base_resolution = Vector2(1920, 1080)
	var screen_size = get_viewport_rect().size
	
	# Maintain aspect ratio by scaling based on the smaller dimension
	var scale_factor = min(screen_size.x / base_resolution.x, screen_size.y / base_resolution.y)
	
	zoom = Vector2(scale_factor, scale_factor)
