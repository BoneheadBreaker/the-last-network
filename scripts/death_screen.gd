extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("core_died", Callable(self, "_core_took_damage")) # connect to exit nodes signal to hear when something broadcasts

func _core_took_damage():
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
