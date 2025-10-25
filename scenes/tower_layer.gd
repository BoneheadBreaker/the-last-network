extends TileMapLayer

@export var tower_scene: PackedScene

func _process(delta):
	if Input.is_action_just_pressed("place_tower"):
		var mouse_pos = get_global_mouse_position()
		var cell = local_to_map(mouse_pos)
		place_tower(cell)

func place_tower(cell: Vector2i):
	if get_tile(cell) != -1:
		print("Cell occupied")
		return

	var tower = tower_scene.instantiate()
	tower.position = local_to_world(cell) + tile_size / 2
	get_parent().add_child(tower)

	set_tile(cell, 0)  # placeholder tile
