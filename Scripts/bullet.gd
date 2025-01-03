extends CharacterBody2D
class_name Bullet

@onready var sfx: AudioStreamPlayer2D = $SFX

@export var speed = 1500.0
@export var damage = 1
@export var damage_mod = 0.25
@export var damage_type := DamageTypes.type.bullet
@export var trail_effect: PackedScene

@export var fire_sfx : AudioStream

var effect_instance
var fire_direciton = Vector2.ZERO
func _ready():
	sfx.stream = fire_sfx
	sfx.pitch_scale = randf_range(0.9,1.1)
	sfx.play()
	effect_instance = trail_effect.instantiate()
	get_tree().get_root().add_child(effect_instance)
	damage += damage * damage_mod * GameManager.turret_upgrades

func _process(delta: float) -> void:
	effect_instance.global_transform = global_transform
	if(fire_direciton != Vector2.ZERO):
		fire_direciton = fire_direciton.normalized()
		velocity = speed * fire_direciton
	else:
		velocity = speed * get_global_transform().basis_xform(Vector2.RIGHT)
	move_and_slide()

func hit_detected():
	queue_free()

func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()
	
func _set_fire_direction(direction : Vector2):
	fire_direciton = direction
