extends CharacterBody2D
class_name Enemy

const SPEED = 300.0
var health = 500

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

# For stuck detection
var last_pos = Vector2.ZERO
var stuck_timer = 0.0
var stuck_check_interval = 0.5
var stuck_distance_threshold = 1.0

func _ready():
	make_path()
	add_to_group("Enemies")
	last_pos = global_position

func _physics_process(delta: float) -> void:
	# Stuck detection
	stuck_timer += delta
	if stuck_timer >= stuck_check_interval:
		if global_position.distance_to(last_pos) < stuck_distance_threshold:
			# Enemy is likely stuck, force path recalculation
			nav_agent.target_position = nav_agent.target_position
		last_pos = global_position
		stuck_timer = 0.0

	# Stop moving if we reached the target
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var next_pos = nav_agent.get_next_path_position()
	var to_next = next_pos - global_position
	var min_distance = 4.0

	if to_next.length() > min_distance:
		var dir = to_next.normalized()
		velocity = dir * SPEED
	else:
		var dir = to_next.normalized()
		velocity = dir * SPEED * (to_next.length() / min_distance)

	move_and_slide()

func make_path():
	nav_agent.target_position = Globals.last_node.position

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullets"):
		health -= area.DAMAGE
		if health <= 0:
			Globals.emit_signal("enemy_died")
			ResourceManager.add_packets(15)
			queue_free()

func _on_attack_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("core"):
		Globals.emit_signal("damage_last_node", 10)
