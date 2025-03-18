extends CharacterBody2D

var bullet_path = preload("res://Scenes/bullet.tscn")
func _physics_process(_delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("ui_accept"):
		fire()

func fire():
	var bullet=bullet_path.instantiate()
	bullet.dir=global_rotation
	bullet.pos=$Node2D2.global_position
	bullet.rota=global_rotation
	bullet.scale = Vector2(1, 1)
	get_tree().current_scene.add_child(bullet)
