extends State

#Refrences
@export var black_death_particle : GPUParticles2D
@onready var timer : Timer = $Timer
var audio_stream_player_2d: AudioStreamPlayer2D  
var filament: PackedScene = preload("res://Scenes/Props/filament_pickup.tscn")

func _ready():
	audio_stream_player_2d = get_parent().get_parent().get_node("AudioStreamPlayer2D")

func enter(_msg := {}):
	owner.emote.visible = false
	owner.collision.disabled = true
	owner.animator.visible = false
	black_death_particle.emitting = true
	timer.start()
	drop()
	#Using the Audiostreamplayer on our enemy's scene
	audio_stream_player_2d.play()
	#Using audio manager
	#AudioManager.play_sound(AudioManager.DEATH)

func _on_timer_timeout():
	owner.queue_free()

func drop() -> void:
	var drop = filament.instantiate()
	drop.global_position = owner.global_position
	drop.value = randi_range(1, 5)
	get_tree().current_scene.call_deferred("add_child", drop)
