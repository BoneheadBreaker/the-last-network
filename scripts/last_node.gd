extends Node2D

var health = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("damage_last_node", Callable(self, "take_damage")) # connect to its signal to hear when something broadcasts
	Globals.last_node = self

func take_damage(amount):
	health -= amount
	print("Health:", health)
	if health <= 0:
		Globals.emit_signal("core_died")
		print("exit node died..... GAME OVER")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
