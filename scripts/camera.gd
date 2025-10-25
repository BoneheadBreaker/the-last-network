extends Camera2D

var dragging = false # Tracks whether the player is currently dragging (holding down the move_camera button)
var drag_start = Vector2.ZERO # Stores the last recorded global mouse position during dragging
var smooth_pos = Vector2.ZERO # The target position the camera should smoothly move toward

func _ready():
	smooth_pos = position # Initialize smooth_pos to the camera's current position when the scene starts

func _process(delta):
	if Input.is_action_pressed("move_camera"):
		var mouse_pos = get_global_mouse_position() # Get the current mouse position in world coordinates
		
		if not dragging: # If dragging just started, set flag and record starting mouse position
			dragging = true
			drag_start = mouse_pos
		else:
			var delta_pos = drag_start - mouse_pos # Calculate how far the mouse has moved since last frame
			
			if delta_pos.length(): # If there is movement (delta_pos is not zero)
				smooth_pos += delta_pos # Update the target camera position by adding the movement delta
				drag_start = mouse_pos # Update drag_start for the next frame's delta calculation
	else:
		dragging = false # If the move_camera action is not pressed, stop dragging

	position = position.lerp(smooth_pos, 0.2) # Smoothly move the camera's position 20% of the way towards the target position
