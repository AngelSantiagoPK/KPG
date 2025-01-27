class_name NPC
extends CharacterBody2D

#Data
@export var movement_data : MovementData
@export var stats : Stats
@export var shot_size: int = 1
@export var shot_spread_in_deg: int = 30.0

#Refrences
@onready var start_position : Vector2 = global_position
@onready var target_position : Vector2 = global_position
@onready var long_vision: Area2D = $LongVision
@onready var short_vision: Area2D = $ShortVision
@onready var animator : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox : Area2D = $Hitbox
@onready var hit_animator : AnimationPlayer = $HitAnimationPlayer
@onready var emote : Sprite2D = $Emote
@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var state_machine : StateMachine = $StateMachine
@onready var health_bar : TextureProgressBar = $HealthBar
@onready var health_bar_timer : Timer = $HealthBar/HealthBarTimer
@onready var sprite_poly: Node2D = $SpritePoly
@onready var label: Label = $Label
@onready var hand: Node2D = $Hand
@onready var pivot: Node2D = $Hand/Pivot
@onready var pistol_bullet_marker: Marker2D = $Hand/Pivot/Pistol/PistolBulletMarker


#Load Scenes
@onready var muzzle_load : PackedScene = preload("res://Scenes/Particles/muzzle.tscn")
@onready var shell_load : PackedScene = preload("res://Scenes/Props/enemy_shell.tscn")


func _ready():
	stats.health = stats.max_health

func _physics_process(_delta: float):
	hitbox.knockback_vector = velocity.normalized() #Updating the knockback vector
	move_and_slide()

func knockback(vector):
	velocity = velocity.move_toward(vector * movement_data.knockback_force, movement_data.acceleration)

func add_gravity(delta: float) -> void:
	velocity.y += movement_data.gravity * movement_data.gravity_scale * delta

func shoot():
	var target_position : Vector2 = (EventManager.current_form.global_position - global_position).normalized()
	var muzzle = muzzle_load.instantiate()
	var bullet = shell_load.instantiate()
	if EventManager.current_form.global_position.x < global_position.x:
		hand.scale.x = -1
	else:
		hand.scale.x = 1
	pivot.look_at(EventManager.current_form.global_position)
	pistol_bullet_marker.add_child(muzzle)
	bullet.global_position = pistol_bullet_marker.global_position
	bullet.target_vector =target_position
	bullet.rotation = target_position.angle()
	get_tree().current_scene.add_child(bullet)
	AudioManager.play_sound(AudioManager.SHOOT)


func _on_hurtbox_area_entered(area):
	if not area.is_in_group("Bat") and not area.is_in_group("Enemy"):
		knockback(area.knockback_vector)
		hit_animator.set_deferred("play", "Hit")
		update_health_bar()
		if stats.health <= 0:
			state_machine.call_deferred("transition_to", "Death")
			health_bar.visible = false

func update_health_bar():
	health_bar.value = stats.health
	health_bar.visible = true
	health_bar_timer.start()

func _on_health_bar_timer_timeout():
	health_bar.visible = false
