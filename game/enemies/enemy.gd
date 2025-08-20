extends Area2D
class_name EnemyInstance

signal death(type: Enemy)

var enemy: Enemy

var damage_number = preload("res://game/FlavorText.tscn")
var attack_success = false
var underwater = false
const ACCELERATION = 30

@onready var health: int = enemy.max_health

func _ready():
	material = material.duplicate()
	scale = enemy.scale
	$Sprite.texture = enemy.sprite
	$Collider.shape.size = enemy.sprite.get_size()

var downward_accel: float = 0
var rotational_vel: float = 0
var time_since_hit: float = 10
var backwards_velocity: float = 0
var stun_lock_time_remaining: float = 0
var living_time: float = 0

func _process(delta):
	move(delta)
		
	if not is_alive():
		global_position.y += 30 * delta
		downward_accel += 1000 * delta
		
		rotation += rotational_vel
		rotational_vel += delta
	
	time_since_hit += delta
	
	material.set_shader_parameter("brightness",
		lerp(1., 0., ease(time_since_hit * 5, 20))
	)
	
	if attack_success or not is_alive():
		self.scale.x = lerp(self.scale.x, 0., 3 * delta)
		self.scale.y = lerp(self.scale.y, 0., 3 * delta)
	
	if self.scale.x < .05:
		self.queue_free()

func move(delta) -> void:
	backwards_velocity -= ACCELERATION * delta
	if backwards_velocity < 0:
		backwards_velocity = 0
	position.x += backwards_velocity
	if stun_lock_time_remaining >= 0:
		stun_lock_time_remaining -= delta
		return
	position.x -= delta * enemy.speed
	if is_alive():
		living_time += delta
		position.y = -20 * abs(sin(2 * living_time)) + 10

func is_alive() -> bool:
	return health > 0

func damage(value: int):
	health -= value
	if health <= 0:
		death.emit(enemy)
		death_animation()
	
	var num: DamageNumber = damage_number.instantiate()
	get_parent().add_child(num)
	num.set_damage_number(value)
	num.global_position = global_position
	num.global_position.y -= 40
	time_since_hit = 0

func stun_lock(time: float):
	stun_lock_time_remaining = time

func knockback(power: int):
	backwards_velocity = power * (1 - enemy.knockback_resist)

func death_animation():
	pass

func attack_successful():
	attack_success = true
