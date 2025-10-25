extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	position = position.move_toward(Globals.last_node.position, int(SPEED * delta))
	look_at(Globals.last_node.position)

	move_and_slide()
