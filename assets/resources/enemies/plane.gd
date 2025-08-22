extends EnemyInstance

var Octopus = preload("res://assets/resources/enemies/octopus.tres")

@onready var manager: EnemyManager = get_parent().get_parent()

var dying = false
var dying_y = 0
var rank = 0

func move(delta) -> void:
	super.move(delta)
	position.y = dying_y

func is_alive() -> bool:
	return health > 0 or dying

func on_death() -> void:
	dying = true

func _process(delta):
	move(delta)
		
	if dying:
		dying_y += 300 * delta
	
	time_since_hit += delta
	
	material.set_shader_parameter("brightness",
		lerp(1., 0., ease(time_since_hit * 5, 20))
	)
	
	if attack_success:
		self.scale.x = lerp(self.scale.x, 0., 3 * delta)
		self.scale.y = lerp(self.scale.y, 0., 3 * delta)
	
	if dying:
		var game: Game = manager.get_parent()
		var land_node = manager.get_child(game.water_level)
		var approach =land_node.global_position.y
		if global_position.y >= approach:
			scale.x = lerp(scale.x, 0., 10 * delta)
			scale.y = lerp(scale.y, 0., 10 * delta)

	if scale.x < .05:
		queue_free()
		
func set_rank(r: int):
	rank = r
	material.set_shader_parameter("rank", r)

func _exit_tree():
	for i in range(0,2**rank):
		manager.spawn_enemy(3, Octopus, rank, Vector2(position.x - 16 * i, 0))
		await get_tree().create_timer(0.2).timeout
		manager.spawn_enemy(3, Octopus, rank, Vector2(position.x + 16 * i, 0))
	death.emit(enemy)
	dying = false

func stun_lock(_time: float):
	return
