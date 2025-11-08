extends Node3D

var block_scene = preload("res://block.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var instance = block_scene.instantiate()
	instance.get_children()[0].shape.size.x = 10.0
	instance.get_children()[1].mesh.size.x = 10.0
	add_child(instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
