extends Node3D

var block_scene = preload("res://block.tscn")

func new_block(position: Vector3, is_fallen: bool, length: float, color: Color):
	var block = block_scene.instantiate()
	block.get_children()[0].shape.size.x = length
	block.get_children()[1].mesh.size.x = length
	block.get_children()[1].mesh.material.albedo_color = color
	
	if not is_fallen:
		block.rotation.z = PI/2
		block.position.y += length/2
	block.position += position
	return block

func _ready() -> void:
	add_child(new_block(Vector3(10, 0, 0), false, 10.0, Color(1, 0.1, 1, 1)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
