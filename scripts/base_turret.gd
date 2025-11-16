extends CharacterBody2D
class_name Turret

var enemies_in_range = []
var closest_enemy
var firing = false
const FIRING_SPEED = 1
@export var Bullet : PackedScene

func _process(delta):
	if enemies_in_range.size() > 0:
		# Pick a new target if the current one is gone
		if closest_enemy == null or not is_instance_valid(closest_enemy):
			get_closest_body()
			
		if is_instance_valid(closest_enemy): # Only look at a valid enemy
			look_at(closest_enemy.global_position)
			if firing == false:
				firing = true
				shoot_timer()
	else:
		firing = false
	
func shoot_timer(): # use this function because you cant use await in _process
	while firing:
		# Stop firing only if no enemies are left
		if enemies_in_range.size() == 0:
			firing = false
			break
		await get_tree().create_timer(FIRING_SPEED).timeout
		fire()

func _physics_process(delta: float) -> void:
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		enemies_in_range.append(body)
		get_closest_body()


func _on_area_2d_body_exited(body: Node2D) -> void:
	enemies_in_range.erase(body)

func get_closest_body():
	var closest_body = null
	var closest_distance = INF # infinity
	
	for enemy in enemies_in_range:
		var distence = global_position.distance_to(enemy.global_position)
		if distence < closest_distance:
			closest_distance = distence
			closest_body = enemy
	closest_enemy = closest_body

func fire():
	var b = Bullet.instantiate()
	get_parent().add_child(b)
	b.add_to_group("Bullets")
	# the marker 2d is where it should shoot out of
	b.position = $Marker2D.global_position 
	b.rotation = $Marker2D.global_rotation
