extends Weapon

@export var attack_duration: float = 0.5  # Duration for how long the hitbox stays active
@export var cooldown_duration: float = 0.1  # Cooldown before the player can attack again
@export var sword_level: float = 1.0 # Setting sword level for triggering correct animations

@onready var animation = $AnimationPlayer

var can_attack: bool = true

# Ensure hitbox starts inactive
func _ready():
	$MyHitbox.set_deferred("monitoring", false)  # Disable hitbox monitoring when sword is ready
	$MyHitbox.get_node("CollisionShape2D").set_deferred("disabled", true)
	
	
func attack():
	if can_attack:
		can_attack = false

		# trigger correct sword attack animation
		if sword_level == 1.0:
			animation.play("Sword_Attack")
		else:
			animation.play("Sword_Upgraded")
		
		# Enable hitbox and collision shape using set_deferred
		$MyHitbox.set_deferred("monitoring", true)
		$MyHitbox.get_node("CollisionShape2D").set_deferred("disabled", false)

		print("Sword attack!")

		# Start timers for hitbox and cooldown
		await get_tree().create_timer(attack_duration).timeout

		# Disable hitbox and collision shape after attack duration
		$MyHitbox.set_deferred("monitoring", false)
		$MyHitbox.get_node("CollisionShape2D").set_deferred("disabled", true)

		await get_tree().create_timer(cooldown_duration).timeout
		can_attack = true
		
func boost_weapon():
	if sword_level == 2.0:
		# Sword level is maxed
		print("Max sword level!")
	else:
		sword_level += 1.0
