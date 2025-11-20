extends Control

@onready var packet_display = $Resources/VBoxContainer/Packet_display

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResourceManager.connect("resources_changed", Callable(self, "resources_changed")) # connect to the signal to see when packets are changed
	packet_display.text = str(ResourceManager.Packets) # set the initial value

func resources_changed():
	packet_display.text = str(ResourceManager.Packets)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
