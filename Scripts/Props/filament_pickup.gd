extends Area2D

var value: int


func _ready() -> void:
	value = randi_range(1,5) #PICKUP VALUE, MODIFY TO ACOMMODATE GAMEPLAY


func _process(delta: float) -> void:
	pass

func pickup_filament() -> void:
	queue_free() #Add stuff to this method
	
	
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		pickup_filament() 
