extends Node2D

var current_wave = 1 # counts the current wave
var dead_enemies = 0 # counts the dead enemies so we know when the wave ends

var monster_dict = { # level is the key (or id, its the first number) amount of monsters is the value (second number)
	1:1,
	2:3,
	3:5,
	4:10,
	5:15,
	6:20,
	7:35,
	8:40,
	9:50,
	10:53
}

@onready var glitchling = preload("res://scenes/enemies/glitchling.tscn")

func spawn_wave(wave_id):
	# Get the CollisionShape2D node that defines where enemies can spawn.
	# (Make sure "SpawnArea" is a CollisionShape2D with a CircleShape2D shape inside it.)
	var spawn_area = $Area2D/SpawnArea
	
	# Loop through however many enemies this wave should have
	print(wave_id)
	for i in range(monster_dict[wave_id]):
		var m = glitchling.instantiate()  # make a new enemy scene
		
		# Pick a random 2D point somewhere inside a square that covers the circle.
		# (This makes a random x and y offset within the circle’s radius.)
		var spawn_location = Vector2(
			randf_range(-spawn_area.shape.radius, spawn_area.shape.radius),
			randf_range(-spawn_area.shape.radius, spawn_area.shape.radius)
		)
		
		# Make sure the point doesn’t land *outside* the circle.
		# If it's too far, push it back inside.
		spawn_location = spawn_location.limit_length(spawn_area.shape.radius)
		
		# The circle lives somewhere in your scene (not at 0,0),
		# so add its position to move the random point to the *real* world position.
		m.position += spawn_location
		
		# Add the enemy to the spawner in the scene tree so it actually appears.
		add_child(m)

func _on_enemy_died():
	dead_enemies += 1
	
	if dead_enemies == monster_dict[current_wave]:
		dead_enemies = 0
		$InterwaveTimer.start()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.connect("enemy_died", Callable(self, "_on_enemy_died"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	current_wave += 1
	spawn_wave(current_wave)
