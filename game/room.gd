extends Node2D
class_name Room

@export var display_name: String
@export var cooldown_seconds: float
@export var requires_enemies_to_trigger: bool = true

# The weapon fires
signal trigger

@onready var weapon_scale = $Weapon.scale
var extra_scale = Vector2(1, 1)
var time_since_fired = 0

# Certain rooms can give other rooms extra projectile counts
var extra_projectiles_for_next_shot = 0

var game: Game
@onready var cooldown_remaining = cooldown_seconds

func _process(delta: float) -> void:
	cooldown_remaining -= delta
	time_since_fired += delta
	
	$Weapon.scale = extra_scale * weapon_scale

	extra_scale = lerp(Vector2(1.2, 1.2), Vector2(1, 1), ease(10 * time_since_fired, -.5))

	if cooldown_remaining < 0:
		if (game.find_closest_enemy(self) and requires_enemies_to_trigger) or !requires_enemies_to_trigger:
			cooldown_remaining = cooldown_seconds
			trigger_weapon()

	if cooldown_seconds > 0 and cooldown_remaining > 0:
		$CooldownBar.value = cooldown_remaining / cooldown_seconds
	else:
		$CooldownBar.value = 0

func trigger_weapon():
	trigger.emit()

func show_activate_animation():
	time_since_fired = 0

func fire_projectiles(projectile: PackedScene, number: int):
	var targets = game.find_n_closest_enemies(self, number + extra_projectiles_for_next_shot)
	extra_projectiles_for_next_shot = 0

	for target in targets:
		show_activate_animation()
		var projectileInst = projectile.instantiate()
		self.game.add_child(projectileInst)
		game.fire_projectile_from_room(self, projectileInst, target)
		await get_tree().create_timer(.1).timeout

func fire_projectiles_above_enemy(projectile: PackedScene, number: int):
	var targets = game.find_n_closest_enemies(self, number + extra_projectiles_for_next_shot)
	extra_projectiles_for_next_shot = 0

	for target in targets:
		show_activate_animation()
		var projectileInst = projectile.instantiate()
		self.game.add_child(projectileInst)
		game.fire_projectile_above_enemy(self, projectileInst, target)
		await get_tree().create_timer(.1).timeout
