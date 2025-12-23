extends Node2D

var gameplay_scenes = [
	"res://scenes/world.tscn"
]

var ui_scenes = [
	"res://scenes/UI/HUD/hud.tscn",
	"res://scenes/UI/GUI/death_screen.tscn"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("start_game", Callable(self, "_start_game"))

func _start_game():
	var ui_layer = $GUI  # reference your CanvasLayer

	# Add gameplay scenes to root
	for scene_path in gameplay_scenes:
		var instance = load(scene_path).instantiate()
		get_tree().root.add_child(instance)

	# Add UI scenes to CanvasLayer
	for scene_path in ui_scenes:
		var instance = load(scene_path).instantiate()
		ui_layer.add_child(instance)

	$GUI/main_menu.queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
