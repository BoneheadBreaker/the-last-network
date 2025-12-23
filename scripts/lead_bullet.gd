extends Area2D

const SPEED = 600 # the speed the bullet will travel at
@export var DAMAGE = 250 # the amount of damage the bullet will do

func _physics_process(delta):
	position += transform.x * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		queue_free()
