extends Area2D
class_name EnemyInstance

signal death

var enemy: EnemyResource

var damage_number = preload("res://game/DamageNumber.tscn")

@onready var health: int = enemy.max_health

func _ready():
	material = material.duplicate()
	scale = Vector2(enemy.scale, enemy.scale)
	$Sprite.texture = enemy.sprite
	$Collider.shape.size = enemy.sprite.get_size()

var downward_accel: float = 0
var time_since_hit: float = 10
var backwards_velocity: float = 0
var stun_lock_time_remaining: float = 0
var living_time: float = 0

func _process(delta):
	move(delta)
		
	if not is_alive():
		global_position.y += downward_accel
		downward_accel += 50 * delta
	
	time_since_hit += delta
	
	material.set_shader_parameter("brightness",
		lerp(1., 0., ease(10 * time_since_hit, -.5))
	)

func move(delta) -> void:
	backwards_velocity -= enemy.acceleration * delta
	if backwards_velocity < 0:
		backwards_velocity = 0
	position.x += backwards_velocity
	if stun_lock_time_remaining >= 0:
		stun_lock_time_remaining -= delta
		return
	position.x -= delta * enemy.speed
	if is_alive():
		living_time += delta
		position.y = 10 * sin(2 * living_time)

func is_alive() -> bool:
	return health > 0

func damage(value: int):
	health -= value
	if health <= 0:
		death.emit(self)
		death_animation()
	
	var num: DamageNumber = damage_number.instantiate()
	get_parent().add_child(num)
	num.set_damage_number(value)
	num.global_position = self.global_position
	time_since_hit = 0

func stun_lock(time: float):
	stun_lock_time_remaining = time

func knockback(power: int):
	backwards_velocity = power

func death_animation():
	scale.y = -1 * enemy.scale
