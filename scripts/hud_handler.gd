extends Control

@onready var packet_display = $MarginContainer/Resources/VBoxContainer/Packet_display
@onready var wave_display = $MarginContainer2/Control/WaveDisplay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("resources_changed", Callable(self, "resources_changed")) # connect to the signal to see when packets are changed
	Globals.connect("wave_spawned", Callable(self, "wave_spawned"))
	Globals.connect("core_health_changed", Callable(self, ""))
	packet_display.text = str(ResourceManager.Packets) # set the initial value
	
func core_health_changed(new_health):
	print("a")
	$CoreHealthContainer/Label.text = str(new_health)

func wave_spawned(wave_number):
	wave_display.text = str("Wave: ", wave_number)

func resources_changed():
	packet_display.text = str(ResourceManager.Packets)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Signals for detecting if the mouse is over the HUD

func _on_turret_pressed() -> void:
	Globals.emit_signal("new_item_selected", Globals.build_options.TURRET)

func _on_wall_pressed() -> void:
	Globals.emit_signal("new_item_selected", Globals.build_options.WALL)

func _on_h_box_container_mouse_entered() -> void:
	print("true")
	Globals.mouse_over_HUD = true
	
func _on_h_box_container_mouse_exited() -> void:
	print("false")
	Globals.mouse_over_HUD = false

func _on_turret_mouse_entered() -> void:
	print("true")
	Globals.mouse_over_HUD = true

func _on_turret_mouse_exited() -> void:
	print("false")
	Globals.mouse_over_HUD = false

func _on_wall_mouse_entered() -> void:
	print("true")
	Globals.mouse_over_HUD = true

func _on_wall_mouse_exited() -> void:
	print("false")
	Globals.mouse_over_HUD = false

func _on_core_health_upgrade_pressed() -> void:
	Globals.emit_signal("core_upgraded", Globals.core_upgrades.HEALTH)
