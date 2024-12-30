extends Node2D  # Attached to the ParticleBeam node

@onready var beam = $Beam  # Reference to the Beam node

# Public method to emit particles at a specific target
func emit_at_target(target_position: Vector2):
	# Calculate the direction and distance
	var direction = (target_position - beam.global_position).normalized()
	var distance = (target_position - beam.global_position).length()
	
	# Set the constant speed of the particles
	var speed = 200  # Adjust this value as needed
	
	# Calculate the lifetime based on distance and speed
	var lifetime = distance / speed  # Time = Distance / Speed
	
	# Ensure the Beam node has a process material
	if beam.process_material:
		var material = beam.process_material
		material.set("direction", direction.angle())
		material.set("lifetime", lifetime)
		material.set("initial_velocity", speed)
		
		# Restart the particles to apply changes
		beam.restart()
