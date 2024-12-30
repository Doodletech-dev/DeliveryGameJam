extends GPUParticles2D

# Define the target position for particles to move toward
export (Vector2) var target_position = Vector2.ZERO

func _ready():
	# Ensure the particle system starts emitting
	emitting = true

	# Ensure a GPUParticlesMaterial is assigned
	if not process_material or not (process_material is GPUParticlesMaterial):
		print("Error: GPUParticles2D needs a GPUParticlesMaterial assigned!")
		return

	# Configure the emission shape and other properties if needed
	var material = process_material as GPUParticlesMaterial
	material.emission_shape = GPUParticlesMaterial.EMISSION_SHAPE_RING
	material.emission_sphere_radius = 50  # Adjust ring size as needed
	material.initial_velocity = 0  # Ensure particles start stationary
	material.gravity = Vector2.ZERO  # Gravity will be dynamically updated

func _process(delta):
	# Dynamically update gravity to attract particles to the target
	if process_material and process_material is GPUParticlesMaterial:
		var material = process_material as GPUParticlesMaterial
		var direction_to_target = (target_position - global_position).normalized()
		material.gravity = direction_to_target * 100  # Adjust force as needed
