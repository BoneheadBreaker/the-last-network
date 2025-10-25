extends Node2D

# The tower scene to instantiate
@export var tower_scene: PackedScene

# Grid configuration
@export var grid_size: Vector2 = Vector2(32, 32)

# Size of the tower in pixels
@export var tower_size_pixels: Vector2 = Vector2(64, 64)

# Tracks which grid cells are occupied
var occupied_cells := {}

func _process(delta):
	if Input.is_action_just_pressed("place_tower"):
		var mouse_pos = get_global_mouse_position()
		place_tower(mouse_pos)

# Helper to create unique keys for occupied_cells dictionary
func _cell_key(cell: Vector2i) -> String:
	return str(cell.x) + "," + str(cell.y)

func place_tower(mouse_pos: Vector2):
	# Number of grid cells the tower occupies
	var cells_wide = int(ceil(tower_size_pixels.x / grid_size.x))
	var cells_high = int(ceil(tower_size_pixels.y / grid_size.y))

	# Snap mouse to top-left cell
	var top_left_cell = Vector2i(
		int(floor(mouse_pos.x / grid_size.x)),
		int(floor(mouse_pos.y / grid_size.y))
	)

	# Check if any cells are already occupied
	for dx in range(cells_wide):
		for dy in range(cells_high):
			var cell = Vector2i(top_left_cell.x + dx, top_left_cell.y + dy)
			if occupied_cells.has(_cell_key(cell)):
				print("Cannot place tower: cell occupied")
				return

	# Instantiate and place tower centered over its occupied cells
	var tower = tower_scene.instantiate()
	tower.position = (Vector2(top_left_cell) + Vector2(cells_wide, cells_high) * 0.5) * grid_size
	add_child(tower)

	# Mark all occupied cells
	for dx in range(cells_wide):
		for dy in range(cells_high):
			var cell = Vector2i(top_left_cell.x + dx, top_left_cell.y + dy)
			occupied_cells[_cell_key(cell)] = true
