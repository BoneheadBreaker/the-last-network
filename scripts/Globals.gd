extends Node

# Signals
signal enemy_died() # called when an ememy dies
signal damage_last_node(amount) # called when an enemy damages the core, sends the amount of damage
signal core_died() # called when the core dies (it has no health left)
signal resources_changed()
signal wave_spawned(number) # called whenever a new wave starts, sends the wave id/number too
signal start_game() # called when exiting the main menu and playing the game
signal core_upgraded(upgrade)
signal core_health_changed(new_health)

# HUD signals
signal new_item_selected(selected_item)

# Variables
var current_selection = build_options.AIR # the current thing the player has selected
var last_node 
var mouse_over_HUD = false

# Enums
enum build_options {
	AIR, # without air everything is 1 number below what it should be example: turrets become nothing and walls become turrets
	TURRET,
	WALL
}

enum core_upgrades {
	HEALTH
}
