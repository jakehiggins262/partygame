extends Weapon

@export var attack_duration: float = 0.2  # Duration for how long the hitbox stays active
@export var cooldown_duration: float = 0.5  # Cooldown before the player can attack again

var can_attack: bool = true

# Ensure hitbox starts inactive
func _ready():
	$MyHitbox.set_deferred("monitoring", false)  # Disable hitbox monitoring when sword is ready
	$MyHitbox.get_node("CollisionShape2D").set_deferred("disabled", true)
	
	
func attack():
	if can_attack:
		can_attack = false

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
