extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health = 500

@onready var nav : NavigationAgent2D = $NavigationAgent2D

func _ready():
	actor_setup.call_deferred() # make sure the node is "ready"
	nav.velocity_computed.connect(_velocity_computed) # connect so we can get the navs node velocity for avoidance (if enabled)
	add_to_group("Enemies")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(Vector2(789, 3987))
	
func set_movement_target(movement_target: Vector2):
	nav.target_position = movement_target

func _physics_process(delta: float) -> void:
	# Currently trying to add better movement
	# position = position.move_toward(Globals.last_node.position, int(SPEED * delta))  # move toward the last exit node
	# look_at(Globals.last_node.global_position)
	
	_move_towards_player()
	# move_and_slide()

func _move_towards_player() -> void:
	# Update the player position
	set_movement_target(Vector2(789, 3987))

	# If we're at the target, stop
	if nav.is_navigation_finished():
		return

	# Get pathfinding information
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav.get_next_path_position()

	# Calculate the new velocity
	var new_velocity = current_agent_position.direction_to(next_path_position) * SPEED

	# Set correct velocity
	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)
	else:
		_velocity_computed(new_velocity)

	# Do the movement
	move_and_slide()

func _velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullets"):
		health -= area.DAMAGE
		if health <= 0:
			Globals.emit_signal("enemy_died")
			ResourceManager.add_packets(15)
			queue_free()
