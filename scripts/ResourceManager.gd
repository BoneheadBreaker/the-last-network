extends Node

var Packets: int = 100

signal resources_changed()

func add_packets(amount):
	Packets += amount
	emit_signal("resources_changed")

func remove_packets(amount):
	Packets -= amount
	emit_signal("resources_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
