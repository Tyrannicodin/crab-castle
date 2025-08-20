extends Node2D

var clouds = []

var time_to_next_cloud = 0

func _ready() -> void:
	create_new_cloud(randi_range(300, 1000))
	create_new_cloud(randf_range(1200, 1800))
	time_to_next_cloud = randf_range(10, 20)

func _process(delta: float) -> void:
	if time_to_next_cloud < 0:
		time_to_next_cloud = randf_range(30, 50)
		create_new_cloud()
	time_to_next_cloud -= delta
	for cloud in clouds:
		cloud.global_position.x -= 20 * delta
		if cloud.position.x < -300:
			cloud.queue_free()
			clouds.remove_at(clouds.find(cloud))

func create_new_cloud(x = null):
	var new_cloud = $Base.duplicate()
	add_child(new_cloud)
	clouds.push_back(new_cloud)
	new_cloud.show()
	new_cloud.global_position.y = randi_range(100, 300)
	if x == null:
		new_cloud.global_position.x = 2000
	else:
		new_cloud.global_position.x = x
	
	var scalen = randf_range(1.3, 1.5)
	new_cloud.scale.x = scalen
	new_cloud.scale.y = scalen
