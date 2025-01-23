extends Area2D

@onready var original_scale = $wallSprite.scale
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func grow_size() -> void:
	$wallSprite.scale = original_scale * 1.2
	$AudioStreamPlayer2D.play()
	
	
	
func return_size() -> void:
	$wallSprite.scale = original_scale
