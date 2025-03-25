extends CharacterBody2D

var pos: Vector2
var rota: float
var dir: float
var speed = 2000

func _ready():
	global_position = pos
	global_rotation = rota
	add_to_group("Bullet")

func _physics_process(_delta):
	velocity = Vector2(speed, 0).rotated(dir)
	move_and_slide()

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_2d_area_entered(area):
	if area is CharacterBody2D:
		if area.has_method("take_damage"):
			area.take_damage(1)
			print("Player hit!")
			queue_free()
