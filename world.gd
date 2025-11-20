extends Node2D

# The tower scene to instantiate
@export var tower_scene: PackedScene

# Grid configuration
@export var grid_size: Vector2 = Vector2(32, 32)

# Size of the tower in pixels
@export var tower_size_pixels: Vector2 = Vector2(64, 64)

# Tracks which grid cells are occupied
var occupied_cells := {}

	# for later to use in other scripts
	# ResourceManager.connect("resources_changed", Callable(self, "_test"))
	# ResourceManager.add_packets(267)

func _process(delta):
	if Input.is_action_just_pressed("place_tower"):
		if ResourceManager.Packets >= 50:
			ResourceManager.remove_packets(50)
			var mouse_pos = get_global_mouse_position()
			place_tower(mouse_pos)
			add_buffer(mouse_pos)
		else:
			print("Not enough money")

# Helper to create unique keys for occupied_cells dictionary
func _cell_key(cell: Vector2i) -> String:
	return str(cell.x) + "," + str(cell.y)

func add_buffer(world_mouse_pos: Vector2): # adds a buffer around a certain tile so that enemy navigation works properly
	var mouse_local_pos = $Floor.to_local(world_mouse_pos)
	var tile_coords = $Floor.local_to_map(mouse_local_pos)
	
	# TOP
	var tile_coords_top = Vector2i(tile_coords.x, tile_coords.y - 1)
	$Floor.set_cell(tile_coords_top)
	# DOWN
	var tile_coords_bottom = Vector2i(tile_coords.x, tile_coords.y + 1)
	$Floor.set_cell(tile_coords_bottom)
	# LEFT
	var tile_coords_left = Vector2i(tile_coords.x - 1, tile_coords.y)
	$Floor.set_cell(tile_coords_left)
	# RIGHT
	var tile_coords_right = Vector2i(tile_coords.x + 1, tile_coords.y)
	$Floor.set_cell(tile_coords_right)
	# UNDERNEATH
	$Floor.set_cell(tile_coords) # set it to air
	
	print("Tile coords: " + str(tile_coords.x) + str(tile_coords.y))

func place_tower(world_mouse_pos: Vector2):
	var mouse_local_pos = $BuildingLayer.to_local(world_mouse_pos)
	var tile_coords = $BuildingLayer.local_to_map(mouse_local_pos)
	print("Source id: " + str($BuildingLayer.get_cell_source_id(tile_coords)))
	$BuildingLayer.set_cell(tile_coords, 5, Vector2i(0, 0), 1)
	
	print("Source id: " + str($BuildingLayer.get_cell_source_id(tile_coords)))
	print("global mouse pos: " + str(world_mouse_pos))
	print("tile coords: " + str(tile_coords))
