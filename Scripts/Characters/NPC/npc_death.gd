extends State

#Refrences
@export var black_death_particle : GPUParticles2D
@onready var timer : Timer = $Timer

var audio_stream_player_2d: AudioStreamPlayer2D  

func _ready():
	audio_stream_player_2d = get_parent().get_parent().get_node("AudioStreamPlayer2D")


func enter(_msg := {}):
	owner.emote.visible = false
	owner.collision.disabled = true
	owner.animator.visible = false
	owner.sprite_poly.visible = false
	owner.label.hide()
	black_death_particle.emitting = true
	timer.start()
	AudioManager.play_sound(AudioManager.DEATH)
	#Using the Audiostreamplayer on our enemy's scene
	audio_stream_player_2d.play()
	#Using audio manager
	#AudioManager.play_sound(AudioManager.DEATH)

func _on_timer_timeout():
	owner.queue_free()
