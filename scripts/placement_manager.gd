extends Node2D

# Towers
@export_category("Placeables")
@export var simple_tower: PackedScene
@export var wall : PackedScene

@onready var PathTester = $PathTester

func _ready():
	Globals.connect("new_item_selected", Callable(self, "_item_selected"))

func _process(delta):
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("place_tower"):
		if Globals.mouse_over_HUD == false: # if the mouse is NOT over any HUD
			if Globals.current_selection == Globals.build_options.WALL: # If they are trying to build a wall (if a wall is the selected thing)
				if ResourceManager.Packets >= 15:
					ResourceManager.remove_packets(15)
					var mouse_pos = get_global_mouse_position()
					place_tower(mouse_pos, Globals.current_selection)
			else:		
				if ResourceManager.Packets >= 50:
					ResourceManager.remove_packets(50)
					var mouse_pos = get_global_mouse_position()
					place_tower(mouse_pos, Globals.current_selection)
				else:
					print("Not enough money")

func would_block_path(world_mouse_pos, tile_coords): # test if enemy navigation can work after adding this tile
	var agent = $PathTester.get_node("NavigationAgent2D")
	
	$Floor.set_cell(tile_coords, 5, Vector2i(0, 0), Globals.current_selection)
	add_buffer(world_mouse_pos, $Floor)
	
	agent.target_position = Globals.last_node.position
	$Floor.notify_runtime_tile_data_update()
	
	agent.target_position = Globals.last_node.position
	$Floor.notify_runtime_tile_data_update()

	if agent.is_target_reachable():
		print("reachable OR IS IT")
	else:
		print("not reachable OR IS IT")
	
	if agent.is_target_reachable():
		print("reachable")
		return false
	else:
		print("not reachable")
		remove_buffer(world_mouse_pos, $Floor)
		return true
		

func add_buffer(world_mouse_pos: Vector2, tilemap): # adds a buffer around a certain tile so that enemy navigation works properly
	var mouse_local_pos = tilemap.to_local(world_mouse_pos)
	var tile_coords = tilemap.local_to_map(mouse_local_pos)
	
	# TOP
	var tile_coords_top = Vector2i(tile_coords.x, tile_coords.y - 1)
	tilemap.set_cell(tile_coords_top)
	# DOWN
	var tile_coords_bottom = Vector2i(tile_coords.x, tile_coords.y + 1)
	tilemap.set_cell(tile_coords_bottom)
	# LEFT
	var tile_coords_left = Vector2i(tile_coords.x - 1, tile_coords.y)
	tilemap.set_cell(tile_coords_left)
	# RIGHT
	var tile_coords_right = Vector2i(tile_coords.x + 1, tile_coords.y)
	tilemap.set_cell(tile_coords_right)
	# UNDERNEATH
	tilemap.set_cell(tile_coords) # set it to air
	
	tilemap.notify_runtime_tile_data_update()
	
	print("Tile coords: " + str(tile_coords.x) + str(tile_coords.y))

func remove_buffer(world_mouse_pos: Vector2i, tilemap):
	var mouse_local_pos = tilemap.to_local(world_mouse_pos)
	var tile_coords = tilemap.local_to_map(mouse_local_pos)
	
	# set all sides to the ground
	# TOP
	var tile_coords_top = Vector2i(tile_coords.x, tile_coords.y - 1)
	tilemap.set_cell(tile_coords_top, 1, Vector2i(0, 0))
	# DOWN
	var tile_coords_bottom = Vector2i(tile_coords.x, tile_coords.y + 1)
	tilemap.set_cell(tile_coords_bottom, 1, Vector2i(0, 0))
	# LEFT
	var tile_coords_left = Vector2i(tile_coords.x - 1, tile_coords.y)
	tilemap.set_cell(tile_coords_left, 1, Vector2i(0, 0))
	# RIGHT
	var tile_coords_right = Vector2i(tile_coords.x + 1, tile_coords.y)
	tilemap.set_cell(tile_coords_right, 1, Vector2i(0, 0))
	# UNDERNEATH
	tilemap.set_cell(tile_coords, 1, Vector2i(0, 0))
	print(tilemap)
	tilemap.notify_runtime_tile_data_update()

func _item_selected(selected_item):
	Globals.current_selection = selected_item
	print(Globals.current_selection)

func place_tower(world_mouse_pos: Vector2, tower):
	var mouse_local_pos = $BuildingLayer.to_local(world_mouse_pos)
	var tile_coords = $BuildingLayer.local_to_map(mouse_local_pos)
	var result = await would_block_path(world_mouse_pos, tile_coords)
	
	if result == true:
		$Floor.set_cell(tile_coords, 5, Vector2i(0, 0), Globals.current_selection)
		remove_buffer(world_mouse_pos, $Floor)
		print("a")
		return -1
		
	print("Source id: " + str($BuildingLayer.get_cell_source_id(tile_coords)))
	$BuildingLayer.set_cell(tile_coords, 5, Vector2i(0, 0), Globals.current_selection) # tile coords, source id, atlas coords, alternative tile
	add_buffer(world_mouse_pos, $Floor)
	
	print("Source id: " + str($BuildingLayer.get_cell_source_id(tile_coords)))
	print("global mouse pos: " + str(world_mouse_pos))
	print("tile coords: " + str(tile_coords))
