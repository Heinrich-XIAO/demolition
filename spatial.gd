extends Node3D


var block_scene = preload("res://block.tscn")

func new_block(position: Vector3, is_fallen: bool, length: float, color: Color, rotation: Vector3):
	var block = block_scene.instantiate()
	
	# Adjust collision shape
	block.get_children()[0].shape = BoxShape3D.new()
	block.get_children()[0].shape.size.x = length
	
	# Adjust mesh size and color
	block.get_children()[1].scale.x = length  # scale instead of mesh.size
	var mat = block.get_children()[1].get_active_material(0).duplicate()
	mat.albedo_color = color
	block.get_children()[1].set_surface_override_material(0, mat)
	
	if not is_fallen:
		block.rotation.z = PI / 2
		block.position.y += length / 2
	
	block.position += position
	block.rotation += rotation
	return block

func _ready() -> void:
	add_child(new_block(Vector3(10, 0, 0), false, 10.0, Color(1, 0.4, 0.1, 1.0), Vector3.ZERO))
	add_child(new_block(Vector3(0, 0, 0), true, 5.0, Color(0.1, 0.9, 0.3, 1), Vector3(0, PI/2, 0)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
