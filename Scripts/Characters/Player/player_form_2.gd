class_name Form_02
extends CharacterBody2D

@export var camera : Camera2D
@export var movement_data : MovementData
@export var fillament_data: FillamentData
@export var stats : Stats
@export var active: bool = false
var can_shoot: bool = true

#Refrences
@onready var animator : AnimatedSprite2D = $AnimatedSprite2D
@onready var guns_animator : AnimationPlayer = $ShootingAnimationPlayer
@onready var hit_animator : AnimationPlayer = $HitAnimationPlayer
@onready var hand : Node2D = $Hand
@onready var pistol : Sprite2D = $Hand/Pivot/Pistol
@onready var pistol_bullet_marker : Marker2D = $Hand/Pivot/Pistol/PistolBulletMarker
@onready var rifle_delay: Timer = $RifleDelay
@onready var remote: RemoteTransform2D = $RemoteTransform2D
@onready var audio_stream_primary: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_secondary: AudioStreamPlayer2D = $AudioStreamSecondary

#Load Scenes
@onready var muzzle_load : PackedScene = preload("res://Scenes/Particles/muzzle.tscn")
@onready var death_particle_load : PackedScene = preload("res://Scenes/Particles/player_death_particle.tscn")


func _ready():
	stats.health = stats.max_health
	self.check_for_active_camera()

func _physics_process(delta):
	apply_gravity(delta)

	if not active: 
		return
	
	var input_vector = Input.get_axis("move_left","move_right")
	if input_vector != 0:
		apply_acceleration(input_vector, delta)
	else:
		apply_friction(delta)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()

	move_and_slide()
	animate(input_vector)

func apply_acceleration(input_vector, delta):
	velocity.x = move_toward(velocity.x, movement_data.max_speed * input_vector, movement_data.acceleration * delta)

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += movement_data.gravity * movement_data.gravity_scale * delta

func knockback(vector):
	velocity = velocity.move_toward(vector * movement_data.knockback_force, movement_data.acceleration)

func jump():
	velocity.y = -movement_data.jump_strength
	AudioManager.play_sound(AudioManager.JUMP)

<<<<<<< HEAD
func shoot():
	bullets_amount -= 1
	EventManager.bullets_amount -= 1
	EventManager._update_bullet_ui.emit()
	var mouse_position : Vector2 = (get_global_mouse_position() - global_position).normalized()
	var muzzle = muzzle_load.instantiate()
	var bullet = bullet_load.instantiate()
	pistol_bullet_marker.add_child(muzzle)
	bullet.global_position = pistol_bullet_marker.global_position
	bullet.target_vector = mouse_position
	bullet.rotation = mouse_position.angle()
	get_tree().current_scene.add_child(bullet)

	#Using AudioStreamPlayer from the form's scene
	audio_stream_primary.play()

	#Using Audio Manager
	#AudioManager.play_sound(AudioManager.SHOOT)

func shoot_shell():
	shells_amount -= shot_size
	EventManager.shells_amount -= 1
	EventManager._update_bullet_ui.emit()
	var mouse_position : Vector2 = (get_global_mouse_position() - global_position).normalized()
	var muzzle = muzzle_load.instantiate()
	muzzle.global_position = pistol_bullet_marker.global_position
	pistol_bullet_marker.add_child(muzzle)
	
	for i in shot_size:
		var shell = shell_load.instantiate()
		var offset = (i - (shot_size / 2)) * (shot_spread_in_deg / shot_size)
		shell.global_position = pistol_bullet_marker.global_position
		shell.target_vector = mouse_position.rotated(deg_to_rad(offset))
		get_tree().current_scene.add_child(shell)
	
	#Using AudioStreamPlayer from the form's scene
	audio_stream_secondary.play()

	#Using Audio Manager
	#AudioManager.play_sound(AudioManager.SHOOT)

=======
>>>>>>> origin/main
func small_shake():
	if not camera:
		return
	camera.small_shake()

func check_for_active_camera() -> void:
	# Ensure get_tree() is valid (check if it exists)
	var tree = get_tree()
	if tree:
		# Only attempt to access the camera if tree is valid
		if active:
			var camera = tree.get_first_node_in_group("Camera")
			if camera:
				remote.remote_path = camera.get_path()
			else:
				remote.remote_path = ""  # No camera in the group
		else:
			remote.remote_path = ""  # If not active, clear the path
	else:
		# Handle the case where get_tree() is invalid
		print("Error: Scene tree is not available.")

func animate(input_vector):
	var mouse_position : Vector2 = (get_global_mouse_position() - global_position).normalized()
	if mouse_position.x > 0 and animator.flip_h:
		animator.flip_h = false
	elif mouse_position.x < 0 and not animator.flip_h:
		animator.flip_h = true
	
	hand.rotation = mouse_position.angle()
	if hand.scale.y == 1 and mouse_position.x < 0:
		hand.scale.y = -1
	elif hand.scale.y == -1 and mouse_position.x > 0:
		hand.scale.y = 1
	
	if is_on_floor():
		if input_vector != 0:
			animator.play("Run")
		else:
			animator.play("Idle")
	else:
		if velocity.y > 0:
				animator.play("Fall")
		else:
				animator.play("Jump")

func _on_hurtbox_area_entered(_area):
	hit_animator.set_deferred("play", "Hit")
	EventManager._update_health_ui.emit()
	if stats.health <= 0:
		die()
	else:
		AudioManager.play_sound(AudioManager.HURT)
		EventManager.frame_freeze.emit()

func die():
	AudioManager.play_sound(AudioManager.DEATH)
	var death_particle = death_particle_load.instantiate()
	death_particle.global_position = global_position
	get_tree().current_scene.add_child(death_particle)
	EventManager._form_destroyed.emit()
